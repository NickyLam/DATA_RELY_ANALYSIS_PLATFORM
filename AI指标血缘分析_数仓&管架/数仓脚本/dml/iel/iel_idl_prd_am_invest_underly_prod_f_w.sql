: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_am_invest_underly_prod_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_am_invest_underly_prod_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.prod_id as prod_id 
,t1.lp_id as lp_id 
,t1.src_prod_id as src_prod_id 
,t1.prod_cate_cd as prod_cate_cd 
,t1.prod_abbr as prod_abbr 
,t1.prod_fname as prod_fname 
,t1.prft_mode_cd as prft_mode_cd 
,t1.coupon_breed_cd as coupon_breed_cd 
,t1.fin_prod_id as fin_prod_id 
,t1.issue_price as issue_price 
,t1.issue_size as issue_size 
,t1.issue_curr_cd as issue_curr_cd 
,t1.overs_flg as overs_flg 
,t1.tran_site_cd as tran_site_cd 
,t1.tran_caln_cd as tran_caln_cd 
,t1.issue_way_cd as issue_way_cd 
,t1.csner_id as csner_id 
,t1.trustee_id as trustee_id 
,t1.issuer_id as issuer_id 
,t1.mger_id as mger_id 
,t1.finer_id as finer_id 
,t1.issue_dt as issue_dt 
,t1.value_dt as value_dt 
,t1.exp_dt as exp_dt 
,t1.prod_tenor as prod_tenor 
,t1.actl_exp_dt as actl_exp_dt 
,t1.subtn_flg as subtn_flg 
,t1.subtn_claus as subtn_claus 
,t1.contn_weight_flg as contn_weight_flg 
,t1.brkevn_flg as brkevn_flg 
,t1.rgst_trust_org_cd as rgst_trust_org_cd 
,t1.fin_inst_issue_flg as fin_inst_issue_flg 
,t1.guartor_id as guartor_id 
,t1.purch_cfm_tenor as purch_cfm_tenor 
,t1.redem_cfm_tenor as redem_cfm_tenor 
,t1.sub_debt_flg as sub_debt_flg 
,t1.invest_char_type_cd as invest_char_type_cd 
,t1.fac_val as fac_val 
,t1.city_bond_flg as city_bond_flg 
,t1.city_bond_lev_cd as city_bond_lev_cd 
,t1.init_create_tm as init_create_tm 
,t1.init_update_tm as init_update_tm 
,t1.asset_src_cd as asset_src_cd 
,t1.distr_brch_id as distr_brch_id 
,t1.clear_ped_cd as clear_ped_cd 
,t1.proj_dir_indus_categy_cd as proj_dir_indus_categy_cd 
,t1.proj_dir_indus_gen_cd as proj_dir_indus_gen_cd 
,t1.actl_crdt_main_id as actl_crdt_main_id 
,t1.ped_days as ped_days 
,t1.am_plan_type_cd as am_plan_type_cd 
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.job_cd
from ${idl_schema}.prd_am_invest_underly_prod t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_invest_underly_prod_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes