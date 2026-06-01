: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbl_swt_draft_log_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbl_swt_draft_log_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,msg_type
,electric_draft_id
,req_type
,req_name
,req_brch_code
,req_account
,req_bank_id
,rcv_type
,rcv_name
,rcv_brch_code
,rcv_account
,rcv_bank_id
,sign_date
,onl_stlm_flag
,transfer_flag
,rate
,repurchase_rate
,amount
,repurchase_amt
,discount_type
,repurchase_end_date
,repurchase_begin_date
,req_date
,prompt_pay_amt
,reject_code
,reject_info
,overdue_reason
,holder_type
,solutor_date
,txn_ctrct_nb
,invoice_nb
,rcrs_rsn_cd
,btch_nb
,last_upd_txn_id
,last_upd_txn_oprid
,rec_crt_ts
,last_upd_ts
,req_agency_bank_id
,rcv_agency_bank_id
,guarntr_adr
,ucondl_consign_mk
,ucondl_prms_mk
,proxy_sign
,proxy_req
,credit_rate
,credit_rate_agency
,credit_rate_due_date
,req_remark
,rcv_remark
,add_remark
,aoa_account
,aoa_bank_id
,seq_no
,agrmt_nb
from ${idl_schema}.odss_tbl_swt_draft_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbl_swt_draft_log_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes