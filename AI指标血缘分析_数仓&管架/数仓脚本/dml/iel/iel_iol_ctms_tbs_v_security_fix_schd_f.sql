: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_security_fix_schd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_security_fix_schd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.security_code,chr(13),''),chr(10),'') as security_code
,t1.seq as seq
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.fixing_date,chr(13),''),chr(10),'') as fixing_date
,t1.fixing_rate as fixing_rate
,t1.modify_date as modify_date
,t1.modify_user as modify_user
,t1.spread as spread
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_v_security_fix_schd t1
where t1.etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_security_fix_schd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes