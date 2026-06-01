: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_send_collection_dtls_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_send_collection_dtls.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.batch_id as batch_id
,t.branch_id as branch_id
,replace(replace(t.send_date,chr(13),''),chr(10),'') as send_date
,t.draft_id as draft_id
,replace(replace(t.isse_curcd,chr(13),''),chr(10),'') as isse_curcd
,t.isse_amt as isse_amt
,replace(replace(t.drft_hldr_cmonid,chr(13),''),chr(10),'') as drft_hldr_cmonid
,t.apply_amt as apply_amt
,replace(replace(t.mesg_type,chr(13),''),chr(10),'') as mesg_type
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,replace(replace(t.drft_hldr_role,chr(13),''),chr(10),'') as drft_hldr_role
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.ovrdue_rsn,chr(13),''),chr(10),'') as ovrdue_rsn
,replace(replace(t.apply_curcd,chr(13),''),chr(10),'') as apply_curcd
,replace(replace(t.drft_hldr_name,chr(13),''),chr(10),'') as drft_hldr_name
,replace(replace(t.drft_hldr_actno,chr(13),''),chr(10),'') as drft_hldr_actno
,replace(replace(t.drft_hldr_ubank,chr(13),''),chr(10),'') as drft_hldr_ubank
,replace(replace(t.drft_hldr_agcy_ubank,chr(13),''),chr(10),'') as drft_hldr_agcy_ubank
,replace(replace(t.prompt_status,chr(13),''),chr(10),'') as prompt_status
,replace(replace(t.endst_date,chr(13),''),chr(10),'') as endst_date
,replace(replace(t.receive_date,chr(13),''),chr(10),'') as receive_date
,replace(replace(t.sig_mk,chr(13),''),chr(10),'') as sig_mk
,replace(replace(t.dish_code,chr(13),''),chr(10),'') as dish_code
,replace(replace(t.dish_rsn,chr(13),''),chr(10),'') as dish_rsn
,replace(replace(t.cm_status,chr(13),''),chr(10),'') as cm_status
,replace(replace(t.cm_err_procd,chr(13),''),chr(10),'') as cm_err_procd
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,t.swt_biz_id as swt_biz_id
,replace(replace(t.entity_regstat,chr(13),''),chr(10),'') as entity_regstat
,t.entity_reg_id as entity_reg_id
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
,t.cancel_opid as cancel_opid
,t.actlog_id as actlog_id
,replace(replace(t.trf_ref,chr(13),''),chr(10),'') as trf_ref
,replace(replace(t.trf_id,chr(13),''),chr(10),'') as trf_id
,replace(replace(t.src_type,chr(13),''),chr(10),'') as src_type
,replace(replace(t.core_account,chr(13),''),chr(10),'') as core_account
,replace(replace(t.due_flag,chr(13),''),chr(10),'') as due_flag
,t.payment_amout as payment_amout
,t.discount_amount as discount_amount
,replace(replace(t.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t.paymsgsrc,chr(13),''),chr(10),'') as paymsgsrc
,replace(replace(t.trannumber,chr(13),''),chr(10),'') as trannumber
,replace(replace(t.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t.oprno,chr(13),''),chr(10),'') as oprno
,replace(replace(t.pwd,chr(13),''),chr(10),'') as pwd
,replace(replace(t.applock,chr(13),''),chr(10),'') as applock
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_send_collection_dtls t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_send_collection_dtls.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes