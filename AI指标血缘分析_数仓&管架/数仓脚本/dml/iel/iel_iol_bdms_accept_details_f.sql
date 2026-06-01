: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_accept_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_accept_details.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.contract_id as contract_id
,replace(replace(t.seq_no,chr(13),''),chr(10),'') as seq_no
,t.draft_id as draft_id
,replace(replace(t.task_type,chr(13),''),chr(10),'') as task_type
,t.credit_fee as credit_fee
,t.charge as charge
,t.expenses as expenses
,replace(replace(t.ucondl_consgntmrk,chr(13),''),chr(10),'') as ucondl_consgntmrk
,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t.invc_nb,chr(13),''),chr(10),'') as invc_nb
,replace(replace(t.btch_nb,chr(13),''),chr(10),'') as btch_nb
,t.payment_ubank_id as payment_ubank_id
,t.credit_line_id as credit_line_id
,t.credit_line as credit_line
,replace(replace(t.credit_line_status,chr(13),''),chr(10),'') as credit_line_status
,replace(replace(t.accept_status,chr(13),''),chr(10),'') as accept_status
,replace(replace(t.endst_date,chr(13),''),chr(10),'') as endst_date
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,replace(replace(t.print_status,chr(13),''),chr(10),'') as print_status
,replace(replace(t.print_date,chr(13),''),chr(10),'') as print_date
,replace(replace(t.sig_mk,chr(13),''),chr(10),'') as sig_mk
,replace(replace(t.cm_status,chr(13),''),chr(10),'') as cm_status
,replace(replace(t.cm_err_procd,chr(13),''),chr(10),'') as cm_err_procd
,t.swt_biz_id as swt_biz_id
,replace(replace(t.entity_regstat,chr(13),''),chr(10),'') as entity_regstat
,t.entity_reg_id as entity_reg_id
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.req_remark,chr(13),''),chr(10),'') as req_remark
,replace(replace(t.rcv_remark,chr(13),''),chr(10),'') as rcv_remark
,replace(replace(t.ecds_prc_msg,chr(13),''),chr(10),'') as ecds_prc_msg
,replace(replace(t.rcv_prxy_sgntr,chr(13),''),chr(10),'') as rcv_prxy_sgntr
,replace(replace(t.account_date,chr(13),''),chr(10),'') as account_date
,replace(replace(t.cancel_date,chr(13),''),chr(10),'') as cancel_date
,t.actlog_id as actlog_id
,replace(replace(t.cdt_ratgs,chr(13),''),chr(10),'') as cdt_ratgs
,replace(replace(t.cdt_ratg_agcy,chr(13),''),chr(10),'') as cdt_ratg_agcy
,replace(replace(t.cdt_ratg_due_dt,chr(13),''),chr(10),'') as cdt_ratg_due_dt
,replace(replace(t.accptnc_agrmtnb,chr(13),''),chr(10),'') as accptnc_agrmtnb
,replace(replace(t.run_code,chr(13),''),chr(10),'') as run_code
,replace(replace(t.accp_detail_remark,chr(13),''),chr(10),'') as accp_detail_remark
,replace(replace(t.record_logno,chr(13),''),chr(10),'') as record_logno
,replace(replace(t.billseq,chr(13),''),chr(10),'') as billseq
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_accept_details t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_accept_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes