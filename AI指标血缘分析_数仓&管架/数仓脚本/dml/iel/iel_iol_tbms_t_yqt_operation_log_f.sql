: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbms_t_yqt_operation_log_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tbms_t_yqt_operation_log.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,t1.cpyid as cpyid
,t1.uaid as uaid
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,t1.opertype as opertype
,t1.sys_ctime as sys_ctime
,t1.sys_utime as sys_utime
,t1.sys_valid as sys_valid
from ${iol_schema}.tbms_t_yqt_operation_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbms_t_yqt_operation_log.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes