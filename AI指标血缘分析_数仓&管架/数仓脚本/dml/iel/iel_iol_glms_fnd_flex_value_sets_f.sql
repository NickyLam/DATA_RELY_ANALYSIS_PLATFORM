: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_fnd_flex_value_sets_f
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_fnd_flex_value_sets.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.flex_value_set_id as flex_value_set_id
    ,replace(replace(t.flex_value_set_name,chr(13),''),chr(10),'') as flex_value_set_name
    ,t.last_update_date as last_update_date
    ,t.last_updated_by as last_updated_by
    ,t.creation_date as creation_date
    ,t.created_by as created_by
    ,t.last_update_login as last_update_login
    ,replace(replace(t.validation_type,chr(13),''),chr(10),'') as validation_type
    ,replace(replace(t.protected_flag,chr(13),''),chr(10),'') as protected_flag
    ,replace(replace(t.security_enabled_flag,chr(13),''),chr(10),'') as security_enabled_flag
    ,replace(replace(t.longlist_flag,chr(13),''),chr(10),'') as longlist_flag
    ,replace(replace(t.format_type,chr(13),''),chr(10),'') as format_type
    ,t.maximum_size as maximum_size
    ,replace(replace(t.alphanumeric_allowed_flag,chr(13),''),chr(10),'') as alphanumeric_allowed_flag
    ,replace(replace(t.uppercase_only_flag,chr(13),''),chr(10),'') as uppercase_only_flag
    ,replace(replace(t.numeric_mode_enabled_flag,chr(13),''),chr(10),'') as numeric_mode_enabled_flag
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,replace(replace(t.dependant_default_value,chr(13),''),chr(10),'') as dependant_default_value
    ,replace(replace(t.dependant_default_meaning,chr(13),''),chr(10),'') as dependant_default_meaning
    ,t.parent_flex_value_set_id as parent_flex_value_set_id
    ,replace(replace(t.minimum_value,chr(13),''),chr(10),'') as minimum_value
    ,replace(replace(t.maximum_value,chr(13),''),chr(10),'') as maximum_value
    ,t.number_precision as number_precision
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.glms_fnd_flex_value_sets t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_fnd_flex_value_sets.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes