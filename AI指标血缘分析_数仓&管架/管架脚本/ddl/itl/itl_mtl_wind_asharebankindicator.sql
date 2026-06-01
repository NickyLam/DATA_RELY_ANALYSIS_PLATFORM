/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_asharebankindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_asharebankindicator
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_asharebankindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_asharebankindicator(
    etl_dt date -- ETL处理日期
    ,object_id varchar2(100) -- 对象ID
    ,s_info_windcode varchar2(40) -- Wind代码
    ,ann_dt varchar2(8) -- 公告日期
    ,report_period varchar2(8) -- 报告期
    ,statement_type varchar2(10) -- 报表类型
    ,crncy_code varchar2(10) -- 货币代码
    ,capi_ade_ratio number(20,4) -- 资本充足率
    ,core_capi_ade_ratio number(20,4) -- 核心资本充足率
    ,npl_ratio number(20,4) -- 不良贷款比例
    ,loan_depo_ratio number(20,4) -- 存贷款比例
    ,loan_depo_ratio_rmb number(20,4) -- 存贷款比例(人民币)
    ,loan_depo_ratio_normb number(20,4) -- 存贷款比例(外币)
    ,st_asset_liq_ratio_rmb number(20,4) -- 短期资产流动性比例(人民币)
    ,st_asset_liq_ratio_normb number(20,4) -- 短期资产流动性比例(外币)
    ,loan_from_banks_ratio number(20,4) -- 拆入资金比例
    ,lend_to_banks_ratio number(20,4) -- 拆出资金比例
    ,largest_customer_loan number(20,4) -- 单一客户贷款比例
    ,top_ten_customer_loan number(20,4) -- 最大十家客户贷款比例
    ,total_loan number(20,4) -- 贷款总额
    ,total_deposit number(20,4) -- 存款总额
    ,loan_loss_provision number(20,4) -- 贷款呆账准备金
    ,bad_load_five_class number(20,4) -- 不良贷款余额（5级分类）
    ,npl_provision_coverage number(20,4) -- 不良贷款拨备覆盖率
    ,cost_income_ratio number(20,4) -- 成本收入比
    ,non_interest_margin number(20,4) -- 非利息收入占比
    ,net_capital number(20,4) -- 资本净额
    ,core_capi_net_amount number(20,4) -- 核心资本净额
    ,risk_weight_asset number(20,4) -- 加权风险资本净额
    ,interest_bearing_asset number(20,4) -- 生息资产
    ,interest_bearing_asset_comp number(20,4) -- 生息资产(计算值)
    ,interest_bearing_lia number(20,4) -- 计息负债
    ,interest_bearing_lia_comp number(20,4) -- 计息负债(计算值)
    ,non_interest_income number(20,4) -- 非利息收入
    ,noneaning_asset number(20,4) -- 非生息资产
    ,noneaning_lia number(20,4) -- 非计息负债
    ,net_interest_margin number(20,4) -- 净息差
    ,net_interest_margin_is_ann number(20,4) -- 净息差(%)计算值
    ,net_interest_spread number(20,4) -- 净利差
    ,net_interest_spread_is_ann number(20,4) -- 净利差(%)计算值
    ,overdue_loan number(20,4) -- 逾期贷款
    ,total_interest_income number(20,4) -- 总利息收入
    ,total_interest_exp number(20,4) -- 总利息支出
    ,cash_on_hand number(20,4) -- 库存现金
    ,longterm_loans_ratio_cny number(20,4) -- 中长期贷款比例（人民币）
    ,longterm_loans_ratio_fc number(20,4) -- 中长期贷款比例（外币）
    ,ibusiness_loan_ratio number(20,4) -- 国际商业借款比例
    ,interect_collection_ratio number(20,4) -- 利息回收率
    ,cash_reserve_ratio_cny number(20,4) -- 备付金比例（人民币）
    ,cash_reserve_ratio_fc number(20,4) -- 备付金比例（外币）
    ,overseas_funds_app_ratio number(20,4) -- 境外资金运用比例
    ,market_risk_capital number(20,4) -- 市场风险资本
    ,interest_bearing_asset_ifpub number(1,0) -- 生息资产是否是发布值
    ,interest_bearing_lia_ifpub number(1,0) -- 计息负债是否是发布值
    ,net_interest_margin_ifpub number(1,0) -- 净利差是否是发布值
    ,loanreservesratio number(20,4) -- 贷款减值准备对贷款总额比率(%)
    ,subordinated_net_capi number(20,4) -- 附属资本净额
    ,int_bear_asset_avg_balance number(20,4) -- 生息资产平均余额
    ,int_bear_asset_avg_return number(20,4) -- 生息资产平均收益率(%)
    ,int_ccrued_liab_avg_balance number(20,4) -- 计息负债平均余额
    ,int_ccrued_liab_avg_costratio number(20,4) -- 计息负债平均成本率(%)
    ,rescheduledloans number(20,4) -- 已重组贷款
    ,coretier1_net_capi number(20,4) -- 核心一级资本净额
    ,tier1_net_capi number(20,4) -- 一级资本净额
    ,net_capital_2013 number(20,4) -- 资本净额(资本管理办法)
    ,coretier1capi_ade_ratio number(20,4) -- 核心一级资本充足率
    ,tier1capi_ade_ratio number(20,4) -- 一级资本充足率
    ,capi_ade_ratio_2013 number(20,4) -- 资本充足率(资本管理办法)
    ,risk_weight_net_asset_2013 number(20,4) -- 加权风险资产净额(资本管理办法)
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
grant select on ${itl_schema}.mtl_wind_asharebankindicator to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_asharebankindicator is '中国A股银行专用指标';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.s_info_windcode is 'Wind代码';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.ann_dt is '公告日期';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.report_period is '报告期';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.statement_type is '报表类型';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.crncy_code is '货币代码';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.capi_ade_ratio is '资本充足率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.core_capi_ade_ratio is '核心资本充足率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.npl_ratio is '不良贷款比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loan_depo_ratio is '存贷款比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loan_depo_ratio_rmb is '存贷款比例(人民币)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loan_depo_ratio_normb is '存贷款比例(外币)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.st_asset_liq_ratio_rmb is '短期资产流动性比例(人民币)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.st_asset_liq_ratio_normb is '短期资产流动性比例(外币)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loan_from_banks_ratio is '拆入资金比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.lend_to_banks_ratio is '拆出资金比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.largest_customer_loan is '单一客户贷款比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.top_ten_customer_loan is '最大十家客户贷款比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.total_loan is '贷款总额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.total_deposit is '存款总额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loan_loss_provision is '贷款呆账准备金';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.bad_load_five_class is '不良贷款余额（5级分类）';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.npl_provision_coverage is '不良贷款拨备覆盖率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.cost_income_ratio is '成本收入比';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.non_interest_margin is '非利息收入占比';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_capital is '资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.core_capi_net_amount is '核心资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.risk_weight_asset is '加权风险资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_asset is '生息资产';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_asset_comp is '生息资产(计算值)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_lia is '计息负债';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_lia_comp is '计息负债(计算值)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.non_interest_income is '非利息收入';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.noneaning_asset is '非生息资产';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.noneaning_lia is '非计息负债';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_interest_margin is '净息差';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_interest_margin_is_ann is '净息差(%)计算值';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_interest_spread is '净利差';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_interest_spread_is_ann is '净利差(%)计算值';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.overdue_loan is '逾期贷款';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.total_interest_income is '总利息收入';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.total_interest_exp is '总利息支出';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.cash_on_hand is '库存现金';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.longterm_loans_ratio_cny is '中长期贷款比例（人民币）';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.longterm_loans_ratio_fc is '中长期贷款比例（外币）';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.ibusiness_loan_ratio is '国际商业借款比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interect_collection_ratio is '利息回收率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.cash_reserve_ratio_cny is '备付金比例（人民币）';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.cash_reserve_ratio_fc is '备付金比例（外币）';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.overseas_funds_app_ratio is '境外资金运用比例';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.market_risk_capital is '市场风险资本';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_asset_ifpub is '生息资产是否是发布值';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.interest_bearing_lia_ifpub is '计息负债是否是发布值';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_interest_margin_ifpub is '净利差是否是发布值';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.loanreservesratio is '贷款减值准备对贷款总额比率(%)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.subordinated_net_capi is '附属资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.int_bear_asset_avg_balance is '生息资产平均余额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.int_bear_asset_avg_return is '生息资产平均收益率(%)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.int_ccrued_liab_avg_balance is '计息负债平均余额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.int_ccrued_liab_avg_costratio is '计息负债平均成本率(%)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.rescheduledloans is '已重组贷款';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.coretier1_net_capi is '核心一级资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.tier1_net_capi is '一级资本净额';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.net_capital_2013 is '资本净额(资本管理办法)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.coretier1capi_ade_ratio is '核心一级资本充足率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.tier1capi_ade_ratio is '一级资本充足率';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.capi_ade_ratio_2013 is '资本充足率(资本管理办法)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.risk_weight_net_asset_2013 is '加权风险资产净额(资本管理办法)';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_asharebankindicator.etl_timestamp is 'ETL处理时间戳';
