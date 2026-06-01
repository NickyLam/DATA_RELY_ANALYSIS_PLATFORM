: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_loan_ctr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_loan_ctr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
    ,replace(replace(t.prd_id,chr(13),''),chr(10),'') as prd_id
    ,replace(replace(t.ctr_txt_name,chr(13),''),chr(10),'') as ctr_txt_name
    ,replace(replace(t.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
    ,t.ctr_amt as ctr_amt
    ,t.ctr_sign_dt as ctr_sign_dt
    ,t.ctr_eff_dt as ctr_eff_dt
    ,t.ctr_expire_dt as ctr_expire_dt
    ,t.contr_due_dt as contr_due_dt
    ,replace(replace(t.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
    ,replace(replace(t.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
    ,replace(replace(t.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
    ,replace(replace(t.loan_dir_indu_cd,chr(13),''),chr(10),'') as loan_dir_indu_cd
    ,replace(replace(t.loan_dir_zone_cd,chr(13),''),chr(10),'') as loan_dir_zone_cd
    ,replace(replace(t.loan_dir_cty_cd,chr(13),''),chr(10),'') as loan_dir_cty_cd
    ,replace(replace(t.loan_funds_src_cd,chr(13),''),chr(10),'') as loan_funds_src_cd
    ,replace(replace(t.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
    ,replace(replace(t.loan_usage_desc,chr(13),''),chr(10),'') as loan_usage_desc
    ,replace(replace(t.occur_typ_cd,chr(13),''),chr(10),'') as occur_typ_cd
    ,replace(replace(t.loan_prop_cd,chr(13),''),chr(10),'') as loan_prop_cd
    ,replace(replace(t.loan_typ_cd,chr(13),''),chr(10),'') as loan_typ_cd
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,replace(replace(t.loan_biz_breed_cd,chr(13),''),chr(10),'') as loan_biz_breed_cd
    ,replace(replace(t.loan_contr_guar_mode_cd,chr(13),''),chr(10),'') as loan_contr_guar_mode_cd
    ,replace(replace(t.loan_fin_supt_mode_cd,chr(13),''),chr(10),'') as loan_fin_supt_mode_cd
    ,replace(replace(t.indu_stru_adj_typ,chr(13),''),chr(10),'') as indu_stru_adj_typ
    ,replace(replace(t.indus_trsit_upgr_ind,chr(13),''),chr(10),'') as indus_trsit_upgr_ind
    ,replace(replace(t.cty_rstr_indu_flg,chr(13),''),chr(10),'') as cty_rstr_indu_flg
    ,replace(replace(t.strg_emg_industry_typ_cd,chr(13),''),chr(10),'') as strg_emg_industry_typ_cd
    ,replace(replace(t.contr_term_unt_cd,chr(13),''),chr(10),'') as contr_term_unt_cd
    ,t.ctr_term as ctr_term
    ,replace(replace(t.contr_grace_period_unt_cd,chr(13),''),chr(10),'') as contr_grace_period_unt_cd
    ,t.contr_grace_period as contr_grace_period
    ,replace(replace(t.crdt_contr_id,chr(13),''),chr(10),'') as crdt_contr_id
    ,replace(replace(t.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
    ,replace(replace(t.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
    ,t.margin_amt as margin_amt
    ,replace(replace(t.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
    ,t.rate_base_val as rate_base_val
    ,replace(replace(t.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
    ,replace(replace(t.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
    ,t.rate_float_val as rate_float_val
    ,t.exec_rate as exec_rate
    ,replace(replace(t.cb_flg,chr(13),''),chr(10),'') as cb_flg
    ,replace(replace(t.laws_flg,chr(13),''),chr(10),'') as laws_flg
    ,replace(replace(t.last_stats_norm_flg,chr(13),''),chr(10),'') as last_stats_norm_flg
    ,replace(replace(t.regr_flg,chr(13),''),chr(10),'') as regr_flg
    ,replace(replace(t.cms_ast_buy_flg,chr(13),''),chr(10),'') as cms_ast_buy_flg
    ,replace(replace(t.cms_ast_tfr_flg,chr(13),''),chr(10),'') as cms_ast_tfr_flg
    ,replace(replace(t.cms_ast_scrtz_flg,chr(13),''),chr(10),'') as cms_ast_scrtz_flg
    ,replace(replace(t.syndc_loan_flg,chr(13),''),chr(10),'') as syndc_loan_flg
    ,replace(replace(t.lead_bank_flg,chr(13),''),chr(10),'') as lead_bank_flg
    ,replace(replace(t.prim_bank_num,chr(13),''),chr(10),'') as prim_bank_num
    ,replace(replace(t.ptcp_loan_bank_num,chr(13),''),chr(10),'') as ptcp_loan_bank_num
    ,replace(replace(t.agent_bank_num,chr(13),''),chr(10),'') as agent_bank_num
    ,replace(replace(t.prim_bank_name,chr(13),''),chr(10),'') as prim_bank_name
    ,replace(replace(t.ptcp_loan_bank_name,chr(13),''),chr(10),'') as ptcp_loan_bank_name
    ,replace(replace(t.agent_bank_name,chr(13),''),chr(10),'') as agent_bank_name
    ,replace(replace(t.agent_ptcp_loan_flg,chr(13),''),chr(10),'') as agent_ptcp_loan_flg
    ,t.appl_loan_total_amt as appl_loan_total_amt
    ,t.cmmt_loan_amt as cmmt_loan_amt
    ,t.actl_cmmt_loan_amt as actl_cmmt_loan_amt
    ,t.dd_loan_amt as dd_loan_amt
    ,t.dd_cmmt_loan_amt as dd_cmmt_loan_amt
    ,t.cmmt_rema_loan_amt as cmmt_rema_loan_amt
    ,replace(replace(t.mgr_bank_org_cd,chr(13),''),chr(10),'') as mgr_bank_org_cd
    ,replace(replace(t.entr_loan_flg,chr(13),''),chr(10),'') as entr_loan_flg
    ,replace(replace(t.entr_pty_csld_id,chr(13),''),chr(10),'') as entr_pty_csld_id
    ,replace(replace(t.entr_pty_name,chr(13),''),chr(10),'') as entr_pty_name
    ,replace(replace(t.entr_acct,chr(13),''),chr(10),'') as entr_acct
    ,replace(replace(t.entr_acct_typ_cd,chr(13),''),chr(10),'') as entr_acct_typ_cd
    ,replace(replace(t.entr_acct_open_bk_num,chr(13),''),chr(10),'') as entr_acct_open_bk_num
    ,replace(replace(t.entr_acct_open_bk_name,chr(13),''),chr(10),'') as entr_acct_open_bk_name
    ,replace(replace(t.csner_acct,chr(13),''),chr(10),'') as csner_acct
    ,replace(replace(t.csner_acct_typ_cd,chr(13),''),chr(10),'') as csner_acct_typ_cd
    ,t.entr_amt as entr_amt
    ,replace(replace(t.entr_loan_funds_src_cd,chr(13),''),chr(10),'') as entr_loan_funds_src_cd
    ,t.actl_entr_loan_amt as actl_entr_loan_amt
    ,replace(replace(t.entr_loan_usage_cd,chr(13),''),chr(10),'') as entr_loan_usage_cd
    ,replace(replace(t.entr_loan_usage_desc,chr(13),''),chr(10),'') as entr_loan_usage_desc
    ,replace(replace(t.fee_mode,chr(13),''),chr(10),'') as fee_mode
    ,t.fee_amt as fee_amt
    ,replace(replace(t.trade_contr_id,chr(13),''),chr(10),'') as trade_contr_id
    ,replace(replace(t.trade_contr_ccy,chr(13),''),chr(10),'') as trade_contr_ccy
    ,t.trade_contr_total_amt as trade_contr_total_amt
    ,replace(replace(t.intl_biz_id,chr(13),''),chr(10),'') as intl_biz_id
    ,t.fin_agt_amt as fin_agt_amt
    ,t.fin_agt_bal as fin_agt_bal
    ,t.guar_total_val as guar_total_val
    ,t.guar_rate as guar_rate
    ,t.marg_ratio as marg_ratio
    ,replace(replace(t.assoc_aprv_id,chr(13),''),chr(10),'') as assoc_aprv_id
    ,t.pled_est_val as pled_est_val
    ,t.coll_rate as coll_rate
    ,replace(replace(t.coprate_proj_id,chr(13),''),chr(10),'') as coprate_proj_id
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_agt_loan_ctr_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_loan_ctr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes