: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_am_bond_invest_f
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_am_bond_invest.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'') as am_prod_id
,replace(replace(t1.am_prod_name,chr(13),''),chr(10),'') as am_prod_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.am_prod_prft_type_cd,chr(13),''),chr(10),'') as am_prod_prft_type_cd
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.asset_name,chr(13),''),chr(10),'') as asset_name
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.tran_market_cd,chr(13),''),chr(10),'') as tran_market_cd
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,replace(replace(t1.brkevn_bond_flg,chr(13),''),chr(10),'') as brkevn_bond_flg
,replace(replace(t1.convbl_bond_flg,chr(13),''),chr(10),'') as convbl_bond_flg
,replace(replace(t1.sub_debt_flg,chr(13),''),chr(10),'') as sub_debt_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,issue_dt
,value_dt
,exp_dt
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,int_rat_float_point
,fir_pay_int_dt
,last_pay_int_dt
,next_pay_int_dt
,replace(replace(t1.holiday_rule_cd,chr(13),''),chr(10),'') as holiday_rule_cd
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fac_val_amt
,fac_val_int_rat
,mk_pri_full_price
,mk_pri_net_price
,pay_int_freq
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,replace(replace(t1.int_accr_ped_cd,chr(13),''),chr(10),'') as int_accr_ped_cd
,replace(replace(t1.reset_ped_cd,chr(13),''),chr(10),'') as reset_ped_cd
,hold_pos
,hold_fac_val
,pric_bal
,acru_int
,int_recvbl
,int_adj_amt
,evha_val_chag
,actl_int_rat
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,open_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num

from ${icl_schema}.cmm_am_bond_invest t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_am_bond_invest.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
