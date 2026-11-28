//! The wire contract against the .NET golden fixtures: JSON text, canonical hashes,
//! projections, deltas, parameter conversion, validation and vault paths must match
//! `MM.Arrival.Sync.Contracts` byte for byte.

mod common;

use common::{b, cases, field, golden, i, opt_s, s};
use dl_agent_arrival::contracts::projection::{self, Projection};
use dl_agent_arrival::contracts::validator::{self, ParamValue};
use dl_agent_arrival::contracts::{
    ParamType, Parameter, PmsRequest, PmsResultSet, PmsRow, catalog, delta, errors, hasher,
    vault_ops,
};
use dl_agent_arrival::stj;
use dl_json::{Number, Value};

fn sets_json(sets: &[PmsResultSet]) -> String {
    let mut out = String::from("[");
    for (k, set) in sets.iter().enumerate() {
        if k > 0 {
            out.push(',');
        }
        set.write(&mut out);
    }
    out.push(']');
    out
}

fn rows_of(v: &Value) -> Vec<PmsRow> {
    v.as_array()
        .expect("rows array")
        .iter()
        .map(|r| PmsRow::from_json(r).expect("row"))
        .collect()
}

fn parse_sets(text: &str) -> Vec<PmsResultSet> {
    stj::parse(text)
        .expect("sets json")
        .as_array()
        .expect("sets array")
        .iter()
        .map(|v| PmsResultSet::from_json(v).expect("set"))
        .collect()
}

fn projection_of(v: &Value) -> Option<Projection> {
    let list = match v {
        Value::Null => return None,
        Value::Array(a) => a,
        other => panic!("projection {other:?}"),
    };
    Some(
        list.iter()
            .map(|set| {
                set.as_array().map(|cols| {
                    cols.iter()
                        .map(|c| c.as_str().expect("column").to_string())
                        .collect()
                })
            })
            .collect(),
    )
}

#[test]
fn catalog_loads_with_every_procedure_in_the_bundle() {
    let cat = catalog().expect("catalog");
    assert_eq!(cat.operations().len(), 89);
    let bundle = include_str!("../assets/pms-procedures.sql").to_lowercase();
    for op in cat.operations() {
        let needle = op.procedure.to_lowercase();
        assert!(
            bundle.contains(&needle),
            "{} is not in the bundle",
            op.procedure
        );
        assert!(op.max_rows > 0, "{}", op.name);
    }
}

#[test]
fn strings_serialize_like_system_text_json() {
    let g = golden();
    for c in cases(&g, "stj_strings") {
        assert_eq!(stj::quote(s(c, "in")), s(c, "out"), "{:?}", s(c, "in"));
        assert_eq!(stj::quote(s(c, "in")), s(c, "web"));
    }
}

#[test]
fn canonical_numbers_and_values_match() {
    let g = golden();
    for c in cases(&g, "canonical_numbers") {
        let n = Number::from_raw(s(c, "raw")).expect("raw number");
        let mut out = String::new();
        hasher::append_canonical(&mut out, &Value::Number(n));
        assert_eq!(out, s(c, "canon"), "raw {}", s(c, "raw"));
    }
    for c in cases(&g, "canonical_values") {
        let mut out = String::new();
        hasher::append_canonical(&mut out, &stj::parse(s(c, "json")).expect("json"));
        assert_eq!(out, s(c, "canon"), "{}", s(c, "json"));
    }
}

#[test]
fn row_hashes_match() {
    let g = golden();
    for c in cases(&g, "rows") {
        let row = PmsRow::from_json(&stj::parse(s(c, "row")).expect("row")).expect("row");
        assert_eq!(hasher::hash_row(&row), s(c, "hash"), "{}", s(c, "row"));
        let mut text = String::new();
        row.write(&mut text);
        assert_eq!(text, s(c, "row"), "row text");
    }
    for c in cases(&g, "rows_hash") {
        let rows = rows_of(&stj::parse(s(c, "rows")).expect("rows"));
        assert_eq!(hasher::hash_rows(&rows), s(c, "hash"));
    }
    for c in cases(&g, "params_hash") {
        let params: Vec<(String, Option<String>)> = field(c, "params")
            .as_array()
            .expect("params")
            .iter()
            .map(|p| {
                let p = p.as_array().expect("pair");
                (
                    p[0].as_str().expect("name").to_string(),
                    p[1].as_str().map(str::to_string),
                )
            })
            .collect();
        let hash = hasher::hash_parameters(params.iter().map(|(k, v)| (k.as_str(), v.as_deref())));
        assert_eq!(hash, s(c, "hash"));
    }
    for c in cases(&g, "row_keys") {
        let row = PmsRow::from_json(&stj::parse(s(c, "row")).expect("row")).expect("row");
        let keys: Vec<String> = field(c, "keys")
            .as_array()
            .expect("keys")
            .iter()
            .map(|k| k.as_str().expect("key").to_string())
            .collect();
        assert_eq!(hasher::row_key(&row, &keys), s(c, "key"));
    }
    for c in cases(&g, "combine") {
        let hashes: Vec<&str> = field(c, "hashes")
            .as_array()
            .expect("hashes")
            .iter()
            .map(|h| h.as_str().expect("hash"))
            .collect();
        assert_eq!(hasher::combine_etag(hashes), s(c, "etag"));
    }
}

#[test]
fn projections_validate_and_hash_alike() {
    let g = golden();
    let cat = catalog().expect("catalog");
    for c in cases(&g, "projections") {
        let op = cat.get(s(c, "op")).expect("op");
        let p = projection_of(field(c, "projection"));
        let verdict = p
            .as_ref()
            .map_or(Ok(()), |p| projection::try_validate(op, p));
        assert_eq!(verdict.is_ok(), b(c, "ok"), "{:?}", field(c, "projection"));
        assert_eq!(verdict.err().as_deref(), opt_s(c, "error"));
        if b(c, "ok") {
            assert_eq!(projection::hash(p.as_ref()), s(c, "hash"));
            let expected = projection_of(field(c, "effective")).expect("effective");
            for (idx, want) in expected.iter().enumerate() {
                assert_eq!(
                    &projection::effective(op, p.as_ref(), idx),
                    want,
                    "set {idx}"
                );
            }
        }
    }
}

#[test]
fn deltas_match_and_apply() {
    let g = golden();
    let cat = catalog().expect("catalog");
    for c in cases(&g, "deltas") {
        let op = cat.get(s(c, "op")).expect("op");
        let sets = |name: &str| -> Vec<Vec<PmsRow>> {
            stj::parse(s(c, name))
                .expect("sets")
                .as_array()
                .expect("array")
                .iter()
                .map(rows_of)
                .collect()
        };
        let (prev_etag, prev) = delta::full(sets("previous"));
        let (etag, cur) = delta::full(sets("current"));
        assert_eq!(prev_etag, s(c, "prev_etag"));
        assert_eq!(etag, s(c, "etag"));
        assert_eq!(sets_json(&cur), s(c, "full"));
        let d = delta::build(op, &prev, &cur);
        assert_eq!(sets_json(&d), s(c, "delta"));
        let applied =
            delta::try_apply(op, &prev, &parse_sets(s(c, "delta")), &etag).expect("applies");
        let hashes: Vec<&str> = applied.iter().map(|x| x.hash.as_str()).collect();
        let want: Vec<&str> = cur.iter().map(|x| x.hash.as_str()).collect();
        assert_eq!(hashes, want);
    }
}

fn param_type(name: &str) -> ParamType {
    match name {
        "String" => ParamType::String,
        "Int" => ParamType::Int,
        "Decimal" => ParamType::Decimal,
        "Date" => ParamType::Date,
        "Bool" => ParamType::Bool,
        "Xml" => ParamType::Xml,
        "DateTime" => ParamType::DateTime,
        "Long" => ParamType::Long,
        "Binary" => ParamType::Binary,
        other => panic!("type {other}"),
    }
}

fn value_text(v: &ParamValue) -> String {
    match v {
        ParamValue::Int(n) => n.to_string(),
        ParamValue::Long(n) => n.to_string(),
        ParamValue::Decimal(d) => d.to_string(),
        ParamValue::Bool(true) => "True".into(),
        ParamValue::Bool(false) => "False".into(),
        ParamValue::Date(d) => {
            stj::num::format_datetime_o(&dl_time::DateTime::new(*d, dl_time::Time::MIDNIGHT))
        }
        ParamValue::DateTime(dt) => stj::num::format_datetime_o(dt),
        ParamValue::Binary(bytes) => dl_agent_arrival::crypto::hex(bytes),
        ParamValue::Text(t) => t.clone(),
    }
}

#[test]
fn parameter_values_convert_alike() {
    let g = golden();
    for c in cases(&g, "param_values") {
        let p = Parameter {
            name: "p".into(),
            ty: param_type(s(c, "type")),
            required: false,
            max_length: usize::try_from(i(c, "max")).expect("max"),
        };
        let input = s(c, "in");
        assert_eq!(
            validator::is_valid_value(&p, input),
            b(c, "ok"),
            "{} {input:?}",
            s(c, "type")
        );
        if !b(c, "ok") {
            continue;
        }
        let v = validator::convert_value(&p, input).expect("a valid value converts");
        let want = opt_s(c, "out").expect("out");
        assert!(
            value_text(&v).eq_ignore_ascii_case(want),
            "{} {input:?}: {} vs {want}",
            s(c, "type"),
            value_text(&v)
        );
    }
}

#[test]
fn requests_validate_with_the_dotnet_messages() {
    let g = golden();
    let cat = catalog().expect("catalog");
    for c in cases(&g, "requests") {
        let req = PmsRequest::from_json(&stj::parse(s(c, "json")).expect("json")).expect("request");
        let verdict = validator::validate(cat, &req).map(|_| ());
        assert_eq!(verdict.is_ok(), b(c, "ok"), "{}", s(c, "json"));
        assert_eq!(
            verdict.err().as_deref(),
            opt_s(c, "error"),
            "{}",
            s(c, "json")
        );
        let mut text = String::new();
        req.write(&mut text);
        assert_eq!(text, s(c, "json"));
    }
}

#[test]
fn errors_and_vault_paths_match() {
    let g = golden();
    for c in cases(&g, "errors") {
        let n = i32::try_from(i(c, "n")).expect("n");
        assert_eq!(errors::describe(n), s(c, "text"));
    }
    assert!(errors::is_record_locked(Some(&errors::describe(
        errors::LOCK_TIMEOUT
    ))));
    for c in cases(&g, "vault_paths") {
        let got = vault_ops::try_normalize(Some(s(c, "in")));
        assert_eq!(got.is_some(), b(c, "ok"), "{:?}", s(c, "in"));
        if let Some(path) = got {
            assert_eq!(path, s(c, "out"));
        }
    }
}
