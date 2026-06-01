: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_loan_cont_info_f
CreateDate: 20260407
FileName:   ${iel_data_path}/crps_cmm_unite_wl_loan_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.cont_id as cont_id
,t1.crdt_appl_flow_num as crdt_appl_flow_num
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.std_prod_id as std_prod_id
,t1.crdt_type_cd as crdt_type_cd
,t1.appl_type_cd as appl_type_cd
,t1.curr_cd as curr_cd
,t1.base_rat_type_cd as base_rat_type_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.cont_status_cd as cont_status_cd
,t1.apv_status_cd as apv_status_cd
,t1.guar_way_cd as guar_way_cd
,t1.repay_way_cd as repay_way_cd
,t1.loan_usage_type_cd as loan_usage_type_cd
,t1.recvbl_acct_name as recvbl_acct_name
,t1.recvbl_acct_open_org_id as recvbl_acct_open_org_id
,t1.exec_int_rat as exec_int_rat
,t1.cont_bal as cont_bal
,t1.cont_amt as cont_amt
,t1.distr_amt as distr_amt
,t1.tenor as tenor
,t1.begin_dt as begin_dt
,t1.exp_dt as exp_dt
,t1.sign_dt as sign_dt
,t1.distr_dt as distr_dt
,t1.termnt_dt as termnt_dt
,t1.spec_repay_day as spec_repay_day
,t1.operr_id as operr_id
,t1.oper_org_id as oper_org_id
,t1.oper_dt as oper_dt
,t1.rgstrat_id as rgstrat_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_id as update_id
,t1.update_org_id as update_org_id
,t1.update_dt as update_dt
,t1.high_tech_property_flg as high_tech_property_flg
,t1.digit_econ_core_type_cd as digit_econ_core_type_cd
,t1.lmt_cont_id as lmt_cont_id
,t1.dir_indus_cd as dir_indus_cd
,t1.strate_new_indus_type_cd as strate_new_indus_type_cd
,t1.indu_corp_tech_rem_ugd_flg as indu_corp_tech_rem_ugd_flg
,t1.cul_property_flg as cul_property_flg
,t1.lmt_or_encrge_indus_cd as lmt_or_encrge_indus_cd
,t1.sup_chain_fin_bus_prod_cls_cd as sup_chain_fin_bus_prod_cls_cd
,t1.guar_proj_loan_type_cd as guar_proj_loan_type_cd
,t1.buid_bus_guar_loan_type_cd as buid_bus_guar_loan_type_cd
,t1.estate_loan_type_cd as estate_loan_type_cd
,t1.agclt_loan_main_type_cd as agclt_loan_main_type_cd
,t1.agclt_loan_dir_cd as agclt_loan_dir_cd
,t1.loan_fin_supt_way_cd as loan_fin_supt_way_cd
,t1.surp_indus_cd as surp_indus_cd
,t1.adv_man_indu_flg as adv_man_indu_flg
,t1.green_crdt_fin_flg as green_crdt_fin_flg
,t1.cty_lmt_indus_flg as cty_lmt_indus_flg
,t1.high_tech_serv_loan_flg as high_tech_serv_loan_flg
,t1.sci_tech_inovt_corp_flg as sci_tech_inovt_corp_flg
,t1.sci_tech_corp_flg as sci_tech_corp_flg
,t1.high_new_tech_corp_flg as high_new_tech_corp_flg
,t1.spe_soph_unq_new_med_side_enter_flg as spe_soph_unq_new_med_side_enter_flg
,t1.spe_soph_unq_new_lte_gnt_corp_flg as spe_soph_unq_new_lte_gnt_corp_flg
,t1.provi_for_aged_property_flg as provi_for_aged_property_flg
,t1.three_old_tf_or_city_update_proj_flg as three_old_tf_or_city_update_proj_flg
,t1.br_build_ifin_flg as br_build_ifin_flg
,t1.sup_chain_fin_bus_flg as sup_chain_fin_bus_flg
,t1.buid_bus_guar_loan_flg as buid_bus_guar_loan_flg
,t1.county_loan_flg as county_loan_flg
,t1.overs_loan_flg as overs_loan_flg
,t1.ppp_proj_flg as ppp_proj_flg
,t1.new_distr_flg as new_distr_flg
,t1.agclt_flg as agclt_flg
,t1.seed_loan_flg as seed_loan_flg
,t1.proj_fin_flg as proj_fin_flg

from ${idl_schema}.crps_cmm_unite_wl_loan_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_loan_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
