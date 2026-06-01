: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_pbss_flw_t_main_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_pbss_flw_t_main_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.process_inst_id,chr(13),''),chr(10),'') as process_inst_id
,replace(replace(t1.arc_id,chr(13),''),chr(10),'') as arc_id
,replace(replace(t1.scan_seq_no,chr(13),''),chr(10),'') as scan_seq_no
,replace(replace(t1.tr_code,chr(13),''),chr(10),'') as tr_code
,t1.tr_date as tr_date
,replace(replace(t1.biz_code,chr(13),''),chr(10),'') as biz_code
,replace(replace(t1.back_oper_center_id,chr(13),''),chr(10),'') as back_oper_center_id
,replace(replace(t1.br_trace_no,chr(13),''),chr(10),'') as br_trace_no
,t1.biz_priority as biz_priority
,t1.main_note_pages as main_note_pages
,t1.attach_pages as attach_pages
,replace(replace(t1.mag_print_flag,chr(13),''),chr(10),'') as mag_print_flag
,t1.accpt_time as accpt_time
,t1.end_time as end_time
,replace(replace(t1.scan_opr_no,chr(13),''),chr(10),'') as scan_opr_no
,replace(replace(t1.fr_tlr_opr_no,chr(13),''),chr(10),'') as fr_tlr_opr_no
,replace(replace(t1.fr_chrg_opr_no,chr(13),''),chr(10),'') as fr_chrg_opr_no
,replace(replace(t1.auth_flag,chr(13),''),chr(10),'') as auth_flag
,replace(replace(t1.tx_status,chr(13),''),chr(10),'') as tx_status
,replace(replace(t1.ret_reason,chr(13),''),chr(10),'') as ret_reason
,replace(replace(t1.pre_flag,chr(13),''),chr(10),'') as pre_flag
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,t1.biz_pre_time as biz_pre_time
,replace(replace(t1.auth_reason,chr(13),''),chr(10),'') as auth_reason
,replace(replace(t1.tache_code,chr(13),''),chr(10),'') as tache_code
,replace(replace(t1.processor,chr(13),''),chr(10),'') as processor
,replace(replace(t1.receive_no,chr(13),''),chr(10),'') as receive_no
,replace(replace(t1.back_check_flag,chr(13),''),chr(10),'') as back_check_flag
,replace(replace(t1.back_auth_flag,chr(13),''),chr(10),'') as back_auth_flag
,t1.back_check_date as back_check_date
,replace(replace(t1.oldscanno,chr(13),''),chr(10),'') as oldscanno
,replace(replace(t1.is_sys_op,chr(13),''),chr(10),'') as is_sys_op
,replace(replace(t1.main_scan_seq_no,chr(13),''),chr(10),'') as main_scan_seq_no
,t1.first_accpt_time as first_accpt_time
,t1.delta_priority as delta_priority
,replace(replace(t1.busi_check_flag,chr(13),''),chr(10),'') as busi_check_flag
,t1.busi_check_time as busi_check_time
,replace(replace(t1.busi_check_user,chr(13),''),chr(10),'') as busi_check_user
,replace(replace(t1.root_scan_seq_no,chr(13),''),chr(10),'') as root_scan_seq_no
,t1.modify_time as modify_time
,t1.busi_start_time as busi_start_time
,t1.busi_end_time as busi_end_time
,replace(replace(t1.statis_tache_flag,chr(13),''),chr(10),'') as statis_tache_flag
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
from ${iol_schema}.pbss_flw_t_main_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_pbss_flw_t_main_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes