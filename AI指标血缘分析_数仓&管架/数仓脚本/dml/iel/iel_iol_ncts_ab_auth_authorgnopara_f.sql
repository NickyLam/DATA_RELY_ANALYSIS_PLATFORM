: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_auth_authorgnopara_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_auth_authorgnopara.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.authorgno,chr(13),''),chr(10),'') as authorgno 
,replace(replace(t1.authorgname,chr(13),''),chr(10),'') as authorgname 
,replace(replace(t1.oraglev,chr(13),''),chr(10),'') as oraglev 
,replace(replace(t1.taskmode,chr(13),''),chr(10),'') as taskmode 
,replace(replace(t1.deleteflag,chr(13),''),chr(10),'') as deleteflag 
,replace(replace(t1.usingflag,chr(13),''),chr(10),'') as usingflag 
,replace(replace(t1.authorgtype,chr(13),''),chr(10),'') as authorgtype 
,t1.crtdate as crtdate 
,replace(replace(t1.crttellerno,chr(13),''),chr(10),'') as crttellerno 
,t1.upddate as upddate 
,replace(replace(t1.uptellerno,chr(13),''),chr(10),'') as uptellerno 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.ncts_ab_auth_authorgnopara t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_auth_authorgnopara.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes