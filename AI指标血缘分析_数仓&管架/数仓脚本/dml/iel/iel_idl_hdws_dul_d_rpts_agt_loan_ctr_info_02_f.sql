: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_loan_ctr_info_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_loan_ctr_info_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(loan_contr_id,chr(10),''),chr(13),'') as loan_contr_id
      ,etl_dt
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(ctr_txt_name,chr(10),''),chr(13),'') as ctr_txt_name
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,ctr_amt
      ,ctr_sign_dt
      ,ctr_eff_dt
      ,ctr_expire_dt
      ,contr_due_dt
      ,replace(replace(blng_org_id,chr(10),''),chr(13),'') as blng_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(agt_status_cd,chr(10),''),chr(13),'') as agt_status_cd
      ,replace(replace(loan_dir_indu_cd,chr(10),''),chr(13),'') as loan_dir_indu_cd
      ,replace(replace(loan_usage_cd,chr(10),''),chr(13),'') as loan_usage_cd
      ,replace(replace(loan_usage_desc,chr(10),''),chr(13),'') as loan_usage_desc
      ,replace(replace(occur_typ_cd,chr(10),''),chr(13),'') as occur_typ_cd
      ,replace(replace(loan_prop_cd,chr(10),''),chr(13),'') as loan_prop_cd
      ,replace(replace(loan_typ_cd,chr(10),''),chr(13),'') as loan_typ_cd
      ,replace(replace(loan_biz_type_cd,chr(10),''),chr(13),'') as loan_biz_type_cd
      ,replace(replace(loan_biz_breed_cd,chr(10),''),chr(13),'') as loan_biz_breed_cd
      ,replace(replace(loan_contr_guar_mode_cd,chr(10),''),chr(13),'') as loan_contr_guar_mode_cd
      ,replace(replace(loan_fin_supt_mode_cd,chr(10),''),chr(13),'') as loan_fin_supt_mode_cd
      ,replace(replace(indu_stru_adj_typ,chr(10),''),chr(13),'') as indu_stru_adj_typ
      ,replace(replace(indus_trsit_upgr_ind,chr(10),''),chr(13),'') as indus_trsit_upgr_ind
      ,replace(replace(cty_rstr_indu_flg,chr(10),''),chr(13),'') as cty_rstr_indu_flg
      ,replace(replace(strg_emg_industry_typ_cd,chr(10),''),chr(13),'') as strg_emg_industry_typ_cd
      ,replace(replace(contr_term_unt_cd,chr(10),''),chr(13),'') as contr_term_unt_cd
      ,ctr_term
      ,replace(replace(contr_grace_period_unt_cd,chr(10),''),chr(13),'') as contr_grace_period_unt_cd
      ,contr_grace_period
      ,replace(replace(crdt_contr_id,chr(10),''),chr(13),'') as crdt_contr_id
      ,replace(replace(margin_acct_num,chr(10),''),chr(13),'') as margin_acct_num
      ,replace(replace(margin_ccy_cd,chr(10),''),chr(13),'') as margin_ccy_cd
      ,margin_amt
      ,replace(replace(rate_base_typ_cd,chr(10),''),chr(13),'') as rate_base_typ_cd
      ,rate_base_val
      ,replace(replace(float_rate_flg,chr(10),''),chr(13),'') as float_rate_flg
      ,replace(replace(rate_float_mode_cd,chr(10),''),chr(13),'') as rate_float_mode_cd
      ,rate_float_val
      ,exec_rate
      ,replace(replace(cb_flg,chr(10),''),chr(13),'') as cb_flg
      ,replace(replace(laws_flg,chr(10),''),chr(13),'') as laws_flg
      ,replace(replace(last_stats_norm_flg,chr(10),''),chr(13),'') as last_stats_norm_flg
      ,replace(replace(regr_flg,chr(10),''),chr(13),'') as regr_flg
      ,replace(replace(cms_ast_buy_flg,chr(10),''),chr(13),'') as cms_ast_buy_flg
      ,replace(replace(cms_ast_tfr_flg,chr(10),''),chr(13),'') as cms_ast_tfr_flg
      ,replace(replace(cms_ast_scrtz_flg,chr(10),''),chr(13),'') as cms_ast_scrtz_flg
      ,replace(replace(syndc_loan_flg,chr(10),''),chr(13),'') as syndc_loan_flg
      ,replace(replace(lead_bank_flg,chr(10),''),chr(13),'') as lead_bank_flg
      ,replace(replace(prim_bank_num,chr(10),''),chr(13),'') as prim_bank_num
      ,replace(replace(ptcp_loan_bank_num,chr(10),''),chr(13),'') as ptcp_loan_bank_num
      ,replace(replace(agent_bank_num,chr(10),''),chr(13),'') as agent_bank_num
      ,replace(replace(prim_bank_name,chr(10),''),chr(13),'') as prim_bank_name
      ,replace(replace(ptcp_loan_bank_name,chr(10),''),chr(13),'') as ptcp_loan_bank_name
      ,replace(replace(agent_bank_name,chr(10),''),chr(13),'') as agent_bank_name
      ,replace(replace(agent_ptcp_loan_flg,chr(10),''),chr(13),'') as agent_ptcp_loan_flg
      ,appl_loan_total_amt
      ,cmmt_loan_amt
      ,actl_cmmt_loan_amt
      ,dd_loan_amt
      ,dd_cmmt_loan_amt
      ,cmmt_rema_loan_amt
      ,replace(replace(mgr_bank_org_cd,chr(10),''),chr(13),'') as mgr_bank_org_cd
      ,replace(replace(entr_loan_flg,chr(10),''),chr(13),'') as entr_loan_flg
      ,replace(replace(entr_pty_csld_id,chr(10),''),chr(13),'') as entr_pty_csld_id
      ,replace(replace(entr_pty_name,chr(10),''),chr(13),'') as entr_pty_name
      ,actl_entr_loan_amt
      ,replace(replace(entr_loan_usage_cd,chr(10),''),chr(13),'') as entr_loan_usage_cd
      ,replace(replace(entr_loan_usage_desc,chr(10),''),chr(13),'') as entr_loan_usage_desc
      ,replace(replace(fee_mode,chr(10),''),chr(13),'') as fee_mode
      ,fee_amt
      ,replace(replace(trade_contr_id,chr(10),''),chr(13),'') as trade_contr_id
      ,replace(replace(trade_contr_ccy,chr(10),''),chr(13),'') as trade_contr_ccy
      ,trade_contr_total_amt
      ,replace(replace(intl_biz_id,chr(10),''),chr(13),'') as intl_biz_id
      ,fin_agt_amt
      ,fin_agt_bal
      ,guar_total_val
      ,guar_rate
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(assoc_aprv_id,chr(10),''),chr(13),'') as assoc_aprv_id
      ,replace(replace(entr_loan_funds_src_cd,chr(10),''),chr(13),'') as entr_loan_funds_src_cd 
from idl.hdws_dul_d_rpts_agt_loan_ctr_info_02 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_loan_ctr_info_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes