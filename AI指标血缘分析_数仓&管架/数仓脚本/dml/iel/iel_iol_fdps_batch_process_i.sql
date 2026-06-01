: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fdps_batch_process_i
CreateDate: 20240611
FileName:   ${iel_data_path}/fdps_batch_process.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.batch_name,chr(13),''),chr(10),'') as batch_name
,replace(replace(t1.third_batch_id,chr(13),''),chr(10),'') as third_batch_id
,replace(replace(t1.parent_merchant_id,chr(13),''),chr(10),'') as parent_merchant_id
,replace(replace(t1.check_date,chr(13),''),chr(10),'') as check_date
,replace(replace(t1.batch_type,chr(13),''),chr(10),'') as batch_type
,replace(replace(t1.deal_option,chr(13),''),chr(10),'') as deal_option
,replace(replace(t1.old_req_seq_no,chr(13),''),chr(10),'') as old_req_seq_no
,replace(replace(t1.submit_file,chr(13),''),chr(10),'') as submit_file
,replace(replace(t1.result_file,chr(13),''),chr(10),'') as result_file
,submit_count
,submit_sum
,result_count
,result_sum
,deposit_count
,deposit_sum
,withdraw_count
,withdraw_sum
,success_count
,success_amount
,fail_count
,fail_amount
,submit_gua_amount
,success_gua_amount
,replace(replace(t1.tran_branch_id,chr(13),''),chr(10),'') as tran_branch_id
,replace(replace(t1.tran_teller_no,chr(13),''),chr(10),'') as tran_teller_no
,transaction_date
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_msg,chr(13),''),chr(10),'') as resp_msg
,replace(replace(t1.has_detal_flag,chr(13),''),chr(10),'') as has_detal_flag
,replace(replace(t1.batch_status,chr(13),''),chr(10),'') as batch_status
,replace(replace(t1.amt_source,chr(13),''),chr(10),'') as amt_source
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp

from ${iol_schema}.fdps_batch_process t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fdps_batch_process.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
