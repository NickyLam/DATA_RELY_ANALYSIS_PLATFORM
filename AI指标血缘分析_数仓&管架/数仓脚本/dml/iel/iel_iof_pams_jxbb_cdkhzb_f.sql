: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pams_jxbb_cdkhzb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_jxbb_cdkhzb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.tjrq as tjrq
,t1.khdxdh as khdxdh
,t1.pm as pm
,replace(replace(t1.xm,chr(13),''),chr(10),'') as xm
,t1.ye as ye
,t1.yrj as yrj
,t1.nrj as nrj
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.pams_jxbb_cdkhzb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_cdkhzb.f.${batch_date}.dat" \
        charset=utf8
        safe=yes