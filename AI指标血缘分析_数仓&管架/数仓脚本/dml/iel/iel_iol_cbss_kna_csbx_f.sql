: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_csbx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_csbx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.csbxno,chr(13),''),chr(10),'') as csbxno
,replace(replace(t.csbxna,chr(13),''),chr(10),'') as csbxna
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.csbxtp,chr(13),''),chr(10),'') as csbxtp
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.lastdt,chr(13),''),chr(10),'') as lastdt
,replace(replace(t.lastsq,chr(13),''),chr(10),'') as lastsq
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_kna_csbx t
Where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_csbx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes