//! The wire contract with the HL hub (`internal/jobmodel`): jobs, PMS results, room-type
//! mapping and availability rows, cancel policy.
//!
//! JSON written here is byte-identical to Go's `encoding/json` (field order, `omitempty`,
//! HTML-safe escaping); [`Job::content_hash`] matches Go's `ContentHash` exactly.

mod audit;
mod decode;
pub(crate) mod encode;
#[cfg(test)]
mod tests;

pub use audit::{AuditFolio, AuditLogRow, AuditRate, AuditRequest, AuditSnapshot, CAP_PMS_AUDIT};
pub use decode::{Poll, policy_from_value, poll_from_value};

/// `ActionSave`: create or modify the booking's folios.
pub const ACTION_SAVE: &str = "save";
/// `ActionCancel`: cancel the booking's folios.
pub const ACTION_CANCEL: &str = "cancel";
/// `ActionManual`: the hub routed the booking to a human; no PMS write.
pub const ACTION_MANUAL: &str = "manual";
/// `ActionIgnore`: benign, ack silently; no PMS write.
pub const ACTION_IGNORE: &str = "ignore";

/// `Action.Valid`.
pub fn action_valid(a: &str) -> bool {
    matches!(
        a,
        ACTION_SAVE | ACTION_CANCEL | ACTION_MANUAL | ACTION_IGNORE
    )
}

/// One booking job from the hub (`jobmodel.Job`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct Job {
    /// `jobId`: `NewJobID`, sorts by time.
    pub job_id: String,
    /// `hotelId`.
    pub hotel_id: String,
    /// `action`: save | cancel | manual | ignore.
    pub action: String,
    /// `bookingId`.
    pub booking_id: String,
    /// `booker`: the OTA reference (ExtBookingRef if any, else BookingId).
    pub booker: String,
    /// `sourceName`: the booking source, looked up in CLIENT / ClientContacts.
    pub source_name: String,
    /// `hlStatus`: the original HL status (diagnostics).
    pub hl_status: String,
    /// `bookingDate`.
    pub booking_date: String,
    /// `checkIn` (yyyy-MM-dd).
    pub check_in: String,
    /// `checkOut` (yyyy-MM-dd).
    pub check_out: String,
    /// `guestName`.
    pub guest_name: String,
    /// `guestPhone`.
    pub guest_phone: String,
    /// `guestEmail`.
    pub guest_email: String,
    /// `bookStatus`.
    pub book_status: i64,
    /// `paymentCode` ("" keeps the DB default "7").
    pub payment_code: String,
    /// `rooms` (`None` = JSON null).
    pub rooms: Option<Vec<Room>>,
    /// `attempts`.
    pub attempts: i64,
    /// `notBefore` (omitempty).
    pub not_before: String,
    /// `enqueuedAt`.
    pub enqueued_at: String,
    /// `lastError` (omitempty).
    pub last_error: String,
    /// `firstSeenAt` (omitempty).
    pub first_seen_at: String,
    /// `doneAt` (omitempty).
    pub done_at: String,
    /// `hotelName` (omitempty).
    pub hotel_name: String,
    /// `notificationType` (omitempty).
    pub notification_type: String,
    /// `bookingSourceCode` (omitempty).
    pub booking_source_code: String,
    /// `extBookingRef` (omitempty).
    pub ext_booking_ref: String,
    /// `currencyIso` (omitempty).
    pub currency_iso: String,
    /// `amount` (omitempty).
    pub amount: f64,
    /// `deposit` (omitempty).
    pub deposit: f64,
    /// `taxFee` (omitempty).
    pub tax_fee: f64,
    /// `taxFeeOnArrival` (omitempty).
    pub tax_fee_on_arrival: f64,
    /// `discount` (omitempty).
    pub discount: f64,
    /// `paymentFee` (omitempty).
    pub payment_fee: f64,
    /// `ip` (omitempty).
    pub ip: String,
    /// `additionalComments` (omitempty).
    pub additional_comments: String,
    /// `guestTitle` (omitempty).
    pub guest_title: String,
    /// `guestFirstName` (omitempty).
    pub guest_first_name: String,
    /// `guestLastName` (omitempty).
    pub guest_last_name: String,
    /// `guestAddress` (omitempty).
    pub guest_address: String,
    /// `guestCity` (omitempty).
    pub guest_city: String,
    /// `guestState` (omitempty).
    pub guest_state: String,
    /// `guestCountry` (omitempty).
    pub guest_country: String,
    /// `guestPostalCode` (omitempty).
    pub guest_postal_code: String,
    /// `payments` (omitempty).
    pub payments: Vec<HlPayment>,
    /// `extras` (omitempty).
    pub extras: Vec<HlExtra>,
    /// `forceRecreate` (omitempty): the hub asks to book again a booking staff cancelled in
    /// PMS while Hotel Link still holds it (RT-1306). Not part of the content hash.
    pub force_recreate: bool,
}

