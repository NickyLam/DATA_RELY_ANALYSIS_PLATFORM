: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_sec_corp_main_indicators_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_sec_corp_main_indicators.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,announcement_date
,ed
,net_capital
,nc_to_total_risk_reserve
,net_capital_to_net_assets
,net_capital_to_liab
,net_assets_to_liab
,ss_equity_sec_etc_to_nc
,ss_fixed_income_sec_to_nc
,total_risk_capital_reserve
,entrusted_capital
,net_capital_ratio
,self_operate_nb
,self_operate_fund
,self_operate_stock
,self_operate_sec_sum
,self_operate_cb
,special_am_income
,entrusted_am_scale
,directional_am_income
,collective_am_income
,net_stable_funding_ratio
,lcr
,capital_leverage
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,ib_net_income
,si_net_income
,sb_net_income
,am_net_income
,ib_income
,si_income
,sb_income
,am_income
,fs_trade_fina_assets
,fs_other_equity_instr_invest
,fs_impai_provi
,fs_avail_sale_fina_assets
,total_fs
,fs_refin_secur_amo
,total_ins_refin_secur_amo
,ins_borr_secur
,total_ins
,fs_borr_secur
,nii_pur_resale_fina_assets
,nii_debt_invest
,nii_other
,nii_other_debt_invest
,nii_other_fina_assets_ceirm
,nii_fina_assets_calcu_eirm
,nii_lend_funds
,nii_margin_trade
,nii_monet_funds_settl_provi
,nii_loans_recei
,ii_purch_resale_fina_asset
,ii_debt_invest
,ii_other
,ii_other_debt_invest
,ii_other_fina_assets_ceirm
,ii_fina_assets_calcu_eirm
,ii_lend_funds
,ii_margin_trade
,ii_monet_funds_settl_provi
,ii_loans_recei
,nhfci_other
,nhfci_fund_manag
,nhfci_invest_consul
,nhfci_invest_bank
,nhfci_futur_broke
,nhfci_secur_broke
,nhfci_asset_manag
,hfci_other
,hfci_fund_manag
,hfci_invest_consul
,hfci_invest_bank
,hfci_futur_broke
,hfci_secur_broke
,hfci_asset_manag
,fs_hk_margin_fina_colla
,isvalid

from ${iol_schema}.uxds_sec_corp_main_indicators t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_sec_corp_main_indicators.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
