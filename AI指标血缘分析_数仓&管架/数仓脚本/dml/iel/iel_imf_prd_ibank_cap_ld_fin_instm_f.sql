: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_prd_ibank_cap_ld_fin_instm_f
CreateDate: 20230106
FileName:   ${iel_data_path}/prd_ibank_cap_ld_fin_instm.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.asset_name,chr(13),''),chr(10),'') as asset_name
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,corp_fac_val
,fac_val_int_rat
,value_dt
,exp_dt
,replace(replace(t1.src_tenor_cd,chr(13),''),chr(10),'') as src_tenor_cd
,tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.base_fin_instm_id,chr(13),''),chr(10),'') as base_fin_instm_id
,replace(replace(t1.base_asset_type_id,chr(13),''),chr(10),'') as base_asset_type_id
,replace(replace(t1.base_market_type_id,chr(13),''),chr(10),'') as base_market_type_id
,replace(replace(t1.issue_mode_cd,chr(13),''),chr(10),'') as issue_mode_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd
,replace(replace(t1.pay_int_ped_freq,chr(13),''),chr(10),'') as pay_int_ped_freq
,replace(replace(t1.pay_int_ped_corp_cd,chr(13),''),chr(10),'') as pay_int_ped_corp_cd
,replace(replace(t1.pay_int_adj_type_cd,chr(13),''),chr(10),'') as pay_int_adj_type_cd
,replace(replace(t1.src_int_rat_adj_ped_cd,chr(13),''),chr(10),'') as src_int_rat_adj_ped_cd
,replace(replace(t1.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
,replace(replace(t1.int_rat_adj_type_cd,chr(13),''),chr(10),'') as int_rat_adj_type_cd
,replace(replace(t1.issue_org_name,chr(13),''),chr(10),'') as issue_org_name
,input_dt
,replace(replace(t1.cn_abbr,chr(13),''),chr(10),'') as cn_abbr
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.checker_name,chr(13),''),chr(10),'') as checker_name
,fir_ped_set_int_dt
,fir_pay_int_dt
,int_rat_multir
,ovdue_int_rat
,issue_amt
,replace(replace(t1.exp_mode_cd,chr(13),''),chr(10),'') as exp_mode_cd
,replace(replace(t1.edit_num,chr(13),''),chr(10),'') as edit_num
,effect_dt
,invalid_dt
,fst_stl_amt
,exp_stl_amt
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg
,replace(replace(t1.stup_ped_type_cd,chr(13),''),chr(10),'') as stup_ped_type_cd
,replace(replace(t1.pay_flg,chr(13),''),chr(10),'') as pay_flg
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,cash_dt
,replace(replace(t1.pay_int_type_cd,chr(13),''),chr(10),'') as pay_int_type_cd
,replace(replace(t1.crdt_cust_id,chr(13),''),chr(10),'') as crdt_cust_id
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.guar_name,chr(13),''),chr(10),'') as guar_name
,unexp_draw_int_rat
,draw_post_int_rat
,replace(replace(t1.open_cert_flg,chr(13),''),chr(10),'') as open_cert_flg
,replace(replace(t1.auto_calc_int_rat_flg,chr(13),''),chr(10),'') as auto_calc_int_rat_flg
,nmal_int_rat
,vat_rat
,pass_addit_tax_rat
,pass_fee_rat
,replace(replace(t1.pass_fee_int_accr_base_cd,chr(13),''),chr(10),'') as pass_fee_int_accr_base_cd
,trust_fee_rat
,replace(replace(t1.trust_fee_int_accr_base_cd,chr(13),''),chr(10),'') as trust_fee_int_accr_base_cd
,other_fee_rat
,replace(replace(t1.other_fee_int_accr_base_cd,chr(13),''),chr(10),'') as other_fee_int_accr_base_cd
,replace(replace(t1.nmal_int_rat_int_accr_base_cd,chr(13),''),chr(10),'') as nmal_int_rat_int_accr_base_cd
,replace(replace(t1.int_stl_way_cd,chr(13),''),chr(10),'') as int_stl_way_cd
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cashflow_get_way_cd,chr(13),''),chr(10),'') as cashflow_get_way_cd
,create_dt
,update_dt

from ${iml_schema}.prd_ibank_cap_ld_fin_instm t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_ibank_cap_ld_fin_instm.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