impl Job {
    /// The rooms (an absent list is empty).
    pub fn rooms(&self) -> &[Room] {
        self.rooms.as_deref().unwrap_or(&[])
    }
}

/// One booked room line (`jobmodel.Room`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct Room {
    /// `itemId` (HL never sends it; kept for the hash).
    pub item_id: String,
    /// `roomTypeCode`: the SMILE code, already mapped.
    pub room_type_code: String,
    /// `quantity`.
    pub quantity: i64,
    /// `adults`.
    pub adults: i64,
    /// `children`.
    pub children: i64,
    /// `includeBf`.
    pub include_bf: bool,
    /// `breakfastCode`.
    pub breakfast_code: String,
    /// `rates` (`None` = JSON null).
    pub rates: Option<Vec<RateNight>>,
    /// `roomTypeHl` (omitempty).
    pub room_type_hl: String,
    /// `roomCode` (omitempty).
    pub room_code: String,
    /// `ratePlanId` (omitempty).
    pub rate_plan_id: String,
    /// `ratePlanCode` (omitempty).
    pub rate_plan_code: String,
    /// `infants` (omitempty).
    pub infants: i64,
    /// `extraAdults` (omitempty).
    pub extra_adults: i64,
    /// `extraChildren` (omitempty).
    pub extra_children: i64,
    /// `hlAmount` (omitempty).
    pub hl_amount: f64,
    /// `hlDeposit` (omitempty).
    pub hl_deposit: f64,
    /// `hlDiscount` (omitempty).
    pub hl_discount: f64,
    /// `commission` (omitempty).
    pub commission: f64,
    /// `itemStatus` (omitempty).
    pub item_status: String,
    /// `specialName` (omitempty).
    pub special_name: String,
    /// `Variant` (Go `json:"-"`): agent-local suffix of the folio item key, set by the
    /// reconciler when several items share room type and rate plan but differ in rates,
    /// guests or breakfast (RT-1474). Never encoded, decoded or part of the content hash.
    pub variant: String,
}

impl Room {
    /// The nightly rates (an absent list is empty).
    pub fn rates(&self) -> &[RateNight] {
        self.rates.as_deref().unwrap_or(&[])
    }
}

/// One night (`jobmodel.RateNight`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct RateNight {
    /// `date` (yyyy-MM-dd).
    pub date: String,
    /// `rate`.
    pub rate: f64,
    /// `extras` (omitempty).
    pub extras: Vec<RateNightExtra>,
}

/// A per-night surcharge (`jobmodel.RateNightExtra`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct RateNightExtra {
    /// `type` (omitempty).
    pub kind: String,
    /// `amount` (omitempty).
    pub amount: f64,
}

/// `jobmodel.HLPayment` (display only).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct HlPayment {
    /// `method`.
    pub method: String,
    /// `paymentDate`.
    pub payment_date: String,
    /// `amount`.
    pub amount: f64,
    /// `status`.
    pub status: String,
    /// `paymentFee`.
    pub payment_fee: f64,
    /// `type`.
    pub kind: String,
}

/// `jobmodel.HLExtra` (display only).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct HlExtra {
    /// `serviceName`.
    pub service_name: String,
    /// `quantity`.
    pub quantity: i64,
    /// `extraChildren`.
    pub extra_children: i64,
    /// `deposit`.
    pub deposit: f64,
    /// `amount`.
    pub amount: f64,
}

/// One RoomTypeMapped row (`jobmodel.MappingRow`).
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct MappingRow {
    /// `roomId`.
    pub room_id: String,
    /// `roomTypeCode`.
    pub room_type_code: String,
    /// `splitPart` (null when absent).
    pub split_part: Option<i64>,
    /// `totalPart` (null when absent).
    pub total_part: Option<i64>,
    /// `isBooking`.
    pub is_booking: bool,
}

/// `MappingInsert`.
pub const MAPPING_INSERT: &str = "insert";
/// `MappingUpdate`.
pub const MAPPING_UPDATE: &str = "update";
/// `MappingDelete`.
pub const MAPPING_DELETE: &str = "delete";

/// A mapping command from the hub (`jobmodel.MappingCmd`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct MappingCmd {
    /// `cmdId`.
    pub cmd_id: String,
    /// `hotelId`.
    pub hotel_id: String,
    /// `op`: insert | update | delete.
    pub op: String,
    /// `row`: the new values (insert/update).
    pub row: MappingRow,
    /// `orig`: the row to locate (update/delete).
    pub orig: Option<MappingRow>,
    /// `enqueuedAt`.
    pub enqueued_at: String,
}

/// One availability cell (`jobmodel.AvailRow`).
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct AvailRow {
    /// `roomTypeCode`.
    pub room_type_code: String,
    /// `date` (yyyy-MM-dd).
    pub date: String,
    /// `available`.
    pub available: i64,
}

/// What the agent did in the PMS (`jobmodel.PMSResult`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct PmsResult {
    /// `action`: save | cancel | manual | ignore | skip.
    pub action: String,
    /// `completed`.
    pub completed: bool,
    /// `needsManual` (omitempty).
    pub needs_manual: bool,
    /// `reason` (omitempty).
    pub reason: String,
    /// `folios` (never null when built by the agent).
    pub folios: Vec<PmsFolio>,
    /// `syncedAt` (RFC 3339 UTC, no fraction).
    pub synced_at: String,
    /// `auditGaps` (omitempty): PMS change-history (FolioLog) rows the agent could not
    /// write although the booking itself was applied (RT-0702).
    pub audit_gaps: Vec<String>,
}

/// A folio snapshot (`jobmodel.PMSFolio`).
#[derive(Debug, Clone, Default, PartialEq)]
pub struct PmsFolio {
    /// `folioNum`.
    pub folio_num: f64,
    /// `confirmNum`.
    pub confirm_num: f64,
    /// `externalConfirmNumber`.
    pub external_conf: String,
    /// `bookStatus`.
    pub book_status: i64,
    /// `folioStatus`.
    pub folio_status: i64,
    /// `cancelNum`.
    pub cancel_num: f64,
    /// `roomCode`.
    pub room_code: String,
    /// `roomTypeCode`.
    pub room_type_code: String,
    /// `arrivalDate` (yyyy-MM-dd).
    pub arrival_date: String,
    /// `departureDate` (yyyy-MM-dd).
    pub departure_date: String,
}

/// The three guard flags of one operation (`jobmodel.OpPolicy`).
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct OpPolicy {
    /// `allowWhenRoomAssigned`.
    pub allow_when_room_assigned: bool,
    /// `allowWhenAbnormalBookStatus`.
    pub allow_when_abnormal_book_status: bool,
    /// `allowWhenCheckedIn`.
    pub allow_when_checked_in: bool,
}

/// The hub's cancel/modify guard policy (`jobmodel.CancelPolicy`).
#[derive(Debug, Clone, Copy, Default, PartialEq, Eq)]
pub struct CancelPolicy {
    /// `onCancel`.
    pub on_cancel: OpPolicy,
    /// `onModify`.
    pub on_modify: OpPolicy,
}

/// `NewJobID`: zero-padded Unix milliseconds, `-`, the booking id.
pub fn new_job_id(unix_millis: i64, booking_id: &str) -> String {
    format!("{unix_millis:016}-{booking_id}")
}

/// `MappingHash`: sha256 hex of the rows sorted by (RoomTypeCode, RoomId).
pub fn mapping_hash(rows: &[MappingRow]) -> String {
    let mut sorted = rows.to_vec();
    sorted.sort_by(|a, b| {
        a.room_type_code
            .cmp(&b.room_type_code)
            .then_with(|| a.room_id.cmp(&b.room_id))
    });
    let mut out = String::new();
    encode::mapping_rows(&mut out, &sorted);
    sha256_hex(out.as_bytes())
}

/// Lower-case hex SHA-256.
pub(crate) fn sha256_hex(data: &[u8]) -> String {
    use dl_hash::Digest;
    dl_encoding::hex::encode(dl_hash::Sha256::digest(data))
}
