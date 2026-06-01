: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdps_draft_pool_details_f
CreateDate: 20240919
FileName:   ${iel_data_path}/bdps_draft_pool_details.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,contract_id
,cancel_contract_id
,draft_id
,ref_id
,replace(replace(t1.dtl_status,chr(13),''),chr(10),'') as dtl_status
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,last_upd_oper_id
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.bail_acct_no,chr(13),''),chr(10),'') as bail_acct_no
,draft_amount_rate
,replace(replace(t1.cancel_collztn,chr(13),''),chr(10),'') as cancel_collztn
,ebank_pool_out_id
,ebank_pool_in_id
,replace(replace(t1.is_problem_draft,chr(13),''),chr(10),'') as is_problem_draft
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no
,replace(replace(t1.is_occupy,chr(13),''),chr(10),'') as is_occupy
,billsys_out_id
,billsys_in_id
,replace(replace(t1.account_flag,chr(13),''),chr(10),'') as account_flag
,derive_amt
,ple_day
,rate
,replace(replace(t1.serino,chr(13),''),chr(10),'') as serino

from ${iol_schema}.bdps_draft_pool_details t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdps_draft_pool_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
