: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_collztn_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_collztn_details_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,draft_id
,collztn_type
,isse_curcd
,isse_amt
,status
,apply_date
,btch_nb
,collztn_custid
,collztn_propsr_role
,collztn_propsr_cmonid
,collztn_propsr_name
,collztn_propsr_actno
,collztn_propsr_ubank
,collztn_propsr_agcy_ubank
,collztn_req_remark
,collztn_bk_name
,collztn_bk_actno
,collztn_bk_ubank
,collztn_rcv_remark
,collztn_tlrcd
,collztn_status
,collztn_endst_date
,collztn_cancel_date
,collztn_cancel_opid
,account_flag
,account_date
,actlog_id
,collztn_prxy_sgntr
,collztn_sig_mk
,collztn_cm_status
,collztn_cm_err_procd
,collztn_ecds_prc_msg
,collztn_swt_biz_id
,collztn_appno
,collztn_entity_regstat
,collztn_entity_reg_id
,un_isse_curcd
,un_isse_amt
,un_apply_date
,un_propsr_custid
,un_propsr_role
,un_propsr_cmonid
,un_propsr_name
,un_propsr_actno
,un_propsr_ubank
,un_propsr_agcy_ubank
,uncollztn_req_remark
,uncollztn_rcv_remark
,uncollztn_tlrcd
,uncollztn_status
,uncollztn_endst_date
,uncollztn_cancel_date
,uncollztn_cancel_opid
,unaccount_flag
,unaccount_date
,unactlog_id
,uncollztn_prxy_sgntr
,uncollztn_sig_mk
,uncollztn_cm_status
,uncollztn_cm_err_procd
,uncollztn_ecds_prc_msg
,uncollztn_swt_biz_id
,uncollztn_appno
,uncollztn_entity_regstat
,uncollztn_entity_reg_id
,query_check_id
,check_content
,check_result
,query_type
,query_content
,query_order
,check_status
,sub_status
,upd_note_brh_id
,upd_note_oper_id
,upd_sign_brh_id
,upd_sign_oper_id
,accept_status
,bank_credit_seq_no
,disfr_credit_seq_no
,upd_note_audit_status
,upd_sign_audit_status
,after_check_flag
,collztn_con_id
,un_collztn_con_id
,collztn_sub_con_id
,sub_con_flag
,rcv_flag
,subj
,curcd
,storage_dtl_id
,credit_custid
,dtl_log_id
,un_dtl_log_id
,misc
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_collztn_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_collztn_details_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes