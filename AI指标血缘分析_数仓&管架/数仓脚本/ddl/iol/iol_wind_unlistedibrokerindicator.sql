/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_unlistedibrokerindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_unlistedibrokerindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_unlistedibrokerindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedibrokerindicator(
    object_id varchar2(150) -- 对象ID
    ,ann_dt varchar2(12) -- 报告期
    ,report_period varchar2(12) -- 公告日期
    ,statement_type varchar2(60) -- 报表类型
    ,iflisted_data number(5,0) -- 是否上市后数据
    ,net_capital number(20,4) -- 净资本
    ,trusted_capital number(20,4) -- 受托资金
    ,net_gearing_ratio number(20,4) -- 净资本负债率(%)
    ,prop_equity_ratio number(20,4) -- 自营权益类证券比例
    ,longterm_invest_ratio number(20,4) -- 长期投资比例
    ,fixed_capital_ratio number(20,4) -- 固定资本比例
    ,fee_business_ratio number(20,4) -- 营业费用率
    ,total_capital_return number(20,4) -- 总资产收益率
    ,net_capital_yield number(20,4) -- 净资本收益率
    ,current_ratio number(20,4) -- 流动比率
    ,asset_liability_ratio number(20,4) -- 资产负债率
    ,asset_turnover_ratio number(20,4) -- 资产周转率
    ,net_capital_return number(20,4) -- 净资产收益率
    ,contingent_liability_ratio number(20,4) -- 或有负债(担保）比率
    ,prop_securities number(20,4) -- 自营证券
    ,treasury_bond number(20,4) -- 国债
    ,investment_funds number(20,4) -- 投资基金
    ,stocks number(20,4) -- 股票
    ,convertible_bond number(20,4) -- 可转债
    ,per_capita_profits number(20,4) -- 人均利润
    ,net_cap_total_riskprov number(20,4) -- 风险覆盖率
    ,net_cap_net_assets number(20,4) -- 净资本/净资产
    ,prop_equ_der_netcap number(20,4) -- 自营权益类证券及证券衍生品/净资本
    ,prop_fixedincome_netcap number(20,4) -- 自营固定收益类证券/净资本
    ,s_info_compcode varchar2(60) -- 公司id
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
grant select on ${iol_schema}.wind_unlistedibrokerindicator to ${iml_schema};
grant select on ${iol_schema}.wind_unlistedibrokerindicator to ${icl_schema};
grant select on ${iol_schema}.wind_unlistedibrokerindicator to ${idl_schema};
grant select on ${iol_schema}.wind_unlistedibrokerindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_unlistedibrokerindicator is '非上市券商专用指标';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.ann_dt is '报告期';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.report_period is '公告日期';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.statement_type is '报表类型';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.iflisted_data is '是否上市后数据';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_capital is '净资本';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.trusted_capital is '受托资金';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_gearing_ratio is '净资本负债率(%)';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.prop_equity_ratio is '自营权益类证券比例';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.longterm_invest_ratio is '长期投资比例';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.fixed_capital_ratio is '固定资本比例';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.fee_business_ratio is '营业费用率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.total_capital_return is '总资产收益率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_capital_yield is '净资本收益率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.current_ratio is '流动比率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.asset_liability_ratio is '资产负债率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.asset_turnover_ratio is '资产周转率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_capital_return is '净资产收益率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.contingent_liability_ratio is '或有负债(担保）比率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.prop_securities is '自营证券';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.treasury_bond is '国债';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.investment_funds is '投资基金';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.stocks is '股票';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.convertible_bond is '可转债';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.per_capita_profits is '人均利润';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_cap_total_riskprov is '风险覆盖率';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.net_cap_net_assets is '净资本/净资产';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.prop_equ_der_netcap is '自营权益类证券及证券衍生品/净资本';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.prop_fixedincome_netcap is '自营固定收益类证券/净资本';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_unlistedibrokerindicator.etl_timestamp is 'ETL处理时间戳';
