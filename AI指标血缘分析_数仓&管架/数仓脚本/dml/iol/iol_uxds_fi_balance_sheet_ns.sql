/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_fi_balance_sheet_ns
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
drop table ${iol_schema}.uxds_fi_balance_sheet_ns_ex purge;
alter table ${iol_schema}.uxds_fi_balance_sheet_ns add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_fi_balance_sheet_ns;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_fi_balance_sheet_ns_ex nologging
compress
as
select * from ${iol_schema}.uxds_fi_balance_sheet_ns where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_fi_balance_sheet_ns_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,org_id -- 机构id
    ,org_name -- 机构名称
    ,ed -- 截止日期
    ,statement_type_code -- 报表类型编码
    ,statement_type -- 报表类型
    ,chg_seq -- 变动序号
    ,statement_format_code -- 报表格式编码
    ,statement_format -- 报表格式
    ,sas_code -- 报表会计准则编码
    ,sas -- 报表会计准则
    ,announ_seq -- 公告序号
    ,data_source_code -- 数据来源代码
    ,data_source -- 数据来源
    ,statement_source_explain -- 报表来源说明
    ,is_statement_complete -- 报表是否完整
    ,currency_code -- 货币代码
    ,is_audited -- 是否审计
    ,announcement_date -- 公告日期
    ,currency_funds -- 货币资金
    ,tradable_fnncl_assets -- 交易性金融资产
    ,bills_receivable -- 应收票据
    ,account_receivable -- 应收账款
    ,pre_payment -- 预付款项
    ,interest_receivable -- 应收利息
    ,dividend_receivable -- 应收股利
    ,othr_receivables -- 其他应收款
    ,inventory -- 存货
    ,nca_due_within_one_year -- 一年内到期的非流动资产
    ,othr_current_assets -- 其他流动资产
    ,current_assets_si -- 流动资产特殊科目
    ,current_assets_bi -- 流动资产平衡科目
    ,total_current_assets -- 流动资产合计
    ,salable_financial_assets -- 可供出售金融资产
    ,held_to_maturity_invest -- 持有至到期投资
    ,lt_receivable -- 长期应收款
    ,lt_equity_invest -- 长期股权投资
    ,invest_property -- 投资性房地产
    ,fixed_asset -- 固定资产
    ,construction_in_process -- 在建工程
    ,project_goods_and_material -- 工程物资
    ,fixed_assets_disposal -- 固定资产清理
    ,productive_biological_assets -- 生产性生物资产
    ,oil_and_gas_asset -- 油气资产
    ,intangible_assets -- 无形资产
    ,dev_expenditure -- 开发支出
    ,goodwill -- 商誉
    ,lt_deferred_expense -- 长期待摊费用
    ,dt_assets -- 递延所得税资产
    ,othr_noncurrent_assets -- 其他非流动资产
    ,noncurrent_assets_si -- 非流动资产特殊科目
    ,noncurrent_assets_bi -- 非流动资产平衡科目
    ,total_noncurrent_assets -- 非流动资产合计
    ,central_bank_cash_and_deposit -- 现金及存放中央银行款项
    ,interbank_storage -- 存放同业款项
    ,precious_metal -- 贵金属
    ,lending_fund -- 拆出资金
    ,derivative_fnncl_assets -- 衍生金融资产
    ,buy_resale_fnncl_assets -- 买入返售金融资产
    ,disbursement_loan_and_advance -- 发放贷款和垫款
    ,othr_assets -- 其他资产
    ,receivable_invest -- 应收款项类投资
    ,premium_receivable -- 应收保费
    ,subrogation_receivable -- 应收代位追偿款
    ,rein_account_receivable -- 应收分保账款
    ,rein_undue_liability_reserve -- 应收分保未到期责任准备金
    ,receivable_rein_olr -- 应收分保未决赔款准备金
    ,receivable_rein_duty_reserve -- 应收分保寿险责任准备金
    ,receivable_deposit_of_lt_hi -- 应收分保长期健康险责任准备金
    ,assured_pledge_loan -- 保户质押贷款
    ,fixed_deposit -- 定期存款
    ,paid_capital_deposit -- 存出资本保证金
    ,separate_account -- 独立账户资产
    ,customer_fund_deposit -- 其中：客户资金存款
    ,settle_reserves -- 结算备付金
    ,customer_provision -- 其中：客户备付金
    ,paid_deposit -- 存出保证金
    ,td_seat_fee -- 其中：交易席位费
    ,asset_si -- 资产特殊科目
    ,asset_bi -- 资产平衡科目
    ,total_assets -- 资产总计
    ,st_loan -- 短期借款
    ,tradable_fnncl_liab -- 交易性金融负债
    ,bill_payable -- 应付票据
    ,accounts_payable -- 应付账款
    ,pre_receivable -- 预收款项
    ,payroll_payable -- 应付职工薪酬
    ,tax_payable -- 应交税费
    ,interest_payable -- 应付利息
    ,dividend_payable -- 应付股利
    ,othr_payables -- 其他应付款
    ,noncurrent_liab_due_in1y -- 一年内到期的非流动负债
    ,othr_current_liab -- 其他流动负债
    ,current_liab_si -- 流动负债特殊科目
    ,current_liab_bi -- 流动负债平衡科目
    ,total_current_liab -- 流动负债合计
    ,lt_loan -- 长期借款
    ,bond_payable -- 应付债券
    ,lt_payable -- 长期应付款
    ,special_payable -- 专项应付款
    ,estimated_liab -- 预计负债
    ,dt_liab -- 递延所得税负债
    ,othr_non_current_liab -- 其他非流动负债
    ,noncurrent_liab_si -- 非流动负债特殊科目
    ,noncurrent_liab_bi -- 非流动负债平衡科目
    ,total_noncurrent_liab -- 非流动负债合计
    ,loan_from_central_bank -- 向中央银行借款
    ,interbank_deposit_etc -- 同业及其他金融机构存放款项
    ,borrowing_funds -- 拆入资金
    ,derivative_fnncl_liab -- 衍生金融负债
    ,fnncl_assets_sold_for_repur -- 卖出回购金融资产款
    ,savings_absorption -- 吸收存款
    ,othr_liab -- 其他负债
    ,advance_premium -- 预收保费
    ,charge_and_commi_payable -- 应付手续费及佣金
    ,rein_payable -- 应付分保账款
    ,claim_payable -- 应付赔付款
    ,dvdnd_payable_for_the_insured -- 应付保单红利
    ,assured_saving_and_invest -- 保户储金及投资款
    ,unearned_premium_reserve -- 未到期责任准备金
    ,reserve_for_outstanding_losses -- 未决赔款准备金
    ,life_insurance_reserve -- 寿险责任准备金
    ,lt_health_insurance_reserve -- 长期健康险责任准备金
    ,independent_account_liab -- 独立账户负债
    ,pledged_loan -- 其中：质押借款
    ,acting_td_sec -- 代理买卖证券款
    ,act_underwriting_sec -- 代理承销证券款
    ,liab_si -- 负债特殊科目
    ,liab_bi -- 负债平衡科目
    ,total_liab -- 负债合计
    ,shares -- 股本
    ,capital_reserve -- 资本公积
    ,treasury_stock -- 减：库存股
    ,special_reserve -- 专项储备
    ,earned_surplus -- 盈余公积
    ,general_risk_provision -- 一般风险准备
    ,td_risk_preparation -- 交易风险准备
    ,undstrbtd_profit -- 未分配利润
    ,frgn_currency_convert_diff -- 外币报表折算差额
    ,holders_equity_si -- 股东权益特殊科目
    ,holders_equity_bi -- 股东权益平衡科目
    ,total_quity_atsopc -- 归属于母公司股东权益合计
    ,minority_equity -- 少数股东权益
    ,total_holders_equity -- 股东权益合计
    ,total_liab_and_holders_equity -- 负债和股东权益总计
    ,is_statement_released_values -- 报表是否公布值
    ,special_explain -- 特殊情况说明
    ,shares_num -- 股本总数
    ,rein_contract_reserve -- 应收分保合同准备金
    ,saving_and_interbank_deposit -- 吸收存款及同业存放
    ,insurance_contract_reserve -- 保险合同准备金
    ,current_liab_di -- 流动负债递延收益
    ,st_bond_payable -- 应付短期债券
    ,noncurrent_liab_di -- 非流动负债递延收益
    ,received_deposit -- 存入保证金
    ,financing_funds -- 融出资金
    ,receivable -- 应收款项
    ,st_financing_payable -- 应付短期融资款
    ,accrued_payable -- 应付款项
    ,othr_compre_income -- 其他综合收益
    ,lt_staff_salary_payable -- 长期应付职工薪酬
    ,othr_equity_instruments -- 其他权益工具
    ,preferred_share -- 其中：优先股
    ,perpetual_bond -- 其中：永续债
    ,to_sale_debt -- 划分为持有待售的负债
    ,to_sale_asset -- 划分为持有待售的资产
    ,preferred_shares -- 优先股
    ,perpetual_capital_sec -- 永续债
    ,fv_chg_income_fnncl_assets -- 以公允价值计量且其变动计入其他综合收益的金融资产
    ,amortized_cost_fnncl_assets -- 以摊余成本计量的金融资产
    ,debt_invest -- 债权投资
    ,other_debt_invest -- 其他债权投资
    ,other_eq_ins_invest -- 其他权益工具投资
    ,other_illiquid_fnncl_assets -- 其他非流动金融资产
    ,contract_liabilities -- 合同负债
    ,contractual_assets -- 合同资产
    ,bp_and_ap -- 应付票据及应付账款
    ,ar_and_br -- 应收票据及应收账款
    ,lt_payable_sum -- 长期应付款合计
    ,construction_in_process_sum -- 在建工程合计
    ,fixed_asset_sum -- 固定资产合计
    ,other_receivables_sum -- 其它应收款合计
    ,other_payables_sum -- 其它应付款合计
    ,use_right_asset -- 使用权资产
    ,receivable_financing -- 应收款项融资
    ,lease_debt -- 租赁负债
    ,total_quity_atsopc_bi -- 归属于母公司股东权益合计平衡科目
    ,total_quity_atsopc_si -- 归属于母公司股东权益合计特殊科目
    ,agency_business_debt -- 代理业务负债
    ,agency_business_asset -- 代理业务资产
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,inventory_dscorce -- 存货：数据资源
    ,develop_exp_dscorce -- 开发支出：数据资源
    ,inta_asset_dscorce -- 无形资产：数据资源
    ,insurance_contract_debt -- 保险合同负债
    ,insurance_contract_asset -- 保险合同资产
    ,outward_reinsurance_debt -- 分出再保险合同负债
    ,outward_reinsurance_asset -- 分出再保险合同资产
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,org_id -- 机构id
    ,org_name -- 机构名称
    ,ed -- 截止日期
    ,statement_type_code -- 报表类型编码
    ,statement_type -- 报表类型
    ,chg_seq -- 变动序号
    ,statement_format_code -- 报表格式编码
    ,statement_format -- 报表格式
    ,sas_code -- 报表会计准则编码
    ,sas -- 报表会计准则
    ,announ_seq -- 公告序号
    ,data_source_code -- 数据来源代码
    ,data_source -- 数据来源
    ,statement_source_explain -- 报表来源说明
    ,is_statement_complete -- 报表是否完整
    ,currency_code -- 货币代码
    ,is_audited -- 是否审计
    ,announcement_date -- 公告日期
    ,currency_funds -- 货币资金
    ,tradable_fnncl_assets -- 交易性金融资产
    ,bills_receivable -- 应收票据
    ,account_receivable -- 应收账款
    ,pre_payment -- 预付款项
    ,interest_receivable -- 应收利息
    ,dividend_receivable -- 应收股利
    ,othr_receivables -- 其他应收款
    ,inventory -- 存货
    ,nca_due_within_one_year -- 一年内到期的非流动资产
    ,othr_current_assets -- 其他流动资产
    ,current_assets_si -- 流动资产特殊科目
    ,current_assets_bi -- 流动资产平衡科目
    ,total_current_assets -- 流动资产合计
    ,salable_financial_assets -- 可供出售金融资产
    ,held_to_maturity_invest -- 持有至到期投资
    ,lt_receivable -- 长期应收款
    ,lt_equity_invest -- 长期股权投资
    ,invest_property -- 投资性房地产
    ,fixed_asset -- 固定资产
    ,construction_in_process -- 在建工程
    ,project_goods_and_material -- 工程物资
    ,fixed_assets_disposal -- 固定资产清理
    ,productive_biological_assets -- 生产性生物资产
    ,oil_and_gas_asset -- 油气资产
    ,intangible_assets -- 无形资产
    ,dev_expenditure -- 开发支出
    ,goodwill -- 商誉
    ,lt_deferred_expense -- 长期待摊费用
    ,dt_assets -- 递延所得税资产
    ,othr_noncurrent_assets -- 其他非流动资产
    ,noncurrent_assets_si -- 非流动资产特殊科目
    ,noncurrent_assets_bi -- 非流动资产平衡科目
    ,total_noncurrent_assets -- 非流动资产合计
    ,central_bank_cash_and_deposit -- 现金及存放中央银行款项
    ,interbank_storage -- 存放同业款项
    ,precious_metal -- 贵金属
    ,lending_fund -- 拆出资金
    ,derivative_fnncl_assets -- 衍生金融资产
    ,buy_resale_fnncl_assets -- 买入返售金融资产
    ,disbursement_loan_and_advance -- 发放贷款和垫款
    ,othr_assets -- 其他资产
    ,receivable_invest -- 应收款项类投资
    ,premium_receivable -- 应收保费
    ,subrogation_receivable -- 应收代位追偿款
    ,rein_account_receivable -- 应收分保账款
    ,rein_undue_liability_reserve -- 应收分保未到期责任准备金
    ,receivable_rein_olr -- 应收分保未决赔款准备金
    ,receivable_rein_duty_reserve -- 应收分保寿险责任准备金
    ,receivable_deposit_of_lt_hi -- 应收分保长期健康险责任准备金
    ,assured_pledge_loan -- 保户质押贷款
    ,fixed_deposit -- 定期存款
    ,paid_capital_deposit -- 存出资本保证金
    ,separate_account -- 独立账户资产
    ,customer_fund_deposit -- 其中：客户资金存款
    ,settle_reserves -- 结算备付金
    ,customer_provision -- 其中：客户备付金
    ,paid_deposit -- 存出保证金
    ,td_seat_fee -- 其中：交易席位费
    ,asset_si -- 资产特殊科目
    ,asset_bi -- 资产平衡科目
    ,total_assets -- 资产总计
    ,st_loan -- 短期借款
    ,tradable_fnncl_liab -- 交易性金融负债
    ,bill_payable -- 应付票据
    ,accounts_payable -- 应付账款
    ,pre_receivable -- 预收款项
    ,payroll_payable -- 应付职工薪酬
    ,tax_payable -- 应交税费
    ,interest_payable -- 应付利息
    ,dividend_payable -- 应付股利
    ,othr_payables -- 其他应付款
    ,noncurrent_liab_due_in1y -- 一年内到期的非流动负债
    ,othr_current_liab -- 其他流动负债
    ,current_liab_si -- 流动负债特殊科目
    ,current_liab_bi -- 流动负债平衡科目
    ,total_current_liab -- 流动负债合计
    ,lt_loan -- 长期借款
    ,bond_payable -- 应付债券
    ,lt_payable -- 长期应付款
    ,special_payable -- 专项应付款
    ,estimated_liab -- 预计负债
    ,dt_liab -- 递延所得税负债
    ,othr_non_current_liab -- 其他非流动负债
    ,noncurrent_liab_si -- 非流动负债特殊科目
    ,noncurrent_liab_bi -- 非流动负债平衡科目
    ,total_noncurrent_liab -- 非流动负债合计
    ,loan_from_central_bank -- 向中央银行借款
    ,interbank_deposit_etc -- 同业及其他金融机构存放款项
    ,borrowing_funds -- 拆入资金
    ,derivative_fnncl_liab -- 衍生金融负债
    ,fnncl_assets_sold_for_repur -- 卖出回购金融资产款
    ,savings_absorption -- 吸收存款
    ,othr_liab -- 其他负债
    ,advance_premium -- 预收保费
    ,charge_and_commi_payable -- 应付手续费及佣金
    ,rein_payable -- 应付分保账款
    ,claim_payable -- 应付赔付款
    ,dvdnd_payable_for_the_insured -- 应付保单红利
    ,assured_saving_and_invest -- 保户储金及投资款
    ,unearned_premium_reserve -- 未到期责任准备金
    ,reserve_for_outstanding_losses -- 未决赔款准备金
    ,life_insurance_reserve -- 寿险责任准备金
    ,lt_health_insurance_reserve -- 长期健康险责任准备金
    ,independent_account_liab -- 独立账户负债
    ,pledged_loan -- 其中：质押借款
    ,acting_td_sec -- 代理买卖证券款
    ,act_underwriting_sec -- 代理承销证券款
    ,liab_si -- 负债特殊科目
    ,liab_bi -- 负债平衡科目
    ,total_liab -- 负债合计
    ,shares -- 股本
    ,capital_reserve -- 资本公积
    ,treasury_stock -- 减：库存股
    ,special_reserve -- 专项储备
    ,earned_surplus -- 盈余公积
    ,general_risk_provision -- 一般风险准备
    ,td_risk_preparation -- 交易风险准备
    ,undstrbtd_profit -- 未分配利润
    ,frgn_currency_convert_diff -- 外币报表折算差额
    ,holders_equity_si -- 股东权益特殊科目
    ,holders_equity_bi -- 股东权益平衡科目
    ,total_quity_atsopc -- 归属于母公司股东权益合计
    ,minority_equity -- 少数股东权益
    ,total_holders_equity -- 股东权益合计
    ,total_liab_and_holders_equity -- 负债和股东权益总计
    ,is_statement_released_values -- 报表是否公布值
    ,special_explain -- 特殊情况说明
    ,shares_num -- 股本总数
    ,rein_contract_reserve -- 应收分保合同准备金
    ,saving_and_interbank_deposit -- 吸收存款及同业存放
    ,insurance_contract_reserve -- 保险合同准备金
    ,current_liab_di -- 流动负债递延收益
    ,st_bond_payable -- 应付短期债券
    ,noncurrent_liab_di -- 非流动负债递延收益
    ,received_deposit -- 存入保证金
    ,financing_funds -- 融出资金
    ,receivable -- 应收款项
    ,st_financing_payable -- 应付短期融资款
    ,accrued_payable -- 应付款项
    ,othr_compre_income -- 其他综合收益
    ,lt_staff_salary_payable -- 长期应付职工薪酬
    ,othr_equity_instruments -- 其他权益工具
    ,preferred_share -- 其中：优先股
    ,perpetual_bond -- 其中：永续债
    ,to_sale_debt -- 划分为持有待售的负债
    ,to_sale_asset -- 划分为持有待售的资产
    ,preferred_shares -- 优先股
    ,perpetual_capital_sec -- 永续债
    ,fv_chg_income_fnncl_assets -- 以公允价值计量且其变动计入其他综合收益的金融资产
    ,amortized_cost_fnncl_assets -- 以摊余成本计量的金融资产
    ,debt_invest -- 债权投资
    ,other_debt_invest -- 其他债权投资
    ,other_eq_ins_invest -- 其他权益工具投资
    ,other_illiquid_fnncl_assets -- 其他非流动金融资产
    ,contract_liabilities -- 合同负债
    ,contractual_assets -- 合同资产
    ,bp_and_ap -- 应付票据及应付账款
    ,ar_and_br -- 应收票据及应收账款
    ,lt_payable_sum -- 长期应付款合计
    ,construction_in_process_sum -- 在建工程合计
    ,fixed_asset_sum -- 固定资产合计
    ,other_receivables_sum -- 其它应收款合计
    ,other_payables_sum -- 其它应付款合计
    ,use_right_asset -- 使用权资产
    ,receivable_financing -- 应收款项融资
    ,lease_debt -- 租赁负债
    ,total_quity_atsopc_bi -- 归属于母公司股东权益合计平衡科目
    ,total_quity_atsopc_si -- 归属于母公司股东权益合计特殊科目
    ,agency_business_debt -- 代理业务负债
    ,agency_business_asset -- 代理业务资产
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,inventory_dscorce -- 存货：数据资源
    ,develop_exp_dscorce -- 开发支出：数据资源
    ,inta_asset_dscorce -- 无形资产：数据资源
    ,insurance_contract_debt -- 保险合同负债
    ,insurance_contract_asset -- 保险合同资产
    ,outward_reinsurance_debt -- 分出再保险合同负债
    ,outward_reinsurance_asset -- 分出再保险合同资产
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_fi_balance_sheet_ns
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_fi_balance_sheet_ns exchange partition p_${batch_date} with table ${iol_schema}.uxds_fi_balance_sheet_ns_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_fi_balance_sheet_ns to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_fi_balance_sheet_ns_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_fi_balance_sheet_ns',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);