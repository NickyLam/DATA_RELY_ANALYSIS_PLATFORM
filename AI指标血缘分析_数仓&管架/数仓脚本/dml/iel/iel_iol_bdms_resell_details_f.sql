: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_resell_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_resell_details.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.sell_type,chr(13),''),chr(10),'') as sell_type
,t.contract_id as contract_id
,t.draft_id as draft_id
,replace(replace(t.sellbiz_type,chr(13),''),chr(10),'') as sellbiz_type
,replace(replace(t.central_bankflg,chr(13),''),chr(10),'') as central_bankflg
,replace(replace(t.resell_gale_date,chr(13),''),chr(10),'') as resell_gale_date
,replace(replace(t.resell_back_date,chr(13),''),chr(10),'') as resell_back_date
,t.resell_rate_days as resell_rate_days
,replace(replace(t.ban_endrsmt_mk,chr(13),''),chr(10),'') as ban_endrsmt_mk
,t.intrst_rate as intrst_rate
,t.sell_interest as sell_interest
,t.real_money as real_money
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,replace(replace(t.rpd_open_dt,chr(13),''),chr(10),'') as rpd_open_dt
,replace(replace(t.rpd_due_dt,chr(13),''),chr(10),'') as rpd_due_dt
,t.rpd_intrate as rpd_intrate
,t.face_amount as face_amount
,replace(replace(t.btch_no,chr(13),''),chr(10),'') as btch_no
,replace(replace(t.dscnt_props_role,chr(13),''),chr(10),'') as dscnt_props_role
,replace(replace(t.dscnt_props_name,chr(13),''),chr(10),'') as dscnt_props_name
,replace(replace(t.dscnt_props_cmonid,chr(13),''),chr(10),'') as dscnt_props_cmonid
,replace(replace(t.dscnt_props_actno,chr(13),''),chr(10),'') as dscnt_props_actno
,replace(replace(t.dscnt_props_ubank,chr(13),''),chr(10),'') as dscnt_props_ubank
,replace(replace(t.dscnt_props_agcy_ubank,chr(13),''),chr(10),'') as dscnt_props_agcy_ubank
,replace(replace(t.dscnt_role,chr(13),''),chr(10),'') as dscnt_role
,replace(replace(t.dscnt_cmonid,chr(13),''),chr(10),'') as dscnt_cmonid
,replace(replace(t.dscnt_name,chr(13),''),chr(10),'') as dscnt_name
,replace(replace(t.dscnt_actno,chr(13),''),chr(10),'') as dscnt_actno
,replace(replace(t.dscnt_ubank,chr(13),''),chr(10),'') as dscnt_ubank
,replace(replace(t.same_city_flag,chr(13),''),chr(10),'') as same_city_flag
,replace(replace(t.imitate_sell_flag,chr(13),''),chr(10),'') as imitate_sell_flag
,replace(replace(t.inner_flag,chr(13),''),chr(10),'') as inner_flag
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,replace(replace(t.endst_date,chr(13),''),chr(10),'') as endst_date
,replace(replace(t.calc_status,chr(13),''),chr(10),'') as calc_status
,replace(replace(t.sell_status,chr(13),''),chr(10),'') as sell_status
,replace(replace(t.sig_mk,chr(13),''),chr(10),'') as sig_mk
,replace(replace(t.cm_status,chr(13),''),chr(10),'') as cm_status
,replace(replace(t.cm_err_procd,chr(13),''),chr(10),'') as cm_err_procd
,t.swt_biz_id as swt_biz_id
,t.operator_id as operator_id
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t.entity_regstat,chr(13),''),chr(10),'') as entity_regstat
,t.entity_reg_id as entity_reg_id
,replace(replace(t.value1,chr(13),''),chr(10),'') as value1
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.req_remark,chr(13),''),chr(10),'') as req_remark
,replace(replace(t.rcv_remark,chr(13),''),chr(10),'') as rcv_remark
,replace(replace(t.ecds_prc_msg,chr(13),''),chr(10),'') as ecds_prc_msg
,replace(replace(t.rcv_prxy_sgntr,chr(13),''),chr(10),'') as rcv_prxy_sgntr
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.account_date,chr(13),''),chr(10),'') as account_date
,replace(replace(t.cancel_date,chr(13),''),chr(10),'') as cancel_date
,t.cancel_opid as cancel_opid
,t.actlog_id as actlog_id
,replace(replace(t.trf_ref,chr(13),''),chr(10),'') as trf_ref
,replace(replace(t.trf_id,chr(13),''),chr(10),'') as trf_id
,t.postpone_days as postpone_days
,t.intr_offset as intr_offset
from ${iol_schema}.bdms_resell_details t
where t.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_resell_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes