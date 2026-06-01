: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_auth_authorgteller_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_auth_authorgteller.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.authorgno,chr(13),''),chr(10),'') as authorgno 
,replace(replace(t1.authtellerno,chr(13),''),chr(10),'') as authtellerno 
,replace(replace(t1.telleroid,chr(13),''),chr(10),'') as telleroid 
,replace(replace(t1.telleronline,chr(13),''),chr(10),'') as telleronline 
,replace(replace(t1.realocationflag,chr(13),''),chr(10),'') as realocationflag 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.ncts_ab_auth_authorgteller t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_auth_authorgteller.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes