: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_ibank_bond_invest_f
CreateDate: 20240426
FileName:   ${iel_data_path}/cmm_ibank_bond_invest.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.convbl_bond_flg,chr(13),''),chr(10),'') as convbl_bond_flg
,replace(replace(t1.sub_debt_flg,chr(13),''),chr(10),'') as sub_debt_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.payoff_level_cd,chr(13),''),chr(10),'') as payoff_level_cd
,issue_dt
,value_dt
,exp_dt
,replace(replace(t1.tenor_cd,chr(13),''),chr(10),'') as tenor_cd
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.ex_type_cd,chr(13),''),chr(10),'') as ex_type_cd
,fir_ex_dt
,fir_ex_price
,fir_compst_int_rat
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,fac_val_int_rat
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,replace(replace(t1.reset_ped_cd,chr(13),''),chr(10),'') as reset_ped_cd
,hold_pos
,hold_fac_val
,pric_bal
,acru_int
,recvbl_uncol_pric
,recvbl_uncol_int
,int_adj_amt
,evha_val_chag
,actl_int_rat
,last_update_dt
,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.base_rat_asset_type_id,chr(13),''),chr(10),'') as base_rat_asset_type_id
,replace(replace(t1.base_rat_market_type_id,chr(13),''),chr(10),'') as base_rat_market_type_id
,base_rat
,fair_val_pl
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,cbond_full_price_evltion
,cbond_net_price_evltion
,estim_coret_duran
,bp_val
,estim_cvty
,estim_yld_rat
,book_bal
,int_recvbl
,replace(replace(t1.comb_tran_num,chr(13),''),chr(10),'') as comb_tran_num
,currt_bal
,csecu_full_price_evltion
,csecu_net_price_evltion
,csecu_coret_duran
,csecu_bp_val
,csecu_estim_cvty
,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'') as extra_dimen_cd
,stl_dt
,replace(replace(t1.ovdue_status,chr(13),''),chr(10),'') as ovdue_status
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,pric_ovdue_dt
,pric_ovdue_days
,int_ovdue_dt
,int_ovdue_days
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id
,replace(replace(t1.src_pay_int_ped_cd,chr(13),''),chr(10),'') as src_pay_int_ped_cd
,replace(replace(t1.uder_asset_type_id,chr(13),''),chr(10),'') as uder_asset_type_id
,replace(replace(t1.final_dir_type_descb,chr(13),''),chr(10),'') as final_dir_type_descb
,replace(replace(t1.final_dir_indus_gen,chr(13),''),chr(10),'') as final_dir_indus_gen
,replace(replace(t1.crdt_fin_instm_id,chr(13),''),chr(10),'') as crdt_fin_instm_id
,replace(replace(t1.asset_uniq_idf_id,chr(13),''),chr(10),'') as asset_uniq_idf_id
,replace(replace(t1.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id

from ${icl_schema}.cmm_ibank_bond_invest t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_bond_invest.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
