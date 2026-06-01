: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondratingdefinition_a
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondratingdefinition.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.start_dt as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.b_info_creditratingagency,chr(13),''),chr(10),'') as b_info_creditratingagency 
,replace(replace(t1.b_info_creditrating_name,chr(13),''),chr(10),'') as b_info_creditrating_name 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
from ${iol_schema}.wind_cbondratingdefinition t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondratingdefinition.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes