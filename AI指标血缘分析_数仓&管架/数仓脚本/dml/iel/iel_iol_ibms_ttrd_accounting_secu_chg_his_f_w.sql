: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_secu_chg_his_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_accounting_secu_chg_his_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(chg_id,chr(10),''),chr(13),'') as chg_id
,replace(replace(erase_ref_chg_id,chr(10),''),chr(13),'') as erase_ref_chg_id
,replace(replace(tsk_id,chr(10),''),chr(13),'') as tsk_id
,chg_date
,chg_type
,acctg_obj_id
,inst_id
,ext_secu_acct_id
,secu_acct_id
,trade_grp_id
,i_code
,a_type
,m_type
,trade_id
,extra_dim
,estd_or_real
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
,amrt_date
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
,update_time
,prft_fee
,due_fee
,fee
,amrt_cost_cp
,amrt_cost_ai
,biz_date
,his_amrt_date
,amrt_ir_hp
,amrt_ytm
,invest_ytm
,process
,open_ytm
,future_ai
,real_cp_noamrt
,chg_fv_noamrt
,prft_fv_noamrt
,prft_trd_noamrt
,amrt_date_old
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
,calc_date
,calc_date_old
,ipr_state
,ipr_prft_cp
,ipr_prft_ai
,ipr_cp
,ipr_hx_cp
,ipr_hx_ai
,ipr_hx_due_ai
,ipr_bw_ai
,ipr_bw_due_ai
,amrt_date_rc_old
,amrt_date_rc
,amrt_cost_ai_rc
,open_date_rc_old
,open_date_rc
,prft_ir_ai_calc_tax
,tax_ai
,tax_due_ai
,tax_fee
,fv_currency_old
,fv_currency
,set_date
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
,replace(replace(amrt_verify_code_old,chr(10),''),chr(13),'') as amrt_verify_code_old
,replace(replace(amrt_verify_code,chr(10),''),chr(13),'') as amrt_verify_code
,replace(replace(amrt_verify_date_old,chr(10),''),chr(13),'') as amrt_verify_date_old
,replace(replace(amrt_verify_date,chr(10),''),chr(13),'') as amrt_verify_date
,replace(replace(prft_reclass,chr(10),''),chr(13),'') as prft_reclass
,replace(replace(close_set_date,chr(10),''),chr(13),'') as close_set_date
,replace(replace(close_set_date_old,chr(10),''),chr(13),'') as close_set_date_old
,replace(replace(trade_inst_id,chr(10),''),chr(13),'') as trade_inst_id
,replace(replace(trade_inst_id_old,chr(10),''),chr(13),'') as trade_inst_id_old
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
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_accounting_secu_chg_his
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_secu_chg_his_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes