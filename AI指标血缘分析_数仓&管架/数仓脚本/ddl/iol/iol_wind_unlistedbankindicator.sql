/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_unlistedbankindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_unlistedbankindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_unlistedbankindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedbankindicator(
    object_id varchar2(150) -- 对象ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型
    ,crncy_code varchar2(15) -- 货币代码
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
    ,net_interest_margin_is_ann number(20,4) -- 净息差是否公布值
    ,net_interest_spread number(20,4) -- 净利差
    ,net_interest_spread_is_ann number(20,4) -- 净利差是否公布值
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
    ,coretier1capi_ade_ratio number(20,4) -- 核心一级资本充足率
    ,s_info_compcode varchar2(60) -- 公司id
    ,tier1capi_ade_ratio number(20,4) -- 一级资本充足率
    ,capi_ade_ratio_2013 number(20,4) -- 资本充足率(资本管理办法)
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_unlistedbankindicator to ${iml_schema};
grant select on ${iol_schema}.wind_unlistedbankindicator to ${icl_schema};
grant select on ${iol_schema}.wind_unlistedbankindicator to ${idl_schema};
grant select on ${iol_schema}.wind_unlistedbankindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_unlistedbankindicator is '非上市银行专用指标';
comment on column ${iol_schema}.wind_unlistedbankindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_unlistedbankindicator.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_unlistedbankindicator.report_period is '报告期';
comment on column ${iol_schema}.wind_unlistedbankindicator.statement_type is '报表类型';
comment on column ${iol_schema}.wind_unlistedbankindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_unlistedbankindicator.capi_ade_ratio is '资本充足率';
comment on column ${iol_schema}.wind_unlistedbankindicator.core_capi_ade_ratio is '核心资本充足率';
comment on column ${iol_schema}.wind_unlistedbankindicator.npl_ratio is '不良贷款比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.loan_depo_ratio is '存贷款比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.loan_depo_ratio_rmb is '存贷款比例(人民币)';
comment on column ${iol_schema}.wind_unlistedbankindicator.loan_depo_ratio_normb is '存贷款比例(外币)';
comment on column ${iol_schema}.wind_unlistedbankindicator.st_asset_liq_ratio_rmb is '短期资产流动性比例(人民币)';
comment on column ${iol_schema}.wind_unlistedbankindicator.st_asset_liq_ratio_normb is '短期资产流动性比例(外币)';
comment on column ${iol_schema}.wind_unlistedbankindicator.loan_from_banks_ratio is '拆入资金比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.lend_to_banks_ratio is '拆出资金比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.largest_customer_loan is '单一客户贷款比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.top_ten_customer_loan is '最大十家客户贷款比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.total_loan is '贷款总额';
comment on column ${iol_schema}.wind_unlistedbankindicator.total_deposit is '存款总额';
comment on column ${iol_schema}.wind_unlistedbankindicator.loan_loss_provision is '贷款呆账准备金';
comment on column ${iol_schema}.wind_unlistedbankindicator.bad_load_five_class is '不良贷款余额（5级分类）';
comment on column ${iol_schema}.wind_unlistedbankindicator.npl_provision_coverage is '不良贷款拨备覆盖率';
comment on column ${iol_schema}.wind_unlistedbankindicator.cost_income_ratio is '成本收入比';
comment on column ${iol_schema}.wind_unlistedbankindicator.non_interest_margin is '非利息收入占比';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_capital is '资本净额';
comment on column ${iol_schema}.wind_unlistedbankindicator.core_capi_net_amount is '核心资本净额';
comment on column ${iol_schema}.wind_unlistedbankindicator.risk_weight_asset is '加权风险资本净额';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_asset is '生息资产';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_asset_comp is '生息资产(计算值)';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_lia is '计息负债';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_lia_comp is '计息负债(计算值)';
comment on column ${iol_schema}.wind_unlistedbankindicator.non_interest_income is '非利息收入';
comment on column ${iol_schema}.wind_unlistedbankindicator.noneaning_asset is '非生息资产';
comment on column ${iol_schema}.wind_unlistedbankindicator.noneaning_lia is '非计息负债';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_interest_margin is '净息差';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_interest_margin_is_ann is '净息差是否公布值';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_interest_spread is '净利差';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_interest_spread_is_ann is '净利差是否公布值';
comment on column ${iol_schema}.wind_unlistedbankindicator.overdue_loan is '逾期贷款';
comment on column ${iol_schema}.wind_unlistedbankindicator.total_interest_income is '总利息收入';
comment on column ${iol_schema}.wind_unlistedbankindicator.total_interest_exp is '总利息支出';
comment on column ${iol_schema}.wind_unlistedbankindicator.cash_on_hand is '库存现金';
comment on column ${iol_schema}.wind_unlistedbankindicator.longterm_loans_ratio_cny is '中长期贷款比例（人民币）';
comment on column ${iol_schema}.wind_unlistedbankindicator.longterm_loans_ratio_fc is '中长期贷款比例（外币）';
comment on column ${iol_schema}.wind_unlistedbankindicator.ibusiness_loan_ratio is '国际商业借款比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.interect_collection_ratio is '利息回收率';
comment on column ${iol_schema}.wind_unlistedbankindicator.cash_reserve_ratio_cny is '备付金比例（人民币）';
comment on column ${iol_schema}.wind_unlistedbankindicator.cash_reserve_ratio_fc is '备付金比例（外币）';
comment on column ${iol_schema}.wind_unlistedbankindicator.overseas_funds_app_ratio is '境外资金运用比例';
comment on column ${iol_schema}.wind_unlistedbankindicator.market_risk_capital is '市场风险资本';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_asset_ifpub is '生息资产是否是发布值';
comment on column ${iol_schema}.wind_unlistedbankindicator.interest_bearing_lia_ifpub is '计息负债是否是发布值';
comment on column ${iol_schema}.wind_unlistedbankindicator.net_interest_margin_ifpub is '净利差是否是发布值';
comment on column ${iol_schema}.wind_unlistedbankindicator.coretier1capi_ade_ratio is '核心一级资本充足率';
comment on column ${iol_schema}.wind_unlistedbankindicator.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_unlistedbankindicator.tier1capi_ade_ratio is '一级资本充足率';
comment on column ${iol_schema}.wind_unlistedbankindicator.capi_ade_ratio_2013 is '资本充足率(资本管理办法)';
comment on column ${iol_schema}.wind_unlistedbankindicator.start_dt is '开始时间';
comment on column ${iol_schema}.wind_unlistedbankindicator.end_dt is '结束时间';
comment on column ${iol_schema}.wind_unlistedbankindicator.id_mark is '增删标志';
comment on column ${iol_schema}.wind_unlistedbankindicator.etl_timestamp is 'ETL处理时间戳';
