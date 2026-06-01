: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbl_swt_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbl_swt_draft_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_type
,electric_draft_id
,draft_amount
,remit_date
,maturity_date
,transfer_flag
,consignment_code
,maturity_pay_promise
,txn_ctrct_nb
,invoice_nb
,remitter_type
,remitter_brch_code
,remitter_name
,remitter_account
,remitter_bank_id
,remitter_credit
,remitter_rating_org
,remitter_rating_maturity
,payee_type
,payee_brch_code
,payee_name
,payee_account
,payee_bank_id
,acceptor_type
,acceptor_brch_code
,acceptor_name
,acceptor_account
,acceptor_bank_id
,acceptor_credit
,acceptor_rating_org
,acceptor_rating_maturity
,owner_type
,owner_customer_id
,owner_brch_code
,owner_name
,owner_account
,owner_bank_id
,draft_org_status
,draft_snd_status
,draft_rcv_status
,misc
,last_upd_txn_id
,last_upd_txn_oprid
,rec_crt_ts
,last_upd_ts
,bis_edate
,buss_flow_type
,lock_flag
,account_flag
,orig_owner_account
,orig_owner_bank_id
,orig_owner_brch_code
,orig_owner_customer_id
,orig_owner_name
,orig_owner_type
,remark
from ${idl_schema}.odss_tbl_swt_draft_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbl_swt_draft_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes