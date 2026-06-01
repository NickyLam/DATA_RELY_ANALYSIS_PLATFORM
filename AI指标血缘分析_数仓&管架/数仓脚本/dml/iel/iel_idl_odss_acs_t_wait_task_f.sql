: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_acs_t_wait_task_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_acs_t_wait_task_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,scan_seq_no
,accept_no
,work_item_id
,root_act_id
,parent_act_id
,deal_type
,deal_state
,create_time
,deal_scan_seq_no
,deal_ref_image
,deal_time
,account
,acct_name
,ref_seq_no
,ref1
,ref2
,voucher_code
,image_name
,image_name_back
,deal_ref_image_back
,deal_msg
,wait_reason
,max_image_num
from ${idl_schema}.odss_acs_t_wait_task
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_acs_t_wait_task_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes