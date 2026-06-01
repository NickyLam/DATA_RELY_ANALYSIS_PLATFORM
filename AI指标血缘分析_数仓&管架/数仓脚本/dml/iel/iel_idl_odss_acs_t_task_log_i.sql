: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_acs_t_task_log_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_acs_t_task_log_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,workitem_id
,arc_id
,scan_seq_no
,biz_code
,tache_code
,tache_name
,role_code
,user_id
,tr_date
,obtain_time
,submit_time
,submit_route
,task_status
from ${idl_schema}.odss_acs_t_task_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_acs_t_task_log_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes