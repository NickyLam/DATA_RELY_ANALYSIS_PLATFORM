: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_yjzb_hynjh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_yjzb_hynjh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.khnf as khnf
,t.khzbdh as khzbdh
,t.khdxdh as khdxdh
,t.jhz as jhz
,t.lzz as lzz
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_yjzb_hynjh t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_yjzb_hynjh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes