: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_unlistedbrokerincome_f
CreateDate: 20240715
FileName:   ${iel_data_path}/wind_unlistedbrokerincome.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,ebit
,ebitda
,net_profit_after_ded_nr_lp
,net_profit_under_intl_acc_sta
,s_fa_eps_basic
,s_fa_eps_diluted
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt
,oper_rev
,handling_chrg_comm_inc
,net_inc_sec_trading_brok_bus
,net_inc_sec_uw_bus
,net_inc_ec_asset_mgmt_bus
,net_int_inc
,plus_net_invest_inc
,incl_inc_invest_assoc_jv_entp
,plus_net_gain_chg_fv
,plus_net_gain_fx_trans
,other_bus_inc
,oper_exp
,less_taxes_surcharges_ops
,less_gerl_admin_exp
,less_impair_loss_assets
,other_bus_cost
,spe_bal_oper_profit
,tot_bal_oper_profit
,oper_profit
,plus_non_oper_rev
,less_non_oper_exp
,il_net_loss_disp_noncur_asset
,spe_bal_tot_profit
,tot_bal_tot_profit
,tot_profit
,inc_tax
,unconfirmed_invest_loss
,spe_bal_net_profit
,tot_bal_net_profit
,net_profit_incl_min_int_inc
,net_profit_excl_min_int_inc
,minority_int_inc
,other_compreh_inc
,tot_compreh_inc
,tot_compreh_inc_min_shrhldr
,tot_compreh_inc_parent_comp

from ${iol_schema}.wind_unlistedbrokerincome t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_unlistedbrokerincome.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
