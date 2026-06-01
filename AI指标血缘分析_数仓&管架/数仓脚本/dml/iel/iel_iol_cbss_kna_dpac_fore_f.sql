: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_dpac_fore_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_dpac_fore.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.authno,chr(13),''),chr(10),'') as authno
,replace(replace(t.authdt,chr(13),''),chr(10),'') as authdt
,replace(replace(t.fractp,chr(13),''),chr(10),'') as fractp
,replace(replace(t.auamid,chr(13),''),chr(10),'') as auamid
,replace(replace(t.nwactp,chr(13),''),chr(10),'') as nwactp
,replace(replace(t.acsttg,chr(13),''),chr(10),'') as acsttg
,replace(replace(t.disbtg,chr(13),''),chr(10),'') as disbtg
,replace(replace(t.othrst,chr(13),''),chr(10),'') as othrst
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_dpac_fore t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_dpac_fore.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes