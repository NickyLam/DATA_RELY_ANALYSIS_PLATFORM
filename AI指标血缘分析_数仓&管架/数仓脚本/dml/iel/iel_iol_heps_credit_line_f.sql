: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_credit_line_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_credit_line.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.customer_id as customer_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.credit_line,chr(13),''),chr(10),'') as credit_line
,replace(replace(t.credit_time,chr(13),''),chr(10),'') as credit_time
,replace(replace(t.model_result,chr(13),''),chr(10),'') as model_result
,replace(replace(t.operate,chr(13),''),chr(10),'') as operate
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.create_time as create_time
,t.update_time as update_time
,replace(replace(t.ecif_opnion,chr(13),''),chr(10),'') as ecif_opnion
,t.apply_line as apply_line
,t.opnion_line as opnion_line
from iol.heps_credit_line t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_credit_line.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes