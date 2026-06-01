: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_base_asset_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_base_asset_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.asset_src,chr(13),''),chr(10),'') as asset_src
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.asst_typ,chr(13),''),chr(10),'') as asst_typ
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.cd_desc,chr(13),''),chr(10),'') as cd_desc
,replace(replace(t1.loan_biz_type_cd1,chr(13),''),chr(10),'') as loan_biz_type_cd1
,t1.int_dt as int_dt
,t1.due_dt as due_dt
,t1.loan_term_mon as loan_term_mon
,t1.loan_term_day as loan_term_day
,t1.total_term as total_term
,t1.surplus_term as surplus_term
,replace(replace(t1.repay_mode_cd,chr(13),''),chr(10),'') as repay_mode_cd
,replace(replace(t1.repay_freq_cd,chr(13),''),chr(10),'') as repay_freq_cd
,t1.pay_dt as pay_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.issue_amt as issue_amt
,t1.loan_bal as loan_bal
,t1.ovdue_princp_amt as ovdue_princp_amt
,t1.princp_ovdue_dt as princp_ovdue_dt
,t1.ovdue_days as ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.rcva_acr_intr as rcva_acr_intr
,t1.on_int as on_int
,t1.off_int as off_int
,t1.rcva_pnlt as rcva_pnlt
,t1.rcva_cmpd_intr as rcva_cmpd_intr
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,t1.exec_rate as exec_rate
,replace(replace(t1.rate_adj_mode,chr(13),''),chr(10),'') as rate_adj_mode
,replace(replace(t1.jz_rate_base_typ_cd,chr(13),''),chr(10),'') as jz_rate_base_typ_cd
,t1.rate_base_val as rate_base_val
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,t1.rate_float_val as rate_float_val
,replace(replace(t1.pnlt_rate_typ,chr(13),''),chr(10),'') as pnlt_rate_typ
,t1.ovdue_exec_rate as ovdue_exec_rate
,replace(replace(t1.loan_item_rate,chr(13),''),chr(10),'') as loan_item_rate
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,t1.business_dt as business_dt
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.org_cn_short_name,chr(13),''),chr(10),'') as org_cn_short_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.iden_typ_cd,chr(13),''),chr(10),'') as iden_typ_cd
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd
,replace(replace(t1.login_dtl_loc_qy,chr(13),''),chr(10),'') as login_dtl_loc_qy
,t1.syn_crdt_total_lmt as syn_crdt_total_lmt
,t1.loan_total_bal as loan_total_bal
,t1.loan_his_max_ovdue_term as loan_his_max_ovdue_term
,t1.crdt_score as crdt_score
,replace(replace(t1.crdt_rat_resu_cd,chr(13),''),chr(10),'') as crdt_rat_resu_cd
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,t1.age as age
,replace(replace(t1.ethnic_cd,chr(13),''),chr(10),'') as ethnic_cd
,t1.birth_dt as birth_dt
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.birth_pla_cd_city,chr(13),''),chr(10),'') as birth_pla_cd_city
,replace(replace(t1.birth_pla_cd_province,chr(13),''),chr(10),'') as birth_pla_cd_province
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t1.highest_degree_cd,chr(13),''),chr(10),'') as highest_degree_cd
,replace(replace(t1.highest_edu_degree_cd,chr(13),''),chr(10),'') as highest_edu_degree_cd
,replace(replace(t1.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
,replace(replace(t1.phys_dtl_loc,chr(13),''),chr(10),'') as phys_dtl_loc
,replace(replace(t1.work_corp_name,chr(13),''),chr(10),'') as work_corp_name
,replace(replace(t1.corp_blng_indu_cd,chr(13),''),chr(10),'') as corp_blng_indu_cd
,t1.indv_year_income as indv_year_income
,replace(replace(t1.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
,replace(replace(t1.org_org_cd,chr(13),''),chr(10),'') as org_org_cd
,replace(replace(t1.owns_typ_cd,chr(13),''),chr(10),'') as owns_typ_cd
,replace(replace(t1.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
,replace(replace(t1.corp_size_gb_cd,chr(13),''),chr(10),'') as corp_size_gb_cd
,replace(replace(t1.ipo_corp_flg,chr(13),''),chr(10),'') as ipo_corp_flg
,replace(replace(t1.reg_cty_cd,chr(13),''),chr(10),'') as reg_cty_cd
,replace(replace(t1.login_dtl_loc_zcd,chr(13),''),chr(10),'') as login_dtl_loc_zcd
,replace(replace(t1.grp_pty_flg,chr(13),''),chr(10),'') as grp_pty_flg
,replace(replace(t1.blng_grp_name,chr(13),''),chr(10),'') as blng_grp_name
,replace(replace(t1.occur_typ_cd,chr(13),''),chr(10),'') as occur_typ_cd
,replace(replace(t1.ctr_txt_name,chr(13),''),chr(10),'') as ctr_txt_name
,t1.ctr_eff_dt as ctr_eff_dt
,t1.ctr_term as ctr_term
,t1.contr_due_dt as contr_due_dt
,t1.coll_rate as coll_rate
,t1.ctr_amt as ctr_amt
,t1.actl_dd_amt as actl_dd_amt
,t1.contr_bal as contr_bal
,t1.contr_norm_bal as contr_norm_bal
,t1.contr_ovdue_bal as contr_ovdue_bal
,replace(replace(t1.loan_dir_indu_cd,chr(13),''),chr(10),'') as loan_dir_indu_cd
,replace(replace(t1.circ_flg,chr(13),''),chr(10),'') as circ_flg
,t1.lngo_cnt as lngo_cnt
,replace(replace(t1.loan_contr_guar_mode_cd,chr(13),''),chr(10),'') as loan_contr_guar_mode_cd
,replace(replace(t1.guar_contr_typ_cd,chr(13),''),chr(10),'') as guar_contr_typ_cd
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,t1.rollover_cnt as rollover_cnt
,t1.marg_ratio as marg_ratio
,t1.margin_amt as margin_amt
,t1.dps_rcp_amt as dps_rcp_amt
,t1.tbond_amt as tbond_amt
,t1.fin_prd_amt as fin_prd_amt
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg
,t1.pkg_bef_rcva_int_val as pkg_bef_rcva_int_val
,t1.pkg_after_rcva_int_total_amt as pkg_after_rcva_int_total_amt
,t1.pkg_after_rcva_int_bal as pkg_after_rcva_int_bal
,t1.has_retn_pkg_after_rcva_int as has_retn_pkg_after_rcva_int
,t1.tfr_loan_int_total_amt as tfr_loan_int_total_amt
,t1.payinterestamt as payinterestamt
from ${idl_schema}.hdws_dml_d_abss_base_asset_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_base_asset_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes