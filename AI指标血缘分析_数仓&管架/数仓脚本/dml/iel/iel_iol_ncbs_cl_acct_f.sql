: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_cl_acct_f
CreateDate: 20221114
FileName:   ${iel_data_path}/ncbs_cl_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,od_grace_end_date
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.business_unit,chr(13),''),chr(10),'') as business_unit
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.client_type,chr(13),''),chr(10),'') as client_type
,dd_no
,internal_key
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.profit_center,chr(13),''),chr(10),'') as profit_center
,replace(replace(t1.reason_code,chr(13),''),chr(10),'') as reason_code
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,replace(replace(t1.acct_desc,chr(13),''),chr(10),'') as acct_desc
,replace(replace(t1.acct_exec,chr(13),''),chr(10),'') as acct_exec
,replace(replace(t1.acct_status_prev,chr(13),''),chr(10),'') as acct_status_prev
,replace(replace(t1.alloc_seq_fee,chr(13),''),chr(10),'') as alloc_seq_fee
,replace(replace(t1.alloc_seq_int,chr(13),''),chr(10),'') as alloc_seq_int
,replace(replace(t1.alloc_seq_odi,chr(13),''),chr(10),'') as alloc_seq_odi
,replace(replace(t1.alloc_seq_odp,chr(13),''),chr(10),'') as alloc_seq_odp
,replace(replace(t1.alloc_seq_pri,chr(13),''),chr(10),'') as alloc_seq_pri
,replace(replace(t1.alloc_seq_type,chr(13),''),chr(10),'') as alloc_seq_type
,replace(replace(t1.appr_flag,chr(13),''),chr(10),'') as appr_flag
,replace(replace(t1.auto_settle_flag,chr(13),''),chr(10),'') as auto_settle_flag
,replace(replace(t1.bal_type,chr(13),''),chr(10),'') as bal_type
,calc_times
,replace(replace(t1.cmisloan_no,chr(13),''),chr(10),'') as cmisloan_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,cur_stage_no
,replace(replace(t1.dac_value,chr(13),''),chr(10),'') as dac_value
,replace(replace(t1.five_category,chr(13),''),chr(10),'') as five_category
,replace(replace(t1.fta_acct_flag,chr(13),''),chr(10),'') as fta_acct_flag
,replace(replace(t1.fta_code,chr(13),''),chr(10),'') as fta_code
,replace(replace(t1.int_ind_flag,chr(13),''),chr(10),'') as int_ind_flag
,replace(replace(t1.is_individual,chr(13),''),chr(10),'') as is_individual
,replace(replace(t1.lender,chr(13),''),chr(10),'') as lender
,replace(replace(t1.manual_change_schedule_flag,chr(13),''),chr(10),'') as manual_change_schedule_flag
,replace(replace(t1.marketing_prod_desc,chr(13),''),chr(10),'') as marketing_prod_desc
,replace(replace(t1.mid_period,chr(13),''),chr(10),'') as mid_period
,old_dd_no
,replace(replace(t1.old_loan_no,chr(13),''),chr(10),'') as old_loan_no
,replace(replace(t1.osa_flag,chr(13),''),chr(10),'') as osa_flag
,replace(replace(t1.other_consumption,chr(13),''),chr(10),'') as other_consumption
,replace(replace(t1.pay_off_type,chr(13),''),chr(10),'') as pay_off_type
,replace(replace(t1.pre_repay_deal,chr(13),''),chr(10),'') as pre_repay_deal
,replace(replace(t1.purpose_id,chr(13),''),chr(10),'') as purpose_id
,replace(replace(t1.recover_flag,chr(13),''),chr(10),'') as recover_flag
,replace(replace(t1.regen_schedule_flag,chr(13),''),chr(10),'') as regen_schedule_flag
,replace(replace(t1.region_flag,chr(13),''),chr(10),'') as region_flag
,replace(replace(t1.sched_mode,chr(13),''),chr(10),'') as sched_mode
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.sub_project_no,chr(13),''),chr(10),'') as sub_project_no
,replace(replace(t1.sub_sched_mode,chr(13),''),chr(10),'') as sub_sched_mode
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t1.accounting_status,chr(13),''),chr(10),'') as accounting_status
,replace(replace(t1.accounting_status_prev,chr(13),''),chr(10),'') as accounting_status_prev
,accounting_status_upd_date
,acct_open_date
,acct_status_upd_date
,approval_date
,closed_date
,contraction_date
,effect_date
,first_overdue_date
,last_change_date
,last_tran_date
,maturity_date
,open_tran_date
,ori_maturity_date
,orig_acct_open_date
,ssi_end_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_close_reason,chr(13),''),chr(10),'') as acct_close_reason
,replace(replace(t1.acct_close_user_id,chr(13),''),chr(10),'') as acct_close_user_id
,add_ratio
,replace(replace(t1.alt_acct_name,chr(13),''),chr(10),'') as alt_acct_name
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,contributive_ratio
,replace(replace(t1.fir_period,chr(13),''),chr(10),'') as fir_period
,formula_amt
,replace(replace(t1.home_branch,chr(13),''),chr(10),'') as home_branch
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.loan_no,chr(13),''),chr(10),'') as loan_no
,replace(replace(t1.marketing_prod,chr(13),''),chr(10),'') as marketing_prod
,replace(replace(t1.old_prod_type,chr(13),''),chr(10),'') as old_prod_type
,replace(replace(t1.pay_off_reason,chr(13),''),chr(10),'') as pay_off_reason
,add_amt
,replace(replace(t1.apply_branch,chr(13),''),chr(10),'') as apply_branch
,replace(replace(t1.auto_transfer_flag,chr(13),''),chr(10),'') as auto_transfer_flag
,replace(replace(t1.sched_assemble_flag,chr(13),''),chr(10),'') as sched_assemble_flag
,replace(replace(t1.reaccount_cd,chr(13),''),chr(10),'') as reaccount_cd
,replace(replace(t1.ext_trade_no,chr(13),''),chr(10),'') as ext_trade_no
,hour_int_rate
,replace(replace(t1.client_econ_type,chr(13),''),chr(10),'') as client_econ_type
,replace(replace(t1.gear_by_hour_flag,chr(13),''),chr(10),'') as gear_by_hour_flag
,replace(replace(t1.abs_flag,chr(13),''),chr(10),'') as abs_flag
,replace(replace(t1.auto_reversal_flag,chr(13),''),chr(10),'') as auto_reversal_flag
,replace(replace(t1.anytime_rec_flag,chr(13),''),chr(10),'') as anytime_rec_flag
,replace(replace(t1.gear_prod_flag,chr(13),''),chr(10),'') as gear_prod_flag
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type

from ${iol_schema}.ncbs_cl_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cl_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
