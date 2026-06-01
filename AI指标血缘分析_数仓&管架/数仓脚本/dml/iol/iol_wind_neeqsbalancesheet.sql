/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_neeqsbalancesheet
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_neeqsbalancesheet_ex purge;
alter table ${iol_schema}.wind_neeqsbalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_neeqsbalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_neeqsbalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_neeqsbalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_neeqsbalancesheet_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
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
    ,incl_seat_fees_exchange -- 其中：交易席位费
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
    ,incl_pledge_loan -- 其中：质押借款
    ,claims_payable -- 应付赔付款
    ,dvd_payable_insured -- 应付保单红利
    ,tot_liab -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,special_rsrv -- 专项储备
    ,surplus_rsrv -- 盈余公积金
    ,undistributed_profit -- 未分配利润
    ,less_tsy_stk -- 减：库存股
    ,prov_nom_risks -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,comp_type_code -- 公司类型代码
    ,actual_ann_dt -- [内部]实际公告日期
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
    ,hfs_assets -- 划分为持有待售的资产
    ,hfs_sales -- 划分为持有待售的负债
    ,lt_payroll_payable -- 长期应付职工薪酬
    ,other_comp_income -- 其他综合收益
    ,other_equity_tools -- 其他权益工具
    ,other_equity_tools_p_shr -- 其他权益工具:优先股
    ,lending_funds -- 融出资金
    ,accounts_receivable -- 应收款项
    ,st_financing_payable -- 应付短期融资款
    ,payables -- 应付款项
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
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
    ,incl_seat_fees_exchange -- 其中：交易席位费
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
    ,incl_pledge_loan -- 其中：质押借款
    ,claims_payable -- 应付赔付款
    ,dvd_payable_insured -- 应付保单红利
    ,tot_liab -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,special_rsrv -- 专项储备
    ,surplus_rsrv -- 盈余公积金
    ,undistributed_profit -- 未分配利润
    ,less_tsy_stk -- 减：库存股
    ,prov_nom_risks -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,comp_type_code -- 公司类型代码
    ,actual_ann_dt -- [内部]实际公告日期
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
    ,hfs_assets -- 划分为持有待售的资产
    ,hfs_sales -- 划分为持有待售的负债
    ,lt_payroll_payable -- 长期应付职工薪酬
    ,other_comp_income -- 其他综合收益
    ,other_equity_tools -- 其他权益工具
    ,other_equity_tools_p_shr -- 其他权益工具:优先股
    ,lending_funds -- 融出资金
    ,accounts_receivable -- 应收款项
    ,st_financing_payable -- 应付短期融资款
    ,payables -- 应付款项
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_neeqsbalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_neeqsbalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_neeqsbalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_neeqsbalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_neeqsbalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_neeqsbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);