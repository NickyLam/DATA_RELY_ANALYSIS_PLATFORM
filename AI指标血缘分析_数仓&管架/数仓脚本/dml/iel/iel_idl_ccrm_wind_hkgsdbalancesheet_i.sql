: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hkgsdbalancesheet_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hkgsdbalancesheet.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,t1.report_type as report_type
,t1.statement_type as statement_type
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.tot_cur_assets as tot_cur_assets
,t1.cash_cash_equ as cash_cash_equ
,t1.tradable_fin_assets as tradable_fin_assets
,t1.oth_short_inv as oth_short_inv
,t1.ar_total as ar_total
,t1.stm_bs as stm_bs
,t1.oth_rcv as oth_rcv
,t1.inventories as inventories
,t1.oth_cur_assets as oth_cur_assets
,t1.non_cur_assets as non_cur_assets
,t1.net_oth_fix_assets as net_oth_fix_assets
,t1.equity_inv as equity_inv
,t1.held_to_mty_invest as held_to_mty_invest
,t1.avail_for_sale_inv as avail_for_sale_inv
,t1.oth_long_inv as oth_long_inv
,t1.goodwill_intang_assets as goodwill_intang_assets
,t1.goodwill as goodwill
,t1.right_land_usage as right_land_usage
,t1.oth_noncurrent_assets as oth_noncurrent_assets
,t1.tot_assets as tot_assets
,t1.cur_liab as cur_liab
,t1.ap_note as ap_note
,t1.taxes_surcharges_payable as taxes_surcharges_payable
,t1.tradable_fin_liab as tradable_fin_liab
,t1.stloans_ltloans_curdue as stloans_ltloans_curdue
,t1.oth_cur_liab as oth_cur_liab
,t1.non_cur_liab as non_cur_liab
,t1.lt_borrow as lt_borrow
,t1.oth_non_cur_liab as oth_non_cur_liab
,t1.total_liabilities as total_liabilities
,t1.prfshare as prfshare
,t1.comshare as comshare
,t1.reserve as reserve
,t1.premium_stock as premium_stock
,t1.retained_earn as retained_earn
,t1.oth_reserve as oth_reserve
,t1.treasuryshare as treasuryshare
,t1.oth_com_income as oth_com_income
,t1.tot_com_equity as tot_com_equity
,t1.parsh_int as parsh_int
,t1.minority_int as minority_int
,t1.tot_shrhldr_eqy as tot_shrhldr_eqy
,t1.tot_liab_eqy as tot_liab_eqy
,t1.cash_inter_bal as cash_inter_bal
,t1.due_bank as due_bank
,t1.net_loans as net_loans
,t1.deposit_bank as deposit_bank
,t1.funds_lent as funds_lent
,t1.mort_sec as mort_sec
,t1.sale_loan as sale_loan
,t1.tot_deposits as tot_deposits
,t1.loans_oth_banks as loans_oth_banks
,t1.secured_fin as secured_fin
,t1.reinsur_pay as reinsur_pay
,t1.reinsur_rece as reinsur_rece
,t1.insur_pre_rec as insur_pre_rec
,t1.defer_cost as defer_cost
,t1.insur_liab as insur_liab
,t1.invest_liab as invest_liab
,t1.oth_inv as oth_inv
,t1.oth_assets as oth_assets
,t1.oth_liab as oth_liab
,replace(replace(t1.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype
,replace(replace(t1.s_memo,chr(13),''),chr(10),'') as s_memo
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_hkgsdbalancesheet t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hkgsdbalancesheet.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes