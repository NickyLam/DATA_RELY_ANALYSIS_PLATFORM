: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbl_swt_business_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbl_swt_business_log_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,msg_type
,buss_flag
,electric_draft_id
,txn_date
,req_type
,req_name
,req_brch_code
,req_account
,req_bank_id
,customer_id
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
,txn_ctrct_nb
,invoice_nb
,solutor_date
,batch_id
,batch_detail_id
,account_status
,cancel_flag
,txn_status
,rcrs_rsn_cd
,btch_nb
,dpty_mk
,reserve_field1
,reserve_field2
,reserve_field3
,last_upd_txn_id
,last_upd_txn_oprid
,rec_crt_ts
,last_upd_ts
,aoaccn_accout
,aoaccn_bank_id
,req_remark
,rcv_remark
,proxy_sign
,guarant_address
,agrmt_nb
from ${idl_schema}.odss_tbl_swt_business_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbl_swt_business_log_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes