: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_cups_detl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_cups_detl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.trandt as trandt
,replace(replace(t.btchno,chr(13),''),chr(10),'') as btchno
,replace(replace(t.blbrch,chr(13),''),chr(10),'') as blbrch
,replace(replace(t.blusid,chr(13),''),chr(10),'') as blusid
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.cpstyp,chr(13),''),chr(10),'') as cpstyp
,replace(replace(t.csbxno,chr(13),''),chr(10),'') as csbxno
,t.fulcps as fulcps
,t.icpcps as icpcps
,t.sipcps as sipcps
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_cups_detl t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_cups_detl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes