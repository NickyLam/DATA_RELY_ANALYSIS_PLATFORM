: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_batch_reg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_batch_reg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,main_flw_id
,scan_seq_no
,arc_id
,image_id
,tr_date
,tr_state
,tr_type
,account
,acct_name
,deal_time
,replace_image_id
,approve_no
,approve_date
,ref_scan_seq_no
,ref_scan_seq_no2
,match_flag
,deal_user
,deal_result
,deal_message
,stop_reason
,side_from
,organiz_credit_code
,cust_name
,is_main_voucher
,created_accept_no
,created_scan_seq_no
from ${idl_schema}.odss_flw_t_batch_reg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_batch_reg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes