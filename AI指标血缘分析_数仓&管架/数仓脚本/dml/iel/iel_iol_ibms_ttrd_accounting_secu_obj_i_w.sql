: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_secu_obj_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_accounting_secu_obj_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(obj_id,chr(10),''),chr(13),'') as obj_id
,replace(replace(tsk_id,chr(10),''),chr(13),'') as tsk_id
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(ext_secu_acct_id,chr(10),''),chr(13),'') as ext_secu_acct_id
,replace(replace(secu_acct_id,chr(10),''),chr(13),'') as secu_acct_id
,replace(replace(trade_grp_id,chr(10),''),chr(13),'') as trade_grp_id
,replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(trade_id,chr(10),''),chr(13),'') as trade_id
,replace(replace(extra_dim,chr(10),''),chr(13),'') as extra_dim
,real_volume
,real_amount
,real_cp
,ai
,ai_cost
,chg_fv
,due_amount
,due_cp
,due_ai
,amrt_count
,replace(replace(amrt_date,chr(10),''),chr(13),'') as amrt_date
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
,replace(replace(open_time,chr(10),''),chr(13),'') as open_time
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,prft_fee
,due_fee
,fee
,amrt_cost_cp
,amrt_cost_ai
,amrt_ir_hp
,amrt_ytm
,invest_ytm
,open_ytm
,future_ai
,real_cp_noamrt
,chg_fv_noamrt
,prft_fv_noamrt
,prft_trd_noamrt
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
,replace(replace(calc_date,chr(10),''),chr(13),'') as calc_date
,ipr_state
,ipr_prft_cp
,ipr_prft_ai
,ipr_cp
,ipr_hx_cp
,ipr_hx_ai
,ipr_hx_due_ai
,ipr_bw_ai
,ipr_bw_due_ai
,amrt_date_rc
,replace(replace(amrt_cost_ai_rc,chr(10),''),chr(13),'') as amrt_cost_ai_rc
,replace(replace(open_date_rc,chr(10),''),chr(13),'') as open_date_rc
,replace(replace(prft_ir_ai_calc_tax,chr(10),''),chr(13),'') as prft_ir_ai_calc_tax
,replace(replace(tax_ai,chr(10),''),chr(13),'') as tax_ai
,replace(replace(tax_due_ai,chr(10),''),chr(13),'') as tax_due_ai
,replace(replace(tax_fee,chr(10),''),chr(13),'') as tax_fee
,replace(replace(fv_currency,chr(10),''),chr(13),'') as fv_currency
,replace(replace(set_date,chr(10),''),chr(13),'') as set_date
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
,replace(replace(amrt_verify_code,chr(10),''),chr(13),'') as amrt_verify_code
,replace(replace(amrt_verify_date,chr(10),''),chr(13),'') as amrt_verify_date
,replace(replace(prft_reclass,chr(10),''),chr(13),'') as prft_reclass
,replace(replace(close_set_date,chr(10),''),chr(13),'') as close_set_date
,replace(replace(trade_inst_id,chr(10),''),chr(13),'') as trade_inst_id
,replace(replace(custom_dim1,chr(10),''),chr(13),'') as custom_dim1
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
,etl_dt
,etl_timestamp
from iol.ibms_ttrd_accounting_secu_obj
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_secu_obj_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes