: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_ded_rate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_ded_rate.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.id as id
,t1.def_id as def_id
,t1.rate as rate
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.imp_time,chr(13),''),chr(10),'') as imp_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.etl_timestamp as etl_timestamp
from iol.ibms_ttrd_ded_rate t1
where t1.etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_ded_rate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes