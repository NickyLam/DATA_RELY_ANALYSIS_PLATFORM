: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_loan_ctr_info_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_src_dw_agt_loan_ctr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,etl_dt_ora
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.ctr_txt_name,chr(13),''),chr(10),'') as ctr_txt_name
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,ctr_amt
,ctr_sign_dt
,ctr_eff_dt
,ctr_expire_dt
,contr_due_dt
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.loan_dir_indu_cd,chr(13),''),chr(10),'') as loan_dir_indu_cd
,replace(replace(t1.loan_dir_zone_cd,chr(13),''),chr(10),'') as loan_dir_zone_cd
,replace(replace(t1.loan_dir_cty_cd,chr(13),''),chr(10),'') as loan_dir_cty_cd
,replace(replace(t1.loan_funds_src_cd,chr(13),''),chr(10),'') as loan_funds_src_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.loan_usage_desc,chr(13),''),chr(10),'') as loan_usage_desc
,replace(replace(t1.occur_typ_cd,chr(13),''),chr(10),'') as occur_typ_cd
,replace(replace(t1.loan_prop_cd,chr(13),''),chr(10),'') as loan_prop_cd
,replace(replace(t1.loan_typ_cd,chr(13),''),chr(10),'') as loan_typ_cd
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.loan_biz_breed_cd,chr(13),''),chr(10),'') as loan_biz_breed_cd
,replace(replace(t1.loan_contr_guar_mode_cd,chr(13),''),chr(10),'') as loan_contr_guar_mode_cd
,replace(replace(t1.loan_fin_supt_mode_cd,chr(13),''),chr(10),'') as loan_fin_supt_mode_cd
,replace(replace(t1.indu_stru_adj_typ,chr(13),''),chr(10),'') as indu_stru_adj_typ
,replace(replace(t1.indus_trsit_upgr_ind,chr(13),''),chr(10),'') as indus_trsit_upgr_ind
,replace(replace(t1.cty_rstr_indu_flg,chr(13),''),chr(10),'') as cty_rstr_indu_flg
,replace(replace(t1.strg_emg_industry_typ_cd,chr(13),''),chr(10),'') as strg_emg_industry_typ_cd
,replace(replace(t1.contr_term_unt_cd,chr(13),''),chr(10),'') as contr_term_unt_cd
,ctr_term
,replace(replace(t1.contr_grace_period_unt_cd,chr(13),''),chr(10),'') as contr_grace_period_unt_cd
,contr_grace_period
,replace(replace(t1.crdt_contr_id,chr(13),''),chr(10),'') as crdt_contr_id
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
,margin_amt
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,rate_base_val
,replace(replace(t1.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,rate_float_val
,exec_rate
,replace(replace(t1.cb_flg,chr(13),''),chr(10),'') as cb_flg
,replace(replace(t1.laws_flg,chr(13),''),chr(10),'') as laws_flg
,replace(replace(t1.last_stats_norm_flg,chr(13),''),chr(10),'') as last_stats_norm_flg
,replace(replace(t1.regr_flg,chr(13),''),chr(10),'') as regr_flg
,replace(replace(t1.cms_ast_buy_flg,chr(13),''),chr(10),'') as cms_ast_buy_flg
,replace(replace(t1.cms_ast_tfr_flg,chr(13),''),chr(10),'') as cms_ast_tfr_flg
,replace(replace(t1.cms_ast_scrtz_flg,chr(13),''),chr(10),'') as cms_ast_scrtz_flg
,replace(replace(t1.syndc_loan_flg,chr(13),''),chr(10),'') as syndc_loan_flg
,replace(replace(t1.lead_bank_flg,chr(13),''),chr(10),'') as lead_bank_flg
,replace(replace(t1.prim_bank_num,chr(13),''),chr(10),'') as prim_bank_num
,replace(replace(t1.ptcp_loan_bank_num,chr(13),''),chr(10),'') as ptcp_loan_bank_num
,replace(replace(t1.agent_bank_num,chr(13),''),chr(10),'') as agent_bank_num
,replace(replace(t1.prim_bank_name,chr(13),''),chr(10),'') as prim_bank_name
,replace(replace(t1.ptcp_loan_bank_name,chr(13),''),chr(10),'') as ptcp_loan_bank_name
,replace(replace(t1.agent_bank_name,chr(13),''),chr(10),'') as agent_bank_name
,replace(replace(t1.agent_ptcp_loan_flg,chr(13),''),chr(10),'') as agent_ptcp_loan_flg
,appl_loan_total_amt
,cmmt_loan_amt
,actl_cmmt_loan_amt
,dd_loan_amt
,dd_cmmt_loan_amt
,cmmt_rema_loan_amt
,replace(replace(t1.mgr_bank_org_cd,chr(13),''),chr(10),'') as mgr_bank_org_cd
,replace(replace(t1.entr_loan_flg,chr(13),''),chr(10),'') as entr_loan_flg
,replace(replace(t1.entr_pty_csld_id,chr(13),''),chr(10),'') as entr_pty_csld_id
,replace(replace(t1.entr_pty_name,chr(13),''),chr(10),'') as entr_pty_name
,replace(replace(t1.entr_acct,chr(13),''),chr(10),'') as entr_acct
,replace(replace(t1.entr_acct_typ_cd,chr(13),''),chr(10),'') as entr_acct_typ_cd
,replace(replace(t1.entr_acct_open_bk_num,chr(13),''),chr(10),'') as entr_acct_open_bk_num
,replace(replace(t1.entr_acct_open_bk_name,chr(13),''),chr(10),'') as entr_acct_open_bk_name
,replace(replace(t1.csner_acct,chr(13),''),chr(10),'') as csner_acct
,replace(replace(t1.csner_acct_typ_cd,chr(13),''),chr(10),'') as csner_acct_typ_cd
,entr_amt
,replace(replace(t1.entr_loan_funds_src_cd,chr(13),''),chr(10),'') as entr_loan_funds_src_cd
,actl_entr_loan_amt
,replace(replace(t1.entr_loan_usage_cd,chr(13),''),chr(10),'') as entr_loan_usage_cd
,replace(replace(t1.entr_loan_usage_desc,chr(13),''),chr(10),'') as entr_loan_usage_desc
,replace(replace(t1.fee_mode,chr(13),''),chr(10),'') as fee_mode
,fee_amt
,replace(replace(t1.trade_contr_id,chr(13),''),chr(10),'') as trade_contr_id
,replace(replace(t1.trade_contr_ccy,chr(13),''),chr(10),'') as trade_contr_ccy
,trade_contr_total_amt
,replace(replace(t1.intl_biz_id,chr(13),''),chr(10),'') as intl_biz_id
,fin_agt_amt
,fin_agt_bal
,guar_total_val
,guar_rate
,marg_ratio
,replace(replace(t1.assoc_aprv_id,chr(13),''),chr(10),'') as assoc_aprv_id
,pled_est_val
,coll_rate
,replace(replace(t1.coprate_proj_id,chr(13),''),chr(10),'') as coprate_proj_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no

from ${iol_schema}.rsts_src_dw_agt_loan_ctr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_loan_ctr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
