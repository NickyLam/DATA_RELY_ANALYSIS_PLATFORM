: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_secu_chg_f
CreateDate: 20250506
FileName:   ${iel_data_path}/ibms_ttrd_accounting_secu_chg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.chg_id,chr(13),''),chr(10),'') as chg_id
,replace(replace(t1.erase_ref_chg_id,chr(13),''),chr(10),'') as erase_ref_chg_id
,replace(replace(t1.tsk_id,chr(13),''),chr(10),'') as tsk_id
,replace(replace(t1.chg_date,chr(13),''),chr(10),'') as chg_date
,replace(replace(t1.chg_type,chr(13),''),chr(10),'') as chg_type
,replace(replace(t1.acctg_obj_id,chr(13),''),chr(10),'') as acctg_obj_id
,inst_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.trade_grp_id,chr(13),''),chr(10),'') as trade_grp_id
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.extra_dim,chr(13),''),chr(10),'') as extra_dim
,replace(replace(t1.estd_or_real,chr(13),''),chr(10),'') as estd_or_real
,real_volume
,real_amount
,real_cp
,ai
,ai_cost
,ai2ri
,ri2pi
,ai_fillup_estd
,ai_fillup_real
,chg_fv
,chg_fv_l
,chg_fv_s
,due_amount
,due_cp
,due_ai
,amrt_count
,replace(replace(t1.amrt_date,chr(13),''),chr(10),'') as amrt_date
,amrt_ir
,prft_fv
,prft_trd
,prft_ir
,prft_ir_ai
,prft_ir_amrt
,prft_ir_ai_hld
,prft_ir_amrt_hld
,reclass_prft_fv
,impair
,prft_impair
,real_margin
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,prft_fee
,due_fee
,fee
,amrt_cost_cp
,amrt_cost_ai
,replace(replace(t1.biz_date,chr(13),''),chr(10),'') as biz_date
,replace(replace(t1.his_amrt_date,chr(13),''),chr(10),'') as his_amrt_date
,amrt_ir_hp
,amrt_ytm
,invest_ytm
,replace(replace(t1.process,chr(13),''),chr(10),'') as process
,open_ytm
,future_ai
,real_cp_noamrt
,chg_fv_noamrt
,prft_fv_noamrt
,prft_trd_noamrt
,replace(replace(t1.amrt_date_old,chr(13),''),chr(10),'') as amrt_date_old
,amrt_method
,real_volume_termcur
,real_amount_termcur
,due_amount_termcur
,real_cp_termcur
,due_cp_termcur
,prft_ir_amrt_rc
,prft_ir_amrt_hld_rc
,amrt_cost_cp_rc
,amrt_ytm_rc
,amrt_ir_hp_rc
,replace(replace(t1.calc_date,chr(13),''),chr(10),'') as calc_date
,replace(replace(t1.calc_date_old,chr(13),''),chr(10),'') as calc_date_old
,ipr_state
,ipr_prft_cp
,ipr_prft_ai
,ipr_cp
,ipr_hx_cp
,ipr_hx_ai
,ipr_hx_due_ai
,ipr_bw_ai
,ipr_bw_due_ai
,replace(replace(t1.amrt_date_rc_old,chr(13),''),chr(10),'') as amrt_date_rc_old
,replace(replace(t1.amrt_date_rc,chr(13),''),chr(10),'') as amrt_date_rc
,amrt_cost_ai_rc
,replace(replace(t1.open_date_rc_old,chr(13),''),chr(10),'') as open_date_rc_old
,replace(replace(t1.open_date_rc,chr(13),''),chr(10),'') as open_date_rc
,prft_ir_ai_calc_tax
,tax_ai
,tax_due_ai
,tax_fee
,replace(replace(t1.fv_currency_old,chr(13),''),chr(10),'') as fv_currency_old
,replace(replace(t1.fv_currency,chr(13),''),chr(10),'') as fv_currency
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,prft_fv_cash
,tax_ai_hld
,open_ai
,open_ytm_opt
,prft_ir_ai_fut
,prft_ir_ai_cur
,prft_ir_ai_due
,prft_ir_ai_cash
,tax_fut_ai
,tax_due_amrt
,tax_due_amrt_rc
,tax_due_trd
,tax_due_fv
,tax_due_fv_reclass
,tax_due_fv_cash
,tax_due_fee
,due_chg_fv
,due_volume
,replace(replace(t1.amrt_verify_code_old,chr(13),''),chr(10),'') as amrt_verify_code_old
,replace(replace(t1.amrt_verify_code,chr(13),''),chr(10),'') as amrt_verify_code
,replace(replace(t1.amrt_verify_date_old,chr(13),''),chr(10),'') as amrt_verify_date_old
,replace(replace(t1.amrt_verify_date,chr(13),''),chr(10),'') as amrt_verify_date
,prft_reclass
,replace(replace(t1.close_set_date,chr(13),''),chr(10),'') as close_set_date
,replace(replace(t1.close_set_date_old,chr(13),''),chr(10),'') as close_set_date_old
,trade_inst_id
,trade_inst_id_old
,replace(replace(t1.custom_dim1,chr(13),''),chr(10),'') as custom_dim1
,ipr_period
,ipr_cp1
,ipr_cp2
,ipr_cp3
,ipr_prft_cp1
,ipr_prft_cp2
,ipr_prft_cp3
,amrt_start_ir_hp
,tax_amrt
,calc_tax_amrt_cur
,calc_tax_amrt_due
,calc_tax_amrt_cash
,tax_fv
,tax_ir
,tax_due_ir
,prft_ir_fut_ai
,replace(replace(t1.prft_id,chr(13),''),chr(10),'') as prft_id
,replace(replace(t1.prft_id_old,chr(13),''),chr(10),'') as prft_id_old
,deviation
,f_chg_fv_sub
,f_chg_fv_add

from ${iol_schema}.ibms_ttrd_accounting_secu_chg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_secu_chg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
