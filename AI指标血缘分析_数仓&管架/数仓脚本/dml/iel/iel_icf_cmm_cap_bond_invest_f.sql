: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_cap_bond_invest_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_cap_bond_invest.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bal_id,chr(13),''),chr(10),'') as bal_id
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.tran_acct_b_id,chr(13),''),chr(10),'') as tran_acct_b_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,t1.stl_dt as stl_dt
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.guartor_name,chr(13),''),chr(10),'') as guartor_name
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,replace(replace(t1.init_bond_type_cd,chr(13),''),chr(10),'') as init_bond_type_cd
,replace(replace(t1.discnt_debt_flg,chr(13),''),chr(10),'') as discnt_debt_flg
,replace(replace(t1.convbl_bond_flg,chr(13),''),chr(10),'') as convbl_bond_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.hold_pos as hold_pos
,t1.hold_fac_val as hold_fac_val
,t1.net_price_cost as net_price_cost
,t1.currt_bal as currt_bal
,t1.int_adj_amt as int_adj_amt
,t1.evha_val_chag as evha_val_chag
,t1.int_cost as int_cost
,t1.full_price_cost as full_price_cost
,t1.impam_prep as impam_prep
,t1.spd_prft as spd_prft
,t1.amort_prft as amort_prft
,t1.int_prft as int_prft
,t1.evha_val_chag_pl as evha_val_chag_pl
,t1.impam_loss as impam_loss
,t1.tran_fee as tran_fee
,t1.issue_dt as issue_dt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.list_tran_dt as list_tran_dt
,t1.stop_circlt_dt as stop_circlt_dt
,t1.tenor as tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,t1.actl_int_rat as actl_int_rat
,t1.fac_val_int_rat as fac_val_int_rat
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,t1.int_rat_float_point as int_rat_float_point
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_reset_ped_cd,chr(13),''),chr(10),'') as int_rat_reset_ped_cd
,t1.fir_int_rat_reset_dt as fir_int_rat_reset_dt
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,t1.fir_pay_int_dt as fir_pay_int_dt
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,t1.td_acru_int as td_acru_int
,t1.open_dt as open_dt
,t1.recnt_tran_dt as recnt_tran_dt
,t1.acru_int as acru_int
,t1.int_recvbl as int_recvbl
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.bus_cate_name,chr(13),''),chr(10),'') as bus_cate_name
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id
,replace(replace(t1.convbl_bond_id,chr(13),''),chr(10),'') as convbl_bond_id
,t1.cbond_full_price_evltion as cbond_full_price_evltion
,t1.cbond_net_price_evltion as cbond_net_price_evltion
,t1.estim_coret_duran as estim_coret_duran
,t1.bp_val as bp_val
,t1.estim_cvty as estim_cvty
,t1.estim_yld_rat as estim_yld_rat
,t1.book_bal as book_bal
,replace(replace(t1.int_recvbl_subj_id,chr(13),''),chr(10),'') as int_recvbl_subj_id
,replace(replace(t1.acru_int_subj_id,chr(13),''),chr(10),'') as acru_int_subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.evha_val_chag_subj_id,chr(13),''),chr(10),'') as evha_val_chag_subj_id
,replace(replace(t1.custm_bond_id,chr(13),''),chr(10),'') as custm_bond_id
,replace(replace(t1.tran_acct_b_name,chr(13),''),chr(10),'') as tran_acct_b_name
,t1.evha_val_chag_pl_carr_bf as evha_val_chag_pl_carr_bf

from ${icl_schema}.cmm_cap_bond_invest t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_cap_bond_invest.f.${batch_date}.dat" \
        charset=utf8
        safe=yes