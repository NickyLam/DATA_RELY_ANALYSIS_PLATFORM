: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t4a_cust_rslt_out_time_f
CreateDate: 20260330
FileName:   ${iel_data_path}/amls_t4a_cust_rslt_out_time.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rslt_id,chr(13),''),chr(10),'') as rslt_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_id_cl,chr(13),''),chr(10),'') as org_id_cl
,replace(replace(t1.due_dt,chr(13),''),chr(10),'') as due_dt
,replace(replace(t1.create_dt,chr(13),''),chr(10),'') as create_dt
,replace(replace(t1.application_dt,chr(13),''),chr(10),'') as application_dt
,replace(replace(t1.finish_dt,chr(13),''),chr(10),'') as finish_dt
,replace(replace(t1.etl_dt_ora,chr(13),''),chr(10),'') as etl_dt_ora

from ${iol_schema}.amls_t4a_cust_rslt_out_time t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t4a_cust_rslt_out_time.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
