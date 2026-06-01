: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_dba_f
CreateDate: 20180529
FileName:   ${iel_data_path}/isbs_dba.f.${batch_date}.dat
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
,replace(replace(t1.custype,chr(13),''),chr(10),'') as custype 
,replace(replace(t1.idcode,chr(13),''),chr(10),'') as idcode 
,replace(replace(t1.custcod,chr(13),''),chr(10),'') as custcod 
,replace(replace(t1.custnm,chr(13),''),chr(10),'') as custnm 
,replace(replace(t1.oppuser,chr(13),''),chr(10),'') as oppuser 
,replace(replace(t1.txccy,chr(13),''),chr(10),'') as txccy 
,t1.txamt as txamt 
,t1.exrate as exrate 
,t1.lcyamt as lcyamt 
,replace(replace(t1.lcyacc,chr(13),''),chr(10),'') as lcyacc 
,t1.fcyamt as fcyamt 
,replace(replace(t1.fcyacc,chr(13),''),chr(10),'') as fcyacc 
,t1.othamt as othamt 
,replace(replace(t1.othacc,chr(13),''),chr(10),'') as othacc 
,replace(replace(t1.methods,chr(13),''),chr(10),'') as methods 
,replace(replace(t1.buscode,chr(13),''),chr(10),'') as buscode 
,replace(replace(t1.inchargeccy,chr(13),''),chr(10),'') as inchargeccy 
,t1.inchargeamt as inchargeamt 
,replace(replace(t1.outchargeccy,chr(13),''),chr(10),'') as outchargeccy 
,t1.outchargeamt as outchargeamt 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.isbs_dba t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_dba.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes