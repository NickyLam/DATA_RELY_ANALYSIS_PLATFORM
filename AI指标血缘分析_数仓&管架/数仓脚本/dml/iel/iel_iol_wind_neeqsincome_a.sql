: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_neeqsincome_a
CreateDate: 20240509
FileName:   ${iel_data_path}/wind_neeqsincome.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,tot_oper_rev
,oper_rev
,int_inc
,net_int_inc
,insur_prem_unearned
,handling_chrg_comm_inc
,net_handling_chrg_comm_inc
,net_inc_other_ops
,plus_net_inc_other_bus
,prem_inc
,less_ceded_out_prem
,chg_unearned_prem_res
,incl_reinsurance_prem_inc
,net_inc_sec_trading_brok_bus
,net_inc_sec_uw_bus
,net_inc_ec_asset_mgmt_bus
,other_bus_inc
,plus_net_gain_chg_fv
,plus_net_invest_inc
,incl_inc_invest_assoc_jv_entp
,plus_net_gain_fx_trans
,tot_oper_cost
,less_oper_cost
,less_int_exp
,less_handling_chrg_comm_exp
,less_taxes_surcharges_ops
,less_selling_dist_exp
,less_gerl_admin_exp
,less_fin_exp
,less_impair_loss_assets
,prepay_surr
,tot_claim_exp
,chg_insur_cont_rsrv
,dvd_exp_insured
,reinsurance_exp
,oper_exp
,less_claim_recb_reinsurer
,less_ins_rsrv_recb_reinsurer
,less_exp_recb_reinsurer
,other_bus_cost
,oper_profit
,plus_non_oper_rev
,less_non_oper_exp
,il_net_loss_disp_noncur_asset
,tot_profit
,inc_tax
,unconfirmed_invest_loss
,net_profit_incl_min_int_inc
,net_profit_excl_min_int_inc
,minority_int_inc
,other_compreh_inc
,tot_compreh_inc
,tot_compreh_inc_parent_comp
,tot_compreh_inc_min_shrhldr
,ebit
,ebitda
,net_profit_after_ded_nr_lp
,net_profit_under_intl_acc_sta
,replace(replace(t1.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,s_fa_eps_basic
,s_fa_eps_diluted
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,insurance_expense
,spe_bal_oper_profit
,tot_bal_oper_profit
,spe_bal_tot_profit
,tot_bal_tot_profit
,spe_bal_net_profit
,tot_bal_net_profit
,undistributed_profit
,adjlossgain_prevyear
,transfer_from_surplusreserve
,transfer_from_housingimprest
,transfer_from_others
,distributable_profit
,withdr_legalsurplus
,withdr_legalpubwelfunds
,workers_welfare
,withdr_buzexpwelfare
,withdr_reservefund
,distributable_profit_shrhder
,prfshare_dvd_payable
,withdr_othersurpreserve
,comshare_dvd_payable
,capitalized_comstock_div

from ${iol_schema}.wind_neeqsincome t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_neeqsincome.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
