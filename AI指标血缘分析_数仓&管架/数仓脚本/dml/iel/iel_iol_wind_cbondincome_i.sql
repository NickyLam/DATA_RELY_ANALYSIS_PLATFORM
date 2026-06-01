: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t.tot_oper_rev as tot_oper_rev
,t.oper_rev as oper_rev
,t.int_inc as int_inc
,t.net_int_inc as net_int_inc
,t.insur_prem_unearned as insur_prem_unearned
,t.handling_chrg_comm_inc as handling_chrg_comm_inc
,t.net_handling_chrg_comm_inc as net_handling_chrg_comm_inc
,t.net_inc_other_ops as net_inc_other_ops
,t.plus_net_inc_other_bus as plus_net_inc_other_bus
,t.prem_inc as prem_inc
,t.less_ceded_out_prem as less_ceded_out_prem
,t.chg_unearned_prem_res as chg_unearned_prem_res
,t.incl_reinsurance_prem_inc as incl_reinsurance_prem_inc
,t.net_inc_sec_trading_brok_bus as net_inc_sec_trading_brok_bus
,t.net_inc_sec_uw_bus as net_inc_sec_uw_bus
,t.net_inc_ec_asset_mgmt_bus as net_inc_ec_asset_mgmt_bus
,t.other_bus_inc as other_bus_inc
,t.plus_net_gain_chg_fv as plus_net_gain_chg_fv
,t.plus_net_invest_inc as plus_net_invest_inc
,t.incl_inc_invest_assoc_jv_entp as incl_inc_invest_assoc_jv_entp
,t.plus_net_gain_fx_trans as plus_net_gain_fx_trans
,t.tot_oper_cost as tot_oper_cost
,t.less_oper_cost as less_oper_cost
,t.less_int_exp as less_int_exp
,t.less_handling_chrg_comm_exp as less_handling_chrg_comm_exp
,t.less_taxes_surcharges_ops as less_taxes_surcharges_ops
,t.less_selling_dist_exp as less_selling_dist_exp
,t.less_gerl_admin_exp as less_gerl_admin_exp
,t.less_fin_exp as less_fin_exp
,t.less_impair_loss_assets as less_impair_loss_assets
,t.prepay_surr as prepay_surr
,t.tot_claim_exp as tot_claim_exp
,t.chg_insur_cont_rsrv as chg_insur_cont_rsrv
,t.dvd_exp_insured as dvd_exp_insured
,t.reinsurance_exp as reinsurance_exp
,t.oper_exp as oper_exp
,t.less_claim_recb_reinsurer as less_claim_recb_reinsurer
,t.less_ins_rsrv_recb_reinsurer as less_ins_rsrv_recb_reinsurer
,t.less_exp_recb_reinsurer as less_exp_recb_reinsurer
,t.other_bus_cost as other_bus_cost
,t.oper_profit as oper_profit
,t.plus_non_oper_rev as plus_non_oper_rev
,t.less_non_oper_exp as less_non_oper_exp
,t.il_net_loss_disp_noncur_asset as il_net_loss_disp_noncur_asset
,t.tot_profit as tot_profit
,t.inc_tax as inc_tax
,t.unconfirmed_invest_loss as unconfirmed_invest_loss
,t.net_profit_incl_min_int_inc as net_profit_incl_min_int_inc
,t.net_profit_excl_min_int_inc as net_profit_excl_min_int_inc
,t.minority_int_inc as minority_int_inc
,t.other_compreh_inc as other_compreh_inc
,t.tot_compreh_inc as tot_compreh_inc
,t.tot_compreh_inc_parent_comp as tot_compreh_inc_parent_comp
,t.tot_compreh_inc_min_shrhldr as tot_compreh_inc_min_shrhldr
,t.s_fa_eps_basic as s_fa_eps_basic
,t.s_fa_eps_diluted as s_fa_eps_diluted
,replace(replace(t.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,t.insurance_expense as insurance_expense
,t.spe_bal_oper_profit as spe_bal_oper_profit
,t.tot_bal_oper_profit as tot_bal_oper_profit
,t.spe_bal_tot_profit as spe_bal_tot_profit
,t.tot_bal_tot_profit as tot_bal_tot_profit
,t.spe_bal_net_profit as spe_bal_net_profit
,t.tot_bal_net_profit as tot_bal_net_profit
,t.undistributed_profit as undistributed_profit
,t.adjlossgain_prevyear as adjlossgain_prevyear
,t.transfer_from_surplusreserve as transfer_from_surplusreserve
,t.transfer_from_housingimprest as transfer_from_housingimprest
,t.transfer_from_others as transfer_from_others
,t.distributable_profit as distributable_profit
,t.withdr_legalsurplus as withdr_legalsurplus
,t.withdr_legalpubwelfunds as withdr_legalpubwelfunds
,t.workers_welfare as workers_welfare
,t.withdr_buzexpwelfare as withdr_buzexpwelfare
,t.withdr_reservefund as withdr_reservefund
,t.distributable_profit_shrhder as distributable_profit_shrhder
,t.prfshare_dvd_payable as prfshare_dvd_payable
,t.withdr_othersurpreserve as withdr_othersurpreserve
,t.comshare_dvd_payable as comshare_dvd_payable
,t.capitalized_comstock_div as capitalized_comstock_div
,t.audit_am as audit_am
from iol.wind_cbondincome t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes