/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_uxds_bank_special_fnncl_indicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator(
    etl_dt date
    ,seq number(20)
    ,ctime date
    ,mtime date
    ,rtime date
    ,corp_code varchar2(60)
    ,ed date
    ,total_deposit_amt number(18,4)
    ,total_loan_amt number(18,4)
    ,loan_loss_reserve number(18,4)
    ,bad_loan_ratio number(18,4)
    ,capital_adequacy_ratio number(18,4)
    ,core_capital_adequacy_ratio number(9,3)
    ,bad_loan number(18,4)
    ,provision_coverage number(18,4)
    ,deposit_loan_ratio number(18,3)
    ,deposit_and_loan_ratio_rmb number(18,3)
    ,deposit_and_loan_ratio_fc number(18,3)
    ,st_assets_liquid_ratio number(18,3)
    ,st_asset_liquid_ratio_fc number(18,3)
    ,lending_funds_ratio number(18,3)
    ,borrowing_funds_ratio number(18,3)
    ,provision_ratio_rmb number(18,3)
    ,provision_ratio_fc number(18,3)
    ,interest_recovery number(18,4)
    ,net_interest_margin number(18,4)
    ,non_interest_income_ratio number(18,4)
    ,living_asset_avg_interest number(18,4)
    ,interest_liab_avg_interest number(18,4)
    ,loan_ratio_slc number(18,4)
    ,cost_to_income_ratio number(18,4)
    ,non_interest_liab number(18,4)
    ,non_living_asset number(18,4)
    ,net_core_capital number(18,4)
    ,interest_bearing_liab number(18,4)
    ,interest_bearing_liab_cv number(18,4)
    ,is_interest_bearing_liab_value number(1)
    ,wgt_risk_net_amt number(26,4)
    ,net_profit_margin number(18,4)
    ,net_interest_margin_cv number(18,4)
    ,is_np_margin_value number(1)
    ,np_margin_cv number(18,4)
    ,is_net_interest_margin_value number(1)
    ,interest_earning_assets number(18,4)
    ,interest_earning_assets_cv number(18,4)
    ,interest_earning_assets_value number(1)
    ,market_venture_cap number(18,4)
    ,net_capital number(18,4)
    ,top10_customer_loan_ratio number(18,4)
    ,bad_loan_ratio_third_classi number(18,4)
    ,non_interest_income number(18,4)
    ,cash_inv_cfd number(18,4)
    ,first_capital_adequacy_ratio number(18,4)
    ,core_fc_adequacy_ratio number(18,4)
    ,net_primary_capital_net_amt number(18,4)
    ,net_core_first_capital number(18,4)
    ,lcr number(24,4)
    ,leverage_ratio number(24,4)
    ,overdue_loan number(24,4)
    ,overdue_loan_ratio number(24,4)
    ,overdue_loan_of_more_than_90d number(24,4)
    ,recombine_loan number(24,4)
    ,normal_loan_migration_rate number(24,4)
    ,focused_loan_migration_rate number(24,4)
    ,subprime_loan_migration_rate number(24,4)
    ,suspicious_loan_migration_rate number(24,4)
    ,mal_loan_ratio_fc number(18,4)
    ,mal_loan_ratio_rmb number(18,4)
    ,currency_code varchar2(36)
    ,st_asset_flow_ratio number(18,4)
    ,normal_asset number(18,4)
    ,normal_asset_ratio number(9,3)
    ,special_mention_asset number(18,4)
    ,special_mention_asset_ratio number(9,3)
    ,sub_asset number(18,4)
    ,sub_asset_ratio number(9,3)
    ,doubtful_asset number(18,4)
    ,doubtful_asset_ratio number(9,3)
    ,loss_asset number(18,4)
    ,loss_asset_ratio number(9,3)
    ,bank_wproduct_balance number(18,4)
    ,credit_card_credit_limit number(18,4)
    ,issue_guarantee_letter number(18,4)
    ,issue_credit_letter number(18,4)
    ,adj_asset_balance number(18,4)
    ,loan_commitment number(18,4)
    ,acceptance_bill number(18,4)
    ,credit_risk_wgt_asset number(18,4)
    ,net_stable_funds_ratio number(18,4)
    ,available_stable_funds_ratio number(18,4)
    ,market_risk_wgt_asset number(18,4)
    ,needed_stable_funds_ratio number(18,4)
    ,prov_to_loan_ratio number(18,4)
    ,operational_risk_wgt_asset number(18,4)
    ,green_credit_balance number(18,4)
    ,isvalid number(1)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator is '银行特殊财务指标';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.seq is '记录唯一标识';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.ctime is '记录创建日期';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.mtime is '记录修改日期';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.rtime is '记录通讯到用户端日期';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.corp_code is '公司代码/关联到corp_basic_info.org_id';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.ed is '截止日期/';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.total_deposit_amt is '存款总额/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.total_loan_amt is '贷款总额/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.loan_loss_reserve is '贷款损失准备/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.bad_loan_ratio is '不良贷款率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.capital_adequacy_ratio is '资本充足率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.core_capital_adequacy_ratio is '核心资本充足率/单位：%；核心资本足率(％)= 核心资本净额／加权风险资产净额，《商业银行资本充足率管理办法》标准';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.bad_loan is '不良贷款/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.provision_coverage is '拨备覆盖率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.deposit_loan_ratio is '存贷款比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.deposit_and_loan_ratio_rmb is '存贷款比例(人民币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.deposit_and_loan_ratio_fc is '存贷款比例(外币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.st_assets_liquid_ratio is '短期资产流动性比例(人民币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.st_asset_liquid_ratio_fc is '短期资产流动性比例(外币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.lending_funds_ratio is '拆入资金比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.borrowing_funds_ratio is '拆出资金比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.provision_ratio_rmb is '备付金比例(人民币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.provision_ratio_fc is '备付金比例(外币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_recovery is '利息回收率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_interest_margin is '净息差/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.non_interest_income_ratio is '非利息收入占比/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.living_asset_avg_interest is '生息资产平均利率（%）/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_liab_avg_interest is '付息负债平均利率（%）/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.loan_ratio_slc is '单一最大客户贷款比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.cost_to_income_ratio is '成本收入比/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.non_interest_liab is '非计息负债/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.non_living_asset is '非生息资产/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_core_capital is '核心资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_bearing_liab is '计息负债/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_bearing_liab_cv is '计息负债(计算值)/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.is_interest_bearing_liab_value is '计息负债是否公布值/0：否；1：是';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.wgt_risk_net_amt is '加权风险资产净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_profit_margin is '净利差/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_interest_margin_cv is '净息差(％)计算值/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.is_np_margin_value is '净利差是否公布值/0：否；1：是';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.np_margin_cv is '净利差(％)计算值/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.is_net_interest_margin_value is '净息差是否公布值/0：否；1：是';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_earning_assets is '生息资产/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_earning_assets_cv is '生息资产(计算值)/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.interest_earning_assets_value is '生息资产是否公布值/0：否；1：是';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.market_venture_cap is '市场风险资本/单位：元，《商业银行资本充足率管理办法》标准';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_capital is '资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.top10_customer_loan_ratio is '最大十家客户贷款比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.bad_loan_ratio_third_classi is '不良贷款比例-3级分类/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.non_interest_income is '非利息收入/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.cash_inv_cfd is '库存现金/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.first_capital_adequacy_ratio is '一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.core_fc_adequacy_ratio is '核心一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_primary_capital_net_amt is '一级资本净额/单位:元；《商业银行资本管理办法(试行)》标准，数据从20130101开始';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_core_first_capital is '核心一级资本净额/单位：元，《商业银行资本管理办法(试行)》标准，数据从20130101开始';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.lcr is '流动性覆盖率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.leverage_ratio is '杠杆率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.overdue_loan is '逾期贷款/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.overdue_loan_ratio is '逾期贷款占比/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.overdue_loan_of_more_than_90d is '90天以上逾期贷款/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.recombine_loan is '重组贷款/单位：元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.normal_loan_migration_rate is '正常类贷款迁徙率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.focused_loan_migration_rate is '关注类贷款迁徙率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.subprime_loan_migration_rate is '次级类贷款迁徙率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.suspicious_loan_migration_rate is '可疑类贷款迁徙率/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.mal_loan_ratio_fc is '中长期贷款比率(外币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.mal_loan_ratio_rmb is '中长期贷款比率(人民币)/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.currency_code is '货币代码/关联到public_code_table.ctgry_code,public_code_table.class_encode=518';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.st_asset_flow_ratio is '短期资产流动性比例/单位：%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.normal_asset is '正常类资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.normal_asset_ratio is '正常类占比/公式:正常类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.special_mention_asset is '关注类资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.special_mention_asset_ratio is '关注类占比/公式:关注类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.sub_asset is '次级类资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.sub_asset_ratio is '次级类占比/公式:次级类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.doubtful_asset is '可疑类资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.doubtful_asset_ratio is '可疑类占比/公式:可疑类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.loss_asset is '损失类资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.loss_asset_ratio is '损失类占比/公式:损失类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.bank_wproduct_balance is '银行理财产品余额/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.credit_card_credit_limit is '信用卡信用额度/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.issue_guarantee_letter is '开出保函/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.issue_credit_letter is '开出信用证/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.adj_asset_balance is '调整后的表内外资产余额/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.loan_commitment is '贷款承诺/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.acceptance_bill is '银行承兑汇票/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.credit_risk_wgt_asset is '信用风险加权资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.net_stable_funds_ratio is '净稳定资金比例/单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.available_stable_funds_ratio is '可用的稳定资金/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.market_risk_wgt_asset is '市场风险加权资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.needed_stable_funds_ratio is '所需的稳定资金/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.prov_to_loan_ratio is '拨贷比/单位:%';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.operational_risk_wgt_asset is '操作风险加权资产/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.green_credit_balance is '绿色信贷余额/单位:元';
comment on column ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator.isvalid is '是否有效';
