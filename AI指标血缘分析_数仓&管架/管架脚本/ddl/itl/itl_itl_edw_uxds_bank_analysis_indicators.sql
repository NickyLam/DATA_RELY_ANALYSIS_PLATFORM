/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_uxds_bank_analysis_indicators
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators(
    seq number(20) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,interest_recovery number(18,4) -- 利息回收率
    ,rwa_to_general_loan_ratio number(24,4) -- 加权风险资产/一般性贷款
    ,corp_code varchar2(60) -- 公司代码/关联到corp_basic_info.org_id
    ,corp_name varchar2(1500) -- 企业名称
    ,ed date -- 截止日期
    ,currency_code varchar2(36) -- 货币代码
    ,total_assets number(24,4) -- 总资产
    ,net_assets number(24,4) -- 净资产
    ,interbank_storage number(18,4) -- 同业往来资产
    ,interest_earning_assets number(18,4) -- 生息资产
    ,market_venture_cap number(18,4) -- 市场风险资本
    ,interest_earning_assets_cv number(18,4) -- 生息资产(计算值)
    ,interest_earning_assets_value number(1) -- 生息资产是否公布值
    ,non_living_asset number(18,4) -- 非生息资产
    ,interest_bearing_liab number(18,4) -- 计息负债
    ,interest_bearing_liab_cv number(18,4) -- 计息负债(计算值)
    ,is_interest_bearing_liab_value number(1) -- 计息负债是否公布值
    ,non_interest_liab number(18,4) -- 非计息负债
    ,total_deposit_amt number(18,4) -- 存款总额
    ,total_loan_amt number(18,4) -- 贷款总额
    ,cash_inv_cfd number(18,4) -- 库存现金
    ,leverage_ratio number(24,4) -- 杠杆率
    ,prov_to_loan_ratio number(24,4) -- 拨贷比
    ,general_loan number(24,4) -- 一般性贷款
    ,recombine_loan number(24,4) -- 重组贷款
    ,overdue_loan number(24,4) -- 逾期贷款
    ,overdue_loan_ratio number(24,4) -- 逾期贷款占比
    ,bad_loan number(18,4) -- 不良贷款(npls)
    ,bad_loan_ratio number(9,3) -- 不良贷款比例
    ,overdue_loan_mrth_90d number(24,4) -- 90天以上逾期贷款
    ,loans_to_eassets_ratio number(24,4) -- 贷款总额/生息资产
    ,interbank_assets_ratio number(24,4) -- 同业往来资产/生息资产
    ,total_liab number(18,4) -- 总负债
    ,interbank_deposit_etc number(18,4) -- 同业往来负债
    ,deposit_to_ibl_ratio number(24,4) -- 存款总额/计息负债
    ,interbank_liab_ratio number(24,4) -- 同业往来负债/计息负债
    ,bank_wproduct_balance number(18,4) -- 银行理财产品余额
    ,loan_ratio_slc number(18,4) -- 单一最大客户贷款比例
    ,top10_customer_loan_ratio number(18,4) -- 最大十家客户贷款比例
    ,normal_asset number(18,4) -- 正常类资产
    ,normal_proportion number(9,3) -- 正常类占比
    ,special_mention_asset number(18,4) -- 关注类资产
    ,special_proportion number(9,3) -- 关注类占比
    ,substandard_asset number(18,4) -- 次级类资产
    ,substandard_proportion number(9,3) -- 次级类占比
    ,suspicious_asset number(18,4) -- 可疑类资产
    ,suspicious_proportion number(9,3) -- 可疑类占比
    ,loss_asset number(18,4) -- 损失类资产
    ,loss_proportion number(9,3) -- 损失类占比
    ,provision_coverage number(18,4) -- 拨备覆盖率
    ,loan_loss_reserve number(18,4) -- 贷款损失准备
    ,loan_loss_resr_cover_ratio number(24,4) -- 贷款损失准备充足率
    ,normal_loan_migration_rate number(24,4) -- 正常类贷款迁徙率
    ,focused_loan_migration_rate number(24,4) -- 关注类贷款迁徙率
    ,subprime_loan_migration_rate number(24,4) -- 次级类贷款迁徙率
    ,suspicious_loan_migration_rate number(24,4) -- 可疑类贷款迁徙率
    ,deposit_loan_ratio number(24,4) -- 存贷款比例
    ,deposit_and_loan_ratio_rmb number(18,3) -- 存贷款比例(人民币)
    ,deposit_and_loan_ratio_fc number(18,3) -- 存贷款比例(外币)
    ,lending_funds_ratio number(18,3) -- 拆入资金比例
    ,borrowing_funds_ratio number(18,3) -- 拆出资金比例
    ,provision_ratio_rmb number(18,3) -- 备付金比例(人民币)
    ,provision_ratio_fc number(18,3) -- 备付金比例(外币)
    ,mal_loan_ratio_rmb number(18,4) -- 中长期贷款比率(人民币)
    ,mal_loan_ratio_fc number(18,4) -- 中长期贷款比率(外币)
    ,st_asset_flow_ratio number(18,4) -- 短期资产流动性比例
    ,st_assets_liquid_ratio number(18,3) -- 短期资产流动性比例(人民币)
    ,st_asset_liquid_ratio_fc number(18,3) -- 短期资产流动性比例(外币)
    ,lcr number(24,4) -- 流动性覆盖率
    ,net_interest_margin number(18,4) -- 净息差
    ,net_interest_margin_cv number(18,4) -- 净息差计算值
    ,is_net_interest_margin_value number(1) -- 净息差是否公布值
    ,net_profit_margin number(18,4) -- 净利差
    ,np_margin_cv number(18,4) -- 净利差计算值
    ,is_np_margin_value number(1) -- 净利差是否公布值
    ,living_asset_avg_interest number(18,4) -- 生息资产平均利率
    ,interest_liab_avg_interest number(18,4) -- 付息负债平均利率
    ,non_interest_income number(18,4) -- 非利息收入
    ,non_interest_income_ratio number(18,4) -- 非利息收入占比
    ,cost_to_income_ratio number(18,4) -- 成本收入比
    ,net_capital number(18,4) -- 资本净额
    ,net_core_capital number(18,4) -- 核心资本净额
    ,net_primary_capital_net_amt number(18,4) -- 一级资本净额
    ,net_core_first_capital number(18,4) -- 核心一级资本净额
    ,capital_adequacy_ratio number(18,4) -- 资本充足率
    ,core_capital_adequacy_ratio number(9,3) -- 核心资本充足率
    ,first_capital_adequacy_ratio number(18,4) -- 一级资本充足率
    ,core_fc_adequacy_ratio number(18,4) -- 核心一级资本充足率
    ,wgt_risk_net_amt number(26,4) -- 加权风险资产净额
    ,rwa_to_total_asset_ratio number(24,4) -- 加权风险资产/总资产
    ,rwa_to_ear_asset_ratio number(24,4) -- 加权风险资产/生息资产
    ,rwa_to_total_loan_ratio number(24,4) -- 加权风险资产/贷款总额
    ,isvalid number(1) -- 是否有效/默认值为1
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_uxds_bank_analysis_indicators to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators is '银行分析指标';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.seq is '记录唯一标识';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.ctime is '记录创建时间';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.mtime is '记录修改时间';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.rtime is '记录同步时间';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_recovery is '利息回收率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.rwa_to_general_loan_ratio is '加权风险资产/一般性贷款';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.corp_code is '公司代码/关联到corp_basic_info.org_id';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.corp_name is '企业名称';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.ed is '截止日期';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.currency_code is '货币代码';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.total_assets is '总资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_assets is '净资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interbank_storage is '同业往来资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_earning_assets is '生息资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.market_venture_cap is '市场风险资本';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_earning_assets_cv is '生息资产(计算值)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_earning_assets_value is '生息资产是否公布值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.non_living_asset is '非生息资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_bearing_liab is '计息负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_bearing_liab_cv is '计息负债(计算值)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.is_interest_bearing_liab_value is '计息负债是否公布值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.non_interest_liab is '非计息负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.total_deposit_amt is '存款总额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.total_loan_amt is '贷款总额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.cash_inv_cfd is '库存现金';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.leverage_ratio is '杠杆率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.prov_to_loan_ratio is '拨贷比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.general_loan is '一般性贷款';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.recombine_loan is '重组贷款';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.overdue_loan is '逾期贷款';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.overdue_loan_ratio is '逾期贷款占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.bad_loan is '不良贷款(npls)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.bad_loan_ratio is '不良贷款比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.overdue_loan_mrth_90d is '90天以上逾期贷款';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loans_to_eassets_ratio is '贷款总额/生息资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interbank_assets_ratio is '同业往来资产/生息资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.total_liab is '总负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interbank_deposit_etc is '同业往来负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.deposit_to_ibl_ratio is '存款总额/计息负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interbank_liab_ratio is '同业往来负债/计息负债';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.bank_wproduct_balance is '银行理财产品余额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loan_ratio_slc is '单一最大客户贷款比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.top10_customer_loan_ratio is '最大十家客户贷款比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.normal_asset is '正常类资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.normal_proportion is '正常类占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.special_mention_asset is '关注类资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.special_proportion is '关注类占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.substandard_asset is '次级类资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.substandard_proportion is '次级类占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.suspicious_asset is '可疑类资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.suspicious_proportion is '可疑类占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loss_asset is '损失类资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loss_proportion is '损失类占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.provision_coverage is '拨备覆盖率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loan_loss_reserve is '贷款损失准备';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.loan_loss_resr_cover_ratio is '贷款损失准备充足率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.normal_loan_migration_rate is '正常类贷款迁徙率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.focused_loan_migration_rate is '关注类贷款迁徙率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.subprime_loan_migration_rate is '次级类贷款迁徙率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.suspicious_loan_migration_rate is '可疑类贷款迁徙率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.deposit_loan_ratio is '存贷款比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.deposit_and_loan_ratio_rmb is '存贷款比例(人民币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.deposit_and_loan_ratio_fc is '存贷款比例(外币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.lending_funds_ratio is '拆入资金比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.borrowing_funds_ratio is '拆出资金比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.provision_ratio_rmb is '备付金比例(人民币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.provision_ratio_fc is '备付金比例(外币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.mal_loan_ratio_rmb is '中长期贷款比率(人民币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.mal_loan_ratio_fc is '中长期贷款比率(外币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.st_asset_flow_ratio is '短期资产流动性比例';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.st_assets_liquid_ratio is '短期资产流动性比例(人民币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.st_asset_liquid_ratio_fc is '短期资产流动性比例(外币)';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.lcr is '流动性覆盖率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_interest_margin is '净息差';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_interest_margin_cv is '净息差计算值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.is_net_interest_margin_value is '净息差是否公布值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_profit_margin is '净利差';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.np_margin_cv is '净利差计算值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.is_np_margin_value is '净利差是否公布值';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.living_asset_avg_interest is '生息资产平均利率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.interest_liab_avg_interest is '付息负债平均利率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.non_interest_income is '非利息收入';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.non_interest_income_ratio is '非利息收入占比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.cost_to_income_ratio is '成本收入比';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_capital is '资本净额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_core_capital is '核心资本净额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_primary_capital_net_amt is '一级资本净额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.net_core_first_capital is '核心一级资本净额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.capital_adequacy_ratio is '资本充足率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.core_capital_adequacy_ratio is '核心资本充足率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.first_capital_adequacy_ratio is '一级资本充足率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.core_fc_adequacy_ratio is '核心一级资本充足率';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.wgt_risk_net_amt is '加权风险资产净额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.rwa_to_total_asset_ratio is '加权风险资产/总资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.rwa_to_ear_asset_ratio is '加权风险资产/生息资产';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.rwa_to_total_loan_ratio is '加权风险资产/贷款总额';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.isvalid is '是否有效/默认值为1';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_uxds_bank_analysis_indicators.etl_timestamp is 'ETL处理时间戳';
