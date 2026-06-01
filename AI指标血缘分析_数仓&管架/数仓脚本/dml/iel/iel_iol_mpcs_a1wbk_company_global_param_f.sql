: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1wbk_company_global_param_f
CreateDate: 20250709
FileName:   ${iel_data_path}/mpcs_a1wbk_company_global_param.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.param_id,chr(13),''),chr(10),'') as param_id
,replace(replace(t1.param_value,chr(13),''),chr(10),'') as param_value
,replace(replace(t1.param_name,chr(13),''),chr(10),'') as param_name
,replace(replace(t1.param_desc,chr(13),''),chr(10),'') as param_desc
,replace(replace(t1.create_timestamp,chr(13),''),chr(10),'') as create_timestamp
,replace(replace(t1.update_timestamp,chr(13),''),chr(10),'') as update_timestamp

from ${iol_schema}.mpcs_a1wbk_company_global_param t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1wbk_company_global_param.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
