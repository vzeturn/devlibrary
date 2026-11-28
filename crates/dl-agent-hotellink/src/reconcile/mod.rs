//! Turns a hub job into SMILE FO folios (Go `internal/agent/reconcile.go`). This code writes
//! guest bookings into a live hotel PMS, so it follows the Go agent statement by statement;
//! the only intended differences are listed in the crate report.

mod build;
mod diff;
mod history;
#[cfg(test)]
pub(crate) mod tests;

use std::sync::{Arc, RwLock};

use dl_time::{DateTime, Offset, OffsetDateTime};

use crate::error::{Error, Kind, Result};
use crate::gofmt::quote;
use crate::jobmodel::{
    ACTION_CANCEL, ACTION_IGNORE, ACTION_MANUAL, ACTION_SAVE, CancelPolicy, Job, OpPolicy,
    PmsResult,
};
use crate::log::{self, V};
use crate::pms::{ClientSts, Folio, PmsRepo, SmileClient};

pub(crate) use build::{
    build_folio, folios_to_pms, item_key, merge_rooms_by_item, merge_rooms_conflicts, next_seq,
    parse_day, pick_to_cancel, room_key,
};

/// A clock returning the current instant.
pub type Clock = Arc<dyn Fn() -> OffsetDateTime + Send + Sync>;

/// The cancel/modify policy and whether the hub sent it (else the PMS `GlobalParameter`
/// flags decide).
#[derive(Debug, Clone, Copy, Default)]
struct PolicyState {
    p: CancelPolicy,
    from_hub: bool,
}

/// Applies jobs to the PMS (Go `Reconciler`).
pub struct Reconciler {
    repo: Arc<dyn PmsRepo>,
    policy: RwLock<Option<PolicyState>>,
    now: Clock,
}

/// `newManualConflict`: an error the save path turns into a needs-manual result.
pub(crate) fn manual_conflict_err(reason: String) -> Error {
    Error::new(Kind::ManualConflict, reason)
}

/// `time.RFC3339` of the UTC instant (whole seconds, `Z`).
pub(crate) fn rfc3339_utc(t: OffsetDateTime) -> String {
    let d = t.to_utc().datetime();
    format!(
        "{:04}-{:02}-{:02}T{:02}:{:02}:{:02}Z",
        d.year(),
        d.month().number(),
        d.day(),
        d.hour(),
        d.minute(),
        d.second()
    )
}

/// The system clock. SMILE FO stores local wall-clock times; every SMILE site runs on
/// Vietnam time, so "local" is UTC+7.
pub fn system_clock() -> Clock {
    Arc::new(OffsetDateTime::now_utc)
}

fn manual_result(reason: String, synced_at: String) -> PmsResult {
    PmsResult {
        action: "save".into(),
        completed: false,
        needs_manual: true,
        reason,
        folios: Vec::new(),
        synced_at,
        ..PmsResult::default()
    }
}

impl Reconciler {
    /// A reconciler over `repo` using the system clock.
    #[cfg(test)]
    pub fn new(repo: Arc<dyn PmsRepo>) -> Reconciler {
        Reconciler::with_clock(repo, system_clock())
    }

    /// A reconciler with an injected clock (tests).
    pub fn with_clock(repo: Arc<dyn PmsRepo>, now: Clock) -> Reconciler {
        Reconciler {
            repo,
            policy: RwLock::new(None),
            now,
        }
    }

    /// `setPolicy`: one atomic snapshot of policy + source.
    pub fn set_policy(&self, p: CancelPolicy, from_hub: bool) {
        if let Ok(mut g) = self.policy.write() {
            *g = Some(PolicyState { p, from_hub });
        }
    }

    fn policy_view(&self) -> (CancelPolicy, bool) {
        match self.policy.read() {
            Ok(g) => g.map(|s| (s.p, s.from_hub)).unwrap_or_default(),
            Err(p) => p
                .into_inner()
                .map(|s| (s.p, s.from_hub))
                .unwrap_or_default(),
        }
    }

    /// Whether the active policy came from the hub.
    pub fn policy_from_hub(&self) -> bool {
        self.policy_view().1
    }

