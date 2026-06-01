: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_main_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_main_flow_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,process_inst_id
,arc_id
,scan_seq_no
,tr_code
,tr_date
,biz_code
,back_oper_center_id
,br_trace_no
,biz_priority
,main_note_pages
,attach_pages
,mag_print_flag
,accpt_time
,end_time
,scan_opr_no
,fr_tlr_opr_no
,fr_chrg_opr_no
,auth_flag
,tx_status
,ret_reason
,pre_flag
,reserve1
,reserve2
,biz_pre_time
,auth_reason
,tache_code
,processor
,receive_no
,back_check_flag
,back_auth_flag
,back_check_date
,oldscanno
,is_sys_op
,main_scan_seq_no
,first_accpt_time
,delta_priority
,busi_check_flag
,busi_check_time
,busi_check_user
,modify_time
,root_scan_seq_no
,busi_start_time
,busi_end_time
,statis_tache_flag
,sys_id
from ${idl_schema}.odss_flw_t_main_flow
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_main_flow_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes