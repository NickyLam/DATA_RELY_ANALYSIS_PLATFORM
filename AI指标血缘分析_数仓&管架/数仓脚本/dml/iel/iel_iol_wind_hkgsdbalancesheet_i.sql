: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hkgsdbalancesheet_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_hkgsdbalancesheet.i.${batch_date}.dat
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
,t.report_type as report_type
,t.statement_type as statement_type
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t.tot_cur_assets as tot_cur_assets
,t.cash_cash_equ as cash_cash_equ
,t.tradable_fin_assets as tradable_fin_assets
,t.oth_short_inv as oth_short_inv
,t.ar_total as ar_total
,t.stm_bs as stm_bs
,t.oth_rcv as oth_rcv
,t.inventories as inventories
,t.oth_cur_assets as oth_cur_assets
,t.non_cur_assets as non_cur_assets
,t.net_oth_fix_assets as net_oth_fix_assets
,t.equity_inv as equity_inv
,t.held_to_mty_invest as held_to_mty_invest
,t.avail_for_sale_inv as avail_for_sale_inv
,t.oth_long_inv as oth_long_inv
,t.goodwill_intang_assets as goodwill_intang_assets
,t.goodwill as goodwill
,t.right_land_usage as right_land_usage
,t.oth_noncurrent_assets as oth_noncurrent_assets
,t.tot_assets as tot_assets
,t.cur_liab as cur_liab
,t.ap_note as ap_note
,t.taxes_surcharges_payable as taxes_surcharges_payable
,t.tradable_fin_liab as tradable_fin_liab
,t.stloans_ltloans_curdue as stloans_ltloans_curdue
,t.oth_cur_liab as oth_cur_liab
,t.non_cur_liab as non_cur_liab
,t.lt_borrow as lt_borrow
,t.oth_non_cur_liab as oth_non_cur_liab
,t.total_liabilities as total_liabilities
,t.prfshare as prfshare
,t.comshare as comshare
,t.reserve as reserve
,t.premium_stock as premium_stock
,t.retained_earn as retained_earn
,t.oth_reserve as oth_reserve
,t.treasuryshare as treasuryshare
,t.oth_com_income as oth_com_income
,t.tot_com_equity as tot_com_equity
,t.parsh_int as parsh_int
,t.minority_int as minority_int
,t.tot_shrhldr_eqy as tot_shrhldr_eqy
,t.tot_liab_eqy as tot_liab_eqy
,t.cash_inter_bal as cash_inter_bal
,t.due_bank as due_bank
,t.net_loans as net_loans
,t.deposit_bank as deposit_bank
,t.funds_lent as funds_lent
,t.mort_sec as mort_sec
,t.sale_loan as sale_loan
,t.tot_deposits as tot_deposits
,t.loans_oth_banks as loans_oth_banks
,t.secured_fin as secured_fin
,t.reinsur_pay as reinsur_pay
,t.reinsur_rece as reinsur_rece
,t.insur_pre_rec as insur_pre_rec
,t.defer_cost as defer_cost
,t.insur_liab as insur_liab
,t.invest_liab as invest_liab
,t.oth_inv as oth_inv
,t.oth_assets as oth_assets
,t.oth_liab as oth_liab
,replace(replace(t.s_info_comptype,chr(13),''),chr(10),'') as s_info_comptype
,replace(replace(t.s_memo,chr(13),''),chr(10),'') as s_memo
from iol.wind_hkgsdbalancesheet t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hkgsdbalancesheet.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes