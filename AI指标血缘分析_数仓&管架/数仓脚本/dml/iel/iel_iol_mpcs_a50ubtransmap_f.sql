: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a50ubtransmap_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a50ubtransmap.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.paraid as paraid
,replace(replace(t1.msgtype,chr(13),''),chr(10),'') as msgtype
,replace(replace(t1.procecode,chr(13),''),chr(10),'') as procecode
,replace(replace(t1.exprocode,chr(13),''),chr(10),'') as exprocode
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.transname,chr(13),''),chr(10),'') as transname
,replace(replace(t1.addrflag,chr(13),''),chr(10),'') as addrflag
,replace(replace(t1.revflag,chr(13),''),chr(10),'') as revflag
,t1.timeout as timeout
,replace(replace(t1.resflag,chr(13),''),chr(10),'') as resflag
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mpcs_a50ubtransmap t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a50ubtransmap.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes