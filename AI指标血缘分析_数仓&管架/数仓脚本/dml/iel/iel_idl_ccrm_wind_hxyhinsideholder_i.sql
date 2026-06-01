: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hxyhinsideholder_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hxyhinsideholder.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.s_holder_enddate,chr(13),''),chr(10),'') as s_holder_enddate
,replace(replace(t1.s_holder_holdercategory,chr(13),''),chr(10),'') as s_holder_holdercategory
,replace(replace(t1.s_holder_aname,chr(13),''),chr(10),'') as s_holder_aname
,t1.s_holder_quantity as s_holder_quantity
,t1.s_holder_pct as s_holder_pct
,replace(replace(t1.s_holder_sharecategory,chr(13),''),chr(10),'') as s_holder_sharecategory
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t1.s_holder_memo,chr(13),''),chr(10),'') as s_holder_memo
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_hxyhinsideholder t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hxyhinsideholder.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes