: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhinsideholder_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hxyhinsideholder_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(comp_id,chr(10),''),chr(13),'') as comp_id
,replace(replace(ann_dt,chr(10),''),chr(13),'') as ann_dt
,replace(replace(s_holder_enddate,chr(10),''),chr(13),'') as s_holder_enddate
,replace(replace(s_holder_holdercategory,chr(10),''),chr(13),'') as s_holder_holdercategory
,replace(replace(s_holder_aname,chr(10),''),chr(13),'') as s_holder_aname
,replace(replace(s_holder_quantity,chr(10),''),chr(13),'') as s_holder_quantity
,replace(replace(s_holder_pct,chr(10),''),chr(13),'') as s_holder_pct
,replace(replace(s_holder_sharecategory,chr(10),''),chr(13),'') as s_holder_sharecategory
,replace(replace(crncy_code,chr(10),''),chr(13),'') as crncy_code
,replace(replace(s_holder_memo,chr(10),''),chr(13),'') as s_holder_memo
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.wind_hxyhinsideholder
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhinsideholder_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes