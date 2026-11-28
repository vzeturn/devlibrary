//! The `op_sweep` command: runs every operation of the catalog against the hotel's real PMS
//! and reports, per operation, whether the procedure ran (`ok`), failed with a SQL error
//! (classified) or was skipped, and why.
//!
//! Every call runs inside a transaction that is rolled back, reads included (some read
//! procedures write, e.g. `group.auto-assign`), so a sweep leaves the PMS as it was. Nothing
//! commits: `commit: true` is refused. A procedure that ends the sweep's transaction itself
//! (its own `COMMIT`/`ROLLBACK` past the sweep's `BEGIN`) is caught after the call: a temp
//! table made inside the sweep's transaction must still be there after the call and gone after
//! the rollback, and `@@TRANCOUNT` must not be 0; otherwise the row says `transaction:
//! "escaped"` and the operation `failed` (its writes may be kept). One case is told apart: a
//! call that failed with a SQL error, left `@@TRANCOUNT` at 0 and took the mark with it was
//! rolled back by that error (`XACT_ABORT`), so the row says `transaction: "aborted"`; that
//! holds because the bundle's procedures have no `ROLLBACK`, `TRY`/`CATCH` or nested `EXEC`
//! (a test pins it), so nothing of theirs runs after the abort. Each call waits at most
//! [`LOCK_TIMEOUT_MS`] for a lock; the write procedures hold theirs (e.g. `HOLDLOCK` on
//! `AutoFolioNumber`) until the rollback, up to the per-operation timeout, so a sweep runs
//! off-peak. The sweep refuses to start unless the PMS holds the procedure bundle this agent
//! ships (its marker hash).
//!
//! Parameters are type-valid placeholders (required ones a neutral value, optional ones SQL
//! NULL) unless the command gives them (`params: {"<op>": {"<name>": "<value>" | null}}`).
//! Messages are kept only for the classes that point at the install (schema, permission,
//! other), never for business or data errors, which may echo PMS values.

use std::time::{Duration, Instant};

use dl_json::{Map, Value};
use dl_tds::{Client, Error as TdsError, Results};

use crate::agent::installer;
use crate::agent::tds::{self, TdsExecutor};
use crate::contracts::catalog::{Operation, OperationKind, ParamType, catalog};
use crate::contracts::messages::Params;

/// The per-operation timeout when the command names none.
pub const DEFAULT_TIMEOUT: Duration = Duration::from_secs(20);
/// The longest message kept per operation (characters).
const MESSAGE_CHARS: usize = 240;
/// Lock waits inside a sweep (per operation): a busy PMS must not hold the sweep.
pub const LOCK_TIMEOUT_MS: u32 = 2000;
/// Made inside each operation's transaction: proof the rollback undid that transaction.
const MARK: &str = "#dl_sweep_tx";
/// Operations a sweep never calls, whatever the command asks (RT-1496). `folio.post-payment` takes the folio
/// posting lock, posts through SMILE's own `PostOneTransaction` and rolls back its own transaction on a refusal,
/// so it is the one procedure of the bundle outside the no-`ROLLBACK` / no-`EXEC` rule that makes
/// `aborted` sound; a payment is proved on a test PMS, never by a sweep of a hotel's.
pub const NEVER_SWEPT: &[&str] = &["folio.post-payment"];

/// What the command asked for.
#[derive(Debug, Clone, PartialEq)]
pub struct SweepOptions {
    /// Only these operations (all when empty).
    pub only: Vec<String>,
    /// Operations to leave out.
    pub skip: Vec<String>,
    /// Parameter values per operation, over the placeholders.
    pub params: Map,
    /// Per-operation timeout.
    pub timeout: Duration,
    /// The hotel's date, `yyyy-MM-dd` (the placeholder for dates).
    pub today: String,
}

impl SweepOptions {
    /// Reads the command arguments.
    ///
    /// # Errors
    /// A wrong type, an unknown operation, or `commit` (the sweep never commits).
    pub fn from_args(args: &Value, today: &str) -> Result<SweepOptions, String> {
        let names = |key: &str| -> Result<Vec<String>, String> {
            match args.get(key) {
                None | Some(Value::Null) => Ok(Vec::new()),
                Some(Value::Array(a)) => a
                    .iter()
                    .map(|v| {
                        v.as_str()
                            .map(str::to_string)
                            .ok_or_else(|| format!("{key} must list operation names"))
                    })
                    .collect(),
                Some(_) => Err(format!("{key} must be an array of operation names")),
            }
        };
        if !matches!(
            args.get("commit"),
            None | Some(Value::Null | Value::Bool(false))
        ) {
            return Err(
                "op_sweep never commits: every call is rolled back; leave commit out".into(),
            );
        }
        let only = names("only")?;
        let skip = names("skip")?;
        let params = match args.get("params") {
            None | Some(Value::Null) => Map::new(),
            Some(Value::Object(m)) => m.clone(),
            Some(_) => return Err("params must be an object of operation -> parameters".into()),
        };
        let timeout = match args.get("timeout_seconds") {
            None | Some(Value::Null) => DEFAULT_TIMEOUT,
            Some(v) => v
                .as_u64()
                .filter(|n| (1..=300).contains(n))
                .map(Duration::from_secs)
                .ok_or("timeout_seconds must be 1..300")?,
        };
        let cat = catalog().map_err(|e| e.to_string())?;
        let known = |n: &str| cat.operations().iter().any(|o| o.name == n);
        let params_ops: Vec<String> = params.iter().map(|(k, _)| k.to_string()).collect();
        for n in only.iter().chain(&skip).chain(&params_ops) {
            if !known(n) {
                return Err(format!("unknown operation {n}"));
            }
        }
        Ok(SweepOptions {
            only,
            skip,
            params,
            timeout,
            today: today.to_string(),
        })
    }
}

/// A neutral, type-valid value for a required parameter.
fn placeholder(ty: ParamType, today: &str) -> String {
    match ty {
        ParamType::String | ParamType::Int | ParamType::Long | ParamType::Decimal => "0".into(),
        ParamType::Date => today.to_string(),
        ParamType::DateTime => format!("{today}T00:00:00"),
        ParamType::Bool => "false".into(),
        ParamType::Xml => "<root/>".into(),
        ParamType::Binary => "AA==".into(),
    }
}

/// The parameters the sweep sends for `op`.
///
/// # Errors
/// A given value that is not a string or null.
pub fn sweep_params(op: &Operation, opts: &SweepOptions) -> Result<Params, String> {
    let given = match opts.params.get(&op.name) {
        None | Some(Value::Null) => None,
        Some(Value::Object(m)) => Some(m),
        Some(_) => return Err(format!("params.{} must be an object", op.name)),
    };
    let mut out = Params::new();
    for p in &op.parameters {
        let value = match given.and_then(|m| m.get(&p.name)) {
            Some(Value::Null) => None,
            Some(Value::String(s)) => Some(s.clone()),
            Some(Value::Number(n)) => Some(n.to_string()),
            Some(Value::Bool(b)) => Some(b.to_string()),
            Some(_) => return Err(format!("params.{}.{} must be a string", op.name, p.name)),
            None if p.required => Some(placeholder(p.ty, &opts.today)),
            None => None,
        };
        out.insert(p.name.clone(), value);
    }
    Ok(out)
}

/// The class of a SQL error number: `business` (raised by the procedure), `schema` (an
/// object, column or parameter the procedure needs is missing), `permission`, `data` (the
/// placeholder values broke a rule), `timeout` or `other`.
pub fn classify(number: i32) -> &'static str {
    match number {
        n if n >= 50000 => "business",
        207 | 208 | 213 | 201 | 2812 | 4121 | 8144 | 8145 | 4104 | 1911 => "schema",
        229 | 230 | 262 | 297 | 300 | 916 | 15247 | 4064 => "permission",
        245 | 241 | 242 | 515 | 547 | 2601 | 2627 | 8114 | 8115 | 8152 | 2628 | 9436 | 6602 => {
            "data"
        }
        -2 | 1222 => "timeout",
        _ => "other",
    }
}

fn clip(s: &str) -> String {
    match s.char_indices().nth(MESSAGE_CHARS) {
        Some((i, _)) => format!("{}…", &s[..i]),
        None => s.to_string(),
    }
}

/// Runs the sweep on a fresh session of `target`.
///
/// # Errors
/// The PMS cannot be reached (a message without the connection string), or it does not hold
/// the procedure bundle this agent ships.
pub fn sweep<'a>(target: impl Into<tds::Target<'a>>, opts: &SweepOptions) -> Result<Value, String> {
    let target = target.into();
    let open = || {
        tds::connect(target, None).map_err(|e| format!("cannot connect: {}", tds::exec_error(&e)))
    };
    let mut client = open()?;
    let shipped = installer::bundle().hash.as_str();
    let installed =
        installer::read_marker(&mut client, installer::PROPERTY_NAME).map_err(|e| e.0)?;
    if installed.as_deref() != Some(shipped) {
        return Err(format!(
            "the PMS holds procedure bundle {}, this agent ships {shipped}: run install_procedures first; nothing was swept",
            installed.as_deref().unwrap_or("none")
        ));
    }
    let cat = catalog().map_err(|e| e.to_string())?;
    let started = Instant::now();
    let mut results = Vec::new();
    let mut counts = Map::new();
    let mut all_rolled_back = true;
    for op in cat.operations() {
        if !opts.only.is_empty() && !opts.only.contains(&op.name) {
            continue;
        }
        let row = if NEVER_SWEPT.contains(&op.name.as_str()) {
            skipped(op, "never swept: it posts a payment on the folio")
        } else if opts.skip.contains(&op.name) {
            skipped(op, "left out by the command")
        } else {
            let row = run_one(&mut client, op, opts);
            if client.is_broken() {
                // A dropped session rolls its transaction back on the server.
                client = open()?;
            }
            row
        };
        let result = row.get("result").and_then(Value::as_str);
        let key = match result {
            Some("sql_error") => row.get("class").and_then(Value::as_str),
            other => other,
        };
        if let Some(k) = key {
            let n = counts.get(k).and_then(Value::as_u64).unwrap_or(0) + 1;
            counts.insert(k.to_string(), n);
        }
        if result != Some("skipped")
            && !matches!(
                row.get("transaction").and_then(Value::as_str),
                Some("rolled_back" | "aborted")
            )
        {
            all_rolled_back = false;
        }
        results.push(Value::Object(row));
    }
    let mut out = Map::new();
    out.insert("catalog_version", i64::from(cat.version));
    out.insert("bundle", shipped);
    out.insert("rolled_back", all_rolled_back);
    out.insert("total", results.len() as u64);
    out.insert("counts", Value::Object(counts));
    out.insert("ms", started.elapsed().as_millis() as u64);
    out.insert("ops", Value::Array(results));
    Ok(Value::Object(out))
}

fn head(op: &Operation) -> Map {
    let mut m = Map::new();
    m.insert("op", op.name.as_str());
    m.insert(
        "kind",
        match op.kind {
            OperationKind::Read => "read",
            OperationKind::Write => "write",
        },
    );
    m.insert("procedure", op.procedure.as_str());
    m
}

fn skipped(op: &Operation, why: &str) -> Map {
    let mut m = head(op);
    m.insert("result", "skipped");
    m.insert("why", why);
    m
}

/// One operation inside its own transaction.
fn run_one(client: &mut Client, op: &Operation, opts: &SweepOptions) -> Map {
    let params = match sweep_params(op, opts) {
        Ok(p) => p,
        Err(e) => return skipped(op, &e),
    };
    let sql_params = match TdsExecutor::params(op, &params) {
        Ok(p) => p,
        Err(e) => return skipped(op, &e.to_string()),
    };
    let mut m = head(op);
    let started = Instant::now();
    let begin = client.set_timeout(Some(opts.timeout)).and_then(|()| {
        client
            .batch(&format!(
                "SET LOCK_TIMEOUT {LOCK_TIMEOUT_MS}; BEGIN TRANSACTION; CREATE TABLE {MARK} (n INT);"
            ))
            .map(|_| ())
    });
    if let Err(e) = begin {
        m.insert("result", "error");
        m.insert(
            "why",
            format!("could not open the transaction: {}", tds::exec_error(&e)),
        );
        if !client.is_broken()
            && let Err(e) = client.batch(&end_batch())
        {
            dl_log::warn!("op_sweep could not undo a half-opened transaction"; op = %op.name, error = %e);
        }
        return m;
    }
    let called = client.call(&op.procedure, &sql_params);
    let call_failed = called.is_err();
    let closed = close(client);
    m.insert("ms", started.elapsed().as_millis() as u64);
    match called {
        Ok(results) => {
            let sets: Vec<_> = results
                .sets()
                .iter()
                .filter(|s| !s.columns().is_empty())
                .collect();
            m.insert("result", "ok");
            m.insert("sets", sets.len() as u64);
            m.insert("rows", sets.iter().map(|s| s.len() as u64).sum::<u64>());
        }
        Err(e) => sql_error(&mut m, &e),
    }
    match closed {
        Ok(c) => {
            if c.trancount != 1 {
                m.insert("trancount", c.trancount);
            }
            if c.rolled_back() {
                m.insert("transaction", "rolled_back");
            } else if c.aborted_by(call_failed) {
                m.insert("transaction", "aborted");
            } else {
                dl_log::error!("op_sweep: a procedure ended the sweep's transaction"; op = %op.name, trancount = c.trancount);
                m.insert("transaction", "escaped");
                m.insert("result", "failed");
                m.insert(
                    "why",
                    "the procedure ended the sweep's transaction itself: what it wrote may be kept in the PMS; check this operation by hand and leave it out of the next sweep",
                );
            }
        }
        Err(e) => {
            // The session is dropped by the caller when broken; otherwise make sure.
            dl_log::warn!("op_sweep could not end its transaction"; op = %op.name, error = %e);
            m.insert("transaction", "dropped");
            if !client.is_broken()
                && let Err(e) = client.batch(&end_batch())
            {
                dl_log::warn!("op_sweep rollback retry failed"; op = %op.name, error = %e);
            }
        }
    }
    m
}

/// How an operation's transaction ended.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Closing {
    /// `@@TRANCOUNT` right after the call (1: the sweep's own transaction still open).
    trancount: i64,
    /// The mark was there after the call: the procedure did not end the sweep's transaction.
    alive: bool,
    /// The mark outlived the rollback: the sweep's transaction had been committed.
    survived: bool,
}

impl Closing {
    /// The rollback undid the sweep's own transaction and with it every write of the call
    /// (a `ROLLBACK` at any nesting level ends the outermost transaction).
    fn rolled_back(self) -> bool {
        self.trancount >= 1 && self.alive && !self.survived
    }

    /// The call's SQL error rolled the sweep's transaction back (`XACT_ABORT`): nothing open,
    /// and the mark went with the transaction (a commit would have kept it).
    fn aborted_by(self, call_failed: bool) -> bool {
        call_failed && self.trancount == 0 && !self.alive && !self.survived
    }
}

fn mark_test() -> String {
    format!("CAST(CASE WHEN OBJECT_ID('tempdb..{MARK}') IS NULL THEN 0 ELSE 1 END AS BIGINT)")
}

/// Rolls back whatever is open, then answers whether the mark is still there (and drops it).
fn end_batch() -> String {
    format!(
        "IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; SELECT {}; IF OBJECT_ID('tempdb..{MARK}') IS NOT NULL DROP TABLE {MARK};",
        mark_test()
    )
}

/// Reads the state the call left, then rolls back.
fn close(client: &mut Client) -> Result<Closing, TdsError> {
    let after = client.batch(&format!(
        "SELECT CAST(@@TRANCOUNT AS BIGINT), {}",
        mark_test()
    ))?;
    let ended = client.batch(&end_batch())?;
    let a = numbers(&after);
    let e = numbers(&ended);
    Ok(Closing {
        trancount: a.first().copied().unwrap_or(-1),
        alive: a.get(1) == Some(&1),
        survived: e.first() != Some(&0),
    })
}

/// The first row of the first result set with columns, as integers (-1 for anything else).
fn numbers(results: &Results) -> Vec<i64> {
    results
        .sets()
        .iter()
        .find(|s| !s.columns().is_empty())
        .and_then(|s| s.rows().first())
        .map(|r| {
            r.values()
                .iter()
                .map(|v| match v {
                    dl_tds::Value::I64(n) => *n,
                    _ => -1,
                })
                .collect()
        })
        .unwrap_or_default()
}

fn sql_error(m: &mut Map, e: &TdsError) {
    m.insert("result", "sql_error");
    match e {
        TdsError::Server {
            number, message, ..
        } => {
            let class = classify(*number);
            m.insert("class", class);
            m.insert("number", i64::from(*number));
            if matches!(class, "schema" | "permission" | "other") {
                m.insert("message", clip(message));
            }
        }
        TdsError::Timeout => {
            m.insert("class", "timeout");
        }
        other => {
            m.insert("class", "other");
            m.insert("message", clip(&tds::exec_error(other).to_string()));
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn op(name: &str) -> &'static Operation {
        catalog()
            .unwrap()
            .operations()
            .iter()
            .find(|o| o.name == name)
            .unwrap()
    }

    #[test]
    fn options_take_known_names_only() {
        let o = SweepOptions::from_args(&Value::Null, "2026-11-19").unwrap();
        assert!(o.only.is_empty() && o.skip.is_empty());
        assert_eq!(o.timeout, DEFAULT_TIMEOUT);
        let bad = [
            r#"{"only":["nope.op"]}"#,
            r#"{"params":{"nope":{}}}"#,
            r#"{"timeout_seconds":0}"#,
        ];
        for b in bad {
            assert!(
                SweepOptions::from_args(&dl_json::parse(b).unwrap(), "2026-11-19").is_err(),
                "{b}"
            );
        }
    }

    #[test]
    fn the_sweep_never_commits() {
        for b in [
            r#"{"commit":true}"#,
            r#"{"commit":true,"only":["checkin.online"]}"#,
            r#"{"commit":"yes"}"#,
            r#"{"commit":1}"#,
        ] {
            let e =
                SweepOptions::from_args(&dl_json::parse(b).unwrap(), "2026-11-19").expect_err(b);
            assert!(e.contains("never commits"), "{b}: {e}");
        }
        for b in [r#"{"commit":false}"#, r#"{"commit":null}"#] {
            assert!(
                SweepOptions::from_args(&dl_json::parse(b).unwrap(), "2026-11-19").is_ok(),
                "{b}"
            );
        }
        const {
            assert!(
                LOCK_TIMEOUT_MS <= 2000,
                "a sweep waits at most 2 s for a lock"
            )
        };
        let end = end_batch();
        assert!(end.contains("ROLLBACK TRANSACTION") && !end.contains("COMMIT"));
    }

    #[test]
    fn only_the_sweeps_own_transaction_rolled_back_counts() {
        let c = |trancount, alive, survived| Closing {
            trancount,
            alive,
            survived,
        };
        assert!(c(1, true, false).rolled_back());
        assert!(
            c(2, true, false).rolled_back(),
            "a nested level left open is undone by the outer rollback"
        );
        assert!(
            !c(0, false, false).rolled_back(),
            "the procedure ended the transaction"
        );
        assert!(
            !c(1, false, false).rolled_back(),
            "the procedure ended it and began another"
        );
        assert!(
            !c(1, true, true).rolled_back(),
            "the sweep's transaction was committed"
        );
        assert!(!c(-1, true, false).rolled_back(), "unreadable");
        assert!(
            c(0, false, false).aborted_by(true),
            "the call's error rolled the transaction back"
        );
        assert!(
            !c(0, false, false).aborted_by(false),
            "no error: the procedure ended the transaction itself"
        );
        assert!(
            !c(0, true, false).aborted_by(true),
            "the mark outlived the call: committed"
        );
        assert!(!c(1, false, false).aborted_by(true), "a new transaction");
    }

    /// What makes `aborted` sound: nothing of the bundle runs after an aborting error, and
    /// every catalog operation calls a procedure of the bundle. The procedures of
    /// [`NEVER_SWEPT`] are the only exception, and a sweep never calls them. The words are read
    /// in this crate's procedures: the shared SA_ layer that the installer puts first creates
    /// `SA_FolioBill` at install time inside a TRY/CATCH around `EXEC` (RT-1484), which never
    /// runs during a sweep.
    #[test]
    fn the_bundle_never_rolls_back_catches_or_calls_out() {
        let full = installer::bundle().text.to_uppercase();
        let source = include_str!("../../assets/pms-procedures.sql").to_uppercase();
        let text = without_never_swept(&source);
        assert!(
            text.len() < source.len(),
            "the never-swept procedures are in the bundle"
        );
        for word in ["ROLLBACK", "BEGIN TRY", "BEGIN CATCH", "SAVE TRAN"] {
            assert!(!text.contains(word), "the bundle has {word}");
        }
        for line in text.lines() {
            let t = line.trim_start();
            let calls_out = (t.starts_with("EXEC ") || t.starts_with("EXECUTE "))
                && !t.contains("SP_EXECUTESQL");
            assert!(!calls_out, "the bundle calls a procedure: {line}");
        }
        for op in catalog().expect("catalog").operations() {
            let made = format!("CREATE PROCEDURE DBO.{}", op.procedure.to_uppercase());
            let found = full
                .match_indices(&made)
                .any(|(i, _)| full[i + made.len()..].starts_with(char::is_whitespace));
            assert!(found, "{} is not in the bundle", op.procedure);
        }
    }

    /// The bundle text (upper case) without the bodies of the [`NEVER_SWEPT`] procedures: each
    /// `CREATE PROCEDURE` up to the next batch marker.
    fn without_never_swept(text: &str) -> String {
        let mut out = text.to_string();
        for name in NEVER_SWEPT {
            let proc = catalog()
                .expect("catalog")
                .operations()
                .iter()
                .find(|o| o.name == *name)
                .unwrap_or_else(|| panic!("{name} is not in the catalog"))
                .procedure
                .to_uppercase();
            let made = format!("CREATE PROCEDURE DBO.{proc}");
            let start = out
                .find(&made)
                .unwrap_or_else(|| panic!("{proc} is not in the bundle"));
            let end = out[start..]
                .find("-- @@MMARRIVAL:BATCH")
                .map_or(out.len(), |i| start + i);
            out.replace_range(start..end, "");
        }
        out
    }

    #[test]
    fn the_sweep_never_calls_a_payment_post() {
        for name in NEVER_SWEPT {
            assert!(op(name).kind == OperationKind::Write, "{name} is a write");
        }
        assert!(NEVER_SWEPT.contains(&"folio.post-payment"));
    }

    #[test]
    fn placeholders_fill_required_parameters_and_null_the_rest() {
        let args =
            dl_json::parse(r#"{"params":{"folio.room-status":{"RoomCode":"101"}}}"#).unwrap();
        let o = SweepOptions::from_args(&args, "2026-11-19").unwrap();
        let p = sweep_params(op("folio.room-status"), &o).unwrap();
        assert_eq!(p.get("FolioNum"), Some(Some("0")));
        assert_eq!(p.get("RoomCode"), Some(Some("101")));
        let p = sweep_params(op("report.occupancy"), &o).unwrap();
        assert_eq!(p.get("from"), Some(Some("2026-11-19")));
        let p = sweep_params(op("folio.search"), &o).unwrap();
        assert_eq!(
            p.get("sInfo"),
            Some(None),
            "optional parameters are SQL NULL"
        );
        for o2 in catalog().unwrap().operations() {
            let p = sweep_params(o2, &o).unwrap();
            TdsExecutor::params(o2, &p).unwrap_or_else(|e| panic!("{}: {e}", o2.name));
        }
    }

    #[test]
    fn sql_errors_are_classified() {
        assert_eq!(classify(50001), "business");
        assert_eq!(classify(208), "schema");
        assert_eq!(classify(2812), "schema");
        assert_eq!(classify(916), "permission");
        assert_eq!(classify(229), "permission");
        assert_eq!(classify(2627), "data");
        assert_eq!(classify(1222), "timeout");
        assert_eq!(classify(102), "other");
    }
}
