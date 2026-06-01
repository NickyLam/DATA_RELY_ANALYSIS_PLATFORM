: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_base_rule_info_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_fin_base_rule_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_rule_id,chr(13),''),chr(10),'') as base_rule_id
,eff_date
,replace(replace(t1.rate_type,chr(13),''),chr(10),'') as rate_type
,rate
,replace(replace(t1.index_id,chr(13),''),chr(10),'') as index_id
,replace(replace(t1.index_source,chr(13),''),chr(10),'') as index_source
,coefficient
,spread_rate
,replace(replace(t1.reset_type,chr(13),''),chr(10),'') as reset_type
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,branch
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.base_rule_type,chr(13),''),chr(10),'') as base_rule_type
,replace(replace(t1.publish_type,chr(13),''),chr(10),'') as publish_type
,rate_lower
,rate_limit

from ${iol_schema}.fams_fin_base_rule_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_base_rule_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