    fn op_cancel(&self) -> OpPolicy {
        self.policy_view().0.on_cancel
    }

    fn op_modify(&self) -> OpPolicy {
        self.policy_view().0.on_modify
    }

    fn now_utc_rfc3339(&self) -> String {
        rfc3339_utc((self.now)())
    }

    /// The local wall-clock "now" written into new folios (Go `r.now()` in local time).
    fn now_local(&self) -> DateTime {
        (self.now)().to_offset(Offset::VIETNAM).datetime()
    }

    /// `findExistingFolios`: by `ExternalConfirmNumber` (Booker, then BookingID), then by
    /// `Booker` for each distinct key.
    pub(crate) fn find_existing_folios(&self, job: &Job) -> Result<Vec<Folio>> {
        let folios = self.repo.get_folios(&job.booker)?;
        if !folios.is_empty() {
            return Ok(folios);
        }
        if job.booker != job.booking_id {
            let folios = self.repo.get_folios(&job.booking_id)?;
            if !folios.is_empty() {
                return Ok(folios);
            }
        }
        for key in distinct(&[&job.booker, &job.booking_id]) {
            let by_booker = self.repo.get_folios_by_booker(key)?;
            if !by_booker.is_empty() {
                return Ok(by_booker);
            }
        }
        Ok(Vec::new())
    }

    /// `Apply`. FolioLog rows that could not be written are reported in
    /// `PmsResult.audit_gaps` (RT-0702).
    pub fn apply(&self, job: &Job) -> Result<PmsResult> {
        history::reset_gaps();
        let res = self.apply_inner(job);
        let gaps = history::take_gaps();
        res.map(|mut r| {
            r.audit_gaps = gaps;
            r
        })
    }

    fn apply_inner(&self, job: &Job) -> Result<PmsResult> {
        match job.action.as_str() {
            ACTION_SAVE => self.apply_save(job),
            ACTION_CANCEL => self.apply_cancel(job),
            ACTION_MANUAL => Ok(PmsResult {
                action: "manual".into(),
                completed: false,
                needs_manual: true,
                reason: format!(
                    "booking {}: hub định tuyến xử lý tay (status/notification)",
                    job.booking_id
                ),
                folios: Vec::new(),
                synced_at: self.now_utc_rfc3339(),
                ..PmsResult::default()
            }),
            ACTION_IGNORE => Ok(PmsResult {
                action: "ignore".into(),
                completed: true,
                folios: Vec::new(),
                synced_at: self.now_utc_rfc3339(),
                ..PmsResult::default()
            }),
            other => Err(Error::other(format!(
                "action không hỗ trợ: {}",
                quote(other)
            ))),
        }
    }

    fn apply_cancel(&self, job: &Job) -> Result<PmsResult> {
        let folios = self.find_existing_folios(job)?;
        let synced_at = self.now_utc_rfc3339();
        if folios.is_empty() {
            log::info(
                "cancel: không có folio để hủy",
                &[("bookingId", V::S(&job.booking_id))],
            );
            return Ok(PmsResult {
                action: "cancel".into(),
                completed: true,
                folios: Vec::new(),
                synced_at,
                ..PmsResult::default()
            });
        }
        if self.has_conflicting_folios(&folios, self.op_cancel())? {
            return Ok(PmsResult {
                action: "cancel".into(),
                completed: false,
                needs_manual: true,
                reason: format!(
                    "booking {}: folio đang xung đột (đã nhận phòng/đổi trạng thái), không hủy tự động",
                    job.booking_id
                ),
                folios: folios_to_pms(&folios),
                synced_at,
                ..PmsResult::default()
            });
        }
        let mut snapshot = folios.clone();
        self.cancel_folios_logged(job, &folios, "HL cancel")?;
        for f in &mut snapshot {
            if f.cancel_num == 0.0 {
                f.cancel_num = f.folio_num;
            }
        }
        log::info(
            "đã hủy folio",
            &[
                ("bookingId", V::S(&job.booking_id)),
                ("count", V::I(snapshot.len() as i64)),
            ],
        );
        Ok(PmsResult {
            action: "cancel".into(),
            completed: true,
            folios: folios_to_pms(&snapshot),
            synced_at,
            ..PmsResult::default()
        })
    }

    fn apply_save(&self, job: &Job) -> Result<PmsResult> {
        let existing = self.find_existing_folios(job)?;
        let check_in = parse_day(&job.check_in).map_err(|e| {
            e.context(format!(
                "booking {} CheckIn {}: ",
                job.booking_id,
                quote(&job.check_in)
            ))
        })?;
        let check_out = parse_day(&job.check_out).map_err(|e| {
            e.context(format!(
                "booking {} CheckOut {}: ",
                job.booking_id,
                quote(&job.check_out)
            ))
        })?;
        let (ta, sts) = self.lookup_travel_agent(&job.source_name)?;

        if existing.is_empty() {
            let mut cancelled_before = self
                .repo
                .has_user_cancelled_folio(&job.booker, &job.booking_id)?;
            if cancelled_before && job.force_recreate {
                // RT-1306: HL still holds the booking, the hub asked to book it again.
                log::warn(
                    "hub ép tạo lại booking đã bị user hủy",
                    &[
                        ("bookingId", V::S(&job.booking_id)),
                        ("booker", V::S(&job.booker)),
                    ],
                );
                cancelled_before = false;
            }
            if cancelled_before {
                let reason = format!(
                    "booking {}: đã từng bị hủy ở PMS trước đó (bởi user), từ chối tạo lại — cần xử lý tay",
                    job.booking_id
                );
                log::warn(
                    "chặn tạo lại booking đã bị user hủy",
                    &[
                        ("bookingId", V::S(&job.booking_id)),
                        ("booker", V::S(&job.booker)),
                    ],
                );
                return Ok(manual_result(reason, self.now_utc_rfc3339()));
            }
            // RECOVERY: a booking the agent itself cancelled earlier (HL cancelled it, then
            // reinstated it) is created again; FolioLog names the old folios (RT-0702).
            let prev_cancelled = self
                .repo
                .agent_cancelled_folio_nums(&job.booker, &job.booking_id)?;
            if !prev_cancelled.is_empty() {
                log::info(
                    "khôi phục booking do agent hủy trước đó",
                    &[
                        ("bookingId", V::S(&job.booking_id)),
                        ("cancelledFolios", V::I(prev_cancelled.len() as i64)),
                    ],
                );
            }
            let confirm_num = self.repo.get_new_confirm_num()?;
            self.log_merge_conflicts(job);
            self.create_rooms(
                job,
                &merge_rooms_by_item(job.rooms()),
                confirm_num,
                check_in,
                check_out,
                ta.as_ref(),
                sts.as_ref(),
                None,
                true,
                &history::CreateLog::new(&prev_cancelled),
            )?;
        } else {
            if self.lock_by_room_skip(&existing, self.op_modify())? {
                log::info(
                    "bỏ qua modify (lock by room)",
                    &[
                        ("bookingId", V::S(&job.booking_id)),
                        ("folios", V::I(existing.len() as i64)),
                    ],
                );
                return Ok(PmsResult {
                    action: "save".into(),
                    completed: true,
                    reason: "lock by room: booking có folio đã xếp phòng, bỏ qua để giữ xếp phòng lễ tân".into(),
                    folios: folios_to_pms(&existing),
                    synced_at: self.now_utc_rfc3339(),
                    ..PmsResult::default()
                });
            }
            let skip_reason = match self.apply_diff(
                job,
                &existing,
                check_in,
                check_out,
                ta.as_ref(),
                sts.as_ref(),
            ) {
                Ok(s) => s,
                Err(e) if e.kind() == Kind::ManualConflict => {
                    return Ok(manual_result(
                        e.message().to_owned(),
                        self.now_utc_rfc3339(),
                    ));
                }
                Err(e) => return Err(e),
            };
            if !skip_reason.is_empty() {
                log::info(
                    "modify: bỏ qua folio bảo vệ",
                    &[
                        ("bookingId", V::S(&job.booking_id)),
                        ("reason", V::S(&skip_reason)),
                    ],
                );
                let final_folios = self.find_existing_folios(job)?;
                return Ok(PmsResult {
                    action: "save".into(),
                    completed: true,
                    reason: skip_reason,
                    folios: folios_to_pms(&final_folios),
                    synced_at: self.now_utc_rfc3339(),
                    ..PmsResult::default()
                });
            }
        }
        let final_folios = self.find_existing_folios(job)?;
        Ok(PmsResult {
            action: "save".into(),
            completed: true,
            folios: folios_to_pms(&final_folios),
            synced_at: self.now_utc_rfc3339(),
            ..PmsResult::default()
        })
    }

    fn log_merge_conflicts(&self, job: &Job) {
        for key in merge_rooms_conflicts(job.rooms()) {
            log::warn(
                "HL gửi nhiều room-item cùng loại nhưng khác thông tin (số khách/giá) — \
                 mỗi biến thể được giữ thành nhóm folio riêng (khóa |v:<hash>)",
                &[
                    ("bookingId", V::S(&job.booking_id)),
                    ("itemKey", V::S(&key)),
                ],
            );
        }
    }

    /// `isProtectedFolio`: checked in (when that blocks), or room assigned (unless the hub
    /// policy allows it).
    fn is_protected_folio(&self, f: &Folio, op: OpPolicy) -> bool {
        if f.folio_status > 1 && self.block_checked_in(op) {
            return true;
        }
        if !f.room_code.is_empty() {
            if self.policy_from_hub() {
                return !op.allow_when_room_assigned;
            }
            return true;
        }
        false
    }

    fn lock_by_room_skip(&self, folios: &[Folio], op: OpPolicy) -> Result<bool> {
        let (block_room, _) = self.cancel_guards(op)?;
        if !block_room {
            return Ok(false);
        }
        Ok(folios.iter().any(|f| !f.room_code.is_empty()))
    }

    /// `cancelGuards`: (blockRoom, blockStatus) from the hub policy, else from the PMS
    /// `CancelByRoom` / `CancelByStatus` flags.
    fn cancel_guards(&self, op: OpPolicy) -> Result<(bool, bool)> {
        if self.policy_from_hub() {
            return Ok((
                !op.allow_when_room_assigned,
                !op.allow_when_abnormal_book_status,
            ));
        }
        let by_status = self.repo.get_global_param_int("CancelByStatus")?;
        let by_room = self.repo.get_global_param_int("CancelByRoom")?;
        Ok((by_room == 1, by_status == 1))
    }

    fn block_checked_in(&self, op: OpPolicy) -> bool {
        if self.policy_from_hub() {
            return !op.allow_when_checked_in;
        }
        true
    }

    fn has_conflicting_folios(&self, folios: &[Folio], op: OpPolicy) -> Result<bool> {
        let (block_room, block_status) = self.cancel_guards(op)?;
        let block_checked_in = self.block_checked_in(op);
        Ok(folios.iter().any(|f| {
            (f.book_status != 1 && block_status)
                || (!f.room_code.is_empty() && block_room)
                || (f.folio_status > 1 && block_checked_in)
        }))
    }

    fn lookup_travel_agent(
        &self,
        source_name: &str,
    ) -> Result<(Option<SmileClient>, Option<ClientSts>)> {
        if let Some(ta) = self.repo.get_client_by_name(source_name)? {
            let sts = self.repo.get_client_sts(ta.client_folio_num)?;
            return Ok((Some(ta), sts));
        }
        let Some(contact) = self.repo.get_client_contact_by_name(source_name)? else {
            return Ok((None, None));
        };
        let ta = self
            .repo
            .get_client_by_folio_num(contact.client_folio_num)?;
        let sts = self.repo.get_client_sts(contact.client_folio_num)?;
        Ok((ta, sts))
    }
}

fn distinct<'a>(keys: &[&'a str]) -> Vec<&'a str> {
    let mut out: Vec<&str> = Vec::new();
    for k in keys {
        if k.is_empty() || out.contains(k) {
            continue;
        }
        out.push(k);
    }
    out
}
