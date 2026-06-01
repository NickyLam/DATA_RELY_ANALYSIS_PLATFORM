: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_loan_ctr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_loan_ctr_infof.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.loan_contr_id
,t.etl_dt
,t.blng_pty_id
,t.prd_id
,t.ctr_txt_name
,t.ccy_cd
,t.ctr_amt
,t.ctr_sign_dt
,t.ctr_eff_dt
,t.ctr_expire_dt
,t.contr_due_dt
,t.blng_org_id
,t.mgmt_org_id
,t.pty_mgr_id
,t.agt_status_cd
,t.loan_dir_indu_cd
,t.loan_dir_zone_cd
,t.loan_dir_cty_cd
,t.loan_funds_src_cd
,t.loan_usage_cd
,t.loan_usage_desc
,t.occur_typ_cd
,t.loan_prop_cd
,t.loan_typ_cd
,t.loan_biz_type_cd
,t.loan_biz_breed_cd
,t.loan_contr_guar_mode_cd
,t.loan_fin_supt_mode_cd
,t.indu_stru_adj_typ
,t.indus_trsit_upgr_ind
,t.cty_rstr_indu_flg
,t.strg_emg_industry_typ_cd
,t.contr_term_unt_cd
,t.ctr_term
,t.contr_grace_period_unt_cd
,t.contr_grace_period
,t.crdt_contr_id
,t.margin_acct_num
,t.margin_ccy_cd
,t.margin_amt
,t.rate_base_typ_cd
,t.rate_base_val
,t.float_rate_flg
,t.rate_float_mode_cd
,t.rate_float_val
,t.exec_rate
,t.cb_flg
,t.laws_flg
,t.last_stats_norm_flg
,t.regr_flg
,t.cms_ast_buy_flg
,t.cms_ast_tfr_flg
,t.cms_ast_scrtz_flg
,t.syndc_loan_flg
,t.lead_bank_flg
,t.prim_bank_num
,t.ptcp_loan_bank_num
,t.agent_bank_num
,t.prim_bank_name
,t.ptcp_loan_bank_name
,t.agent_bank_name
,t.agent_ptcp_loan_flg
,t.appl_loan_total_amt
,t.cmmt_loan_amt
,t.actl_cmmt_loan_amt
,t.dd_loan_amt
,t.dd_cmmt_loan_amt
,t.cmmt_rema_loan_amt
,t.mgr_bank_org_cd
,t.entr_loan_flg
,t.entr_pty_csld_id
,t.entr_pty_name
,t.entr_acct
,t.entr_acct_typ_cd
,t.entr_acct_open_bk_num
,t.entr_acct_open_bk_name
,t.csner_acct
,t.csner_acct_typ_cd
,t.entr_amt
,t.entr_loan_funds_src_cd
,t.actl_entr_loan_amt
,t.entr_loan_usage_cd
,t.entr_loan_usage_desc
,t.fee_mode
,t.fee_amt
,t.trade_contr_id
,t.trade_contr_ccy
,t.trade_contr_total_amt
,t.intl_biz_id
,t.fin_agt_amt
,t.fin_agt_bal
,t.guar_total_val
,t.guar_rate
,t.marg_ratio
,t.assoc_aprv_id
,t.pled_est_val
,t.coll_rate
,t.coprate_proj_id
,t.data_src_cd
,t.cntrpty_cust_nbr
,t.cntrpty_pty_name
,t.invt_mode_cd
,t.actl_fin_pty_id
,t.actl_fin_pty_name
,t.txn_ast_name
,t.cnsm_srv_type_fin_flg
,t.dir_indu_fund_flg
,t.first_house_flg
,t.circ_flg
from idl.hdws_iml_agt_loan_ctr_info t
where ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'))" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_loan_ctr_infof.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes