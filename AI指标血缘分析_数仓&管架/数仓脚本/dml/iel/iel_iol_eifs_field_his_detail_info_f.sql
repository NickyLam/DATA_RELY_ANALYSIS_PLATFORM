: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_field_his_detail_info_f
CreateDate: 20220819
FileName:   ${iel_data_path}/eifs_field_his_detail_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.modify_his_id,chr(13),''),chr(10),'') as modify_his_id
    ,replace(replace(t.info_id,chr(13),''),chr(10),'') as info_id
    ,replace(replace(t.table_name,chr(13),''),chr(10),'') as table_name
    ,replace(replace(t.table_name_desc,chr(13),''),chr(10),'') as table_name_desc
    ,replace(replace(t.type_desc,chr(13),''),chr(10),'') as type_desc
    ,replace(replace(t.field_name,chr(13),''),chr(10),'') as field_name
    ,replace(replace(t.field_name_desc,chr(13),''),chr(10),'') as field_name_desc
    ,replace(replace(t.before_value,chr(13),''),chr(10),'') as before_value
    ,replace(replace(t.after_value,chr(13),''),chr(10),'') as after_value
 from iol.eifs_field_his_detail_info t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_field_his_detail_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes