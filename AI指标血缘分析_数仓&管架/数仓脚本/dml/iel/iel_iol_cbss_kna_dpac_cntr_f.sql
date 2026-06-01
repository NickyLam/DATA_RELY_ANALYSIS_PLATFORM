: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_dpac_cntr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_dpac_cntr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.cntrno,chr(13),''),chr(10),'') as cntrno
,t.acrdam as acrdam
,replace(replace(t.bgaldt,chr(13),''),chr(10),'') as bgaldt
,replace(replace(t.matudt,chr(13),''),chr(10),'') as matudt
,t.crinrt as crinrt
,replace(replace(t.cuinme,chr(13),''),chr(10),'') as cuinme
,replace(replace(t.aprvno,chr(13),''),chr(10),'') as aprvno
,t.apfllv as apfllv
,t.acmlbl as acmlbl
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_dpac_cntr t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_dpac_cntr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes