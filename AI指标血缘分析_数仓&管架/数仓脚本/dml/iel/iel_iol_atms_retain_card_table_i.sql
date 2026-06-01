: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_retain_card_table_i
CreateDate: 20240130
FileName:   ${iel_data_path}/atms_retain_card_table.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.logic_id,chr(13),''),chr(10),'') as logic_id
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.retain_date,chr(13),''),chr(10),'') as retain_date
,replace(replace(t1.retain_time,chr(13),''),chr(10),'') as retain_time
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,replace(replace(t1.card_stuck_org,chr(13),''),chr(10),'') as card_stuck_org
,replace(replace(t1.card_handle_org,chr(13),''),chr(10),'') as card_handle_org
,replace(replace(t1.auto_flag,chr(13),''),chr(10),'') as auto_flag
,replace(replace(t1.check_op,chr(13),''),chr(10),'') as check_op
,replace(replace(t1.check_date,chr(13),''),chr(10),'') as check_date
,replace(replace(t1.check_time,chr(13),''),chr(10),'') as check_time
,replace(replace(t1.op_no,chr(13),''),chr(10),'') as op_no
,replace(replace(t1.op_date,chr(13),''),chr(10),'') as op_date
,replace(replace(t1.op_time,chr(13),''),chr(10),'') as op_time
,replace(replace(t1.op_address,chr(13),''),chr(10),'') as op_address
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,replace(replace(t1.account_id,chr(13),''),chr(10),'') as account_id
,replace(replace(t1.account_phome,chr(13),''),chr(10),'') as account_phome
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,start_dt
,end_dt

from ${iol_schema}.atms_retain_card_table t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_retain_card_table.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
