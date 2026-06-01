: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_lcps_js_sys_office_f
CreateDate: 20240822
FileName:   ${iel_data_path}/lcps_js_sys_office.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.office_code,chr(13),''),chr(10),'') as office_code
,replace(replace(t1.parent_code,chr(13),''),chr(10),'') as parent_code
,replace(replace(t1.parent_codes,chr(13),''),chr(10),'') as parent_codes
,tree_sort
,replace(replace(t1.tree_sorts,chr(13),''),chr(10),'') as tree_sorts
,replace(replace(t1.tree_leaf,chr(13),''),chr(10),'') as tree_leaf
,tree_level
,replace(replace(t1.tree_names,chr(13),''),chr(10),'') as tree_names
,replace(replace(t1.view_code,chr(13),''),chr(10),'') as view_code
,replace(replace(t1.office_name,chr(13),''),chr(10),'') as office_name
,replace(replace(t1.full_name,chr(13),''),chr(10),'') as full_name
,replace(replace(t1.office_type,chr(13),''),chr(10),'') as office_type
,replace(replace(t1.leader,chr(13),''),chr(10),'') as leader
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.zip_code,chr(13),''),chr(10),'') as zip_code
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,create_date
,replace(replace(t1.update_by,chr(13),''),chr(10),'') as update_by
,update_date
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name

from ${iol_schema}.lcps_js_sys_office t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/lcps_js_sys_office.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
