: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_secu_obj_i
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_accounting_secu_obj.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.tsk_id,chr(13),''),chr(10),'') as tsk_id
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.trade_grp_id,chr(13),''),chr(10),'') as trade_grp_id
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.extra_dim,chr(13),''),chr(10),'') as extra_dim
,t1.real_volume as real_volume
,t1.real_amount as real_amount
,t1.real_cp as real_cp
,t1.ai as ai
,t1.ai_cost as ai_cost
,t1.chg_fv as chg_fv
,t1.due_amount as due_amount
,t1.due_cp as due_cp
,t1.due_ai as due_ai
,t1.amrt_count as amrt_count
,replace(replace(t1.amrt_date,chr(13),''),chr(10),'') as amrt_date
,t1.amrt_ir as amrt_ir
,t1.prft_fv as prft_fv
,t1.prft_trd as prft_trd
,t1.prft_ir as prft_ir
,t1.prft_ir_ai as prft_ir_ai
,t1.prft_ir_amrt as prft_ir_amrt
,t1.prft_ir_ai_hld as prft_ir_ai_hld
,t1.prft_ir_amrt_hld as prft_ir_amrt_hld
,t1.reclass_prft_fv as reclass_prft_fv
,t1.impair as impair
,t1.prft_impair as prft_impair
,t1.real_margin as real_margin
,replace(replace(t1.open_time,chr(13),''),chr(10),'') as open_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,t1.prft_fee as prft_fee
,t1.due_fee as due_fee
,t1.fee as fee
,t1.amrt_cost_cp as amrt_cost_cp
,t1.amrt_cost_ai as amrt_cost_ai
,t1.amrt_ir_hp as amrt_ir_hp
,t1.amrt_ytm as amrt_ytm
,t1.invest_ytm as invest_ytm
,t1.open_ytm as open_ytm
,t1.future_ai as future_ai
,t1.real_cp_noamrt as real_cp_noamrt
,t1.chg_fv_noamrt as chg_fv_noamrt
,t1.prft_fv_noamrt as prft_fv_noamrt
,t1.prft_trd_noamrt as prft_trd_noamrt
,t1.amrt_method as amrt_method
,t1.real_volume_termcur as real_volume_termcur
,t1.real_amount_termcur as real_amount_termcur
,t1.due_amount_termcur as due_amount_termcur
,t1.real_cp_termcur as real_cp_termcur
,t1.due_cp_termcur as due_cp_termcur
,t1.prft_ir_amrt_rc as prft_ir_amrt_rc
,t1.prft_ir_amrt_hld_rc as prft_ir_amrt_hld_rc
,t1.amrt_cost_cp_rc as amrt_cost_cp_rc
,t1.amrt_ytm_rc as amrt_ytm_rc
,t1.amrt_ir_hp_rc as amrt_ir_hp_rc
,replace(replace(t1.calc_date,chr(13),''),chr(10),'') as calc_date
,t1.ipr_state as ipr_state
,t1.ipr_prft_cp as ipr_prft_cp
,t1.ipr_prft_ai as ipr_prft_ai
,t1.ipr_cp as ipr_cp
,t1.ipr_hx_cp as ipr_hx_cp
,t1.ipr_hx_ai as ipr_hx_ai
,t1.ipr_hx_due_ai as ipr_hx_due_ai
,t1.ipr_bw_ai as ipr_bw_ai
,t1.ipr_bw_due_ai as ipr_bw_due_ai
,replace(replace(t1.amrt_date_rc,chr(13),''),chr(10),'') as amrt_date_rc
,t1.amrt_cost_ai_rc as amrt_cost_ai_rc
,replace(replace(t1.open_date_rc,chr(13),''),chr(10),'') as open_date_rc
,t1.prft_ir_ai_calc_tax as prft_ir_ai_calc_tax
,t1.tax_ai as tax_ai
,t1.tax_due_ai as tax_due_ai
,t1.tax_fee as tax_fee
,replace(replace(t1.fv_currency,chr(13),''),chr(10),'') as fv_currency
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,t1.prft_fv_cash as prft_fv_cash
,t1.tax_ai_hld as tax_ai_hld
,t1.open_ai as open_ai
,t1.open_ytm_opt as open_ytm_opt
,t1.prft_ir_ai_fut as prft_ir_ai_fut
,t1.prft_ir_ai_cur as prft_ir_ai_cur
,t1.prft_ir_ai_due as prft_ir_ai_due
,t1.prft_ir_ai_cash as prft_ir_ai_cash
,t1.tax_fut_ai as tax_fut_ai
,t1.tax_due_amrt as tax_due_amrt
,t1.tax_due_amrt_rc as tax_due_amrt_rc
,t1.tax_due_trd as tax_due_trd
,t1.tax_due_fv as tax_due_fv
,t1.tax_due_fv_reclass as tax_due_fv_reclass
,t1.tax_due_fv_cash as tax_due_fv_cash
,t1.tax_due_fee as tax_due_fee
,t1.due_chg_fv as due_chg_fv
,t1.due_volume as due_volume
,replace(replace(t1.amrt_verify_code,chr(13),''),chr(10),'') as amrt_verify_code
,replace(replace(t1.amrt_verify_date,chr(13),''),chr(10),'') as amrt_verify_date
,t1.prft_reclass as prft_reclass
,replace(replace(t1.close_set_date,chr(13),''),chr(10),'') as close_set_date
,t1.trade_inst_id as trade_inst_id
,replace(replace(t1.custom_dim1,chr(13),''),chr(10),'') as custom_dim1
,t1.ipr_period as ipr_period
,t1.ipr_cp1 as ipr_cp1
,t1.ipr_cp2 as ipr_cp2
,t1.ipr_cp3 as ipr_cp3
,t1.ipr_prft_cp1 as ipr_prft_cp1
,t1.ipr_prft_cp2 as ipr_prft_cp2
,t1.ipr_prft_cp3 as ipr_prft_cp3
,t1.amrt_start_ir_hp as amrt_start_ir_hp
,t1.tax_amrt as tax_amrt
,t1.calc_tax_amrt_cur as calc_tax_amrt_cur
,t1.calc_tax_amrt_due as calc_tax_amrt_due
,t1.calc_tax_amrt_cash as calc_tax_amrt_cash
,t1.tax_fv as tax_fv
,t1.tax_ir as tax_ir
,t1.tax_due_ir as tax_due_ir
,replace(replace(t1.prft_id,chr(13),''),chr(10),'') as prft_id
,t1.deviation as deviation
,t1.prft_ir_fut_ai as prft_ir_fut_ai

from ${iol_schema}.ibms_ttrd_accounting_secu_obj t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_secu_obj.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
