: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_secu_obj_his_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ibms_ttrd_accounting_secu_obj_his.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(obj_id,chr(13),''),chr(10),'')
,replace(replace(tsk_id,chr(13),''),chr(10),'')
,replace(replace(beg_date,chr(13),''),chr(10),'')
,replace(replace(end_date,chr(13),''),chr(10),'')
,replace(replace(ext_secu_acct_id,chr(13),''),chr(10),'')
,replace(replace(secu_acct_id,chr(13),''),chr(10),'')
,replace(replace(trade_grp_id,chr(13),''),chr(10),'')
,replace(replace(i_code,chr(13),''),chr(10),'')
,replace(replace(a_type,chr(13),''),chr(10),'')
,replace(replace(m_type,chr(13),''),chr(10),'')
,replace(replace(trade_id,chr(13),''),chr(10),'')
,replace(replace(extra_dim,chr(13),''),chr(10),'')
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
,replace(replace(amrt_date,chr(13),''),chr(10),'')
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
,replace(replace(open_time,chr(13),''),chr(10),'')
,replace(replace(update_time,chr(13),''),chr(10),'')
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
,replace(replace(calc_date,chr(13),''),chr(10),'')
,ipr_state
,ipr_prft_cp
,ipr_prft_ai
,ipr_cp
,ipr_hx_cp
,ipr_hx_ai
,ipr_hx_due_ai
,ipr_bw_ai
,ipr_bw_due_ai
,replace(replace(amrt_date_rc,chr(13),''),chr(10),'')
,amrt_cost_ai_rc
,replace(replace(open_date_rc,chr(13),''),chr(10),'')
,prft_ir_ai_calc_tax
,tax_ai
,tax_due_ai
,tax_fee
,replace(replace(fv_currency,chr(13),''),chr(10),'')
,replace(replace(set_date,chr(13),''),chr(10),'')
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
,replace(replace(amrt_verify_code,chr(13),''),chr(10),'')
,replace(replace(amrt_verify_date,chr(13),''),chr(10),'')
,prft_reclass
,replace(replace(close_set_date,chr(13),''),chr(10),'')
,trade_inst_id
,replace(replace(custom_dim1,chr(13),''),chr(10),'')
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
,replace(replace(prft_id,chr(13),''),chr(10),'')
,deviation
,prft_ir_fut_ai

from ${iol_schema}.ibms_ttrd_accounting_secu_obj_his t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_secu_obj_his.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
