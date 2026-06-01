: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_fnd_flex_values_vl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_fnd_flex_values_vl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.row_id,chr(13),''),chr(10),'') as row_id
    ,t.flex_value_set_id as flex_value_set_id
    ,t.flex_value_id as flex_value_id
    ,replace(replace(t.flex_value,chr(13),''),chr(10),'') as flex_value
    ,t.last_update_date as last_update_date
    ,t.last_updated_by as last_updated_by
    ,t.creation_date as creation_date
    ,t.created_by as created_by
    ,t.last_update_login as last_update_login
    ,replace(replace(t.enabled_flag,chr(13),''),chr(10),'') as enabled_flag
    ,replace(replace(t.summary_flag,chr(13),''),chr(10),'') as summary_flag
    ,t.start_date_active as start_date_active
    ,t.end_date_active as end_date_active
    ,replace(replace(t.parent_flex_value_low,chr(13),''),chr(10),'') as parent_flex_value_low
    ,replace(replace(t.parent_flex_value_high,chr(13),''),chr(10),'') as parent_flex_value_high
    ,t.structured_hierarchy_level as structured_hierarchy_level
    ,replace(replace(t.hierarchy_level,chr(13),''),chr(10),'') as hierarchy_level
    ,replace(replace(t.compiled_value_attributes,chr(13),''),chr(10),'') as compiled_value_attributes
    ,replace(replace(t.value_category,chr(13),''),chr(10),'') as value_category
    ,replace(replace(t.attribute1,chr(13),''),chr(10),'') as attribute1
    ,replace(replace(t.attribute2,chr(13),''),chr(10),'') as attribute2
    ,replace(replace(t.attribute3,chr(13),''),chr(10),'') as attribute3
    ,replace(replace(t.attribute4,chr(13),''),chr(10),'') as attribute4
    ,replace(replace(t.attribute5,chr(13),''),chr(10),'') as attribute5
    ,replace(replace(t.attribute6,chr(13),''),chr(10),'') as attribute6
    ,replace(replace(t.attribute7,chr(13),''),chr(10),'') as attribute7
    ,replace(replace(t.attribute8,chr(13),''),chr(10),'') as attribute8
    ,replace(replace(t.attribute9,chr(13),''),chr(10),'') as attribute9
    ,replace(replace(t.attribute10,chr(13),''),chr(10),'') as attribute10
    ,replace(replace(t.attribute11,chr(13),''),chr(10),'') as attribute11
    ,replace(replace(t.attribute12,chr(13),''),chr(10),'') as attribute12
    ,replace(replace(t.attribute13,chr(13),''),chr(10),'') as attribute13
    ,replace(replace(t.attribute14,chr(13),''),chr(10),'') as attribute14
    ,replace(replace(t.attribute15,chr(13),''),chr(10),'') as attribute15
    ,replace(replace(t.attribute16,chr(13),''),chr(10),'') as attribute16
    ,replace(replace(t.attribute17,chr(13),''),chr(10),'') as attribute17
    ,replace(replace(t.attribute18,chr(13),''),chr(10),'') as attribute18
    ,replace(replace(t.attribute19,chr(13),''),chr(10),'') as attribute19
    ,replace(replace(t.attribute20,chr(13),''),chr(10),'') as attribute20
    ,replace(replace(t.attribute21,chr(13),''),chr(10),'') as attribute21
    ,replace(replace(t.attribute22,chr(13),''),chr(10),'') as attribute22
    ,replace(replace(t.attribute23,chr(13),''),chr(10),'') as attribute23
    ,replace(replace(t.attribute24,chr(13),''),chr(10),'') as attribute24
    ,replace(replace(t.attribute25,chr(13),''),chr(10),'') as attribute25
    ,replace(replace(t.attribute26,chr(13),''),chr(10),'') as attribute26
    ,replace(replace(t.attribute27,chr(13),''),chr(10),'') as attribute27
    ,replace(replace(t.attribute28,chr(13),''),chr(10),'') as attribute28
    ,replace(replace(t.attribute29,chr(13),''),chr(10),'') as attribute29
    ,replace(replace(t.attribute30,chr(13),''),chr(10),'') as attribute30
    ,replace(replace(t.attribute31,chr(13),''),chr(10),'') as attribute31
    ,replace(replace(t.attribute32,chr(13),''),chr(10),'') as attribute32
    ,replace(replace(t.attribute33,chr(13),''),chr(10),'') as attribute33
    ,replace(replace(t.attribute34,chr(13),''),chr(10),'') as attribute34
    ,replace(replace(t.attribute35,chr(13),''),chr(10),'') as attribute35
    ,replace(replace(t.attribute36,chr(13),''),chr(10),'') as attribute36
    ,replace(replace(t.attribute37,chr(13),''),chr(10),'') as attribute37
    ,replace(replace(t.attribute38,chr(13),''),chr(10),'') as attribute38
    ,replace(replace(t.attribute39,chr(13),''),chr(10),'') as attribute39
    ,replace(replace(t.attribute40,chr(13),''),chr(10),'') as attribute40
    ,replace(replace(t.attribute41,chr(13),''),chr(10),'') as attribute41
    ,replace(replace(t.attribute42,chr(13),''),chr(10),'') as attribute42
    ,replace(replace(t.attribute43,chr(13),''),chr(10),'') as attribute43
    ,replace(replace(t.attribute44,chr(13),''),chr(10),'') as attribute44
    ,replace(replace(t.attribute45,chr(13),''),chr(10),'') as attribute45
    ,replace(replace(t.attribute46,chr(13),''),chr(10),'') as attribute46
    ,replace(replace(t.attribute47,chr(13),''),chr(10),'') as attribute47
    ,replace(replace(t.attribute48,chr(13),''),chr(10),'') as attribute48
    ,replace(replace(t.attribute49,chr(13),''),chr(10),'') as attribute49
    ,replace(replace(t.attribute50,chr(13),''),chr(10),'') as attribute50
    ,replace(replace(t.flex_value_meaning,chr(13),''),chr(10),'') as flex_value_meaning
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,t.attribute_sort_order as attribute_sort_order
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.glms_fnd_flex_values_vl t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_fnd_flex_values_vl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes