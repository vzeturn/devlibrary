//! Lenient decoding of the wire types, like Go's `json.Unmarshal` into the structs: a
//! missing or mistyped field keeps its zero value, unknown fields are ignored.

use dl_json::Value;

use super::{
    AuditRequest, CancelPolicy, HlExtra, HlPayment, Job, MappingCmd, MappingRow, OpPolicy,
    PmsFolio, PmsResult, RateNight, RateNightExtra, Room,
};

pub(crate) fn s(v: &Value, k: &str) -> String {
    v.get(k).and_then(Value::as_str).unwrap_or("").to_owned()
}

pub(crate) fn i(v: &Value, k: &str) -> i64 {
    match v.get(k) {
        Some(x) => x
            .as_i64()
            .or_else(|| x.as_f64().filter(|f| f.fract() == 0.0).map(|f| f as i64))
            .unwrap_or(0),
        None => 0,
    }
}

pub(crate) fn f(v: &Value, k: &str) -> f64 {
    v.get(k).and_then(Value::as_f64).unwrap_or(0.0)
}

pub(crate) fn b(v: &Value, k: &str) -> bool {
    v.get(k).and_then(Value::as_bool).unwrap_or(false)
}

fn list<T>(v: &Value, k: &str, each: impl Fn(&Value) -> T) -> Option<Vec<T>> {
    v.get(k)
        .and_then(Value::as_array)
        .map(|a| a.iter().map(each).collect())
}

fn opt_i(v: &Value, k: &str) -> Option<i64> {
    match v.get(k) {
        None | Some(Value::Null) => None,
        Some(_) => Some(i(v, k)),
    }
}

impl Job {
    /// Decodes a job object.
    pub fn from_value(v: &Value) -> Job {
        Job {
            job_id: s(v, "jobId"),
            hotel_id: s(v, "hotelId"),
            action: s(v, "action"),
            booking_id: s(v, "bookingId"),
            booker: s(v, "booker"),
            source_name: s(v, "sourceName"),
            hl_status: s(v, "hlStatus"),
            booking_date: s(v, "bookingDate"),
            check_in: s(v, "checkIn"),
            check_out: s(v, "checkOut"),
            guest_name: s(v, "guestName"),
            guest_phone: s(v, "guestPhone"),
            guest_email: s(v, "guestEmail"),
            book_status: i(v, "bookStatus"),
            payment_code: s(v, "paymentCode"),
            rooms: list(v, "rooms", Room::from_value),
            attempts: i(v, "attempts"),
            not_before: s(v, "notBefore"),
            enqueued_at: s(v, "enqueuedAt"),
            last_error: s(v, "lastError"),
            first_seen_at: s(v, "firstSeenAt"),
            done_at: s(v, "doneAt"),
            hotel_name: s(v, "hotelName"),
            notification_type: s(v, "notificationType"),
            booking_source_code: s(v, "bookingSourceCode"),
            ext_booking_ref: s(v, "extBookingRef"),
            currency_iso: s(v, "currencyIso"),
            amount: f(v, "amount"),
            deposit: f(v, "deposit"),
            tax_fee: f(v, "taxFee"),
            tax_fee_on_arrival: f(v, "taxFeeOnArrival"),
            discount: f(v, "discount"),
            payment_fee: f(v, "paymentFee"),
            ip: s(v, "ip"),
            additional_comments: s(v, "additionalComments"),
            guest_title: s(v, "guestTitle"),
            guest_first_name: s(v, "guestFirstName"),
            guest_last_name: s(v, "guestLastName"),
            guest_address: s(v, "guestAddress"),
            guest_city: s(v, "guestCity"),
            guest_state: s(v, "guestState"),
            guest_country: s(v, "guestCountry"),
            guest_postal_code: s(v, "guestPostalCode"),
            payments: list(v, "payments", |p| HlPayment {
                method: s(p, "method"),
                payment_date: s(p, "paymentDate"),
                amount: f(p, "amount"),
                status: s(p, "status"),
                payment_fee: f(p, "paymentFee"),
                kind: s(p, "type"),
            })
            .unwrap_or_default(),
            extras: list(v, "extras", |e| HlExtra {
                service_name: s(e, "serviceName"),
                quantity: i(e, "quantity"),
                extra_children: i(e, "extraChildren"),
                deposit: f(e, "deposit"),
                amount: f(e, "amount"),
            })
            .unwrap_or_default(),
            force_recreate: b(v, "forceRecreate"),
        }
    }
}

impl Room {
    fn from_value(v: &Value) -> Room {
        Room {
            item_id: s(v, "itemId"),
            room_type_code: s(v, "roomTypeCode"),
            quantity: i(v, "quantity"),
            adults: i(v, "adults"),
            children: i(v, "children"),
            include_bf: b(v, "includeBf"),
            breakfast_code: s(v, "breakfastCode"),
            rates: list(v, "rates", |n| RateNight {
                date: s(n, "date"),
                rate: f(n, "rate"),
                extras: list(n, "extras", |e| RateNightExtra {
                    kind: s(e, "type"),
                    amount: f(e, "amount"),
                })
                .unwrap_or_default(),
            }),
            room_type_hl: s(v, "roomTypeHl"),
            room_code: s(v, "roomCode"),
            rate_plan_id: s(v, "ratePlanId"),
            rate_plan_code: s(v, "ratePlanCode"),
            infants: i(v, "infants"),
            extra_adults: i(v, "extraAdults"),
            extra_children: i(v, "extraChildren"),
            hl_amount: f(v, "hlAmount"),
            hl_deposit: f(v, "hlDeposit"),
            hl_discount: f(v, "hlDiscount"),
            commission: f(v, "commission"),
            item_status: s(v, "itemStatus"),
            special_name: s(v, "specialName"),
            variant: String::new(),
        }
    }
}

impl MappingRow {
    /// Decodes a mapping row object.
    pub fn from_value(v: &Value) -> MappingRow {
        MappingRow {
            room_id: s(v, "roomId"),
            room_type_code: s(v, "roomTypeCode"),
            split_part: opt_i(v, "splitPart"),
            total_part: opt_i(v, "totalPart"),
            is_booking: b(v, "isBooking"),
        }
    }
}

impl MappingCmd {
    /// Decodes a mapping command object.
    pub fn from_value(v: &Value) -> MappingCmd {
        MappingCmd {
            cmd_id: s(v, "cmdId"),
            hotel_id: s(v, "hotelId"),
            op: s(v, "op"),
            row: v.get("row").map(MappingRow::from_value).unwrap_or_default(),
            orig: match v.get("orig") {
                None | Some(Value::Null) => None,
                Some(o) => Some(MappingRow::from_value(o)),
            },
            enqueued_at: s(v, "enqueuedAt"),
        }
    }
}

impl PmsResult {
    /// Decodes a PMS result object.
    pub fn from_value(v: &Value) -> PmsResult {
        PmsResult {
            action: s(v, "action"),
            completed: b(v, "completed"),
            needs_manual: b(v, "needsManual"),
            reason: s(v, "reason"),
            folios: list(v, "folios", |x| PmsFolio {
                folio_num: f(x, "folioNum"),
                confirm_num: f(x, "confirmNum"),
                external_conf: s(x, "externalConfirmNumber"),
                book_status: i(x, "bookStatus"),
                folio_status: i(x, "folioStatus"),
                cancel_num: f(x, "cancelNum"),
                room_code: s(x, "roomCode"),
                room_type_code: s(x, "roomTypeCode"),
                arrival_date: s(x, "arrivalDate"),
                departure_date: s(x, "departureDate"),
            })
            .unwrap_or_default(),
            synced_at: s(v, "syncedAt"),
            audit_gaps: list(v, "auditGaps", |x| {
                x.as_str().unwrap_or_default().to_owned()
            })
            .unwrap_or_default(),
        }
    }
}

fn op_policy(v: &Value) -> OpPolicy {
    OpPolicy {
        allow_when_room_assigned: b(v, "allowWhenRoomAssigned"),
        allow_when_abnormal_book_status: b(v, "allowWhenAbnormalBookStatus"),
        allow_when_checked_in: b(v, "allowWhenCheckedIn"),
    }
}

/// `CancelPolicy.UnmarshalJSON`: the nested shape when `onCancel` or `onModify` is
/// present (a JSON null counts as absent, like a nil pointer), otherwise the legacy flat
/// `allowCancelWhen*` flags fill `onCancel` only.
pub fn policy_from_value(v: &Value) -> CancelPolicy {
    let present = |k: &str| !matches!(v.get(k), None | Some(Value::Null));
    if present("onCancel") || present("onModify") {
        let mut p = CancelPolicy::default();
        if let Some(c) = v.get("onCancel").filter(|x| !x.is_null()) {
            p.on_cancel = op_policy(c);
        }
        if let Some(m) = v.get("onModify").filter(|x| !x.is_null()) {
            p.on_modify = op_policy(m);
        }
        return p;
    }
    CancelPolicy {
        on_cancel: OpPolicy {
            allow_when_room_assigned: b(v, "allowCancelWhenRoomAssigned"),
            allow_when_abnormal_book_status: b(v, "allowCancelWhenAbnormalBookStatus"),
            allow_when_checked_in: b(v, "allowCancelWhenCheckedIn"),
        },
        on_modify: OpPolicy::default(),
    }
}

/// The long-poll answer: `{jobs, wantMapping, mappingCmds, pmsAudits}`.
#[derive(Debug, Clone, Default, PartialEq)]
pub struct Poll {
    /// `jobs`.
    pub jobs: Vec<Job>,
    /// `wantMapping`: the hub asks for a mapping push.
    pub want_mapping: bool,
    /// `mappingCmds`.
    pub mapping_cmds: Vec<MappingCmd>,
    /// `pmsAudits`: read-only PMS audits the hub wants (RT-0702).
    pub pms_audits: Vec<AuditRequest>,
}

/// Decodes the long-poll answer.
pub fn poll_from_value(v: &Value) -> Poll {
    Poll {
        jobs: list(v, "jobs", Job::from_value).unwrap_or_default(),
        want_mapping: b(v, "wantMapping"),
        mapping_cmds: list(v, "mappingCmds", MappingCmd::from_value).unwrap_or_default(),
        pms_audits: list(v, "pmsAudits", AuditRequest::from_value).unwrap_or_default(),
    }
}
