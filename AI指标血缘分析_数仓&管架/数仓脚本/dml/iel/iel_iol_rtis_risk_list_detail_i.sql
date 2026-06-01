: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_risk_list_detail_i
CreateDate: 20240704
FileName:   ${iel_data_path}/rtis_risk_list_detail.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,detail_id
,list_id
,replace(replace(t1.rule_name,chr(13),''),chr(10),'') as rule_name
,replace(replace(t1.rule_package_name,chr(13),''),chr(10),'') as rule_package_name
,score
,replace(replace(t1.risk_type,chr(13),''),chr(10),'') as risk_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rule_id,chr(13),''),chr(10),'') as rule_id
,replace(replace(t1.rule_code,chr(13),''),chr(10),'') as rule_code
,create_at
,update_at
,risk_list_status
,rule_level
,replace(replace(t1.rule_type,chr(13),''),chr(10),'') as rule_type
,replace(replace(t1.rule_seq,chr(13),''),chr(10),'') as rule_seq
,rule_status
,replace(replace(t1.policy_names,chr(13),''),chr(10),'') as policy_names
,replace(replace(t1.org,chr(13),''),chr(10),'') as org

from ${iol_schema}.rtis_risk_list_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_risk_list_detail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
