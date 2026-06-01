: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_sys_datadict_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_sys_datadict_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dict_code,chr(13),''),chr(10),'') as dict_code
,replace(replace(t1.item_code,chr(13),''),chr(10),'') as item_code
,replace(replace(t1.item_value,chr(13),''),chr(10),'') as item_value
,t1.order_no as order_no
,replace(replace(t1.default_value,chr(13),''),chr(10),'') as default_value
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,t1.create_time as create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,t1.update_time as update_time
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fams_sys_datadict_list t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_sys_datadict_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes