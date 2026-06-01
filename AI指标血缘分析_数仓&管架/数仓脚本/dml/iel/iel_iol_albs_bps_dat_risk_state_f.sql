: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_albs_bps_dat_risk_state_f
CreateDate: 20230423
FileName:   ${iel_data_path}/albs_bps_dat_risk_state.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.own_org,chr(13),''),chr(10),'') as own_org
,replace(replace(t1.state_src,chr(13),''),chr(10),'') as state_src
,replace(replace(t1.state_code,chr(13),''),chr(10),'') as state_code
,replace(replace(t1.state_name,chr(13),''),chr(10),'') as state_name
,replace(replace(t1.user_remark,chr(13),''),chr(10),'') as user_remark
,replace(replace(t1.oper_type,chr(13),''),chr(10),'') as oper_type
,replace(replace(t1.edit_status,chr(13),''),chr(10),'') as edit_status
,replace(replace(t1.data_enable,chr(13),''),chr(10),'') as data_enable
,replace(replace(t1.crt_date,chr(13),''),chr(10),'') as crt_date
,replace(replace(t1.crt_datetime,chr(13),''),chr(10),'') as crt_datetime
,replace(replace(t1.crt_user_id,chr(13),''),chr(10),'') as crt_user_id
,replace(replace(t1.crt_branch_id,chr(13),''),chr(10),'') as crt_branch_id
,replace(replace(t1.last_date,chr(13),''),chr(10),'') as last_date
,replace(replace(t1.last_datetime,chr(13),''),chr(10),'') as last_datetime
,replace(replace(t1.last_user_id,chr(13),''),chr(10),'') as last_user_id
,replace(replace(t1.last_branch_id,chr(13),''),chr(10),'') as last_branch_id
,replace(replace(t1.last_txn,chr(13),''),chr(10),'') as last_txn
,replace(replace(t1.state_name_en,chr(13),''),chr(10),'') as state_name_en
,replace(replace(t1.list_id,chr(13),''),chr(10),'') as list_id
,replace(replace(t1.state_abbreviate,chr(13),''),chr(10),'') as state_abbreviate
,replace(replace(t1.crt_user_code,chr(13),''),chr(10),'') as crt_user_code
,replace(replace(t1.crt_branch_code,chr(13),''),chr(10),'') as crt_branch_code
,replace(replace(t1.last_user_code,chr(13),''),chr(10),'') as last_user_code
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.albs_bps_dat_risk_state t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/albs_bps_dat_risk_state.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
