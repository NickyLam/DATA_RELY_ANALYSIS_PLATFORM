: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_alss_rate_ol_cust_curr_i
CreateDate: 20221111
FileName:   ${iel_data_path}/alss_rate_ol_cust_curr.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,curr_id
,replace(replace(t1.rate_id,chr(13),''),chr(10),'') as rate_id
,replace(replace(t1.rate_name,chr(13),''),chr(10),'') as rate_name
,replace(replace(t1.chanl_code,chr(13),''),chr(10),'') as chanl_code
,replace(replace(t1.chanl_name,chr(13),''),chr(10),'') as chanl_name
,replace(replace(t1.model_code,chr(13),''),chr(10),'') as model_code
,replace(replace(t1.model_name,chr(13),''),chr(10),'') as model_name
,replace(replace(t1.event_code,chr(13),''),chr(10),'') as event_code
,replace(replace(t1.event_name,chr(13),''),chr(10),'') as event_name
,replace(replace(t1.method_code,chr(13),''),chr(10),'') as method_code
,replace(replace(t1.method_name,chr(13),''),chr(10),'') as method_name
,replace(replace(t1.score,chr(13),''),chr(10),'') as score
,replace(replace(t1.level_name,chr(13),''),chr(10),'') as level_name
,replace(replace(t1.namelist,chr(13),''),chr(10),'') as namelist
,replace(replace(t1.oper,chr(13),''),chr(10),'') as oper
,rate_time
,next_rate_time
,state
,replace(replace(t1.develop_dept,chr(13),''),chr(10),'') as develop_dept
,create_time
,update_time
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.view_status,chr(13),''),chr(10),'') as view_status
,replace(replace(t1.risk_list,chr(13),''),chr(10),'') as risk_list

from ${iol_schema}.alss_rate_ol_cust_curr t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_rate_ol_cust_curr.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
