: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_rb_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.business_unit,chr(13),''),chr(10),'') as business_unit
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,t1.internal_key as internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.profit_center,chr(13),''),chr(10),'') as profit_center
,replace(replace(t1.reason_code,chr(13),''),chr(10),'') as reason_code
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.voucher_status,chr(13),''),chr(10),'') as voucher_status
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,replace(replace(t1.acct_class,chr(13),''),chr(10),'') as acct_class
,replace(replace(t1.acct_desc,chr(13),''),chr(10),'') as acct_desc
,replace(replace(t1.acct_exec,chr(13),''),chr(10),'') as acct_exec
,replace(replace(t1.acct_license_no,chr(13),''),chr(10),'') as acct_license_no
,replace(replace(t1.acct_nature,chr(13),''),chr(10),'') as acct_nature
,replace(replace(t1.acct_real_flag,chr(13),''),chr(10),'') as acct_real_flag
,replace(replace(t1.acct_res_status,chr(13),''),chr(10),'') as acct_res_status
,replace(replace(t1.acct_status_prev,chr(13),''),chr(10),'') as acct_status_prev
,replace(replace(t1.acct_stop_pay,chr(13),''),chr(10),'') as acct_stop_pay
,replace(replace(t1.addtl_principal,chr(13),''),chr(10),'') as addtl_principal
,replace(replace(t1.all_dep_ind,chr(13),''),chr(10),'') as all_dep_ind
,replace(replace(t1.all_dra_ind,chr(13),''),chr(10),'') as all_dra_ind
,replace(replace(t1.appr_flag,chr(13),''),chr(10),'') as appr_flag
,replace(replace(t1.appr_letter_no,chr(13),''),chr(10),'') as appr_letter_no
,replace(replace(t1.auto_renew_rollover,chr(13),''),chr(10),'') as auto_renew_rollover
,replace(replace(t1.auto_settle_flag,chr(13),''),chr(10),'') as auto_settle_flag
,replace(replace(t1.bal_type,chr(13),''),chr(10),'') as bal_type
,replace(replace(t1.checked_flag,chr(13),''),chr(10),'') as checked_flag
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,t1.cur_stage_no as cur_stage_no
,replace(replace(t1.dac_value,chr(13),''),chr(10),'') as dac_value
,replace(replace(t1.gl_type,chr(13),''),chr(10),'') as gl_type
,replace(replace(t1.impound_fad,chr(13),''),chr(10),'') as impound_fad
,replace(replace(t1.individual_flag,chr(13),''),chr(10),'') as individual_flag
,replace(replace(t1.int_ind_flag,chr(13),''),chr(10),'') as int_ind_flag
,replace(replace(t1.last_mvmt_status,chr(13),''),chr(10),'') as last_mvmt_status
,replace(replace(t1.lead_acct_flag,chr(13),''),chr(10),'') as lead_acct_flag
,replace(replace(t1.main_bal_flag,chr(13),''),chr(10),'') as main_bal_flag
,replace(replace(t1.main_int_flag,chr(13),''),chr(10),'') as main_int_flag
,replace(replace(t1.management_free_flag,chr(13),''),chr(10),'') as management_free_flag
,replace(replace(t1.multi_bal_type_flag,chr(13),''),chr(10),'') as multi_bal_type_flag
,replace(replace(t1.no_tran_flag,chr(13),''),chr(10),'') as no_tran_flag
,replace(replace(t1.osa_flag,chr(13),''),chr(10),'') as osa_flag
,replace(replace(t1.ownership_type,chr(13),''),chr(10),'') as ownership_type
,replace(replace(t1.partial_renew_roll,chr(13),''),chr(10),'') as partial_renew_roll
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.region_flag,chr(13),''),chr(10),'') as region_flag
,t1.renew_no as renew_no
,t1.rollover_no as rollover_no
,replace(replace(t1.settle,chr(13),''),chr(10),'') as settle
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,t1.times_renewed as times_renewed
,t1.times_rolledover as times_rolledover
,replace(replace(t1.xrate_id,chr(13),''),chr(10),'') as xrate_id
,replace(replace(t1.accounting_status,chr(13),''),chr(10),'') as accounting_status
,replace(replace(t1.accounting_status_prev,chr(13),''),chr(10),'') as accounting_status_prev
,replace(replace(t1.fixed_call,chr(13),''),chr(10),'') as fixed_call
,t1.accounting_status_upd_date as accounting_status_upd_date
,t1.acct_close_date as acct_close_date
,t1.acct_due_date as acct_due_date
,t1.acct_license_date as acct_license_date
,t1.acct_open_date as acct_open_date
,t1.acct_status_upd_date as acct_status_upd_date
,t1.approval_date as approval_date
,t1.dormant_date as dormant_date
,t1.effect_date as effect_date
,t1.last_change_date as last_change_date
,t1.last_tran_date as last_tran_date
,t1.maturity_date as maturity_date
,t1.open_tran_date as open_tran_date
,t1.ori_maturity_date as ori_maturity_date
,t1.orig_acct_open_date as orig_acct_open_date
,t1.settle_date as settle_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.iss_country,chr(13),''),chr(10),'') as iss_country
,replace(replace(t1.acct_branch,chr(13),''),chr(10),'') as acct_branch
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.acct_close_reason,chr(13),''),chr(10),'') as acct_close_reason
,replace(replace(t1.acct_close_user_id,chr(13),''),chr(10),'') as acct_close_user_id
,replace(replace(t1.alt_acct_name,chr(13),''),chr(10),'') as alt_acct_name
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.home_branch,chr(13),''),chr(10),'') as home_branch
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.main_prod_type,chr(13),''),chr(10),'') as main_prod_type
,replace(replace(t1.mm_ref_no,chr(13),''),chr(10),'') as mm_ref_no
,replace(replace(t1.notice_period,chr(13),''),chr(10),'') as notice_period
,replace(replace(t1.old_prod_type,chr(13),''),chr(10),'') as old_prod_type
,t1.parent_internal_key as parent_internal_key
,replace(replace(t1.settle_user_id,chr(13),''),chr(10),'') as settle_user_id
,replace(replace(t1.voucher_start_no,chr(13),''),chr(10),'') as voucher_start_no
,t1.xrate as xrate
,replace(replace(t1.apply_branch,chr(13),''),chr(10),'') as apply_branch
,replace(replace(t1.acct_name_prefix,chr(13),''),chr(10),'') as acct_name_prefix
,replace(replace(t1.acct_name_suffix,chr(13),''),chr(10),'') as acct_name_suffix
,replace(replace(t1.acct_property2,chr(13),''),chr(10),'') as acct_property2
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.agreement_id,chr(13),''),chr(10),'') as agreement_id
,replace(replace(t1.joint_acct_flag,chr(13),''),chr(10),'') as joint_acct_flag
,replace(replace(t1.recover_flag,chr(13),''),chr(10),'') as recover_flag
,replace(replace(t1.open_user_id,chr(13),''),chr(10),'') as open_user_id
,t1.amend_date as amend_date
from ${iol_schema}.ncbs_rb_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes