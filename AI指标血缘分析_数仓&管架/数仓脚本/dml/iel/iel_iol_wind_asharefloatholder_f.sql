: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharefloatholder_f
CreateDate: 20230822
FileName:   ${iel_data_path}/wind_asharefloatholder.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.s_holder_enddate,chr(13),''),chr(10),'') as s_holder_enddate
,replace(replace(t1.s_holder_holdercategory,chr(13),''),chr(10),'') as s_holder_holdercategory
,replace(replace(t1.s_holder_name,chr(13),''),chr(10),'') as s_holder_name
,s_holder_quantity
,replace(replace(t1.s_holder_windname,chr(13),''),chr(10),'') as s_holder_windname
,opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode

from ${iol_schema}.wind_asharefloatholder t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharefloatholder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
