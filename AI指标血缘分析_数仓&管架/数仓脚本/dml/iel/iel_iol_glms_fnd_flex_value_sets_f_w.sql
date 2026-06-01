: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_fnd_flex_value_sets_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_fnd_flex_value_sets_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(flex_value_set_id,chr(10),''),chr(13),'') as flex_value_set_id
,replace(replace(flex_value_set_name,chr(10),''),chr(13),'') as flex_value_set_name
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(validation_type,chr(10),''),chr(13),'') as validation_type
,replace(replace(protected_flag,chr(10),''),chr(13),'') as protected_flag
,replace(replace(security_enabled_flag,chr(10),''),chr(13),'') as security_enabled_flag
,replace(replace(longlist_flag,chr(10),''),chr(13),'') as longlist_flag
,replace(replace(format_type,chr(10),''),chr(13),'') as format_type
,replace(replace(maximum_size,chr(10),''),chr(13),'') as maximum_size
,replace(replace(alphanumeric_allowed_flag,chr(10),''),chr(13),'') as alphanumeric_allowed_flag
,replace(replace(uppercase_only_flag,chr(10),''),chr(13),'') as uppercase_only_flag
,replace(replace(numeric_mode_enabled_flag,chr(10),''),chr(13),'') as numeric_mode_enabled_flag
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(dependant_default_value,chr(10),''),chr(13),'') as dependant_default_value
,replace(replace(dependant_default_meaning,chr(10),''),chr(13),'') as dependant_default_meaning
,replace(replace(parent_flex_value_set_id,chr(10),''),chr(13),'') as parent_flex_value_set_id
,replace(replace(minimum_value,chr(10),''),chr(13),'') as minimum_value
,replace(replace(maximum_value,chr(10),''),chr(13),'') as maximum_value
,replace(replace(number_precision,chr(10),''),chr(13),'') as number_precision
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_fnd_flex_value_sets
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_fnd_flex_value_sets_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes