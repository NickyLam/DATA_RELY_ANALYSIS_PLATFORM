: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccdb_ochat_log_call_worksum_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccdb_ochat_log_call_worksum.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sum_no,chr(13),''),chr(10),'') as sum_no
,replace(replace(t1.call_id,chr(13),''),chr(10),'') as call_id
,t1.call_date as call_date
,replace(replace(t1.skill_group,chr(13),''),chr(10),'') as skill_group
,replace(replace(t1.account_code,chr(13),''),chr(10),'') as account_code
,replace(replace(t1.agent_id,chr(13),''),chr(10),'') as agent_id
,replace(replace(t1.call_type,chr(13),''),chr(10),'') as call_type
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.buss_code,chr(13),''),chr(10),'') as buss_code
,replace(replace(t1.call_flag,chr(13),''),chr(10),'') as call_flag
,replace(replace(t1.picktime,chr(13),''),chr(10),'') as picktime
,replace(replace(t1.ringtime,chr(13),''),chr(10),'') as ringtime
,replace(replace(t1.hangtime,chr(13),''),chr(10),'') as hangtime
,replace(replace(t1.acwtime,chr(13),''),chr(10),'') as acwtime
,replace(replace(t1.call_no,chr(13),''),chr(10),'') as call_no
,replace(replace(t1.ani,chr(13),''),chr(10),'') as ani
,replace(replace(t1.locationid,chr(13),''),chr(10),'') as locationid
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.satisfied_type,chr(13),''),chr(10),'') as satisfied_type
,replace(replace(t1.satisfied_time,chr(13),''),chr(10),'') as satisfied_time
,replace(replace(t1.fcr,chr(13),''),chr(10),'') as fcr
,replace(replace(t1.idcard,chr(13),''),chr(10),'') as idcard
,replace(replace(t1.ivr_node_name,chr(13),''),chr(10),'') as ivr_node_name
,replace(replace(t1.ivr_node_code,chr(13),''),chr(10),'') as ivr_node_code
,replace(replace(t1.callback_state,chr(13),''),chr(10),'') as callback_state
,replace(replace(t1.by_gone,chr(13),''),chr(10),'') as by_gone
,replace(replace(t1.ext_no,chr(13),''),chr(10),'') as ext_no
,replace(replace(t1.province_name,chr(13),''),chr(10),'') as province_name
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t1.workbill_type_code,chr(13),''),chr(10),'') as workbill_type_code
,replace(replace(t1.workbill_type_name,chr(13),''),chr(10),'') as workbill_type_name
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.emp_name,chr(13),''),chr(10),'') as emp_name
,replace(replace(t1.is_invite,chr(13),''),chr(10),'') as is_invite
,replace(replace(t1.duplicate_sign,chr(13),''),chr(10),'') as duplicate_sign
,replace(replace(t1.line_no,chr(13),''),chr(10),'') as line_no
,replace(replace(t1.recordid,chr(13),''),chr(10),'') as recordid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.firsts,chr(13),''),chr(10),'') as firsts
,replace(replace(t1.cust_active,chr(13),''),chr(10),'') as cust_active
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.device_no,chr(13),''),chr(10),'') as device_no
,replace(replace(t1.buss_type,chr(13),''),chr(10),'') as buss_type
from ${iol_schema}.ccdb_ochat_log_call_worksum t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccdb_ochat_log_call_worksum.i.${batch_date}.dat" \
        charset=utf8
        safe=yes