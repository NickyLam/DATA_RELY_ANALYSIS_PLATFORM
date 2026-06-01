: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ccdb_ob_list_collection_f
CreateDate: 20220819
FileName:   ${iel_data_path}/ccdb_ob_list_collection.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.task_code,chr(13),''),chr(10),'') as task_code
    ,replace(replace(t.code,chr(13),''),chr(10),'') as code
    ,replace(replace(t.work_tel,chr(13),''),chr(10),'') as work_tel
    ,replace(replace(t.home_tel,chr(13),''),chr(10),'') as home_tel
    ,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,t.days as days
    ,t.money as money
    ,replace(replace(t.call_result,chr(13),''),chr(10),'') as call_result
    ,replace(replace(t.call_status,chr(13),''),chr(10),'') as call_status
    ,t.create_date as create_date
    ,replace(replace(t.creator_code,chr(13),''),chr(10),'') as creator_code
    ,replace(replace(t.creator_name,chr(13),''),chr(10),'') as creator_name
    ,t.last_call_time as last_call_time
    ,t.data_stat as data_stat
    ,replace(replace(t.call_id,chr(13),''),chr(10),'') as call_id
    ,replace(replace(t.succ_tel,chr(13),''),chr(10),'') as succ_tel
    ,replace(replace(t.fail_code,chr(13),''),chr(10),'') as fail_code
    ,t.max_call_count as max_call_count
    ,t.call_count as call_count
    ,replace(replace(t.call_data,chr(13),''),chr(10),'') as call_data
    ,replace(replace(t.batch_date,chr(13),''),chr(10),'') as batch_date
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ccdb_ob_list_collection t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccdb_ob_list_collection.f.${batch_date}.dat" \
        charset=utf8
        safe=yes