: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cchs_sys_dictionary_info_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cchs_sys_dictionary_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.value,chr(13),''),chr(10),'') as value
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,update_date
,create_date
,replace(replace(t1.code_path,chr(13),''),chr(10),'') as code_path
,replace(replace(t1.has_child,chr(13),''),chr(10),'') as has_child
,replace(replace(t1.editable,chr(13),''),chr(10),'') as editable
,replace(replace(t1.creater_code,chr(13),''),chr(10),'') as creater_code
,replace(replace(t1.update_code,chr(13),''),chr(10),'') as update_code
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.parent_id,chr(13),''),chr(10),'') as parent_id
,busstype

from ${iol_schema}.cchs_sys_dictionary_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cchs_sys_dictionary_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
