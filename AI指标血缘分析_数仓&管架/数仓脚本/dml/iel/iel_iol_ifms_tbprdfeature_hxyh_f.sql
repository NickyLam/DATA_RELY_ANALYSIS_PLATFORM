: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbprdfeature_hxyh_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbprdfeature_hxyh.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.trade_rule,chr(13),''),chr(10),'') as trade_rule
,replace(replace(t.prd_feature,chr(13),''),chr(10),'') as prd_feature
,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t.reserve5,chr(13),''),chr(10),'') as reserve5
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ifms_tbprdfeature_hxyh t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbprdfeature_hxyh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes