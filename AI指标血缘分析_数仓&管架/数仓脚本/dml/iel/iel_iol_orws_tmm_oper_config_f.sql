: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_tmm_oper_config_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_tmm_oper_config.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.id as id 
,t1.model_id as model_id 
,t1.model_group as model_group 
,t1.warn_level as warn_level 
,t1.is_auto as is_auto 
,replace(replace(t1.auto_description,chr(13),''),chr(10),'') as auto_description 
,t1.auto_emp_id as auto_emp_id 
,replace(replace(t1.power_value,chr(13),''),chr(10),'') as power_value 
,replace(replace(t1.bizinfo_template,chr(13),''),chr(10),'') as bizinfo_template 
,t1.owner_organ_id as owner_organ_id 
,t1.risk_level as risk_level 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.orws_tmm_oper_config t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_tmm_oper_config.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes