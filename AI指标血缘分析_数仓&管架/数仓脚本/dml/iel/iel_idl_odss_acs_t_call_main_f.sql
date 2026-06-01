: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_acs_t_call_main_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_acs_t_call_main_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,create_time
,accept_no
,scan_seq_no
,biz_code
,cust_name
,cust_id
,biz_account
,acct_name
,br_code
,tlr_no
,tr_date
,call_manager_center
,call_result
,call_num
,call_tout_flag
,call_iout_user_id
,call_tout_charge_id
,call_tout_time
,call_flag_1
,call_flag_2
,call_flag_3
,call_flag_4
,lock_state
,lock_user_id
,lock_time
,task_create_msg
,call_flag_5
,normal
from ${idl_schema}.odss_acs_t_call_main
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_acs_t_call_main_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes