/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_unlistedinsuranceindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_unlistedinsuranceindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_unlistedinsuranceindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedinsuranceindicator(
    object_id varchar2(150) -- 对象ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型
    ,cap_adequacy_ratio_life number(20,4) -- 寿险：偿付能力充足率
    ,cap_adequacy_ratio_property number(20,4) -- 产险：偿付能力充足率
    ,surrender_rate number(20,4) -- 退保率
    ,policy_persistency_rate_13m number(20,4) -- 保单继续率-13个月
    ,policy_persistency_rate_25m number(20,4) -- 保单继续率-25个月
    ,policy_persistency_rate_14m number(20,4) -- 保单继续率-14个月
    ,policy_persistency_rate_26m number(20,4) -- 保单继续率-26个月
    ,net_investment_yield number(20,4) -- 净投资收益率
    ,total_investment_yield number(20,4) -- 总投资收益率
    ,risk_discount_rate number(20,4) -- 评估利率假设：风险贴现率
    ,combined_cost_property number(20,4) -- 产险：综合成本率
    ,loss_ratio_property number(20,4) -- 产险：赔付率
    ,fee_ratio_property number(20,4) -- 产险：费用率
    ,intrinsic_value_life number(20,4) -- 寿险：内含价值
    ,value_new_business_life number(20,4) -- 寿险：新业务价值
    ,value_effective_business_life number(20,4) -- 寿险：有效业务价值
    ,actual_capital_life number(20,4) -- 寿险：实际资本
    ,minimun_capital_life number(20,4) -- 寿险：最低资本
    ,actual_capital_property number(20,4) -- 产险：实际资本
    ,minimun_capital_property number(20,4) -- 产险：最低资本
    ,actual_capital_group number(20,4) -- 集团：实际资本
    ,minimun_capital_group number(20,4) -- 集团：最低资本
    ,capital_adequacy_ratio_group number(20,4) -- 集团：偿付能力充足率
    ,crncy_code varchar2(15) -- 货币代码
    ,report_type number(9,0) -- 报告类型代码
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
grant select on ${iol_schema}.wind_unlistedinsuranceindicator to ${iml_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceindicator to ${icl_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceindicator to ${idl_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_unlistedinsuranceindicator is '非上市保险专用指标';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.report_period is '报告期';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.statement_type is '报表类型';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.cap_adequacy_ratio_life is '寿险：偿付能力充足率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.cap_adequacy_ratio_property is '产险：偿付能力充足率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.surrender_rate is '退保率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.policy_persistency_rate_13m is '保单继续率-13个月';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.policy_persistency_rate_25m is '保单继续率-25个月';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.policy_persistency_rate_14m is '保单继续率-14个月';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.policy_persistency_rate_26m is '保单继续率-26个月';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.net_investment_yield is '净投资收益率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.total_investment_yield is '总投资收益率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.risk_discount_rate is '评估利率假设：风险贴现率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.combined_cost_property is '产险：综合成本率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.loss_ratio_property is '产险：赔付率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.fee_ratio_property is '产险：费用率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.intrinsic_value_life is '寿险：内含价值';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.value_new_business_life is '寿险：新业务价值';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.value_effective_business_life is '寿险：有效业务价值';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.actual_capital_life is '寿险：实际资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.minimun_capital_life is '寿险：最低资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.actual_capital_property is '产险：实际资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.minimun_capital_property is '产险：最低资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.actual_capital_group is '集团：实际资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.minimun_capital_group is '集团：最低资本';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.capital_adequacy_ratio_group is '集团：偿付能力充足率';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.report_type is '报告类型代码';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_unlistedinsuranceindicator.etl_timestamp is 'ETL处理时间戳';
