: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_collztn_dtls_log_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_collztn_dtls_log_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,collztn_con_id
,collztn_sub_con_id
,un_collztn_con_id
,collztn_dtl_id
,storage_dtl_id
,draft_id
,dtl_type
,collztn_type
,isse_curcd
,isse_amt
,status
,apply_date
,btch_nb
,custid
,propsr_role
,propsr_cmonid
,propsr_name
,propsr_actno
,propsr_ubank
,propsr_agcy_ubank
,propsr_remark
,bk_custid
,bk_name
,bk_actno
,bk_ubank
,bk_agcy_ubank
,bk_remark
,tlrcd
,collztn_status
,endst_date
,cancel_date
,cancel_opid
,account_flag
,account_date
,actlog_id
,prxy_sgntr
,sig_mk
,cm_status
,cm_err_procd
,ecds_prc_msg
,swt_biz_id
,appno
,entity_regstat
,entity_reg_id
,query_check_id
,check_content
,check_result
,query_type
,query_content
,query_order
,check_status
,bank_credit_seq_no
,disfr_credit_seq_no
,after_check_flag
,credit_custid
,misc
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_collztn_dtls_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_collztn_dtls_log_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes