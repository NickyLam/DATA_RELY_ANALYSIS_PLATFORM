: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbss_flw_t_main_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pbss_flw_t_main_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.process_inst_id,chr(13),''),chr(10),'') as process_inst_id
    ,replace(replace(t.arc_id,chr(13),''),chr(10),'') as arc_id
    ,replace(replace(t.scan_seq_no,chr(13),''),chr(10),'') as scan_seq_no
    ,replace(replace(t.tr_code,chr(13),''),chr(10),'') as tr_code
    ,t.tr_date as tr_date
    ,replace(replace(t.biz_code,chr(13),''),chr(10),'') as biz_code
    ,replace(replace(t.back_oper_center_id,chr(13),''),chr(10),'') as back_oper_center_id
    ,replace(replace(t.br_trace_no,chr(13),''),chr(10),'') as br_trace_no
    ,t.biz_priority as biz_priority
    ,t.main_note_pages as main_note_pages
    ,t.attach_pages as attach_pages
    ,replace(replace(t.mag_print_flag,chr(13),''),chr(10),'') as mag_print_flag
    ,t.accpt_time as accpt_time
    ,t.end_time as end_time
    ,replace(replace(t.scan_opr_no,chr(13),''),chr(10),'') as scan_opr_no
    ,replace(replace(t.fr_tlr_opr_no,chr(13),''),chr(10),'') as fr_tlr_opr_no
    ,replace(replace(t.fr_chrg_opr_no,chr(13),''),chr(10),'') as fr_chrg_opr_no
    ,replace(replace(t.auth_flag,chr(13),''),chr(10),'') as auth_flag
    ,replace(replace(t.tx_status,chr(13),''),chr(10),'') as tx_status
    ,replace(replace(t.ret_reason,chr(13),''),chr(10),'') as ret_reason
    ,replace(replace(t.pre_flag,chr(13),''),chr(10),'') as pre_flag
    ,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
    ,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
    ,t.biz_pre_time as biz_pre_time
    ,replace(replace(t.auth_reason,chr(13),''),chr(10),'') as auth_reason
    ,replace(replace(t.tache_code,chr(13),''),chr(10),'') as tache_code
    ,replace(replace(t.processor,chr(13),''),chr(10),'') as processor
    ,replace(replace(t.receive_no,chr(13),''),chr(10),'') as receive_no
    ,replace(replace(t.back_check_flag,chr(13),''),chr(10),'') as back_check_flag
    ,replace(replace(t.back_auth_flag,chr(13),''),chr(10),'') as back_auth_flag
    ,t.back_check_date as back_check_date
    ,replace(replace(t.oldscanno,chr(13),''),chr(10),'') as oldscanno
    ,replace(replace(t.is_sys_op,chr(13),''),chr(10),'') as is_sys_op
    ,replace(replace(t.main_scan_seq_no,chr(13),''),chr(10),'') as main_scan_seq_no
    ,t.first_accpt_time as first_accpt_time
    ,t.delta_priority as delta_priority
    ,replace(replace(t.busi_check_flag,chr(13),''),chr(10),'') as busi_check_flag
    ,t.busi_check_time as busi_check_time
    ,replace(replace(t.busi_check_user,chr(13),''),chr(10),'') as busi_check_user
    ,replace(replace(t.root_scan_seq_no,chr(13),''),chr(10),'') as root_scan_seq_no
    ,t.modify_time as modify_time
    ,t.busi_start_time as busi_start_time
    ,t.busi_end_time as busi_end_time
    ,replace(replace(t.statis_tache_flag,chr(13),''),chr(10),'') as statis_tache_flag
    ,replace(replace(t.sys_id,chr(13),''),chr(10),'') as sys_id
    ,replace(replace(t.netstate,chr(13),''),chr(10),'') as netstate
    ,replace(replace(t.logonpwnew,chr(13),''),chr(10),'') as logonpwnew
    ,replace(replace(t.netreset,chr(13),''),chr(10),'') as netreset
    ,replace(replace(t.first_check_user,chr(13),''),chr(10),'') as first_check_user
    ,replace(replace(t.second_check_user,chr(13),''),chr(10),'') as second_check_user
    ,replace(replace(t.fr_end_status,chr(13),''),chr(10),'') as fr_end_status
    ,replace(replace(t.fr_end_reason,chr(13),''),chr(10),'') as fr_end_reason
    ,replace(replace(t.mtwo_seal_reason,chr(13),''),chr(10),'') as mtwo_seal_reason
from iol.pbss_flw_t_main_flow t 
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbss_flw_t_main_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes