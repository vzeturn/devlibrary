//! RT-1432: the bundle carries the shared SA_ layer ahead of the procedures and the Check-In bill
//! procedure calls it instead of keeping its own TransactionCode + SubCode join.

use dl_agent_arrival::agent::installer;

#[test]
fn bundle_installs_the_sa_layer_before_the_procedures() {
    let b = installer::bundle();
    let first_create = b
        .batches
        .iter()
        .position(|x| x.sql.contains("CREATE FUNCTION dbo.SA_TrnCode_Resolve"))
        .expect("SA_TrnCode_Resolve batch");
    let bill = b
        .batches
        .iter()
        .position(|x| x.sql.contains("CREATE PROCEDURE dbo.srCI_InformationBill"))
        .expect("bill procedure batch");
    assert!(first_create < bill);
}

#[test]
fn bill_procedure_has_no_private_transaction_code_join() {
    let b = installer::bundle();
    let bill = b
        .batches
        .iter()
        .find(|x| x.sql.contains("CREATE PROCEDURE dbo.srCI_InformationBill"))
        .expect("bill procedure batch");
    assert!(bill.sql.contains("dbo.SA_TrnCode_Resolve("));
    assert!(!bill.sql.contains("dbo.TransactionCode"));
}

/// RT-1484: the Check-In bill reads the shared SA_FolioBill, installed ahead of the procedure.
#[test]
fn bill_procedure_reads_the_shared_folio_bill_function() {
    let b = installer::bundle();
    let func = b
        .batches
        .iter()
        .position(|x| x.sql.contains("dbo.SA_FolioBill(@FolioNum decimal(18,0)"))
        .expect("SA_FolioBill batch");
    let bill_idx = b
        .batches
        .iter()
        .position(|x| x.sql.contains("CREATE PROCEDURE dbo.srCI_InformationBill"))
        .expect("bill procedure batch");
    assert!(func < bill_idx);
    let bill = &b.batches[bill_idx];
    assert!(
        bill.sql
            .contains("dbo.SA_FolioBill(@sFolioNum, @sBalanceCode)")
    );
    assert!(!bill.sql.contains("dbo.FolioTransaction"));
}
