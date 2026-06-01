: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_cbondinsideholder_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_cbondinsideholder.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.b_holder_enddate,chr(13),''),chr(10),'') as b_holder_enddate
,replace(replace(t1.b_holder_holdercategory,chr(13),''),chr(10),'') as b_holder_holdercategory
,replace(replace(t1.b_holder_name,chr(13),''),chr(10),'') as b_holder_name
,t1.b_holder_quantity as b_holder_quantity
,t1.b_holder_pct as b_holder_pct
,replace(replace(t1.b_holder_sharecategory,chr(13),''),chr(10),'') as b_holder_sharecategory
,replace(replace(t1.b_holder_aname,chr(13),''),chr(10),'') as b_holder_aname
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_cbondinsideholder t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_cbondinsideholder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes