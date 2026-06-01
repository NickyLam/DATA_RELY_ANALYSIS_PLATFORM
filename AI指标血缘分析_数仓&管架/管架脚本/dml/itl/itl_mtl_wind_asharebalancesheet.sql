/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_asharebalancesheet
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.mtl_wind_asharebalancesheet drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_asharebalancesheet drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_asharebalancesheet add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_asharebalancesheet partition for (to_date('${batch_date}','yyyymmdd')) (
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,wind_code -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,monetary_cap -- 货币资金
    ,tradable_fin_assets -- 交易性金融资产
    ,notes_rcv -- 应收票据
    ,acct_rcv -- 应收账款
    ,oth_rcv -- 其他应收款
    ,prepay -- 预付款项
    ,dvd_rcv -- 应收股利
    ,int_rcv -- 应收利息
    ,inventories -- 存货
    ,consumptive_bio_assets -- 消耗性生物资产
    ,deferred_exp -- 待摊费用
    ,non_cur_assets_due_within_1y -- 一年内到期的非流动资产
    ,settle_rsrv -- 结算备付金
    ,loans_to_oth_banks -- 拆出资金
    ,prem_rcv -- 应收保费
    ,rcv_from_reinsurer -- 应收分保账款
    ,rcv_from_ceded_insur_cont_rsrv -- 应收分保合同准备金
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,oth_cur_assets -- 其他流动资产
    ,tot_cur_assets -- 流动资产合计
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,invest_real_estate -- 投资性房地产
    ,time_deposits -- 定期存款
    ,oth_assets -- 其他资产
    ,long_term_rec -- 长期应收款
    ,fix_assets -- 固定资产
    ,const_in_prog -- 在建工程
    ,proj_matl -- 工程物资
    ,fix_assets_disp -- 固定资产清理
    ,productive_bio_assets -- 生产性生物资产
    ,oil_and_natural_gas_assets -- 油气资产
    ,intang_assets -- 无形资产
    ,r_and_d_costs -- 开发支出
    ,goodwill -- 商誉
    ,long_term_deferred_exp -- 长期待摊费用
    ,deferred_tax_assets -- 递延所得税资产
    ,loans_and_adv_granted -- 发放贷款及垫款
    ,oth_non_cur_assets -- 其他非流动资产
    ,tot_non_cur_assets -- 非流动资产合计
    ,cash_deposits_central_bank -- 现金及存放中央银行款项
    ,asset_dep_oth_banks_fin_inst -- 存放同业和其它金融机构款项
    ,precious_metals -- 贵金属
    ,derivative_fin_assets -- 衍生金融资产
    ,agency_bus_assets -- 代理业务资产
    ,subr_rec -- 应收代位追偿款
    ,rcv_ceded_unearned_prem_rsrv -- 应收分保未到期责任准备金
    ,rcv_ceded_claim_rsrv -- 应收分保未决赔款准备金
    ,rcv_ceded_life_insur_rsrv -- 应收分保寿险责任准备金
    ,rcv_ceded_lt_health_insur_rsrv -- 应收分保长期健康险责任准备金
    ,mrgn_paid -- 存出保证金
    ,insured_pledge_loan -- 保户质押贷款
    ,cap_mrgn_paid -- 存出资本保证金
    ,independent_acct_assets -- 独立账户资产
    ,clients_cap_deposit -- 客户资金存款
    ,clients_rsrv_settle -- 客户备付金
    ,incl_seat_fees_exchange -- 其中:交易席位费
    ,rcv_invest -- 应收款项类投资
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,borrow_central_bank -- 向中央银行借款
    ,deposit_received_ib_deposits -- 吸收存款及同业存放
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,notes_payable -- 应付票据
    ,acct_payable -- 应付账款
    ,adv_from_cust -- 预收款项
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,handling_charges_comm_payable -- 应付手续费及佣金
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,dvd_payable -- 应付股利
    ,oth_payable -- 其他应付款
    ,acc_exp -- 预提费用
    ,deferred_inc -- 递延收益
    ,st_bonds_payable -- 应付短期债券
    ,payable_to_reinsurer -- 应付分保账款
    ,rsrv_insur_cont -- 保险合同准备金
    ,acting_trading_sec -- 代理买卖证券款
    ,acting_uw_sec -- 代理承销证券款
    ,non_cur_liab_due_within_1y -- 一年内到期的非流动负债
    ,oth_cur_liab -- 其他流动负债
    ,tot_cur_liab -- 流动负债合计
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,lt_payable -- 长期应付款
    ,specific_item_payable -- 专项应付款
    ,provisions -- 预计负债
    ,deferred_tax_liab -- 递延所得税负债
    ,deferred_inc_non_cur_liab -- 递延收益-非流动负债
    ,oth_non_cur_liab -- 其他非流动负债
    ,tot_non_cur_liab -- 非流动负债合计
    ,liab_dep_oth_banks_fin_inst -- 同业和其它金融机构存放款项
    ,derivative_fin_liab -- 衍生金融负债
    ,cust_bank_dep -- 吸收存款
    ,agency_bus_liab -- 代理业务负债
    ,oth_liab -- 其他负债
    ,prem_received_adv -- 预收保费
    ,deposit_received -- 存入保证金
    ,insured_deposit_invest -- 保户储金及投资款
    ,unearned_prem_rsrv -- 未到期责任准备金
    ,out_loss_rsrv -- 未决赔款准备金
    ,life_insur_rsrv -- 寿险责任准备金
    ,lt_health_insur_v -- 长期健康险责任准备金
    ,independent_acct_liab -- 独立账户负债
    ,incl_pledge_loan -- 其中:质押借款
    ,claims_payable -- 应付赔付款
    ,dvd_payable_insured -- 应付保单红利
    ,tot_liab -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,special_rsrv -- 专项储备
    ,surplus_rsrv -- 盈余公积金
    ,undistributed_profit -- 未分配利润
    ,less_tsy_stk -- 减:库存股
    ,prov_nom_risks -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,comp_type_code -- 公司类型代码
    ,actual_ann_dt -- 实际公告日期
    ,spe_cur_assets_diff -- 流动资产差额(特殊报表科目)
    ,tot_cur_assets_diff -- 流动资产差额(合计平衡项目)
    ,spe_non_cur_assets_diff -- 非流动资产差额(特殊报表科目)
    ,tot_non_cur_assets_diff -- 非流动资产差额(合计平衡项目)
    ,spe_bal_assets_diff -- 资产差额(特殊报表科目)
    ,tot_bal_assets_diff -- 资产差额(合计平衡项目)
    ,spe_cur_liab_diff -- 流动负债差额(特殊报表科目)
    ,tot_cur_liab_diff -- 流动负债差额(合计平衡项目)
    ,spe_non_cur_liab_diff -- 非流动负债差额(特殊报表科目)
    ,tot_non_cur_liab_diff -- 非流动负债差额(合计平衡项目)
    ,spe_bal_liab_diff -- 负债差额(特殊报表科目)
    ,tot_bal_liab_diff -- 负债差额(合计平衡项目)
    ,spe_bal_shrhldr_eqy_diff -- 股东权益差额(特殊报表科目)
    ,tot_bal_shrhldr_eqy_diff -- 股东权益差额(合计平衡项目)
    ,spe_bal_liab_eqy_diff -- 负债及股东权益差额(特殊报表项目)
    ,tot_bal_liab_eqy_diff -- 负债及股东权益差额(合计平衡项目)
    ,lt_payroll_payable -- 长期应付职工薪酬
    ,other_comp_income -- 其他综合收益
    ,other_equity_tools -- 其他权益工具
    ,other_equity_tools_p_shr -- 其他权益工具:优先股
    ,lending_funds -- 融出资金
    ,accounts_receivable -- 应收款项
    ,st_financing_payable -- 应付短期融资款
    ,payables -- 应付款项
    ,s_info_compcode -- 公司ID
    ,tot_shr -- 期末总股本
    ,hfs_assets -- 持有待售的资产
    ,hfs_sales -- 持有待售的负债
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(s_info_windcode), ' ') as s_info_windcode -- Wind代码
    ,nvl(trim(wind_code), ' ') as wind_code -- Wind代码
    ,nvl(trim(ann_dt), ' ') as ann_dt -- 公告日期
    ,nvl(trim(report_period), ' ') as report_period -- 报告期
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(monetary_cap), 0) as monetary_cap -- 货币资金
    ,nvl(trim(tradable_fin_assets), 0) as tradable_fin_assets -- 交易性金融资产
    ,nvl(trim(notes_rcv), 0) as notes_rcv -- 应收票据
    ,nvl(trim(acct_rcv), 0) as acct_rcv -- 应收账款
    ,nvl(trim(oth_rcv), 0) as oth_rcv -- 其他应收款
    ,nvl(trim(prepay), 0) as prepay -- 预付款项
    ,nvl(trim(dvd_rcv), 0) as dvd_rcv -- 应收股利
    ,nvl(trim(int_rcv), 0) as int_rcv -- 应收利息
    ,nvl(trim(inventories), 0) as inventories -- 存货
    ,nvl(trim(consumptive_bio_assets), 0) as consumptive_bio_assets -- 消耗性生物资产
    ,nvl(trim(deferred_exp), 0) as deferred_exp -- 待摊费用
    ,nvl(trim(non_cur_assets_due_within_1y), 0) as non_cur_assets_due_within_1y -- 一年内到期的非流动资产
    ,nvl(trim(settle_rsrv), 0) as settle_rsrv -- 结算备付金
    ,nvl(trim(loans_to_oth_banks), 0) as loans_to_oth_banks -- 拆出资金
    ,nvl(trim(prem_rcv), 0) as prem_rcv -- 应收保费
    ,nvl(trim(rcv_from_reinsurer), 0) as rcv_from_reinsurer -- 应收分保账款
    ,nvl(trim(rcv_from_ceded_insur_cont_rsrv), 0) as rcv_from_ceded_insur_cont_rsrv -- 应收分保合同准备金
    ,nvl(trim(red_monetary_cap_for_sale), 0) as red_monetary_cap_for_sale -- 买入返售金融资产
    ,nvl(trim(oth_cur_assets), 0) as oth_cur_assets -- 其他流动资产
    ,nvl(trim(tot_cur_assets), 0) as tot_cur_assets -- 流动资产合计
    ,nvl(trim(fin_assets_avail_for_sale), 0) as fin_assets_avail_for_sale -- 可供出售金融资产
    ,nvl(trim(held_to_mty_invest), 0) as held_to_mty_invest -- 持有至到期投资
    ,nvl(trim(long_term_eqy_invest), 0) as long_term_eqy_invest -- 长期股权投资
    ,nvl(trim(invest_real_estate), 0) as invest_real_estate -- 投资性房地产
    ,nvl(trim(time_deposits), 0) as time_deposits -- 定期存款
    ,nvl(trim(oth_assets), 0) as oth_assets -- 其他资产
    ,nvl(trim(long_term_rec), 0) as long_term_rec -- 长期应收款
    ,nvl(trim(fix_assets), 0) as fix_assets -- 固定资产
    ,nvl(trim(const_in_prog), 0) as const_in_prog -- 在建工程
    ,nvl(trim(proj_matl), 0) as proj_matl -- 工程物资
    ,nvl(trim(fix_assets_disp), 0) as fix_assets_disp -- 固定资产清理
    ,nvl(trim(productive_bio_assets), 0) as productive_bio_assets -- 生产性生物资产
    ,nvl(trim(oil_and_natural_gas_assets), 0) as oil_and_natural_gas_assets -- 油气资产
    ,nvl(trim(intang_assets), 0) as intang_assets -- 无形资产
    ,nvl(trim(r_and_d_costs), 0) as r_and_d_costs -- 开发支出
    ,nvl(trim(goodwill), 0) as goodwill -- 商誉
    ,nvl(trim(long_term_deferred_exp), 0) as long_term_deferred_exp -- 长期待摊费用
    ,nvl(trim(deferred_tax_assets), 0) as deferred_tax_assets -- 递延所得税资产
    ,nvl(trim(loans_and_adv_granted), 0) as loans_and_adv_granted -- 发放贷款及垫款
    ,nvl(trim(oth_non_cur_assets), 0) as oth_non_cur_assets -- 其他非流动资产
    ,nvl(trim(tot_non_cur_assets), 0) as tot_non_cur_assets -- 非流动资产合计
    ,nvl(trim(cash_deposits_central_bank), 0) as cash_deposits_central_bank -- 现金及存放中央银行款项
    ,nvl(trim(asset_dep_oth_banks_fin_inst), 0) as asset_dep_oth_banks_fin_inst -- 存放同业和其它金融机构款项
    ,nvl(trim(precious_metals), 0) as precious_metals -- 贵金属
    ,nvl(trim(derivative_fin_assets), 0) as derivative_fin_assets -- 衍生金融资产
    ,nvl(trim(agency_bus_assets), 0) as agency_bus_assets -- 代理业务资产
    ,nvl(trim(subr_rec), 0) as subr_rec -- 应收代位追偿款
    ,nvl(trim(rcv_ceded_unearned_prem_rsrv), 0) as rcv_ceded_unearned_prem_rsrv -- 应收分保未到期责任准备金
    ,nvl(trim(rcv_ceded_claim_rsrv), 0) as rcv_ceded_claim_rsrv -- 应收分保未决赔款准备金
    ,nvl(trim(rcv_ceded_life_insur_rsrv), 0) as rcv_ceded_life_insur_rsrv -- 应收分保寿险责任准备金
    ,nvl(trim(rcv_ceded_lt_health_insur_rsrv), 0) as rcv_ceded_lt_health_insur_rsrv -- 应收分保长期健康险责任准备金
    ,nvl(trim(mrgn_paid), 0) as mrgn_paid -- 存出保证金
    ,nvl(trim(insured_pledge_loan), 0) as insured_pledge_loan -- 保户质押贷款
    ,nvl(trim(cap_mrgn_paid), 0) as cap_mrgn_paid -- 存出资本保证金
    ,nvl(trim(independent_acct_assets), 0) as independent_acct_assets -- 独立账户资产
    ,nvl(trim(clients_cap_deposit), 0) as clients_cap_deposit -- 客户资金存款
    ,nvl(trim(clients_rsrv_settle), 0) as clients_rsrv_settle -- 客户备付金
    ,nvl(trim(incl_seat_fees_exchange), 0) as incl_seat_fees_exchange -- 其中:交易席位费
    ,nvl(trim(rcv_invest), 0) as rcv_invest -- 应收款项类投资
    ,nvl(trim(tot_assets), 0) as tot_assets -- 资产总计
    ,nvl(trim(st_borrow), 0) as st_borrow -- 短期借款
    ,nvl(trim(borrow_central_bank), 0) as borrow_central_bank -- 向中央银行借款
    ,nvl(trim(deposit_received_ib_deposits), 0) as deposit_received_ib_deposits -- 吸收存款及同业存放
    ,nvl(trim(loans_oth_banks), 0) as loans_oth_banks -- 拆入资金
    ,nvl(trim(tradable_fin_liab), 0) as tradable_fin_liab -- 交易性金融负债
    ,nvl(trim(notes_payable), 0) as notes_payable -- 应付票据
    ,nvl(trim(acct_payable), 0) as acct_payable -- 应付账款
    ,nvl(trim(adv_from_cust), 0) as adv_from_cust -- 预收款项
    ,nvl(trim(fund_sales_fin_assets_rp), 0) as fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,nvl(trim(handling_charges_comm_payable), 0) as handling_charges_comm_payable -- 应付手续费及佣金
    ,nvl(trim(empl_ben_payable), 0) as empl_ben_payable -- 应付职工薪酬
    ,nvl(trim(taxes_surcharges_payable), 0) as taxes_surcharges_payable -- 应交税费
    ,nvl(trim(int_payable), 0) as int_payable -- 应付利息
    ,nvl(trim(dvd_payable), 0) as dvd_payable -- 应付股利
    ,nvl(trim(oth_payable), 0) as oth_payable -- 其他应付款
    ,nvl(trim(acc_exp), 0) as acc_exp -- 预提费用
    ,nvl(trim(deferred_inc), 0) as deferred_inc -- 递延收益
    ,nvl(trim(st_bonds_payable), 0) as st_bonds_payable -- 应付短期债券
    ,nvl(trim(payable_to_reinsurer), 0) as payable_to_reinsurer -- 应付分保账款
    ,nvl(trim(rsrv_insur_cont), 0) as rsrv_insur_cont -- 保险合同准备金
    ,nvl(trim(acting_trading_sec), 0) as acting_trading_sec -- 代理买卖证券款
    ,nvl(trim(acting_uw_sec), 0) as acting_uw_sec -- 代理承销证券款
    ,nvl(trim(non_cur_liab_due_within_1y), 0) as non_cur_liab_due_within_1y -- 一年内到期的非流动负债
    ,nvl(trim(oth_cur_liab), 0) as oth_cur_liab -- 其他流动负债
    ,nvl(trim(tot_cur_liab), 0) as tot_cur_liab -- 流动负债合计
    ,nvl(trim(lt_borrow), 0) as lt_borrow -- 长期借款
    ,nvl(trim(bonds_payable), 0) as bonds_payable -- 应付债券
    ,nvl(trim(lt_payable), 0) as lt_payable -- 长期应付款
    ,nvl(trim(specific_item_payable), 0) as specific_item_payable -- 专项应付款
    ,nvl(trim(provisions), 0) as provisions -- 预计负债
    ,nvl(trim(deferred_tax_liab), 0) as deferred_tax_liab -- 递延所得税负债
    ,nvl(trim(deferred_inc_non_cur_liab), 0) as deferred_inc_non_cur_liab -- 递延收益-非流动负债
    ,nvl(trim(oth_non_cur_liab), 0) as oth_non_cur_liab -- 其他非流动负债
    ,nvl(trim(tot_non_cur_liab), 0) as tot_non_cur_liab -- 非流动负债合计
    ,nvl(trim(liab_dep_oth_banks_fin_inst), 0) as liab_dep_oth_banks_fin_inst -- 同业和其它金融机构存放款项
    ,nvl(trim(derivative_fin_liab), 0) as derivative_fin_liab -- 衍生金融负债
    ,nvl(trim(cust_bank_dep), 0) as cust_bank_dep -- 吸收存款
    ,nvl(trim(agency_bus_liab), 0) as agency_bus_liab -- 代理业务负债
    ,nvl(trim(oth_liab), 0) as oth_liab -- 其他负债
    ,nvl(trim(prem_received_adv), 0) as prem_received_adv -- 预收保费
    ,nvl(trim(deposit_received), 0) as deposit_received -- 存入保证金
    ,nvl(trim(insured_deposit_invest), 0) as insured_deposit_invest -- 保户储金及投资款
    ,nvl(trim(unearned_prem_rsrv), 0) as unearned_prem_rsrv -- 未到期责任准备金
    ,nvl(trim(out_loss_rsrv), 0) as out_loss_rsrv -- 未决赔款准备金
    ,nvl(trim(life_insur_rsrv), 0) as life_insur_rsrv -- 寿险责任准备金
    ,nvl(trim(lt_health_insur_v), 0) as lt_health_insur_v -- 长期健康险责任准备金
    ,nvl(trim(independent_acct_liab), 0) as independent_acct_liab -- 独立账户负债
    ,nvl(trim(incl_pledge_loan), 0) as incl_pledge_loan -- 其中:质押借款
    ,nvl(trim(claims_payable), 0) as claims_payable -- 应付赔付款
    ,nvl(trim(dvd_payable_insured), 0) as dvd_payable_insured -- 应付保单红利
    ,nvl(trim(tot_liab), 0) as tot_liab -- 负债合计
    ,nvl(trim(cap_stk), 0) as cap_stk -- 股本
    ,nvl(trim(cap_rsrv), 0) as cap_rsrv -- 资本公积金
    ,nvl(trim(special_rsrv), 0) as special_rsrv -- 专项储备
    ,nvl(trim(surplus_rsrv), 0) as surplus_rsrv -- 盈余公积金
    ,nvl(trim(undistributed_profit), 0) as undistributed_profit -- 未分配利润
    ,nvl(trim(less_tsy_stk), 0) as less_tsy_stk -- 减:库存股
    ,nvl(trim(prov_nom_risks), 0) as prov_nom_risks -- 一般风险准备
    ,nvl(trim(cnvd_diff_foreign_curr_stat), 0) as cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,nvl(trim(unconfirmed_invest_loss), 0) as unconfirmed_invest_loss -- 未确认的投资损失
    ,nvl(trim(minority_int), 0) as minority_int -- 少数股东权益
    ,nvl(trim(tot_shrhldr_eqy_excl_min_int), 0) as tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,nvl(trim(tot_shrhldr_eqy_incl_min_int), 0) as tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,nvl(trim(tot_liab_shrhldr_eqy), 0) as tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,nvl(trim(comp_type_code), ' ') as comp_type_code -- 公司类型代码
    ,nvl(trim(actual_ann_dt), ' ') as actual_ann_dt -- 实际公告日期
    ,nvl(trim(spe_cur_assets_diff), 0) as spe_cur_assets_diff -- 流动资产差额(特殊报表科目)
    ,nvl(trim(tot_cur_assets_diff), 0) as tot_cur_assets_diff -- 流动资产差额(合计平衡项目)
    ,nvl(trim(spe_non_cur_assets_diff), 0) as spe_non_cur_assets_diff -- 非流动资产差额(特殊报表科目)
    ,nvl(trim(tot_non_cur_assets_diff), 0) as tot_non_cur_assets_diff -- 非流动资产差额(合计平衡项目)
    ,nvl(trim(spe_bal_assets_diff), 0) as spe_bal_assets_diff -- 资产差额(特殊报表科目)
    ,nvl(trim(tot_bal_assets_diff), 0) as tot_bal_assets_diff -- 资产差额(合计平衡项目)
    ,nvl(trim(spe_cur_liab_diff), 0) as spe_cur_liab_diff -- 流动负债差额(特殊报表科目)
    ,nvl(trim(tot_cur_liab_diff), 0) as tot_cur_liab_diff -- 流动负债差额(合计平衡项目)
    ,nvl(trim(spe_non_cur_liab_diff), 0) as spe_non_cur_liab_diff -- 非流动负债差额(特殊报表科目)
    ,nvl(trim(tot_non_cur_liab_diff), 0) as tot_non_cur_liab_diff -- 非流动负债差额(合计平衡项目)
    ,nvl(trim(spe_bal_liab_diff), 0) as spe_bal_liab_diff -- 负债差额(特殊报表科目)
    ,nvl(trim(tot_bal_liab_diff), 0) as tot_bal_liab_diff -- 负债差额(合计平衡项目)
    ,nvl(trim(spe_bal_shrhldr_eqy_diff), 0) as spe_bal_shrhldr_eqy_diff -- 股东权益差额(特殊报表科目)
    ,nvl(trim(tot_bal_shrhldr_eqy_diff), 0) as tot_bal_shrhldr_eqy_diff -- 股东权益差额(合计平衡项目)
    ,nvl(trim(spe_bal_liab_eqy_diff), 0) as spe_bal_liab_eqy_diff -- 负债及股东权益差额(特殊报表项目)
    ,nvl(trim(tot_bal_liab_eqy_diff), 0) as tot_bal_liab_eqy_diff -- 负债及股东权益差额(合计平衡项目)
    ,nvl(trim(lt_payroll_payable), 0) as lt_payroll_payable -- 长期应付职工薪酬
    ,nvl(trim(other_comp_income), 0) as other_comp_income -- 其他综合收益
    ,nvl(trim(other_equity_tools), 0) as other_equity_tools -- 其他权益工具
    ,nvl(trim(other_equity_tools_p_shr), 0) as other_equity_tools_p_shr -- 其他权益工具:优先股
    ,nvl(trim(lending_funds), 0) as lending_funds -- 融出资金
    ,nvl(trim(accounts_receivable), 0) as accounts_receivable -- 应收款项
    ,nvl(trim(st_financing_payable), 0) as st_financing_payable -- 应付短期融资款
    ,nvl(trim(payables), 0) as payables -- 应付款项
    ,nvl(trim(s_info_compcode), ' ') as s_info_compcode -- 公司ID
    ,nvl(trim(tot_shr), 0) as tot_shr -- 期末总股本
    ,nvl(trim(hfs_assets), 0) as hfs_assets -- 持有待售的资产
    ,nvl(trim(hfs_sales), 0) as hfs_sales -- 持有待售的负债
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_asharebalancesheet
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_asharebalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);