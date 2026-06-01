: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_acs_t_batch_log_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_acs_t_batch_log_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,scan_seq_no
,accept_no
,cust_id
,cust_name
,acct_no
,acct_name
,initiator
,init_time
,proce_time
,processor
,operator
,oper_time
,batch_status
,batch_image_id
,batch_reason
,biz_code
,taskid
,tache_code
from ${idl_schema}.odss_acs_t_batch_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_acs_t_batch_log_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes