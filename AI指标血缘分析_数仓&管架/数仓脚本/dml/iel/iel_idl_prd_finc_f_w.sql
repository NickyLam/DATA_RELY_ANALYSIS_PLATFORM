: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_finc_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_finc_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.prod_id as prod_id 
,t1.lp_id as lp_id 
,t1.finc_prod_id as finc_prod_id 
,t1.prod_belong_cate_cd as prod_belong_cate_cd 
,t1.ref_yld_rat_comnt as ref_yld_rat_comnt 
,t1.prod_cate_cd as prod_cate_cd 
,t1.ta_cd as ta_cd 
,t1.prod_name as prod_name 
,t1.prod_alias as prod_alias 
,t1.prod_nv as prod_nv 
,t1.prod_fac_val as prod_fac_val 
,t1.issue_price as issue_price 
,t1.prod_sponsor_cd as prod_sponsor_cd 
,t1.prod_trustee_cd as prod_trustee_cd 
,t1.prod_mger_cd as prod_mger_cd 
,t1.prod_host_org_id as prod_host_org_id 
,t1.coll_start_dt as coll_start_dt 
,t1.coll_end_dt as coll_end_dt 
,t1.prod_found_dt as prod_found_dt 
,t1.prod_value_dt as prod_value_dt 
,t1.prod_end_dt as prod_end_dt 
,t1.prft_exp_dt as prft_exp_dt 
,t1.coll_fail_dt as coll_fail_dt 
,t1.coll_post_close_exp_day as coll_post_close_exp_day 
,t1.actl_found_dt as actl_found_dt 
,t1.prod_lowt_coll_amt as prod_lowt_coll_amt 
,t1.prod_higt_coll_amt as prod_higt_coll_amt 
,t1.prod_lowt_coll_lot as prod_lowt_coll_lot 
,t1.prod_higt_coll_lot as prod_higt_coll_lot 
,t1.prod_actl_coll_amt as prod_actl_coll_amt 
,t1.curr_size as curr_size 
,t1.allow_divd_way_cd as allow_divd_way_cd 
,t1.deflt_divd_way_cd as deflt_divd_way_cd 
,t1.sell_rg_ctrl_flg as sell_rg_ctrl_flg 
,t1.lmt_ctrl_flg as lmt_ctrl_flg 
,t1.coll_term_acct_mode_cd as coll_term_acct_mode_cd 
,t1.open_term_acct_mode_cd as open_term_acct_mode_cd 
,t1.chn_cd as chn_cd 
,t1.allow_cust_group_list as allow_cust_group_list 
,t1.ctrl_flg as ctrl_flg 
,t1.bta_ctrl_flg as bta_ctrl_flg 
,t1.charge_way_cd as charge_way_cd 
,t1.prft_embody_way_cd as prft_embody_way_cd 
,t1.prod_attr_cd as prod_attr_cd 
,t1.risk_level_cd as risk_level_cd 
,t1.status_cd as status_cd 
,t1.tran_flg as tran_flg 
,t1.curr_cd as curr_cd 
,t1.ec_flg as ec_flg 
,t1.open_tm as open_tm 
,t1.close_tm as close_tm 
,t1.indv_min_buy_corp as indv_min_buy_corp 
,t1.indv_fir_lowt_invest_amt as indv_fir_lowt_invest_amt 
,t1.indv_supp_lowt_invest_amt as indv_supp_lowt_invest_amt 
,t1.indv_lowt_aip_amt as indv_lowt_aip_amt 
,t1.indv_lowt_hold_lot as indv_lowt_hold_lot 
,t1.indv_sig_least_redem_lot as indv_sig_least_redem_lot 
,t1.indv_sig_max_redem_lot as indv_sig_max_redem_lot 
,t1.indv_redem_corp as indv_redem_corp 
,t1.indv_lowt_fund_tran_lot as indv_lowt_fund_tran_lot 
,t1.indv_sig_max_buy_amt as indv_sig_max_buy_amt 
,t1.indv_single_acct_amax_bamt as indv_single_acct_amax_bamt 
,t1.org_min_buy_corp as org_min_buy_corp 
,t1.org_fir_lowt_invest_amt as org_fir_lowt_invest_amt 
,t1.org_supp_lowt_invest_amt as org_supp_lowt_invest_amt 
,t1.org_lowt_aip_amt as org_lowt_aip_amt 
,t1.org_lowt_hold_lot as org_lowt_hold_lot 
,t1.org_sig_min_redem_lot as org_sig_min_redem_lot 
,t1.org_sig_max_redem_lot as org_sig_max_redem_lot 
,t1.org_redem_corp as org_redem_corp 
,t1.org_lowt_fund_tran_lot as org_lowt_fund_tran_lot 
,t1.org_sig_max_buy_amt as org_sig_max_buy_amt 
,t1.org_single_acct_amax_bamt as org_single_acct_amax_bamt 
,t1.coll_start_tm as coll_start_tm 
,t1.buy_acct_id as buy_acct_id 
,t1.redem_acct_id as redem_acct_id 
,t1.realtm_redem_adv_exp_acct_id as realtm_redem_adv_exp_acct_id 
,t1.redem_cap_avl_days as redem_cap_avl_days 
,t1.divd_cap_avl_days as divd_cap_avl_days 
,t1.prod_exp_cap_avl_days as prod_exp_cap_avl_days 
,t1.huge_redem_ratio as huge_redem_ratio 
,t1.prod_int_accr_base as prod_int_accr_base 
,t1.subscr_int_accr_base as subscr_int_accr_base 
,t1.mgmt_fee_base_days as mgmt_fee_base_days 
,t1.expe_yld_rat as expe_yld_rat 
,t1.ped_days as ped_days 
,t1.tard_way_cd as tard_way_cd 
,t1.prod_tepla_id as prod_tepla_id 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.prd_finc t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes