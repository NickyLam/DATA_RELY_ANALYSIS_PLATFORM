: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pbms_tbl_hrt_rule_f
CreateDate: 20251113
FileName:   ${iel_data_path}/pbms_tbl_hrt_rule.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_hrt_rule
,replace(replace(t1.activity_code,chr(13),''),chr(10),'') as activity_code
,replace(replace(t1.rule_name,chr(13),''),chr(10),'') as rule_name
,replace(replace(t1.stat_item,chr(13),''),chr(10),'') as stat_item
,window_days
,min_value
,replace(replace(t1.include_min,chr(13),''),chr(10),'') as include_min
,max_value
,replace(replace(t1.include_max,chr(13),''),chr(10),'') as include_max
,replace(replace(t1.unit,chr(13),''),chr(10),'') as unit
,effective_begin
,effective_end
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,del_flag
,give_bonus

from ${iol_schema}.pbms_tbl_hrt_rule t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_hrt_rule.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
