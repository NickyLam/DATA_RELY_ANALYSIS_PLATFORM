: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_nibs_ib_log_busfill_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nibs_ib_log_busfill_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tx_seq_num,chr(13),''),chr(10),'') as tx_seq_num
,t1.oritrandate as oritrandate
,t1.oritrantime as oritrantime
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.tx_org_num,chr(13),''),chr(10),'') as tx_org_num
,replace(replace(t1.tx_teller_num,chr(13),''),chr(10),'') as tx_teller_num
,t1.maindate as maindate
,t1.maintime as maintime
,replace(replace(t1.note1,chr(13),''),chr(10),'') as note1
,replace(replace(t1.note2,chr(13),''),chr(10),'') as note2
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.nibs_ib_log_busfill_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_busfill_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes