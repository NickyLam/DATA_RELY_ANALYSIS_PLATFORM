: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_pol_graph_snapshot_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_pol_graph_snapshot.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.graph_seq,chr(13),''),chr(10),'') as graph_seq
,replace(replace(t.type,chr(13),''),chr(10),'') as type
,replace(replace(t.event_code,chr(13),''),chr(10),'') as event_code
,replace(replace(t.etime,chr(13),''),chr(10),'') as etime
,replace(replace(t.src,chr(13),''),chr(10),'') as src
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_pol_graph_snapshot t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_pol_graph_snapshot.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes