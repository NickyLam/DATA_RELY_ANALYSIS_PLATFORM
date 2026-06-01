: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_fnd_flex_values_vl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_fnd_flex_values_vl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(row_id,chr(10),''),chr(13),'') as row_id
,replace(replace(flex_value_set_id,chr(10),''),chr(13),'') as flex_value_set_id
,replace(replace(flex_value_id,chr(10),''),chr(13),'') as flex_value_id
,replace(replace(flex_value,chr(10),''),chr(13),'') as flex_value
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(enabled_flag,chr(10),''),chr(13),'') as enabled_flag
,replace(replace(summary_flag,chr(10),''),chr(13),'') as summary_flag
,replace(replace(start_date_active,chr(10),''),chr(13),'') as start_date_active
,replace(replace(end_date_active,chr(10),''),chr(13),'') as end_date_active
,replace(replace(parent_flex_value_low,chr(10),''),chr(13),'') as parent_flex_value_low
,replace(replace(parent_flex_value_high,chr(10),''),chr(13),'') as parent_flex_value_high
,replace(replace(structured_hierarchy_level,chr(10),''),chr(13),'') as structured_hierarchy_level
,replace(replace(hierarchy_level,chr(10),''),chr(13),'') as hierarchy_level
,replace(replace(compiled_value_attributes,chr(10),''),chr(13),'') as compiled_value_attributes
,replace(replace(value_category,chr(10),''),chr(13),'') as value_category
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,replace(replace(attribute3,chr(10),''),chr(13),'') as attribute3
,replace(replace(attribute4,chr(10),''),chr(13),'') as attribute4
,replace(replace(attribute5,chr(10),''),chr(13),'') as attribute5
,replace(replace(attribute6,chr(10),''),chr(13),'') as attribute6
,replace(replace(attribute7,chr(10),''),chr(13),'') as attribute7
,replace(replace(attribute8,chr(10),''),chr(13),'') as attribute8
,replace(replace(attribute9,chr(10),''),chr(13),'') as attribute9
,replace(replace(attribute10,chr(10),''),chr(13),'') as attribute10
,replace(replace(attribute11,chr(10),''),chr(13),'') as attribute11
,replace(replace(attribute12,chr(10),''),chr(13),'') as attribute12
,replace(replace(attribute13,chr(10),''),chr(13),'') as attribute13
,replace(replace(attribute14,chr(10),''),chr(13),'') as attribute14
,replace(replace(attribute15,chr(10),''),chr(13),'') as attribute15
,replace(replace(attribute16,chr(10),''),chr(13),'') as attribute16
,replace(replace(attribute17,chr(10),''),chr(13),'') as attribute17
,replace(replace(attribute18,chr(10),''),chr(13),'') as attribute18
,replace(replace(attribute19,chr(10),''),chr(13),'') as attribute19
,replace(replace(attribute20,chr(10),''),chr(13),'') as attribute20
,replace(replace(attribute21,chr(10),''),chr(13),'') as attribute21
,replace(replace(attribute22,chr(10),''),chr(13),'') as attribute22
,replace(replace(attribute23,chr(10),''),chr(13),'') as attribute23
,replace(replace(attribute24,chr(10),''),chr(13),'') as attribute24
,replace(replace(attribute25,chr(10),''),chr(13),'') as attribute25
,replace(replace(attribute26,chr(10),''),chr(13),'') as attribute26
,replace(replace(attribute27,chr(10),''),chr(13),'') as attribute27
,replace(replace(attribute28,chr(10),''),chr(13),'') as attribute28
,replace(replace(attribute29,chr(10),''),chr(13),'') as attribute29
,replace(replace(attribute30,chr(10),''),chr(13),'') as attribute30
,replace(replace(attribute31,chr(10),''),chr(13),'') as attribute31
,replace(replace(attribute32,chr(10),''),chr(13),'') as attribute32
,replace(replace(attribute33,chr(10),''),chr(13),'') as attribute33
,replace(replace(attribute34,chr(10),''),chr(13),'') as attribute34
,replace(replace(attribute35,chr(10),''),chr(13),'') as attribute35
,replace(replace(attribute36,chr(10),''),chr(13),'') as attribute36
,replace(replace(attribute37,chr(10),''),chr(13),'') as attribute37
,replace(replace(attribute38,chr(10),''),chr(13),'') as attribute38
,replace(replace(attribute39,chr(10),''),chr(13),'') as attribute39
,replace(replace(attribute40,chr(10),''),chr(13),'') as attribute40
,replace(replace(attribute41,chr(10),''),chr(13),'') as attribute41
,replace(replace(attribute42,chr(10),''),chr(13),'') as attribute42
,replace(replace(attribute43,chr(10),''),chr(13),'') as attribute43
,replace(replace(attribute44,chr(10),''),chr(13),'') as attribute44
,replace(replace(attribute45,chr(10),''),chr(13),'') as attribute45
,replace(replace(attribute46,chr(10),''),chr(13),'') as attribute46
,replace(replace(attribute47,chr(10),''),chr(13),'') as attribute47
,replace(replace(attribute48,chr(10),''),chr(13),'') as attribute48
,replace(replace(attribute49,chr(10),''),chr(13),'') as attribute49
,replace(replace(attribute50,chr(10),''),chr(13),'') as attribute50
,replace(replace(flex_value_meaning,chr(10),''),chr(13),'') as flex_value_meaning
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(attribute_sort_order,chr(10),''),chr(13),'') as attribute_sort_order
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_fnd_flex_values_vl
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_fnd_flex_values_vl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes