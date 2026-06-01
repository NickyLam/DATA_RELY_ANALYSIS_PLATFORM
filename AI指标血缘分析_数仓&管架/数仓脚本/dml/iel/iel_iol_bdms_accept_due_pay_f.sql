: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_accept_due_pay_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_accept_due_pay.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.branch_id as branch_id
,t.draft_id as draft_id
,replace(replace(t.isse_curcd,chr(13),''),chr(10),'') as isse_curcd
,t.isse_amt as isse_amt
,replace(replace(t.mesg_type,chr(13),''),chr(10),'') as mesg_type
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.ovrdue_rsn,chr(13),''),chr(10),'') as ovrdue_rsn
,replace(replace(t.apply_curcd,chr(13),''),chr(10),'') as apply_curcd
,t.apply_amt as apply_amt
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,t.voc_cnt as voc_cnt
,replace(replace(t.drft_hldr_role,chr(13),''),chr(10),'') as drft_hldr_role
,replace(replace(t.drft_hldr_cmonid,chr(13),''),chr(10),'') as drft_hldr_cmonid
,replace(replace(t.drft_hldr_name,chr(13),''),chr(10),'') as drft_hldr_name
,replace(replace(t.drft_hldr_actno,chr(13),''),chr(10),'') as drft_hldr_actno
,replace(replace(t.drft_hldr_ubank,chr(13),''),chr(10),'') as drft_hldr_ubank
,replace(replace(t.drft_hldr_agcy_ubank,chr(13),''),chr(10),'') as drft_hldr_agcy_ubank
,replace(replace(t.accept_date,chr(13),''),chr(10),'') as accept_date
,replace(replace(t.accept_curcd,chr(13),''),chr(10),'') as accept_curcd
,t.accept_amount as accept_amount
,replace(replace(t.return_customer_name,chr(13),''),chr(10),'') as return_customer_name
,replace(replace(t.customer_account,chr(13),''),chr(10),'') as customer_account
,replace(replace(t.receive_date,chr(13),''),chr(10),'') as receive_date
,replace(replace(t.reply_date,chr(13),''),chr(10),'') as reply_date
,t.operator_id as operator_id
,replace(replace(t.repay_sig_mk,chr(13),''),chr(10),'') as repay_sig_mk
,replace(replace(t.dish_code,chr(13),''),chr(10),'') as dish_code
,replace(replace(t.dish_rsn,chr(13),''),chr(10),'') as dish_rsn
,replace(replace(t.appstatus,chr(13),''),chr(10),'') as appstatus
,replace(replace(t.acpay_status,chr(13),''),chr(10),'') as acpay_status
,replace(replace(t.endst_date,chr(13),''),chr(10),'') as endst_date
,replace(replace(t.sig_mk,chr(13),''),chr(10),'') as sig_mk
,replace(replace(t.cm_status,chr(13),''),chr(10),'') as cm_status
,replace(replace(t.cm_err_procd,chr(13),''),chr(10),'') as cm_err_procd
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,t.swt_biz_id as swt_biz_id
,replace(replace(t.entity_regstat,chr(13),''),chr(10),'') as entity_regstat
,t.entity_reg_id as entity_reg_id
,replace(replace(t.appno,chr(13),''),chr(10),'') as appno
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.req_remark,chr(13),''),chr(10),'') as req_remark
,replace(replace(t.rcv_remark,chr(13),''),chr(10),'') as rcv_remark
,replace(replace(t.ecds_prc_msg,chr(13),''),chr(10),'') as ecds_prc_msg
,replace(replace(t.req_prxy_prop_stn,chr(13),''),chr(10),'') as req_prxy_prop_stn
,replace(replace(t.rcv_prxy_sgntr,chr(13),''),chr(10),'') as rcv_prxy_sgntr
,replace(replace(t.account_date,chr(13),''),chr(10),'') as account_date
,replace(replace(t.cancel_date,chr(13),''),chr(10),'') as cancel_date
,t.actlog_id as actlog_id
,replace(replace(t.trf_id,chr(13),''),chr(10),'') as trf_id
,replace(replace(t.trf_ref,chr(13),''),chr(10),'') as trf_ref
,replace(replace(t.storage_flag,chr(13),''),chr(10),'') as storage_flag
,replace(replace(t.storage_dtl_id,chr(13),''),chr(10),'') as storage_dtl_id
,replace(replace(t.position_audit_status,chr(13),''),chr(10),'') as position_audit_status
,replace(replace(t.position_seqno,chr(13),''),chr(10),'') as position_seqno
,replace(replace(t.applock,chr(13),''),chr(10),'') as applock
,replace(replace(t.is_early,chr(13),''),chr(10),'') as is_early
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_accept_due_pay t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_accept_due_pay.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes