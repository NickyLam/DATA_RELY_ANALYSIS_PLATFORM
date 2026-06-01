: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_sglr_hydjjg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_sglr_hydjjg.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin 20230317
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.khdxdh as khdxdh
    ,replace(replace(t.hydh,chr(13),''),chr(10),'') as hydh
    ,replace(replace(t.hymc,chr(13),''),chr(10),'') as hymc
    ,replace(replace(t.fhdh,chr(13),''),chr(10),'') as fhdh
    ,replace(replace(t.fhmc,chr(13),''),chr(10),'') as fhmc
    ,replace(replace(t.jgdh,chr(13),''),chr(10),'') as jgdh
    ,replace(replace(t.jgmc,chr(13),''),chr(10),'') as jgmc
    ,replace(replace(t.djbh,chr(13),''),chr(10),'') as djbh
    ,replace(replace(t.zxmc,chr(13),''),chr(10),'') as zxmc
    ,replace(replace(t.djmc,chr(13),''),chr(10),'') as djmc
    ,t.yxqsrq as yxqsrq
    ,t.yxjsrq as yxjsrq
    ,replace(replace(t.czr,chr(13),''),chr(10),'') as czr
    ,t.czsj as czsj
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_sglr_hydjjg t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_sglr_hydjjg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes