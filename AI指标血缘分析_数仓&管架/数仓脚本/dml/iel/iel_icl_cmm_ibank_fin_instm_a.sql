: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_fin_instm_a
CreateDate: 20230118
FileName:   ${iel_data_path}/cmm_ibank_fin_instm.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name
,replace(replace(t1.fin_instm_abbr,chr(13),''),chr(10),'') as fin_instm_abbr
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.prod_cls_tenor_cd,chr(13),''),chr(10),'') as prod_cls_tenor_cd
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.discov_org_cls_name,chr(13),''),chr(10),'') as discov_org_cls_name
,issue_dt
,value_dt
,exp_dt
,replace(replace(t1.tenor_cd,chr(13),''),chr(10),'') as tenor_cd
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,fac_val_int_rat
,replace(replace(t1.fwd_int_rat_curve,chr(13),''),chr(10),'') as fwd_int_rat_curve
,replace(replace(t1.disct_int_rat_curve,chr(13),''),chr(10),'') as disct_int_rat_curve
,risk_wt
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,pay_int_freq
,fir_pay_int_dt
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id
,replace(replace(t1.mger_cust_id,chr(13),''),chr(10),'') as mger_cust_id
,replace(replace(t1.mger_id,chr(13),''),chr(10),'') as mger_id
,replace(replace(t1.mger_name,chr(13),''),chr(10),'') as mger_name
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd
,replace(replace(t1.cashflow_get_way_cd,chr(13),''),chr(10),'') as cashflow_get_way_cd
,replace(replace(t1.spec_aim_vector_type_cd,chr(13),''),chr(10),'') as spec_aim_vector_type_cd
,replace(replace(t1.spec_aim_vector_code,chr(13),''),chr(10),'') as spec_aim_vector_code
,replace(replace(t1.am_prod_stat_code,chr(13),''),chr(10),'') as am_prod_stat_code
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_rg_cd,chr(13),''),chr(10),'') as issuer_rg_cd
,replace(replace(t1.move_way_cd,chr(13),''),chr(10),'') as move_way_cd
,replace(replace(t1.non_uder_asset_cls_cd,chr(13),''),chr(10),'') as non_uder_asset_cls_cd
,replace(replace(t1.non_uder_asset_subclass_cd,chr(13),''),chr(10),'') as non_uder_asset_subclass_cd
,replace(replace(t1.dr_input_freq_cd,chr(13),''),chr(10),'') as dr_input_freq_cd
,dr_effect_dt
,dr_exp_dt
,margin_dr_ratio
,hxb_dep_rcpt_dr_ratio
,tbond_dr_ratio
,chn_pb_bond_dr_ratio
,chn_cb_dr_ratio
,chn_pub_dept_dr_ratio
,other_dr_ratio
,replace(replace(t1.dr_prod_descb_info,chr(13),''),chr(10),'') as dr_prod_descb_info
,replace(replace(t1.dr_acct_id,chr(13),''),chr(10),'') as dr_acct_id
,dr_acct_bal
,fund_open_dt
,replace(replace(t1.actl_finer_cust_id,chr(13),''),chr(10),'') as actl_finer_cust_id
,replace(replace(t1.actl_finer_name,chr(13),''),chr(10),'') as actl_finer_name
,replace(replace(t1.actl_finer_group_name,chr(13),''),chr(10),'') as actl_finer_group_name
,set_open_tenor_start_dt
,set_open_tenor_end_dt
,replace(replace(t1.set_open_flg,chr(13),''),chr(10),'') as set_open_flg
,replace(replace(t1.set_open_ped_cd,chr(13),''),chr(10),'') as set_open_ped_cd
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t1.guar_way_comb,chr(13),''),chr(10),'') as guar_way_comb
,replace(replace(t1.crdt_class_proj_flg,chr(13),''),chr(10),'') as crdt_class_proj_flg
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd
,replace(replace(t1.incre_crdt_way_cd,chr(13),''),chr(10),'') as incre_crdt_way_cd
,replace(replace(t1.incre_crdt_main_name,chr(13),''),chr(10),'') as incre_crdt_main_name
,replace(replace(t1.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,replace(replace(t1.contn_weight_flg,chr(13),''),chr(10),'') as contn_weight_flg
,dr_input_dt
,replace(replace(t1.asset_supt_secu_flg,chr(13),''),chr(10),'') as asset_supt_secu_flg
,replace(replace(t1.noth_rating_abs_flg,chr(13),''),chr(10),'') as noth_rating_abs_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,replace(replace(t1.nv_type_dir_indus_type_cd,chr(13),''),chr(10),'') as nv_type_dir_indus_type_cd
,replace(replace(t1.underly_fin_instm_id,chr(13),''),chr(10),'') as underly_fin_instm_id
,replace(replace(t1.underly_asset_type_id,chr(13),''),chr(10),'') as underly_asset_type_id
,replace(replace(t1.underly_market_type_id,chr(13),''),chr(10),'') as underly_market_type_id

from ${icl_schema}.cmm_ibank_fin_instm t1
where etl_dt = to_date('20230430','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_fin_instm.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
