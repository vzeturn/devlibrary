//! The service's own attempt to apply missing order grants (`BootstrapGrantsRepair`,
//! RT-1309). It runs the same idempotent bootstrap as `pda-enroll` and `pda-grants`
//! under the identities `pda-enroll` tries, in the same order
//! ([`default_attempts`]): the service's Windows identity first, then the SMILE default
//! SQL login. The next identity is tried only when the previous one was refused
//! ([`is_access_refusal`]); any other failure ends the round.
//!
//! Hard rule: whichever identity runs it, the bootstrap only creates and grants objects
//! for `pda_sync` (its login, user, tables and grants). It never alters the SMILE login
//! or its password, and an outcome names the identity and an error code, never a password.

use crate::bootstrap::{Error, SqlAdminCredential};
use crate::config::AgentIdentity;
use crate::hosting::enroll_attempts::{Attempt, DefaultLogin, default_attempts, is_access_refusal};
use crate::reporting::{Logger, Value};
use crate::security::SharedSecretStore;
use crate::util::ctx::Ctx;

/// Category of the self-repair's log lines.
pub const REPAIR_CATEGORY: &str = "MM.PdaOrder.SyncAgent.Commands.BootstrapGrantsRepair";
/// The outcome of the identity whose bootstrap ran.
pub const APPLIED: &str = "applied";

/// What one identity did.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RepairAttempt {
    /// `windows` or `sql:<login>`.
    pub identity: String,
    /// [`APPLIED`], `skipped: <why>`, an error code (`SQL_NO_ACCESS`), `SQL error <n>`
    /// or an error type; never a password.
    pub outcome: String,
}

/// The identities of one repair round, in the order they were tried.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct RepairOutcome {
    /// One entry per identity tried or skipped.
    pub attempts: Vec<RepairAttempt>,
    /// The ids of the bootstrap steps the identity that applied it ran (RT-1425: each one
    /// becomes a `SQL_GRANT_APPLIED` site event); empty when none ran.
    pub applied_steps: Vec<String>,
}

impl RepairOutcome {
    /// The identity whose bootstrap ran, if any did.
    pub fn applied_by(&self) -> Option<&str> {
        self.attempts
            .iter()
            .find(|a| a.outcome == APPLIED)
            .map(|a| a.identity.as_str())
    }

    /// `windows: SQL_NO_ACCESS; sql:smile: SQL_LOGIN_FAILED`.
    pub fn summary(&self) -> String {
        self.attempts
            .iter()
            .map(|a| format!("{}: {}", a.identity, a.outcome))
            .collect::<Vec<_>>()
            .join("; ")
    }

    /// `[{"identity": .., "outcome": ..}]` for a site event's detail.
    pub fn to_json(&self) -> dl_json::Value {
        dl_json::Value::Array(
            self.attempts
                .iter()
                .map(|a| {
                    let mut m = dl_json::Map::new();
                    m.insert("identity", a.identity.as_str());
                    m.insert("outcome", a.outcome.as_str());
                    dl_json::Value::Object(m)
                })
                .collect(),
        )
    }
}

/// The service's own attempt to apply missing grants (`IOrderGrantsRepair`).
pub trait GrantsRepair: Send + Sync {
    /// Tries the identities in order and says what each did.
    fn try_repair(&self, ctx: &Ctx) -> RepairOutcome;
}

/// Runs the bootstrap as one identity; the ids of the SQL steps it executed.
pub type ApplyAs = dyn Fn(&SqlAdminCredential, &Ctx) -> Result<Vec<String>, Error> + Send + Sync;

/// The bootstrap of `enroll` and `grants` for the enrolled target, as each identity of
/// `pda-enroll` in turn (`BootstrapGrantsRepair`).
pub struct BootstrapGrantsRepair {
    attempts: Vec<Attempt>,
    apply: Box<ApplyAs>,
    log: Logger,
}

impl BootstrapGrantsRepair {
    /// The real repair: `pda-enroll`'s identities ([`DefaultLogin::from_process`]) and
    /// the real bootstrapper for `identity`'s SQL target; `log` is the root logger.
    pub fn new(secrets: SharedSecretStore, identity: AgentIdentity, log: &Logger) -> Self {
        let root = log.clone();
        let apply =
            move |credential: &SqlAdminCredential, ctx: &Ctx| -> Result<Vec<String>, Error> {
                let bootstrapper = crate::hosting::enroll::real_bootstrapper(
                    secrets.clone(),
                    credential.clone(),
                    &root,
                )?;
                let preflight = bootstrapper.preflight(
                    identity.sql_instance.as_deref(),
                    identity.sql_database.as_deref(),
                    ctx,
                )?;
                let report = bootstrapper.apply(&preflight, false, ctx)?;
                Ok(report
                    .steps
                    .iter()
                    .filter(|s| s.executed)
                    .map(|s| s.id.clone())
                    .collect())
            };
        Self::with_parts(
            default_attempts(&DefaultLogin::from_process()),
            Box::new(apply),
            log,
        )
    }

    /// A repair over given identities and runner (tests).
    pub fn with_parts(attempts: Vec<Attempt>, apply: Box<ApplyAs>, log: &Logger) -> Self {
        BootstrapGrantsRepair {
            attempts,
            apply,
            log: log.for_category(REPAIR_CATEGORY),
        }
    }
}

/// The outcome text of a failed run and whether the next identity may cure it.
fn failure(e: &Error) -> (String, bool) {
    match (e.code(), e.sql()) {
        // The target was enrolled, so a schema mismatch from a restricted identity (the
        // service account sees no tables of the POS database) is a visibility refusal that
        // the next identity may cure (RT-1427).
        (Some(code), _) => (
            code.to_owned(),
            is_access_refusal(code) || code == crate::config::codes::FINGERPRINT_MISMATCH,
        ),
        (None, Some(sql)) => (format!("SQL error {}", sql.number()), false),
        (None, None) => (e.to_exception().type_name, false),
    }
}

impl GrantsRepair for BootstrapGrantsRepair {
    fn try_repair(&self, ctx: &Ctx) -> RepairOutcome {
        let mut out = RepairOutcome::default();
        for attempt in &self.attempts {
            if ctx.is_done() {
                break;
            }
            let (label, credential) = match attempt {
                Attempt::Skipped { label, reason } => {
                    self.log.info(
                        "Grants self-repair skips {Identity}: {Reason}",
                        &[Value::from(label.as_str()), Value::from(reason.as_str())],
                    );
                    out.attempts.push(RepairAttempt {
                        identity: label.clone(),
                        outcome: format!("skipped: {reason}"),
                    });
                    continue;
                }
                Attempt::Try { label, credential } => (label, credential),
            };
            match (self.apply)(credential, ctx) {
                Ok(applied) => {
                    self.log.info(
                        "Grants self-repair applied {Applied} SQL step(s) as {Identity}",
                        &[Value::from(applied.len()), Value::from(label.as_str())],
                    );
                    out.attempts.push(RepairAttempt {
                        identity: label.clone(),
                        outcome: APPLIED.to_owned(),
                    });
                    out.applied_steps = applied;
                    break;
                }
                Err(e) => {
                    let (outcome, refused) = failure(&e);
                    self.log.warn_ex(
                        e.to_exception(),
                        "Grants self-repair as {Identity} failed ({Outcome})",
                        &[Value::from(label.as_str()), Value::from(outcome.as_str())],
                    );
                    out.attempts.push(RepairAttempt {
                        identity: label.clone(),
                        outcome,
                    });
                    if !refused {
                        break;
                    }
                }
            }
        }
        out
    }
}

#[cfg(test)]
mod tests {
    use std::sync::{Arc, Mutex};

    use super::*;
    use crate::config::{AgentError, codes};

    const PASSWORD: &str = "Sm1le-default-pw";

    fn attempts(smile_password: Option<&str>) -> Vec<Attempt> {
        let second = match smile_password {
            Some(p) => Attempt::Try {
                label: "sql:smile".into(),
                credential: SqlAdminCredential::sql("smile", p),
            },
            None => Attempt::Skipped {
                label: "sql:smile".into(),
                reason: "no default password in this build".into(),
            },
        };
        vec![
            Attempt::Try {
                label: "windows".into(),
                credential: SqlAdminCredential::windows(),
            },
            second,
        ]
    }

    /// A runner that answers each identity in turn and records who ran.
    fn runner(answers: Vec<Result<Vec<String>, Error>>) -> (Box<ApplyAs>, Arc<Mutex<Vec<String>>>) {
        let ran = Arc::new(Mutex::new(Vec::new()));
        let answers = Mutex::new(answers.into_iter());
        let seen = ran.clone();
        let apply = move |c: &SqlAdminCredential, _ctx: &Ctx| {
            seen.lock()
                .unwrap()
                .push(c.user.clone().unwrap_or_else(|| "windows".into()));
            answers
                .lock()
                .unwrap()
                .next()
                .expect("an answer per identity")
        };
        (Box::new(apply), ran)
    }

    fn refused(code: &str) -> Result<Vec<String>, Error> {
        Err(Error::Agent(AgentError::new(code, "refused")))
    }

    #[test]
    fn a_refused_windows_identity_falls_back_to_the_smile_login() {
        let (apply, ran) = runner(vec![
            refused(codes::SQL_NO_ACCESS),
            Ok(vec!["po_number_grants".into(), "full_rw_grants".into()]),
        ]);
        let repair =
            BootstrapGrantsRepair::with_parts(attempts(Some(PASSWORD)), apply, &Logger::none());

        let out = repair.try_repair(&Ctx::background());

        assert_eq!(*ran.lock().unwrap(), ["windows", "smile"]);
        assert_eq!(out.applied_by(), Some("sql:smile"));
        // RT-1425: the steps it ran, for one SQL_GRANT_APPLIED event each.
        assert_eq!(out.applied_steps, ["po_number_grants", "full_rw_grants"]);
        assert_eq!(out.summary(), "windows: SQL_NO_ACCESS; sql:smile: applied");
        let json = dl_json::to_string(&out.to_json());
        assert!(!json.contains(PASSWORD), "never a password: {json}");
    }

    #[test]
    fn a_windows_schema_mismatch_falls_back_to_the_smile_login() {
        let (apply, ran) = runner(vec![
            refused(codes::FINGERPRINT_MISMATCH),
            Ok(vec!["full_rw_grants".into()]),
        ]);
        let repair =
            BootstrapGrantsRepair::with_parts(attempts(Some(PASSWORD)), apply, &Logger::none());

        let out = repair.try_repair(&Ctx::background());

        assert_eq!(*ran.lock().unwrap(), ["windows", "smile"]);
        assert_eq!(out.applied_by(), Some("sql:smile"));
    }

    #[test]
    fn a_failed_login_of_both_identities_is_reported_per_identity() {
        let (apply, _) = runner(vec![
            refused(codes::SQL_LOGIN_FAILED),
            refused(codes::SQL_LOGIN_FAILED),
        ]);
        let repair =
            BootstrapGrantsRepair::with_parts(attempts(Some(PASSWORD)), apply, &Logger::none());

        let out = repair.try_repair(&Ctx::background());

        assert_eq!(out.applied_by(), None);
        assert!(out.applied_steps.is_empty());
        assert_eq!(
            out.summary(),
            "windows: SQL_LOGIN_FAILED; sql:smile: SQL_LOGIN_FAILED"
        );
    }

    #[test]
    fn a_failure_that_is_not_a_refusal_ends_the_round() {
        let (apply, ran) = runner(vec![Err(Error::unexpected(
            "System.InvalidOperationException",
            "boom",
        ))]);
        let repair =
            BootstrapGrantsRepair::with_parts(attempts(Some(PASSWORD)), apply, &Logger::none());

        let out = repair.try_repair(&Ctx::background());

        assert_eq!(*ran.lock().unwrap(), ["windows"]);
        assert_eq!(out.attempts.len(), 1);
        assert_eq!(out.applied_by(), None);
    }

    #[test]
    fn an_identity_without_a_password_is_recorded_as_skipped() {
        let (apply, ran) = runner(vec![refused(codes::SQL_NO_ACCESS)]);
        let repair = BootstrapGrantsRepair::with_parts(attempts(None), apply, &Logger::none());

        let out = repair.try_repair(&Ctx::background());

        assert_eq!(*ran.lock().unwrap(), ["windows"]);
        assert_eq!(
            out.summary(),
            "windows: SQL_NO_ACCESS; sql:smile: skipped: no default password in this build"
        );
    }
}
