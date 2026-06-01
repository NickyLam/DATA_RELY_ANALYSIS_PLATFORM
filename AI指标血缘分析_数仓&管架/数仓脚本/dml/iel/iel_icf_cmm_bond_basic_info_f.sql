: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_bond_basic_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_bond_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.bond_abbr,chr(13),''),chr(10),'') as bond_abbr
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,replace(replace(t1.bond_cls_name,chr(13),''),chr(10),'') as bond_cls_name
,replace(replace(t1.trust_org_id,chr(13),''),chr(10),'') as trust_org_id
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id
,replace(replace(t1.issuer_cd,chr(13),''),chr(10),'') as issuer_cd
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,issue_corp
,issue_price
,issue_int_rat
,issue_size
,fac_val_int_rat
,fac_val
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,int_rat_float_point
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,int_rat_float_uplmi
,int_rat_float_lolmi
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_accr_curr_cd,chr(13),''),chr(10),'') as int_accr_curr_cd
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,replace(replace(t1.comp_int_ped_cd,chr(13),''),chr(10),'') as comp_int_ped_cd
,replace(replace(t1.reval_ped_cd,chr(13),''),chr(10),'') as reval_ped_cd
,fir_reval_dt
,replace(replace(t1.reval_way_cd,chr(13),''),chr(10),'') as reval_way_cd
,last_reval_dt
,next_reval_dt
,reval_start_dt
,reval_end_dt
,reval_int_rat
,exp_yld_rat
,issue_dt
,value_dt
,exp_dt
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,list_dt
,fir_pay_int_dt
,last_pay_int_dt
,next_pay_int_dt
,next_rpp_amt
,next_pay_int_amt
,stop_circlt_dt
,replace(replace(t1.tranbl_bond_flg,chr(13),''),chr(10),'') as tranbl_bond_flg
,replace(replace(t1.discnt_debt_vch_flg,chr(13),''),chr(10),'') as discnt_debt_vch_flg
,replace(replace(t1.acru_int_flg,chr(13),''),chr(10),'') as acru_int_flg
,replace(replace(t1.subtn_bond_flg,chr(13),''),chr(10),'') as subtn_bond_flg
,replace(replace(t1.ex_choice_type_cd,chr(13),''),chr(10),'') as ex_choice_type_cd
,replace(replace(t1.bond_market_type_cd,chr(13),''),chr(10),'') as bond_market_type_cd
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,inpwned_ratio
,replace(replace(t1.caption_type_cd,chr(13),''),chr(10),'') as caption_type_cd
,replace(replace(t1.valuation_way_cd,chr(13),''),chr(10),'') as valuation_way_cd
,replace(replace(t1.data_src_sys_idf,chr(13),''),chr(10),'') as data_src_sys_idf
,replace(replace(t1.issue_main_belong_cty_rg_cd,chr(13),''),chr(10),'') as issue_main_belong_cty_rg_cd
,replace(replace(t1.issue_rg_cd,chr(13),''),chr(10),'') as issue_rg_cd
,replace(replace(t1.actl_mang_land_nation_cd,chr(13),''),chr(10),'') as actl_mang_land_nation_cd
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd
,replace(replace(t1.loc_gov_cls_cd,chr(13),''),chr(10),'') as loc_gov_cls_cd
,prod_currt_tot_bal
,hold_level_currt_bal
,replace(replace(t1.stc_flg,chr(13),''),chr(10),'') as stc_flg
,replace(replace(t1.prior_level_flg,chr(13),''),chr(10),'') as prior_level_flg
,replace(replace(t1.irevbl_guar_flg,chr(13),''),chr(10),'') as irevbl_guar_flg
,replace(replace(t1.estate_bond_type_name,chr(13),''),chr(10),'') as estate_bond_type_name

from ${icl_schema}.cmm_bond_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bond_basic_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
