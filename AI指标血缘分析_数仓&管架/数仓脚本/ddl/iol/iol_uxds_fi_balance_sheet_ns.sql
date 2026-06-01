/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_fi_balance_sheet_ns
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_fi_balance_sheet_ns
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_fi_balance_sheet_ns purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_fi_balance_sheet_ns(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,org_id varchar2(60) -- 机构id
    ,org_name varchar2(600) -- 机构名称
    ,ed date -- 截止日期
    ,statement_type_code varchar2(36) -- 报表类型编码
    ,statement_type varchar2(120) -- 报表类型
    ,chg_seq number(3,0) -- 变动序号
    ,statement_format_code varchar2(36) -- 报表格式编码
    ,statement_format varchar2(120) -- 报表格式
    ,sas_code varchar2(36) -- 报表会计准则编码
    ,sas varchar2(120) -- 报表会计准则
    ,announ_seq number(20,0) -- 公告序号
    ,data_source_code varchar2(36) -- 数据来源代码
    ,data_source varchar2(120) -- 数据来源
    ,statement_source_explain varchar2(300) -- 报表来源说明
    ,is_statement_complete number(1,0) -- 报表是否完整
    ,currency_code varchar2(36) -- 货币代码
    ,is_audited number(1,0) -- 是否审计
    ,announcement_date date -- 公告日期
    ,currency_funds number(18,4) -- 货币资金
    ,tradable_fnncl_assets number(18,4) -- 交易性金融资产
    ,bills_receivable number(18,4) -- 应收票据
    ,account_receivable number(18,4) -- 应收账款
    ,pre_payment number(18,4) -- 预付款项
    ,interest_receivable number(18,4) -- 应收利息
    ,dividend_receivable number(18,4) -- 应收股利
    ,othr_receivables number(18,4) -- 其他应收款
    ,inventory number(18,4) -- 存货
    ,nca_due_within_one_year number(18,4) -- 一年内到期的非流动资产
    ,othr_current_assets number(18,4) -- 其他流动资产
    ,current_assets_si number(18,4) -- 流动资产特殊科目
    ,current_assets_bi number(18,4) -- 流动资产平衡科目
    ,total_current_assets number(18,4) -- 流动资产合计
    ,salable_financial_assets number(18,4) -- 可供出售金融资产
    ,held_to_maturity_invest number(18,4) -- 持有至到期投资
    ,lt_receivable number(18,4) -- 长期应收款
    ,lt_equity_invest number(18,4) -- 长期股权投资
    ,invest_property number(18,4) -- 投资性房地产
    ,fixed_asset number(18,4) -- 固定资产
    ,construction_in_process number(18,4) -- 在建工程
    ,project_goods_and_material number(18,4) -- 工程物资
    ,fixed_assets_disposal number(18,4) -- 固定资产清理
    ,productive_biological_assets number(18,4) -- 生产性生物资产
    ,oil_and_gas_asset number(18,4) -- 油气资产
    ,intangible_assets number(18,4) -- 无形资产
    ,dev_expenditure number(18,4) -- 开发支出
    ,goodwill number(18,4) -- 商誉
    ,lt_deferred_expense number(18,4) -- 长期待摊费用
    ,dt_assets number(18,4) -- 递延所得税资产
    ,othr_noncurrent_assets number(18,4) -- 其他非流动资产
    ,noncurrent_assets_si number(18,4) -- 非流动资产特殊科目
    ,noncurrent_assets_bi number(18,4) -- 非流动资产平衡科目
    ,total_noncurrent_assets number(18,4) -- 非流动资产合计
    ,central_bank_cash_and_deposit number(18,4) -- 现金及存放中央银行款项
    ,interbank_storage number(18,4) -- 存放同业款项
    ,precious_metal number(18,4) -- 贵金属
    ,lending_fund number(18,4) -- 拆出资金
    ,derivative_fnncl_assets number(18,4) -- 衍生金融资产
    ,buy_resale_fnncl_assets number(18,4) -- 买入返售金融资产
    ,disbursement_loan_and_advance number(18,4) -- 发放贷款和垫款
    ,othr_assets number(18,4) -- 其他资产
    ,receivable_invest number(18,4) -- 应收款项类投资
    ,premium_receivable number(18,4) -- 应收保费
    ,subrogation_receivable number(18,4) -- 应收代位追偿款
    ,rein_account_receivable number(18,4) -- 应收分保账款
    ,rein_undue_liability_reserve number(18,4) -- 应收分保未到期责任准备金
    ,receivable_rein_olr number(18,4) -- 应收分保未决赔款准备金
    ,receivable_rein_duty_reserve number(18,4) -- 应收分保寿险责任准备金
    ,receivable_deposit_of_lt_hi number(18,4) -- 应收分保长期健康险责任准备金
    ,assured_pledge_loan number(18,4) -- 保户质押贷款
    ,fixed_deposit number(18,4) -- 定期存款
    ,paid_capital_deposit number(18,4) -- 存出资本保证金
    ,separate_account number(18,4) -- 独立账户资产
    ,customer_fund_deposit number(18,4) -- 其中：客户资金存款
    ,settle_reserves number(18,4) -- 结算备付金
    ,customer_provision number(18,4) -- 其中：客户备付金
    ,paid_deposit number(18,4) -- 存出保证金
    ,td_seat_fee number(18,4) -- 其中：交易席位费
    ,asset_si number(18,4) -- 资产特殊科目
    ,asset_bi number(18,4) -- 资产平衡科目
    ,total_assets number(18,4) -- 资产总计
    ,st_loan number(18,4) -- 短期借款
    ,tradable_fnncl_liab number(18,4) -- 交易性金融负债
    ,bill_payable number(18,4) -- 应付票据
    ,accounts_payable number(18,4) -- 应付账款
    ,pre_receivable number(18,4) -- 预收款项
    ,payroll_payable number(18,4) -- 应付职工薪酬
    ,tax_payable number(18,4) -- 应交税费
    ,interest_payable number(18,4) -- 应付利息
    ,dividend_payable number(18,4) -- 应付股利
    ,othr_payables number(18,4) -- 其他应付款
    ,noncurrent_liab_due_in1y number(18,4) -- 一年内到期的非流动负债
    ,othr_current_liab number(18,4) -- 其他流动负债
    ,current_liab_si number(18,4) -- 流动负债特殊科目
    ,current_liab_bi number(18,4) -- 流动负债平衡科目
    ,total_current_liab number(18,4) -- 流动负债合计
    ,lt_loan number(18,4) -- 长期借款
    ,bond_payable number(18,4) -- 应付债券
    ,lt_payable number(18,4) -- 长期应付款
    ,special_payable number(18,4) -- 专项应付款
    ,estimated_liab number(18,4) -- 预计负债
    ,dt_liab number(18,4) -- 递延所得税负债
    ,othr_non_current_liab number(18,4) -- 其他非流动负债
    ,noncurrent_liab_si number(18,4) -- 非流动负债特殊科目
    ,noncurrent_liab_bi number(18,4) -- 非流动负债平衡科目
    ,total_noncurrent_liab number(18,4) -- 非流动负债合计
    ,loan_from_central_bank number(18,4) -- 向中央银行借款
    ,interbank_deposit_etc number(18,4) -- 同业及其他金融机构存放款项
    ,borrowing_funds number(18,4) -- 拆入资金
    ,derivative_fnncl_liab number(18,4) -- 衍生金融负债
    ,fnncl_assets_sold_for_repur number(18,4) -- 卖出回购金融资产款
    ,savings_absorption number(18,4) -- 吸收存款
    ,othr_liab number(18,4) -- 其他负债
    ,advance_premium number(18,4) -- 预收保费
    ,charge_and_commi_payable number(18,4) -- 应付手续费及佣金
    ,rein_payable number(18,4) -- 应付分保账款
    ,claim_payable number(18,4) -- 应付赔付款
    ,dvdnd_payable_for_the_insured number(18,4) -- 应付保单红利
    ,assured_saving_and_invest number(18,4) -- 保户储金及投资款
    ,unearned_premium_reserve number(18,4) -- 未到期责任准备金
    ,reserve_for_outstanding_losses number(18,4) -- 未决赔款准备金
    ,life_insurance_reserve number(18,4) -- 寿险责任准备金
    ,lt_health_insurance_reserve number(18,4) -- 长期健康险责任准备金
    ,independent_account_liab number(18,4) -- 独立账户负债
    ,pledged_loan number(18,4) -- 其中：质押借款
    ,acting_td_sec number(18,4) -- 代理买卖证券款
    ,act_underwriting_sec number(18,4) -- 代理承销证券款
    ,liab_si number(18,4) -- 负债特殊科目
    ,liab_bi number(18,4) -- 负债平衡科目
    ,total_liab number(18,4) -- 负债合计
    ,shares number(18,4) -- 股本
    ,capital_reserve number(18,4) -- 资本公积
    ,treasury_stock number(18,4) -- 减：库存股
    ,special_reserve number(18,4) -- 专项储备
    ,earned_surplus number(18,4) -- 盈余公积
    ,general_risk_provision number(18,4) -- 一般风险准备
    ,td_risk_preparation number(18,4) -- 交易风险准备
    ,undstrbtd_profit number(18,4) -- 未分配利润
    ,frgn_currency_convert_diff number(18,4) -- 外币报表折算差额
    ,holders_equity_si number(18,4) -- 股东权益特殊科目
    ,holders_equity_bi number(18,4) -- 股东权益平衡科目
    ,total_quity_atsopc number(18,4) -- 归属于母公司股东权益合计
    ,minority_equity number(18,4) -- 少数股东权益
    ,total_holders_equity number(18,4) -- 股东权益合计
    ,total_liab_and_holders_equity number(18,4) -- 负债和股东权益总计
    ,is_statement_released_values number(1,0) -- 报表是否公布值
    ,special_explain varchar2(4000) -- 特殊情况说明
    ,shares_num number(18,0) -- 股本总数
    ,rein_contract_reserve number(18,4) -- 应收分保合同准备金
    ,saving_and_interbank_deposit number(18,4) -- 吸收存款及同业存放
    ,insurance_contract_reserve number(18,4) -- 保险合同准备金
    ,current_liab_di number(18,4) -- 流动负债递延收益
    ,st_bond_payable number(18,4) -- 应付短期债券
    ,noncurrent_liab_di number(18,4) -- 非流动负债递延收益
    ,received_deposit number(18,4) -- 存入保证金
    ,financing_funds number(18,4) -- 融出资金
    ,receivable number(18,4) -- 应收款项
    ,st_financing_payable number(18,4) -- 应付短期融资款
    ,accrued_payable number(18,4) -- 应付款项
    ,othr_compre_income number(24,4) -- 其他综合收益
    ,lt_staff_salary_payable number(24,4) -- 长期应付职工薪酬
    ,othr_equity_instruments number(24,4) -- 其他权益工具
    ,preferred_share number(24,4) -- 其中：优先股
    ,perpetual_bond number(24,4) -- 其中：永续债
    ,to_sale_debt number(18,4) -- 划分为持有待售的负债
    ,to_sale_asset number(18,4) -- 划分为持有待售的资产
    ,preferred_shares number(18,4) -- 优先股
    ,perpetual_capital_sec number(18,4) -- 永续债
    ,fv_chg_income_fnncl_assets number(24,4) -- 以公允价值计量且其变动计入其他综合收益的金融资产
    ,amortized_cost_fnncl_assets number(24,4) -- 以摊余成本计量的金融资产
    ,debt_invest number(24,4) -- 债权投资
    ,other_debt_invest number(24,4) -- 其他债权投资
    ,other_eq_ins_invest number(24,4) -- 其他权益工具投资
    ,other_illiquid_fnncl_assets number(24,4) -- 其他非流动金融资产
    ,contract_liabilities number(24,4) -- 合同负债
    ,contractual_assets number(24,4) -- 合同资产
    ,bp_and_ap number(24,4) -- 应付票据及应付账款
    ,ar_and_br number(24,4) -- 应收票据及应收账款
    ,lt_payable_sum number(24,4) -- 长期应付款合计
    ,construction_in_process_sum number(24,4) -- 在建工程合计
    ,fixed_asset_sum number(24,4) -- 固定资产合计
    ,other_receivables_sum number(24,4) -- 其它应收款合计
    ,other_payables_sum number(24,4) -- 其它应付款合计
    ,use_right_asset number(24,4) -- 使用权资产
    ,receivable_financing number(24,4) -- 应收款项融资
    ,lease_debt number(24,4) -- 租赁负债
    ,total_quity_atsopc_bi number(24,4) -- 归属于母公司股东权益合计平衡科目
    ,total_quity_atsopc_si number(24,4) -- 归属于母公司股东权益合计特殊科目
    ,agency_business_debt number(18,4) -- 代理业务负债
    ,agency_business_asset number(18,4) -- 代理业务资产
    ,unconfirmed_invest_loss number(18,4) -- 未确认的投资损失
    ,inventory_dscorce number(24,4) -- 存货：数据资源
    ,develop_exp_dscorce number(24,4) -- 开发支出：数据资源
    ,inta_asset_dscorce number(24,4) -- 无形资产：数据资源
    ,insurance_contract_debt number(24,4) -- 保险合同负债
    ,insurance_contract_asset number(24,4) -- 保险合同资产
    ,outward_reinsurance_debt number(24,4) -- 分出再保险合同负债
    ,outward_reinsurance_asset number(24,4) -- 分出再保险合同资产
    ,isvalid number(1,0) -- 是否有效
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_fi_balance_sheet_ns to ${iml_schema};
grant select on ${iol_schema}.uxds_fi_balance_sheet_ns to ${icl_schema};
grant select on ${iol_schema}.uxds_fi_balance_sheet_ns to ${idl_schema};
grant select on ${iol_schema}.uxds_fi_balance_sheet_ns to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_fi_balance_sheet_ns is '';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.rtime is '记录同步时间';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.org_id is '机构id';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.org_name is '机构名称';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.ed is '截止日期';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.statement_type_code is '报表类型编码';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.statement_type is '报表类型';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.chg_seq is '变动序号';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.statement_format_code is '报表格式编码';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.statement_format is '报表格式';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.sas_code is '报表会计准则编码';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.sas is '报表会计准则';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.announ_seq is '公告序号';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.data_source_code is '数据来源代码';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.data_source is '数据来源';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.statement_source_explain is '报表来源说明';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.is_statement_complete is '报表是否完整';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.currency_code is '货币代码';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.is_audited is '是否审计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.currency_funds is '货币资金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.tradable_fnncl_assets is '交易性金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.bills_receivable is '应收票据';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.account_receivable is '应收账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.pre_payment is '预付款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.interest_receivable is '应收利息';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dividend_receivable is '应收股利';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_receivables is '其他应收款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.inventory is '存货';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.nca_due_within_one_year is '一年内到期的非流动资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_current_assets is '其他流动资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.current_assets_si is '流动资产特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.current_assets_bi is '流动资产平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_current_assets is '流动资产合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.salable_financial_assets is '可供出售金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.held_to_maturity_invest is '持有至到期投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_receivable is '长期应收款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_equity_invest is '长期股权投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.invest_property is '投资性房地产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fixed_asset is '固定资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.construction_in_process is '在建工程';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.project_goods_and_material is '工程物资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fixed_assets_disposal is '固定资产清理';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.productive_biological_assets is '生产性生物资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.oil_and_gas_asset is '油气资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.intangible_assets is '无形资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dev_expenditure is '开发支出';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.goodwill is '商誉';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_deferred_expense is '长期待摊费用';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dt_assets is '递延所得税资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_noncurrent_assets is '其他非流动资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_assets_si is '非流动资产特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_assets_bi is '非流动资产平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_noncurrent_assets is '非流动资产合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.central_bank_cash_and_deposit is '现金及存放中央银行款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.interbank_storage is '存放同业款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.precious_metal is '贵金属';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lending_fund is '拆出资金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.derivative_fnncl_assets is '衍生金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.buy_resale_fnncl_assets is '买入返售金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.disbursement_loan_and_advance is '发放贷款和垫款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_assets is '其他资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable_invest is '应收款项类投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.premium_receivable is '应收保费';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.subrogation_receivable is '应收代位追偿款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.rein_account_receivable is '应收分保账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.rein_undue_liability_reserve is '应收分保未到期责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable_rein_olr is '应收分保未决赔款准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable_rein_duty_reserve is '应收分保寿险责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable_deposit_of_lt_hi is '应收分保长期健康险责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.assured_pledge_loan is '保户质押贷款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fixed_deposit is '定期存款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.paid_capital_deposit is '存出资本保证金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.separate_account is '独立账户资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.customer_fund_deposit is '其中：客户资金存款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.settle_reserves is '结算备付金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.customer_provision is '其中：客户备付金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.paid_deposit is '存出保证金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.td_seat_fee is '其中：交易席位费';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.asset_si is '资产特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.asset_bi is '资产平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_assets is '资产总计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.st_loan is '短期借款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.tradable_fnncl_liab is '交易性金融负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.bill_payable is '应付票据';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.accounts_payable is '应付账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.pre_receivable is '预收款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.payroll_payable is '应付职工薪酬';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.tax_payable is '应交税费';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.interest_payable is '应付利息';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dividend_payable is '应付股利';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_payables is '其他应付款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_liab_due_in1y is '一年内到期的非流动负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_current_liab is '其他流动负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.current_liab_si is '流动负债特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.current_liab_bi is '流动负债平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_current_liab is '流动负债合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_loan is '长期借款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.bond_payable is '应付债券';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_payable is '长期应付款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.special_payable is '专项应付款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.estimated_liab is '预计负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dt_liab is '递延所得税负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_non_current_liab is '其他非流动负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_liab_si is '非流动负债特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_liab_bi is '非流动负债平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_noncurrent_liab is '非流动负债合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.loan_from_central_bank is '向中央银行借款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.interbank_deposit_etc is '同业及其他金融机构存放款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.borrowing_funds is '拆入资金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.derivative_fnncl_liab is '衍生金融负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fnncl_assets_sold_for_repur is '卖出回购金融资产款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.savings_absorption is '吸收存款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_liab is '其他负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.advance_premium is '预收保费';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.charge_and_commi_payable is '应付手续费及佣金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.rein_payable is '应付分保账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.claim_payable is '应付赔付款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.dvdnd_payable_for_the_insured is '应付保单红利';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.assured_saving_and_invest is '保户储金及投资款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.unearned_premium_reserve is '未到期责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.reserve_for_outstanding_losses is '未决赔款准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.life_insurance_reserve is '寿险责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_health_insurance_reserve is '长期健康险责任准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.independent_account_liab is '独立账户负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.pledged_loan is '其中：质押借款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.acting_td_sec is '代理买卖证券款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.act_underwriting_sec is '代理承销证券款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.liab_si is '负债特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.liab_bi is '负债平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_liab is '负债合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.shares is '股本';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.capital_reserve is '资本公积';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.treasury_stock is '减：库存股';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.special_reserve is '专项储备';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.earned_surplus is '盈余公积';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.general_risk_provision is '一般风险准备';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.td_risk_preparation is '交易风险准备';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.undstrbtd_profit is '未分配利润';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.frgn_currency_convert_diff is '外币报表折算差额';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.holders_equity_si is '股东权益特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.holders_equity_bi is '股东权益平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_quity_atsopc is '归属于母公司股东权益合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.minority_equity is '少数股东权益';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_holders_equity is '股东权益合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_liab_and_holders_equity is '负债和股东权益总计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.is_statement_released_values is '报表是否公布值';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.special_explain is '特殊情况说明';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.shares_num is '股本总数';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.rein_contract_reserve is '应收分保合同准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.saving_and_interbank_deposit is '吸收存款及同业存放';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.insurance_contract_reserve is '保险合同准备金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.current_liab_di is '流动负债递延收益';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.st_bond_payable is '应付短期债券';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.noncurrent_liab_di is '非流动负债递延收益';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.received_deposit is '存入保证金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.financing_funds is '融出资金';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable is '应收款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.st_financing_payable is '应付短期融资款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.accrued_payable is '应付款项';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_compre_income is '其他综合收益';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_staff_salary_payable is '长期应付职工薪酬';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.othr_equity_instruments is '其他权益工具';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.preferred_share is '其中：优先股';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.perpetual_bond is '其中：永续债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.to_sale_debt is '划分为持有待售的负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.to_sale_asset is '划分为持有待售的资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.preferred_shares is '优先股';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.perpetual_capital_sec is '永续债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fv_chg_income_fnncl_assets is '以公允价值计量且其变动计入其他综合收益的金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.amortized_cost_fnncl_assets is '以摊余成本计量的金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.debt_invest is '债权投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.other_debt_invest is '其他债权投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.other_eq_ins_invest is '其他权益工具投资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.other_illiquid_fnncl_assets is '其他非流动金融资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.contract_liabilities is '合同负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.contractual_assets is '合同资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.bp_and_ap is '应付票据及应付账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.ar_and_br is '应收票据及应收账款';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lt_payable_sum is '长期应付款合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.construction_in_process_sum is '在建工程合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.fixed_asset_sum is '固定资产合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.other_receivables_sum is '其它应收款合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.other_payables_sum is '其它应付款合计';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.use_right_asset is '使用权资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.receivable_financing is '应收款项融资';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.lease_debt is '租赁负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_quity_atsopc_bi is '归属于母公司股东权益合计平衡科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.total_quity_atsopc_si is '归属于母公司股东权益合计特殊科目';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.agency_business_debt is '代理业务负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.agency_business_asset is '代理业务资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.unconfirmed_invest_loss is '未确认的投资损失';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.inventory_dscorce is '存货：数据资源';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.develop_exp_dscorce is '开发支出：数据资源';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.inta_asset_dscorce is '无形资产：数据资源';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.insurance_contract_debt is '保险合同负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.insurance_contract_asset is '保险合同资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.outward_reinsurance_debt is '分出再保险合同负债';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.outward_reinsurance_asset is '分出再保险合同资产';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_fi_balance_sheet_ns.etl_timestamp is 'ETL处理时间戳';
