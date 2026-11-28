//! Cancel, conflict and create/cancel ordering cases.

use super::*;
use crate::jobmodel::{ACTION_CANCEL, ACTION_IGNORE, ACTION_MANUAL};

fn cancel_job() -> Job {
    Job {
        action: ACTION_CANCEL.into(),
        ..save_job()
    }
}

fn ext(s: &str) -> Option<String> {
    Some(s.into())
}

/// A one-night DLX job for booking `id` (booker "BK").
fn dlx_job(id: &str, check_out: &str) -> Job {
    Job {
        booking_id: id.into(),
        booker: "BK".into(),
        action: ACTION_SAVE.into(),
        check_in: "2026-06-15".into(),
        check_out: check_out.into(),
        rooms: Some(vec![Room {
            room_type_code: "DLX".into(),
            rate_plan_id: "RP".into(),
            quantity: 1,
            rates: Some(vec![rn("2026-06-15", 100.0)]),
            ..Room::default()
        }]),
        ..Job::default()
    }
}

fn at_030405() -> OffsetDateTime {
    let t = dl_time::Time::from_hms(3, 4, 5).expect("valid");
    Date::new(2026, 6, 15).expect("valid").at(t).assume_utc()
}

#[test]
fn conflict_flags() {
    type Case = (&'static str, Folio, &'static [(&'static str, i64)], bool);
    let cases: [Case; 5] = [
        (
            "FolioStatus>1 always conflicts",
            Folio {
                folio_status: 2,
                ..Folio::default()
            },
            &[],
            true,
        ),
        (
            "BookStatus!=1 + CancelByStatus=1",
            Folio {
                book_status: 0,
                folio_status: 1,
                ..Folio::default()
            },
            &[("CancelByStatus", 1)],
            true,
        ),
        (
            "BookStatus!=1 + CancelByStatus=0",
            Folio {
                book_status: 0,
                folio_status: 1,
                ..Folio::default()
            },
            &[],
            false,
        ),
        (
            "RoomCode set + CancelByRoom=1",
            Folio {
                book_status: 1,
                folio_status: 1,
                room_code: "101".into(),
                ..Folio::default()
            },
            &[("CancelByRoom", 1)],
            true,
        ),
        (
            "RoomCode set + CancelByRoom=0",
            Folio {
                book_status: 1,
                folio_status: 1,
                room_code: "101".into(),
                ..Folio::default()
            },
            &[],
            false,
        ),
    ];
    for (name, folio, params, want) in cases {
        let repo = FakeRepo::new();
        for (k, v) in params {
            repo.st().global_params.insert((*k).into(), *v);
        }
        let got = new_reconciler(&repo)
            .has_conflicting_folios(&[folio], OpPolicy::default())
            .expect("no error");
        assert_eq!(got, want, "{name}");
    }
}

#[test]
fn cancel_no_folios_is_ok() {
    let repo = FakeRepo::new();
    new_reconciler(&repo).apply(&cancel_job()).expect("apply");
    assert!(repo.st().cancelled.is_empty());
}

#[test]
fn cancel_with_conflict_needs_manual() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        folio_status: 2,
        ..Folio::default()
    }];
    let res = new_reconciler(&repo)
        .apply(&cancel_job())
        .expect("not an error");
    assert!(res.needs_manual && !res.completed, "{res:?}");
    assert!(!res.reason.is_empty(), "reason for the dashboard");
    assert!(repo.st().cancelled.is_empty());
}

#[test]
fn diff_disappeared_conflict_needs_manual() {
    let repo = FakeRepo::new();
    {
        let mut s = repo.st();
        s.global_params.insert("CancelByStatus".into(), 1);
        s.folios = vec![Folio {
            id: 1,
            folio_num: 100000.0,
            book_status: 3,
            folio_status: 1,
            room_type_code: "SUITE".into(),
            user_info1: "rt:SUITE#0".into(),
            ..Folio::default()
        }];
    }
    let res = new_reconciler(&repo)
        .apply(&save_job())
        .expect("not an error");
    assert!(res.needs_manual && !res.completed, "{res:?}");
    assert!(repo.st().cancelled.is_empty());
}

#[test]
fn cancel_happy_path() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        id: 1,
        folio_num: 100000.0,
        book_status: 1,
        folio_status: 1,
        ..Folio::default()
    }];
    new_reconciler(&repo).apply(&cancel_job()).expect("apply");
    assert_eq!(repo.st().cancelled.len(), 1);
}

#[test]
fn cancel_then_recreate_aborts_on_conflicting_in_house() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        folio_num: 1.0,
        external_confirm_number: ext("B-2"),
        room_type_code: "STD".into(),
        folio_status: 9,
        ..Folio::default()
    }];
    let res = new_reconciler(&repo)
        .apply(&dlx_job("B-2", "2026-06-16"))
        .expect("green skip, not an error");
    assert!(res.completed && !res.needs_manual, "{res:?}");
    let s = repo.st();
    assert!(s.inserted.is_empty() && s.cancelled.is_empty());
}

#[test]
fn recreate_then_cancel_creates_before_cancel_fails() {
    let repo = FakeRepo::new();
    {
        let mut s = repo.st();
        s.folios = vec![Folio {
            folio_num: 1.0,
            external_confirm_number: ext("B-3"),
            room_type_code: "STD".into(),
            ..Folio::default()
        }];
        s.cancel_err = Some("cancel boom".into());
    }
    assert!(
        new_reconciler(&repo)
            .apply(&dlx_job("B-3", "2026-06-16"))
            .is_err()
    );
    assert_eq!(repo.st().inserted.len(), 1, "create before cancel");
}

#[test]
fn create_rooms_guard_skips_when_folio_appears() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        folio_num: 1.0,
        external_confirm_number: ext("B-1"),
        ..Folio::default()
    }];
    let mut job = dlx_job("B-1", "2026-06-16");
    job.booker = "BK".into();
    let rooms = job.rooms.clone().expect("rooms");
    new_reconciler(&repo)
        .create_rooms(
            &job,
            &rooms,
            500001.0,
            day(2026, 6, 15),
            day(2026, 6, 16),
            None,
            None,
            None,
            true,
            &super::super::history::CreateLog::new(&[]),
        )
        .expect("create_rooms");
    assert!(repo.st().inserted.is_empty(), "guard skips the insert");
}

#[test]
fn apply_save_returns_save_result() {
    let repo = FakeRepo::new();
    repo.st().folios_after_insert = Some(vec![Folio {
        folio_num: 100001.0,
        confirm_num: 500001.0,
        external_confirm_number: ext("B-9"),
        room_type_code: "DLX".into(),
        book_status: 1,
        folio_status: 1,
        arrival_date: day(2026, 6, 15),
        departure_date: day(2026, 6, 17),
        ..Folio::default()
    }]);
    let r = Reconciler::with_clock(repo.clone(), Arc::new(at_030405));
    let res = r.apply(&dlx_job("B-9", "2026-06-17")).expect("apply");
    assert!(res.action == "save" && res.completed, "{res:?}");
    assert_eq!(res.folios.len(), 1);
    assert_eq!(res.folios[0].external_conf, "B-9");
    assert_eq!(res.folios[0].arrival_date, "2026-06-15");
    assert_eq!(res.synced_at, "2026-06-15T03:04:05Z");
}

#[test]
fn apply_save_never_recreates_cancelled_booking() {
    let repo = FakeRepo::new();
    repo.st().cancelled_booking.insert("BK".into(), true);
    let res = new_reconciler(&repo)
        .apply(&dlx_job("B-9", "2026-06-17"))
        .expect("manual, not an error");
    assert!(res.needs_manual && !res.completed, "{res:?}");
    assert!(repo.st().inserted.is_empty());
}

#[test]
fn apply_save_force_recreate_overrides_staff_cancel() {
    let repo = FakeRepo::new();
    repo.st().cancelled_booking.insert("BK".into(), true);
    let job = Job {
        force_recreate: true,
        ..dlx_job("B-9", "2026-06-17")
    };
    let res = new_reconciler(&repo).apply(&job).expect("apply");
    assert!(!res.needs_manual && res.completed, "{res:?}");
    assert!(!repo.st().inserted.is_empty());
}

#[test]
fn apply_cancel_returns_cancel_result() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        folio_num: 1.0,
        external_confirm_number: ext("B-10"),
        room_type_code: "DLX".into(),
        arrival_date: day(2026, 6, 15),
        departure_date: day(2026, 6, 16),
        ..Folio::default()
    }];
    let r = Reconciler::with_clock(repo.clone(), Arc::new(at_030405));
    let job = Job {
        booking_id: "B-10".into(),
        booker: "BK".into(),
        action: ACTION_CANCEL.into(),
        ..Job::default()
    };
    let res = r.apply(&job).expect("apply");
    assert!(
        res.action == "cancel" && res.completed && res.folios.len() == 1,
        "{res:?}"
    );
    assert!(res.folios[0].cancel_num != 0.0, "CancelNum stamped");
}

#[test]
fn apply_cancel_refused_needs_manual() {
    let repo = FakeRepo::new();
    repo.st().folios = vec![Folio {
        folio_num: 1.0,
        external_confirm_number: ext("B-11"),
        folio_status: 9,
        ..Folio::default()
    }];
    let r = Reconciler::with_clock(repo.clone(), Arc::new(at_030405));
    let job = Job {
        booking_id: "B-11".into(),
        booker: "BK".into(),
        action: ACTION_CANCEL.into(),
        ..Job::default()
    };
    let res = r.apply(&job).expect("not an error");
    assert!(
        res.action == "cancel" && !res.completed && res.needs_manual,
        "{res:?}"
    );
    assert!(!res.reason.is_empty());
}

#[test]
fn happy_path_not_manual() {
    let repo = FakeRepo::new();
    let res = new_reconciler(&repo).apply(&save_job()).expect("apply");
    assert!(!res.needs_manual, "{res:?}");
}

fn manual_like(action: &str) -> Job {
    Job {
        action: action.into(),
        booking_id: "B1".into(),
        ..Job::default()
    }
}

#[test]
fn apply_manual_no_pms_write() {
    let repo = FakeRepo::new();
    let res = new_reconciler(&repo)
        .apply(&manual_like(ACTION_MANUAL))
        .expect("no error");
    assert!(res.needs_manual && !res.completed, "{res:?}");
    assert_eq!(res.action, "manual");
    let (u, i, c, _) = counts(&repo);
    assert_eq!((u, i, c), (0, 0, 0));
}

#[test]
fn apply_ignore_silent_ack() {
    let repo = FakeRepo::new();
    let res = new_reconciler(&repo)
        .apply(&manual_like(ACTION_IGNORE))
        .expect("no error");
    assert!(res.completed && !res.needs_manual, "{res:?}");
    assert_eq!(res.action, "ignore");
    let (u, i, c, _) = counts(&repo);
    assert_eq!((u, i, c), (0, 0, 0));
}
