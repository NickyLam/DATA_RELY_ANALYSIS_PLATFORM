: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_ibank_fin_instm_f
CreateDate: 20230703
FileName:   ${iel_data_path}/icrm_cmm_ibank_fin_instm.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.fin_instm_id as fin_instm_id
,t1.asset_type_id as asset_type_id
,t1.market_type_id as market_type_id
,t1.fin_instm_name as fin_instm_name
,t1.fin_instm_abbr as fin_instm_abbr
,t1.prod_type_cd as prod_type_cd
,t1.asset_type_name as asset_type_name
,t1.prod_cls_tenor_cd as prod_cls_tenor_cd
,t1.issue_org_id as issue_org_id
,t1.discov_org_cls_name as discov_org_cls_name
,t1.issue_dt as issue_dt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.tenor_cd as tenor_cd
,t1.base_rat_id as base_rat_id
,t1.int_accr_base_cd as int_accr_base_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.issue_way_cd as issue_way_cd
,t1.cty_cd as cty_cd
,t1.curr_cd as curr_cd
,t1.fac_val_amt as fac_val_amt
,t1.fac_val_int_rat as fac_val_int_rat
,t1.fwd_int_rat_curve as fwd_int_rat_curve
,t1.disct_int_rat_curve as disct_int_rat_curve
,t1.risk_wt as risk_wt
,t1.pay_int_ped_cd as pay_int_ped_cd
,t1.pay_int_freq as pay_int_freq
,t1.fir_pay_int_dt as fir_pay_int_dt
,t1.belong_org_id as belong_org_id
,t1.std_prod_id as std_prod_id
,t1.underly_fin_instm_id as underly_fin_instm_id
,t1.underly_asset_type_id as underly_asset_type_id
,t1.underly_market_type_id as underly_market_type_id
,t1.issuer_cust_id as issuer_cust_id
,t1.mger_cust_id as mger_cust_id
,t1.mger_id as mger_id
,t1.mger_name as mger_name
,t1.mgmt_mode_cd as mgmt_mode_cd
,t1.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,t1.int_rat_adj_ped_corp_cd as int_rat_adj_ped_corp_cd
,t1.contn_weight_flg as contn_weight_flg
,t1.src_pay_int_ped_cd as src_pay_int_ped_cd
,t1.cashflow_get_way_cd as cashflow_get_way_cd
,t1.spec_aim_vector_type_cd as spec_aim_vector_type_cd
,t1.spec_aim_vector_code as spec_aim_vector_code
,t1.am_prod_stat_code as am_prod_stat_code
,t1.issuer_id as issuer_id
,t1.issuer_rg_cd as issuer_rg_cd
,t1.move_way_cd as move_way_cd
,t1.non_uder_asset_cls_cd as non_uder_asset_cls_cd
,t1.non_uder_asset_subclass_cd as non_uder_asset_subclass_cd
,t1.dr_input_freq_cd as dr_input_freq_cd
,t1.dr_input_dt as dr_input_dt
,t1.dr_effect_dt as dr_effect_dt
,t1.dr_exp_dt as dr_exp_dt
,t1.margin_dr_ratio as margin_dr_ratio
,t1.hxb_dep_rcpt_dr_ratio as hxb_dep_rcpt_dr_ratio
,t1.tbond_dr_ratio as tbond_dr_ratio
,t1.chn_pb_bond_dr_ratio as chn_pb_bond_dr_ratio
,t1.chn_cb_dr_ratio as chn_cb_dr_ratio
,t1.chn_pub_dept_dr_ratio as chn_pub_dept_dr_ratio
,t1.other_dr_ratio as other_dr_ratio
,t1.dr_prod_descb_info as dr_prod_descb_info
,t1.dr_acct_id as dr_acct_id
,t1.dr_acct_bal as dr_acct_bal
,t1.fund_open_dt as fund_open_dt
,t1.actl_finer_cust_id as actl_finer_cust_id
,t1.actl_finer_name as actl_finer_name
,t1.actl_finer_group_name as actl_finer_group_name
,t1.set_open_flg as set_open_flg
,t1.set_open_ped_cd as set_open_ped_cd
,t1.open_type_cd as open_type_cd
,t1.incre_crdt_way_cd as incre_crdt_way_cd
,t1.incre_crdt_main_name as incre_crdt_main_name
,t1.set_open_tenor_start_dt as set_open_tenor_start_dt
,t1.set_open_tenor_end_dt as set_open_tenor_end_dt
,t1.usage_descb as usage_descb
,t1.guar_way_comb as guar_way_comb
,t1.crdt_class_proj_flg as crdt_class_proj_flg
,t1.asset_supt_secu_flg as asset_supt_secu_flg
,t1.noth_rating_abs_flg as noth_rating_abs_flg
,t1.abs_flg as abs_flg
,t1.list_dt as list_dt
,t1.nv_type_dir_indus_type_cd as nv_type_dir_indus_type_cd

from ${idl_schema}.icrm_cmm_ibank_fin_instm t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_ibank_fin_instm.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
