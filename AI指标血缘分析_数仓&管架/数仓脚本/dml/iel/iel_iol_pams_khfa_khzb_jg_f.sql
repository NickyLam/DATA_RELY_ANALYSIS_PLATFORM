: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khfa_khzb_jg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_khfa_khzb_jg.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.khzbdh as khzbdh
,replace(replace(t.khzbmc,chr(13),''),chr(10),'') as khzbmc
,t.zbdh as zbdh
,replace(replace(t.sdbs,chr(13),''),chr(10),'') as sdbs
,replace(replace(t.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t.tjkj,chr(13),''),chr(10),'') as tjkj
,t.zbpx as zbpx
,replace(replace(t.ydsfzs,chr(13),''),chr(10),'') as ydsfzs
,replace(replace(t.ydbm,chr(13),''),chr(10),'') as ydbm
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.pams_khfa_khzb_jg t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khfa_khzb_jg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes