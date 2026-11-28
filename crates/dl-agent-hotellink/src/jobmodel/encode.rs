//! Go-compatible JSON encoding of the wire types (field order and `omitempty` as the
//! struct tags in `internal/jobmodel`).

use super::{
    AvailRow, CancelPolicy, HlExtra, HlPayment, Job, MappingCmd, MappingRow, OpPolicy, PmsFolio,
    PmsResult, RateNight, RateNightExtra, Room,
};
use crate::gojson::{Obj, array, string};

impl Job {
    /// `json.Marshal(job)`.
    pub fn to_json(&self) -> String {
        let mut out = String::new();
        self.write_json(&mut out);
        out
    }

    /// Appends `json.Marshal(job)` to `out`.
    pub fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str("jobId", &self.job_id)
            .str("hotelId", &self.hotel_id)
            .str("action", &self.action)
            .str("bookingId", &self.booking_id)
            .str("booker", &self.booker)
            .str("sourceName", &self.source_name)
            .str("hlStatus", &self.hl_status)
            .str("bookingDate", &self.booking_date)
            .str("checkIn", &self.check_in)
            .str("checkOut", &self.check_out)
            .str("guestName", &self.guest_name)
            .str("guestPhone", &self.guest_phone)
            .str("guestEmail", &self.guest_email)
            .int("bookStatus", self.book_status)
            .str("paymentCode", &self.payment_code)
            .raw("rooms", |out| {
                array(out, self.rooms.as_deref(), |out, r| r.write_json(out))
            })
            .int("attempts", self.attempts)
            .str_omit("notBefore", &self.not_before)
            .str("enqueuedAt", &self.enqueued_at)
            .str_omit("lastError", &self.last_error)
            .str_omit("firstSeenAt", &self.first_seen_at)
            .str_omit("doneAt", &self.done_at)
            .str_omit("hotelName", &self.hotel_name)
            .str_omit("notificationType", &self.notification_type)
            .str_omit("bookingSourceCode", &self.booking_source_code)
            .str_omit("extBookingRef", &self.ext_booking_ref)
            .str_omit("currencyIso", &self.currency_iso)
            .float_omit("amount", self.amount)
            .float_omit("deposit", self.deposit)
            .float_omit("taxFee", self.tax_fee)
            .float_omit("taxFeeOnArrival", self.tax_fee_on_arrival)
            .float_omit("discount", self.discount)
            .float_omit("paymentFee", self.payment_fee)
            .str_omit("ip", &self.ip)
            .str_omit("additionalComments", &self.additional_comments)
            .str_omit("guestTitle", &self.guest_title)
            .str_omit("guestFirstName", &self.guest_first_name)
            .str_omit("guestLastName", &self.guest_last_name)
            .str_omit("guestAddress", &self.guest_address)
            .str_omit("guestCity", &self.guest_city)
            .str_omit("guestState", &self.guest_state)
            .str_omit("guestCountry", &self.guest_country)
            .str_omit("guestPostalCode", &self.guest_postal_code);
        if !self.payments.is_empty() {
            o.raw("payments", |out| {
                array(out, Some(&self.payments), |out, p| p.write_json(out))
            });
        }
        if !self.extras.is_empty() {
            o.raw("extras", |out| {
                array(out, Some(&self.extras), |out, e| e.write_json(out))
            });
        }
        o.bool_omit("forceRecreate", self.force_recreate);
        o.end();
    }

    /// `ContentHash`: sha256 hex of the business fields only (Go field names as keys, a
    /// nil room list hashed as `[]`), so HL display fields and hub bookkeeping never
    /// change it.
    pub fn content_hash(&self) -> String {
        let mut out = String::new();
        let mut o = Obj::new(&mut out);
        o.str("HotelID", &self.hotel_id)
            .str("BookingID", &self.booking_id)
            .str("Booker", &self.booker)
            .str("SourceName", &self.source_name)
            .str("HLStatus", &self.hl_status)
            .str("BookingDate", &self.booking_date)
            .str("CheckIn", &self.check_in)
            .str("CheckOut", &self.check_out)
            .str("GuestName", &self.guest_name)
            .str("GuestPhone", &self.guest_phone)
            .str("GuestEmail", &self.guest_email)
            .str("Action", &self.action)
            .int("BookStatus", self.book_status)
            .str("PaymentCode", &self.payment_code)
            .raw("Rooms", |out| {
                array(out, Some(self.rooms()), |out, r| {
                    let mut o = Obj::new(out);
                    o.str("itemId", &r.item_id)
                        .str("roomTypeCode", &r.room_type_code)
                        .int("quantity", r.quantity)
                        .int("adults", r.adults)
                        .int("children", r.children)
                        .bool("includeBf", r.include_bf)
                        .str("breakfastCode", &r.breakfast_code)
                        .raw("rates", |out| {
                            array(out, Some(r.rates()), |out, n| {
                                let mut o = Obj::new(out);
                                o.str("date", &n.date).float("rate", n.rate);
                                o.end();
                            })
                        });
                    o.end();
                })
            });
        o.end();
        super::sha256_hex(out.as_bytes())
    }
}

impl Room {
    fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str("itemId", &self.item_id)
            .str("roomTypeCode", &self.room_type_code)
            .int("quantity", self.quantity)
            .int("adults", self.adults)
            .int("children", self.children)
            .bool("includeBf", self.include_bf)
            .str("breakfastCode", &self.breakfast_code)
            .raw("rates", |out| {
                array(out, self.rates.as_deref(), |out, n| n.write_json(out))
            })
            .str_omit("roomTypeHl", &self.room_type_hl)
            .str_omit("roomCode", &self.room_code)
            .str_omit("ratePlanId", &self.rate_plan_id)
            .str_omit("ratePlanCode", &self.rate_plan_code)
            .int_omit("infants", self.infants)
            .int_omit("extraAdults", self.extra_adults)
            .int_omit("extraChildren", self.extra_children)
            .float_omit("hlAmount", self.hl_amount)
            .float_omit("hlDeposit", self.hl_deposit)
            .float_omit("hlDiscount", self.hl_discount)
            .float_omit("commission", self.commission)
            .str_omit("itemStatus", &self.item_status)
            .str_omit("specialName", &self.special_name);
        o.end();
    }
}

impl RateNight {
    fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str("date", &self.date).float("rate", self.rate);
        if !self.extras.is_empty() {
            o.raw("extras", |out| {
                array(out, Some(&self.extras), |out, e: &RateNightExtra| {
                    let mut o = Obj::new(out);
                    o.str_omit("type", &e.kind).float_omit("amount", e.amount);
                    o.end();
                })
            });
        }
        o.end();
    }
}

impl HlPayment {
    fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str_omit("method", &self.method)
            .str_omit("paymentDate", &self.payment_date)
            .float_omit("amount", self.amount)
            .str_omit("status", &self.status)
            .float_omit("paymentFee", self.payment_fee)
            .str_omit("type", &self.kind);
        o.end();
    }
}

impl HlExtra {
    fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str_omit("serviceName", &self.service_name)
            .int_omit("quantity", self.quantity)
            .int_omit("extraChildren", self.extra_children)
            .float_omit("deposit", self.deposit)
            .float_omit("amount", self.amount);
        o.end();
    }
}

impl MappingRow {
    /// Appends `json.Marshal(row)`.
    pub fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str("roomId", &self.room_id)
            .str("roomTypeCode", &self.room_type_code)
            .raw("splitPart", |out| opt_int(out, self.split_part))
            .raw("totalPart", |out| opt_int(out, self.total_part))
            .bool("isBooking", self.is_booking);
        o.end();
    }
}

fn opt_int(out: &mut String, v: Option<i64>) {
    match v {
        Some(n) => out.push_str(&n.to_string()),
        None => out.push_str("null"),
    }
}

/// `json.Marshal([]MappingRow)` (never null).
pub(crate) fn mapping_rows(out: &mut String, rows: &[MappingRow]) {
    array(out, Some(rows), |out, r| r.write_json(out));
}

impl MappingCmd {
    /// `json.Marshal(cmd)`.
    pub fn to_json(&self) -> String {
        let mut out = String::new();
        let mut o = Obj::new(&mut out);
        o.str("cmdId", &self.cmd_id)
            .str("hotelId", &self.hotel_id)
            .str("op", &self.op)
            .raw("row", |out| self.row.write_json(out));
        if let Some(orig) = &self.orig {
            o.raw("orig", |out| orig.write_json(out));
        }
        o.str("enqueuedAt", &self.enqueued_at);
        o.end();
        out
    }
}

/// `json.Marshal([]AvailRow)` (never null).
pub(crate) fn avail_rows(out: &mut String, rows: &[AvailRow]) {
    array(out, Some(rows), |out, r| {
        let mut o = Obj::new(out);
        o.str("roomTypeCode", &r.room_type_code)
            .str("date", &r.date)
            .int("available", r.available);
        o.end();
    });
}

impl PmsResult {
    /// `json.Marshal(result)`.
    pub fn to_json(&self) -> String {
        let mut out = String::new();
        self.write_json(&mut out);
        out
    }

    /// Appends `json.Marshal(result)` to `out`.
    pub fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.str("action", &self.action)
            .bool("completed", self.completed)
            .bool_omit("needsManual", self.needs_manual)
            .str_omit("reason", &self.reason)
            .raw("folios", |out| {
                array(out, Some(&self.folios), |out, f| f.write_json(out))
            })
            .str("syncedAt", &self.synced_at);
        if !self.audit_gaps.is_empty() {
            o.raw("auditGaps", |out| {
                array(out, Some(&self.audit_gaps), |out, g| string(out, g))
            });
        }
        o.end();
    }
}

impl PmsFolio {
    fn write_json(&self, out: &mut String) {
        let mut o = Obj::new(out);
        o.float("folioNum", self.folio_num)
            .float("confirmNum", self.confirm_num)
            .str("externalConfirmNumber", &self.external_conf)
            .int("bookStatus", self.book_status)
            .int("folioStatus", self.folio_status)
            .float("cancelNum", self.cancel_num)
            .str("roomCode", &self.room_code)
            .str("roomTypeCode", &self.room_type_code)
            .str("arrivalDate", &self.arrival_date)
            .str("departureDate", &self.departure_date);
        o.end();
    }
}

impl CancelPolicy {
    /// `json.Marshal(policy)` (always the nested shape).
    pub fn to_json(&self) -> String {
        let mut out = String::new();
        let mut o = Obj::new(&mut out);
        o.raw("onCancel", |out| op_policy(out, &self.on_cancel))
            .raw("onModify", |out| op_policy(out, &self.on_modify));
        o.end();
        out
    }
}

fn op_policy(out: &mut String, p: &OpPolicy) {
    let mut o = Obj::new(out);
    o.bool("allowWhenRoomAssigned", p.allow_when_room_assigned)
        .bool(
            "allowWhenAbnormalBookStatus",
            p.allow_when_abnormal_book_status,
        )
        .bool("allowWhenCheckedIn", p.allow_when_checked_in);
    o.end();
}
