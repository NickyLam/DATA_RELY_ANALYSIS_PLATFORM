: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_dbh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/isbs_dbh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr 
,replace(replace(t1.tmpref,chr(13),''),chr(10),'') as tmpref 
,replace(replace(t1.ownextkey,chr(13),''),chr(10),'') as ownextkey 
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver 
,replace(replace(t1.actiontype,chr(13),''),chr(10),'') as actiontype 
,replace(replace(t1.actiondesc,chr(13),''),chr(10),'') as actiondesc 
,replace(replace(t1.rptno,chr(13),''),chr(10),'') as rptno 
,replace(replace(t1.country,chr(13),''),chr(10),'') as country 
,replace(replace(t1.paytype,chr(13),''),chr(10),'') as paytype 
,replace(replace(t1.txcode,chr(13),''),chr(10),'') as txcode 
,t1.tc1amt as tc1amt 
,replace(replace(t1.txrem,chr(13),''),chr(10),'') as txrem 
,replace(replace(t1.txcode2,chr(13),''),chr(10),'') as txcode2 
,t1.tc2amt as tc2amt 
,replace(replace(t1.tx2rem,chr(13),''),chr(10),'') as tx2rem 
,replace(replace(t1.isref,chr(13),''),chr(10),'') as isref 
,replace(replace(t1.crtuser,chr(13),''),chr(10),'') as crtuser 
,replace(replace(t1.inptelc,chr(13),''),chr(10),'') as inptelc 
,t1.rptdate as rptdate 
,replace(replace(t1.regno,chr(13),''),chr(10),'') as regno 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.isbs_dbh t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_dbh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes