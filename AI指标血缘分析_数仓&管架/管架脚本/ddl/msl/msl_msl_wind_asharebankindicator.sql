/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_asharebankindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_asharebankindicator
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_asharebankindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_asharebankindicator(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_WINDCODE VARCHAR2(40)
    ,ANN_DT VARCHAR2(8)
    ,REPORT_PERIOD VARCHAR2(8)
    ,STATEMENT_TYPE VARCHAR2(10)
    ,CRNCY_CODE VARCHAR2(10)
    ,CAPI_ADE_RATIO NUMBER(20,4)
    ,CORE_CAPI_ADE_RATIO NUMBER(20,4)
    ,NPL_RATIO NUMBER(20,4)
    ,LOAN_DEPO_RATIO NUMBER(20,4)
    ,LOAN_DEPO_RATIO_RMB NUMBER(20,4)
    ,LOAN_DEPO_RATIO_NORMB NUMBER(20,4)
    ,ST_ASSET_LIQ_RATIO_RMB NUMBER(20,4)
    ,ST_ASSET_LIQ_RATIO_NORMB NUMBER(20,4)
    ,LOAN_FROM_BANKS_RATIO NUMBER(20,4)
    ,LEND_TO_BANKS_RATIO NUMBER(20,4)
    ,LARGEST_CUSTOMER_LOAN NUMBER(20,4)
    ,TOP_TEN_CUSTOMER_LOAN NUMBER(20,4)
    ,TOTAL_LOAN NUMBER(20,4)
    ,TOTAL_DEPOSIT NUMBER(20,4)
    ,LOAN_LOSS_PROVISION NUMBER(20,4)
    ,BAD_LOAD_FIVE_CLASS NUMBER(20,4)
    ,NPL_PROVISION_COVERAGE NUMBER(20,4)
    ,COST_INCOME_RATIO NUMBER(20,4)
    ,NON_INTEREST_MARGIN NUMBER(20,4)
    ,NET_CAPITAL NUMBER(20,4)
    ,CORE_CAPI_NET_AMOUNT NUMBER(20,4)
    ,RISK_WEIGHT_ASSET NUMBER(20,4)
    ,INTEREST_BEARING_ASSET NUMBER(20,4)
    ,INTEREST_BEARING_ASSET_COMP NUMBER(20,4)
    ,INTEREST_BEARING_LIA NUMBER(20,4)
    ,INTEREST_BEARING_LIA_COMP NUMBER(20,4)
    ,NON_INTEREST_INCOME NUMBER(20,4)
    ,NONEANING_ASSET NUMBER(20,4)
    ,NONEANING_LIA NUMBER(20,4)
    ,NET_INTEREST_MARGIN NUMBER(20,4)
    ,NET_INTEREST_MARGIN_IS_ANN NUMBER(20,4)
    ,NET_INTEREST_SPREAD NUMBER(20,4)
    ,NET_INTEREST_SPREAD_IS_ANN NUMBER(20,4)
    ,OVERDUE_LOAN NUMBER(20,4)
    ,TOTAL_INTEREST_INCOME NUMBER(20,4)
    ,TOTAL_INTEREST_EXP NUMBER(20,4)
    ,CASH_ON_HAND NUMBER(20,4)
    ,LONGTERM_LOANS_RATIO_CNY NUMBER(20,4)
    ,LONGTERM_LOANS_RATIO_FC NUMBER(20,4)
    ,IBUSINESS_LOAN_RATIO NUMBER(20,4)
    ,INTERECT_COLLECTION_RATIO NUMBER(20,4)
    ,CASH_RESERVE_RATIO_CNY NUMBER(20,4)
    ,CASH_RESERVE_RATIO_FC NUMBER(20,4)
    ,OVERSEAS_FUNDS_APP_RATIO NUMBER(20,4)
    ,MARKET_RISK_CAPITAL NUMBER(20,4)
    ,INTEREST_BEARING_ASSET_IFPUB NUMBER(1,0)
    ,INTEREST_BEARING_LIA_IFPUB NUMBER(1,0)
    ,NET_INTEREST_MARGIN_IFPUB NUMBER(1,0)
    ,LOANRESERVESRATIO NUMBER(20,4)
    ,SUBORDINATED_NET_CAPI NUMBER(20,4)
    ,INT_BEAR_ASSET_AVG_BALANCE NUMBER(20,4)
    ,INT_BEAR_ASSET_AVG_RETURN NUMBER(20,4)
    ,INT_CCRUED_LIAB_AVG_BALANCE NUMBER(20,4)
    ,INT_CCRUED_LIAB_AVG_COSTRATIO NUMBER(20,4)
    ,RESCHEDULEDLOANS NUMBER(20,4)
    ,CORETIER1_NET_CAPI NUMBER(20,4)
    ,TIER1_NET_CAPI NUMBER(20,4)
    ,NET_CAPITAL_2013 NUMBER(20,4)
    ,CORETIER1CAPI_ADE_RATIO NUMBER(20,4)
    ,TIER1CAPI_ADE_RATIO NUMBER(20,4)
    ,CAPI_ADE_RATIO_2013 NUMBER(20,4)
    ,RISK_WEIGHT_NET_ASSET_2013 NUMBER(20,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_wind_asharebankindicator to itl;

-- comment
comment on table ${msl_schema}.msl_wind_asharebankindicator is '中国A股银行专用指标';
comment on column ${msl_schema}.msl_wind_asharebankindicator.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_asharebankindicator.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_asharebankindicator.S_INFO_WINDCODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_asharebankindicator.ANN_DT is '公告日期';
comment on column ${msl_schema}.msl_wind_asharebankindicator.REPORT_PERIOD is '报告期';
comment on column ${msl_schema}.msl_wind_asharebankindicator.STATEMENT_TYPE is '报表类型';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CAPI_ADE_RATIO is '资本充足率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CORE_CAPI_ADE_RATIO is '核心资本充足率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NPL_RATIO is '不良贷款比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOAN_DEPO_RATIO is '存贷款比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOAN_DEPO_RATIO_RMB is '存贷款比例(人民币)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOAN_DEPO_RATIO_NORMB is '存贷款比例(外币)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.ST_ASSET_LIQ_RATIO_RMB is '短期资产流动性比例(人民币)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.ST_ASSET_LIQ_RATIO_NORMB is '短期资产流动性比例(外币)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOAN_FROM_BANKS_RATIO is '拆入资金比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LEND_TO_BANKS_RATIO is '拆出资金比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LARGEST_CUSTOMER_LOAN is '单一客户贷款比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TOP_TEN_CUSTOMER_LOAN is '最大十家客户贷款比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TOTAL_LOAN is '贷款总额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TOTAL_DEPOSIT is '存款总额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOAN_LOSS_PROVISION is '贷款呆账准备金';
comment on column ${msl_schema}.msl_wind_asharebankindicator.BAD_LOAD_FIVE_CLASS is '不良贷款余额（5级分类）';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NPL_PROVISION_COVERAGE is '不良贷款拨备覆盖率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.COST_INCOME_RATIO is '成本收入比';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NON_INTEREST_MARGIN is '非利息收入占比';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_CAPITAL is '资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CORE_CAPI_NET_AMOUNT is '核心资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.RISK_WEIGHT_ASSET is '加权风险资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_ASSET is '生息资产';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_ASSET_COMP is '生息资产(计算值)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_LIA is '计息负债';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_LIA_COMP is '计息负债(计算值)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NON_INTEREST_INCOME is '非利息收入';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NONEANING_ASSET is '非生息资产';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NONEANING_LIA is '非计息负债';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_INTEREST_MARGIN is '净息差';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_INTEREST_MARGIN_IS_ANN is '净息差(%)计算值';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_INTEREST_SPREAD is '净利差';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_INTEREST_SPREAD_IS_ANN is '净利差(%)计算值';
comment on column ${msl_schema}.msl_wind_asharebankindicator.OVERDUE_LOAN is '逾期贷款';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TOTAL_INTEREST_INCOME is '总利息收入';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TOTAL_INTEREST_EXP is '总利息支出';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CASH_ON_HAND is '库存现金';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LONGTERM_LOANS_RATIO_CNY is '中长期贷款比例（人民币）';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LONGTERM_LOANS_RATIO_FC is '中长期贷款比例（外币）';
comment on column ${msl_schema}.msl_wind_asharebankindicator.IBUSINESS_LOAN_RATIO is '国际商业借款比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTERECT_COLLECTION_RATIO is '利息回收率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CASH_RESERVE_RATIO_CNY is '备付金比例（人民币）';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CASH_RESERVE_RATIO_FC is '备付金比例（外币）';
comment on column ${msl_schema}.msl_wind_asharebankindicator.OVERSEAS_FUNDS_APP_RATIO is '境外资金运用比例';
comment on column ${msl_schema}.msl_wind_asharebankindicator.MARKET_RISK_CAPITAL is '市场风险资本';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_ASSET_IFPUB is '生息资产是否是发布值';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INTEREST_BEARING_LIA_IFPUB is '计息负债是否是发布值';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_INTEREST_MARGIN_IFPUB is '净利差是否是发布值';
comment on column ${msl_schema}.msl_wind_asharebankindicator.LOANRESERVESRATIO is '贷款减值准备对贷款总额比率(%)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.SUBORDINATED_NET_CAPI is '附属资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INT_BEAR_ASSET_AVG_BALANCE is '生息资产平均余额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INT_BEAR_ASSET_AVG_RETURN is '生息资产平均收益率(%)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INT_CCRUED_LIAB_AVG_BALANCE is '计息负债平均余额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.INT_CCRUED_LIAB_AVG_COSTRATIO is '计息负债平均成本率(%)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.RESCHEDULEDLOANS is '已重组贷款';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CORETIER1_NET_CAPI is '核心一级资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TIER1_NET_CAPI is '一级资本净额';
comment on column ${msl_schema}.msl_wind_asharebankindicator.NET_CAPITAL_2013 is '资本净额(资本管理办法)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CORETIER1CAPI_ADE_RATIO is '核心一级资本充足率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.TIER1CAPI_ADE_RATIO is '一级资本充足率';
comment on column ${msl_schema}.msl_wind_asharebankindicator.CAPI_ADE_RATIO_2013 is '资本充足率(资本管理办法)';
comment on column ${msl_schema}.msl_wind_asharebankindicator.RISK_WEIGHT_NET_ASSET_2013 is '加权风险资产净额(资本管理办法)';
