: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_am_non_std_invest_f
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_am_non_std_invest.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'') as am_prod_id
,replace(replace(t1.am_plan_id,chr(13),''),chr(10),'') as am_plan_id
,replace(replace(t1.am_prod_name,chr(13),''),chr(10),'') as am_prod_name
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.am_prod_prft_type_cd,chr(13),''),chr(10),'') as am_prod_prft_type_cd
,replace(replace(t1.asset_plan_cd,chr(13),''),chr(10),'') as asset_plan_cd
,replace(replace(t1.asset_plan_name,chr(13),''),chr(10),'') as asset_plan_name
,replace(replace(t1.asset_plan_kind_cd,chr(13),''),chr(10),'') as asset_plan_kind_cd
,replace(replace(t1.asset_prft_type_cd,chr(13),''),chr(10),'') as asset_prft_type_cd
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd
,replace(replace(t1.gover_fin_plat_flg,chr(13),''),chr(10),'') as gover_fin_plat_flg
,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg
,replace(replace(t1.sub_debt_flg,chr(13),''),chr(10),'') as sub_debt_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.fin_corp_id,chr(13),''),chr(10),'') as fin_corp_id
,replace(replace(t1.fin_corp_name,chr(13),''),chr(10),'') as fin_corp_name
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.co_corp_id,chr(13),''),chr(10),'') as co_corp_id
,issue_dt
,value_dt
,exp_dt
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,int_rat_float_point
,rpp_freq
,pay_int_freq
,replace(replace(t1.pay_int_ped_cd,chr(13),''),chr(10),'') as pay_int_ped_cd
,fir_pay_int_dt
,last_pay_int_dt
,next_pay_int_dt
,replace(replace(t1.holiday_rule_cd,chr(13),''),chr(10),'') as holiday_rule_cd
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,cont_amt
,base_rat
,exec_int_rat
,hold_pos
,hold_fac_val
,pric_bal
,td_acru_int
,currt_acru_int
,acru_int
,actl_int_rat
,exp_yld_rat
,evha_val_chag
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,open_dt
,recnt_tran_dt
,replace(replace(t1.crdt_out_acct_flow_num,chr(13),''),chr(10),'') as crdt_out_acct_flow_num

from ${icl_schema}.cmm_am_non_std_invest t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_am_non_std_invest.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
