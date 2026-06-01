: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_pbms_tbl_bonus_plan_f
CreateDate: 20251014
FileName:   ${iel_data_path}/pbms_tbl_bonus_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_bonus_plan
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bonus_plan_type,chr(13),''),chr(10),'') as bonus_plan_type
,total_bonus
,valid_bonus
,apply_bonus
,expire_bonus
,freeze_bonus
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,del_flag

from ${iol_schema}.pbms_tbl_bonus_plan t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_bonus_plan.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
