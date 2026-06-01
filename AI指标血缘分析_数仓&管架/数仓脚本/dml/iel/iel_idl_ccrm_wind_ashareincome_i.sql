: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_ashareincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_ashareincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.wind_code,chr(13),''),chr(10),'') as wind_code
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.tot_oper_rev as tot_oper_rev
,t1.oper_rev as oper_rev
,t1.int_inc as int_inc
,t1.net_int_inc as net_int_inc
,t1.insur_prem_unearned as insur_prem_unearned
,t1.handling_chrg_comm_inc as handling_chrg_comm_inc
,t1.net_handling_chrg_comm_inc as net_handling_chrg_comm_inc
,t1.net_inc_other_ops as net_inc_other_ops
,t1.plus_net_inc_other_bus as plus_net_inc_other_bus
,t1.prem_inc as prem_inc
,t1.less_ceded_out_prem as less_ceded_out_prem
,t1.chg_unearned_prem_res as chg_unearned_prem_res
,t1.incl_reinsurance_prem_inc as incl_reinsurance_prem_inc
,t1.net_inc_sec_trading_brok_bus as net_inc_sec_trading_brok_bus
,t1.net_inc_sec_uw_bus as net_inc_sec_uw_bus
,t1.net_inc_ec_asset_mgmt_bus as net_inc_ec_asset_mgmt_bus
,t1.other_bus_inc as other_bus_inc
,t1.plus_net_gain_chg_fv as plus_net_gain_chg_fv
,t1.plus_net_invest_inc as plus_net_invest_inc
,t1.incl_inc_invest_assoc_jv_entp as incl_inc_invest_assoc_jv_entp
,t1.plus_net_gain_fx_trans as plus_net_gain_fx_trans
,t1.tot_oper_cost as tot_oper_cost
,t1.less_oper_cost as less_oper_cost
,t1.less_int_exp as less_int_exp
,t1.less_handling_chrg_comm_exp as less_handling_chrg_comm_exp
,t1.less_taxes_surcharges_ops as less_taxes_surcharges_ops
,t1.less_selling_dist_exp as less_selling_dist_exp
,t1.less_gerl_admin_exp as less_gerl_admin_exp
,t1.less_fin_exp as less_fin_exp
,t1.less_impair_loss_assets as less_impair_loss_assets
,t1.prepay_surr as prepay_surr
,t1.tot_claim_exp as tot_claim_exp
,t1.chg_insur_cont_rsrv as chg_insur_cont_rsrv
,t1.dvd_exp_insured as dvd_exp_insured
,t1.reinsurance_exp as reinsurance_exp
,t1.oper_exp as oper_exp
,t1.less_claim_recb_reinsurer as less_claim_recb_reinsurer
,t1.less_ins_rsrv_recb_reinsurer as less_ins_rsrv_recb_reinsurer
,t1.less_exp_recb_reinsurer as less_exp_recb_reinsurer
,t1.other_bus_cost as other_bus_cost
,t1.oper_profit as oper_profit
,t1.plus_non_oper_rev as plus_non_oper_rev
,t1.less_non_oper_exp as less_non_oper_exp
,t1.il_net_loss_disp_noncur_asset as il_net_loss_disp_noncur_asset
,t1.tot_profit as tot_profit
,t1.inc_tax as inc_tax
,t1.unconfirmed_invest_loss as unconfirmed_invest_loss
,t1.net_profit_incl_min_int_inc as net_profit_incl_min_int_inc
,t1.net_profit_excl_min_int_inc as net_profit_excl_min_int_inc
,t1.minority_int_inc as minority_int_inc
,t1.other_compreh_inc as other_compreh_inc
,t1.tot_compreh_inc as tot_compreh_inc
,t1.tot_compreh_inc_parent_comp as tot_compreh_inc_parent_comp
,t1.tot_compreh_inc_min_shrhldr as tot_compreh_inc_min_shrhldr
,t1.ebit as ebit
,t1.ebitda as ebitda
,t1.net_profit_after_ded_nr_lp as net_profit_after_ded_nr_lp
,t1.net_profit_under_intl_acc_sta as net_profit_under_intl_acc_sta
,replace(replace(t1.comp_type_code,chr(13),''),chr(10),'') as comp_type_code
,t1.s_fa_eps_basic as s_fa_eps_basic
,t1.s_fa_eps_diluted as s_fa_eps_diluted
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,t1.insurance_expense as insurance_expense
,t1.spe_bal_oper_profit as spe_bal_oper_profit
,t1.tot_bal_oper_profit as tot_bal_oper_profit
,t1.spe_bal_tot_profit as spe_bal_tot_profit
,t1.tot_bal_tot_profit as tot_bal_tot_profit
,t1.spe_bal_net_profit as spe_bal_net_profit
,t1.tot_bal_net_profit as tot_bal_net_profit
,t1.undistributed_profit as undistributed_profit
,t1.adjlossgain_prevyear as adjlossgain_prevyear
,t1.transfer_from_surplusreserve as transfer_from_surplusreserve
,t1.transfer_from_housingimprest as transfer_from_housingimprest
,t1.transfer_from_others as transfer_from_others
,t1.distributable_profit as distributable_profit
,t1.withdr_legalsurplus as withdr_legalsurplus
,t1.withdr_legalpubwelfunds as withdr_legalpubwelfunds
,t1.workers_welfare as workers_welfare
,t1.withdr_buzexpwelfare as withdr_buzexpwelfare
,t1.withdr_reservefund as withdr_reservefund
,t1.distributable_profit_shrhder as distributable_profit_shrhder
,t1.prfshare_dvd_payable as prfshare_dvd_payable
,t1.withdr_othersurpreserve as withdr_othersurpreserve
,t1.comshare_dvd_payable as comshare_dvd_payable
,t1.capitalized_comstock_div as capitalized_comstock_div
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_ashareincome t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_ashareincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes