: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_cfg_t_biz_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_cfg_t_biz_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.id,chr(13),''),chr(10),'') as id 
,replace(replace(t1.biz_code,chr(13),''),chr(10),'') as biz_code 
,replace(replace(t1.biz_name,chr(13),''),chr(10),'') as biz_name 
,t1.eft_date as eft_date 
,replace(replace(t1.biz_property,chr(13),''),chr(10),'') as biz_property 
,replace(replace(t1.is_auto_priority,chr(13),''),chr(10),'') as is_auto_priority 
,t1.pre_setup_point as pre_setup_point 
,t1.pre_setup_priority as pre_setup_priority 
,replace(replace(t1.time_len,chr(13),''),chr(10),'') as time_len 
,t1.timeout_priority as timeout_priority 
,replace(replace(t1.time_limit,chr(13),''),chr(10),'') as time_limit 
,t1.timelimit_priority as timelimit_priority 
,replace(replace(t1.kind_code,chr(13),''),chr(10),'') as kind_code 
,t1.order_no as order_no 
,replace(replace(t1.is_display,chr(13),''),chr(10),'') as is_display 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pbss_cfg_t_biz_code t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_cfg_t_biz_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes