: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_unlistedbankbalancesheet_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_unlistedbankbalancesheet.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period 
,replace(replace(t1.statement_type,chr(13),''),chr(10),'') as statement_type 
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code 
,replace(replace(t1.actual_ann_dt,chr(13),''),chr(10),'') as actual_ann_dt 
,t1.cash_deposits_central_bank as cash_deposits_central_bank 
,t1.asset_dep_oth_banks_fin_inst as asset_dep_oth_banks_fin_inst 
,t1.precious_metals as precious_metals 
,t1.loans_to_oth_banks as loans_to_oth_banks 
,t1.tradable_fin_assets as tradable_fin_assets 
,t1.derivative_fin_assets as derivative_fin_assets 
,t1.red_monetary_cap_for_sale as red_monetary_cap_for_sale 
,t1.int_rcv as int_rcv 
,t1.loans_and_adv_granted as loans_and_adv_granted 
,t1.agency_bus_assets as agency_bus_assets 
,t1.fin_assets_avail_for_sale as fin_assets_avail_for_sale 
,t1.held_to_mty_invest as held_to_mty_invest 
,t1.long_term_eqy_invest as long_term_eqy_invest 
,t1.rcv_invest as rcv_invest 
,t1.fix_assets as fix_assets 
,t1.intang_assets as intang_assets 
,t1.goodwill as goodwill 
,t1.deferred_tax_assets as deferred_tax_assets 
,t1.invest_real_estate as invest_real_estate 
,t1.oth_assets as oth_assets 
,t1.spe_bal_assets as spe_bal_assets 
,t1.tot_bal_assets as tot_bal_assets 
,t1.tot_assets as tot_assets 
,t1.liab_dep_oth_banks_fin_inst as liab_dep_oth_banks_fin_inst 
,t1.borrow_central_bank as borrow_central_bank 
,t1.loans_oth_banks as loans_oth_banks 
,t1.tradable_fin_liab as tradable_fin_liab 
,t1.derivative_fin_liab as derivative_fin_liab 
,t1.fund_sales_fin_assets_rp as fund_sales_fin_assets_rp 
,t1.cust_bank_dep as cust_bank_dep 
,t1.empl_ben_payable as empl_ben_payable 
,t1.taxes_surcharges_payable as taxes_surcharges_payable 
,t1.int_payable as int_payable 
,t1.agency_bus_liab as agency_bus_liab 
,t1.bonds_payable as bonds_payable 
,t1.deferred_tax_liab as deferred_tax_liab 
,t1.provisions as provisions 
,t1.oth_liab as oth_liab 
,t1.spe_bal_liab as spe_bal_liab 
,t1.tot_bal_liab as tot_bal_liab 
,t1.tot_liab as tot_liab 
,t1.cap_stk as cap_stk 
,t1.cap_rsrv as cap_rsrv 
,t1.less_tsy_stk as less_tsy_stk 
,t1.surplus_rsrv as surplus_rsrv 
,t1.undistributed_profit as undistributed_profit 
,t1.prov_nom_risks as prov_nom_risks 
,t1.cnvd_diff_foreign_curr_stat as cnvd_diff_foreign_curr_stat 
,t1.unconfirmed_invest_loss as unconfirmed_invest_loss 
,t1.spe_bal_shrhldr_eqy as spe_bal_shrhldr_eqy 
,t1.tot_bal_shrhldr_eqy as tot_bal_shrhldr_eqy 
,t1.minority_int as minority_int 
,t1.tot_shrhldr_eqy_excl_min_int as tot_shrhldr_eqy_excl_min_int 
,t1.tot_shrhldr_eqy_incl_min_int as tot_shrhldr_eqy_incl_min_int 
,t1.spe_bal_liab_eqy as spe_bal_liab_eqy 
,t1.tot_bal_liab_eqy as tot_bal_liab_eqy 
,t1.tot_liab_shrhldr_eqy as tot_liab_shrhldr_eqy 
from ${iol_schema}.wind_unlistedbankbalancesheet t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_unlistedbankbalancesheet.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes