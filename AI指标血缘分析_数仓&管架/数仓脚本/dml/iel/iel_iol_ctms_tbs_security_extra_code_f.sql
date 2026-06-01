: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_security_extra_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_security_extra_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.security_code,chr(13),''),chr(10),'') as security_code
,replace(replace(t.extra_type,chr(13),''),chr(10),'') as extra_type
,replace(replace(t.extra_code,chr(13),''),chr(10),'') as extra_code
,t.customer_number as customer_number
,t.modify_user as modify_user
,t.modify_date as modify_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ctms_tbs_security_extra_code t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_security_extra_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes