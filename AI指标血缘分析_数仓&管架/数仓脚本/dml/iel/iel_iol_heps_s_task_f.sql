: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_s_task_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_s_task.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.task_id as task_id
,t.customer_id as customer_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.actor_no,chr(13),''),chr(10),'') as actor_no
,replace(replace(t.title,chr(13),''),chr(10),'') as title
,t.official_valuation as official_valuation
,replace(replace(t.plot_name,chr(13),''),chr(10),'') as plot_name
,replace(replace(t.house_location,chr(13),''),chr(10),'') as house_location
,replace(replace(t.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t.customer_mobile,chr(13),''),chr(10),'') as customer_mobile
,t.application_time as application_time
,replace(replace(t.task_status,chr(13),''),chr(10),'') as task_status
,replace(replace(t.loan_type,chr(13),''),chr(10),'') as loan_type
,replace(replace(t.cus_card_no,chr(13),''),chr(10),'') as cus_card_no
,replace(replace(t.house_area,chr(13),''),chr(10),'') as house_area
,replace(replace(t.house_level,chr(13),''),chr(10),'') as house_level
,t.high_loan_limit as high_loan_limit
,replace(replace(t.task_source,chr(13),''),chr(10),'') as task_source
,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.purpors,chr(13),''),chr(10),'') as purpors
,replace(replace(t.actor_name,chr(13),''),chr(10),'') as actor_name
,t.trial_time as trial_time
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.pro_name,chr(13),''),chr(10),'') as pro_name
,replace(replace(t.devision_id,chr(13),''),chr(10),'') as devision_id
,replace(replace(t.plot_number,chr(13),''),chr(10),'') as plot_number
,replace(replace(t.approval_limit,chr(13),''),chr(10),'') as approval_limit
,replace(replace(t.ser_no,chr(13),''),chr(10),'') as ser_no
,replace(replace(t.city_area_code,chr(13),''),chr(10),'') as city_area_code
,replace(replace(t.city_name,chr(13),''),chr(10),'') as city_name
,replace(replace(t.area_name,chr(13),''),chr(10),'') as area_name
,replace(replace(t.is_tag,chr(13),''),chr(10),'') as is_tag
,replace(replace(t.first_flow_id,chr(13),''),chr(10),'') as first_flow_id
,replace(replace(t.pro_id,chr(13),''),chr(10),'') as pro_id
,replace(replace(t.actor_orgid,chr(13),''),chr(10),'') as actor_orgid
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.source_company,chr(13),''),chr(10),'') as source_company
,replace(replace(t.zj_actor_no,chr(13),''),chr(10),'') as zj_actor_no
,replace(replace(t.xh_actor_no,chr(13),''),chr(10),'') as xh_actor_no
,replace(replace(t.xh_actor_name,chr(13),''),chr(10),'') as xh_actor_name
,replace(replace(t.flowable_tag,chr(13),''),chr(10),'') as flowable_tag
,replace(replace(t.flowable_instance_id,chr(13),''),chr(10),'') as flowable_instance_id
,replace(replace(t.developers,chr(13),''),chr(10),'') as developers
from iol.heps_s_task t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_s_task.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes