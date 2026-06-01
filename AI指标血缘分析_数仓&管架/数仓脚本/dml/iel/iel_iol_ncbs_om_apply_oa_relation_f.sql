: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_om_apply_oa_relation_f
CreateDate: 20231219
FileName:   ${iel_data_path}/ncbs_om_apply_oa_relation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.oa_approval_no,chr(13),''),chr(10),'') as oa_approval_no
,replace(replace(t1.om_apply_no,chr(13),''),chr(10),'') as om_apply_no
,replace(replace(t1.business_type,chr(13),''),chr(10),'') as business_type
,replace(replace(t1.start_timestamp,chr(13),''),chr(10),'') as start_timestamp
,replace(replace(t1.end_timestamp,chr(13),''),chr(10),'') as end_timestamp
,replace(replace(t1.om_user_id,chr(13),''),chr(10),'') as om_user_id
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.deal_msg,chr(13),''),chr(10),'') as deal_msg
,replace(replace(t1.param_code,chr(13),''),chr(10),'') as param_code
,replace(replace(t1.param_code_name,chr(13),''),chr(10),'') as param_code_name
,replace(replace(t1.effect_date,chr(13),''),chr(10),'') as effect_date
,replace(replace(t1.expire_date,chr(13),''),chr(10),'') as expire_date

from ${iol_schema}.ncbs_om_apply_oa_relation t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_om_apply_oa_relation.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
