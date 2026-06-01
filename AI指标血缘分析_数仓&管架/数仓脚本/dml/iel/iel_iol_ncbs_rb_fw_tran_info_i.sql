: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_fw_tran_info_i
CreateDate: 20230324
FileName:   ${iel_data_path}/ncbs_rb_fw_tran_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,service_id
,service_no
,tran_date
,tran_time
,response_type
,end_time
,source_type
,seq_no
,program_id
,status
,reference
,platform_id
,user_id
,ip_address
,branch_id
,compensate_service_no
,week_day
,create_date
,bus_seq_no
,run_date
,inner_service_flag
,gl_posted_flag
,acct_no
,acct_seq_no
,tran_amt
,ccy
,auth_user_id
,oth_acct_no
,oth_acct_seq_no
,voucher_no
,doc_type
,prefix
,cheque_voucher_no
,cheque_doc_type
,cheque_prefix
,remark
,tran_name
,inner_flag
,source_model
,base_acct_no
,sub_seq_no
,financial_flag

from ${iol_schema}.ncbs_rb_fw_tran_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_fw_tran_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
