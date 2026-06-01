/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hksharebankindicator
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hksharebankindicator
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hksharebankindicator purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hksharebankindicator(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(30) -- 货币代码
    ,capi_ade_ratio number(20,4) -- 资本充足率(%)
    ,core_capi_ade_ratio number(20,4) -- 核心资本充足率(%)
    ,npl_ratio number(20,4) -- 不良贷款比例-5级分类(%)
    ,loan_depo_ratio number(20,4) -- 存贷款比例(%)
    ,total_loan number(20,4) -- 贷款总额
    ,total_deposit number(20,4) -- 存款总额
    ,loan_loss_provision number(20,4) -- 贷款呆帐准备金
    ,bad_load_five_class number(20,4) -- 不良贷款余额-5级分类
    ,npl_provision_coverage number(20,4) -- 不良贷款拨备覆盖率-5级分类(%)
    ,cost_income_ratio number(20,4) -- 成本收入比(%)
    ,net_capital number(20,4) -- 资本净额
    ,core_capi_net_amount number(20,4) -- 核心资本净额
    ,risk_weight_asset number(20,4) -- 加权风险资产净额
    ,interest_bearing_asset number(20,4) -- 生息资产
    ,net_interest_margin number(20,4) -- 净息差(%)
    ,net_interest_spread number(20,4) -- 净利差(%)
    ,loanreservesratio number(20,4) -- 贷款减值准备对贷款总额比率(%)
    ,coretier1_net_capi number(20,4) -- 核心一级资本净额
    ,tier1_net_capi number(20,4) -- 一级资本净额
    ,net_capital_2013 number(20,4) -- 资本净额(资本管理办法)
    ,coretier1capi_ade_ratio number(20,4) -- 核心一级资本充足率
    ,tier1capi_ade_ratio number(20,4) -- 一级资本充足率
    ,capi_ade_ratio_2013 number(20,4) -- 资本充足率(资本管理办法)
    ,risk_weight_net_asset_2013 number(20,4) -- 加权风险资产净额(资本管理办法)
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
grant select on ${iol_schema}.wind_hksharebankindicator to ${iml_schema};
grant select on ${iol_schema}.wind_hksharebankindicator to ${icl_schema};
grant select on ${iol_schema}.wind_hksharebankindicator to ${idl_schema};
grant select on ${iol_schema}.wind_hksharebankindicator to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hksharebankindicator is '港股银行专用指标';
comment on column ${iol_schema}.wind_hksharebankindicator.object_id is '对象ID';
comment on column ${iol_schema}.wind_hksharebankindicator.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hksharebankindicator.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hksharebankindicator.report_period is '报告期';
comment on column ${iol_schema}.wind_hksharebankindicator.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_hksharebankindicator.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hksharebankindicator.capi_ade_ratio is '资本充足率(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.core_capi_ade_ratio is '核心资本充足率(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.npl_ratio is '不良贷款比例-5级分类(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.loan_depo_ratio is '存贷款比例(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.total_loan is '贷款总额';
comment on column ${iol_schema}.wind_hksharebankindicator.total_deposit is '存款总额';
comment on column ${iol_schema}.wind_hksharebankindicator.loan_loss_provision is '贷款呆帐准备金';
comment on column ${iol_schema}.wind_hksharebankindicator.bad_load_five_class is '不良贷款余额-5级分类';
comment on column ${iol_schema}.wind_hksharebankindicator.npl_provision_coverage is '不良贷款拨备覆盖率-5级分类(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.cost_income_ratio is '成本收入比(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.net_capital is '资本净额';
comment on column ${iol_schema}.wind_hksharebankindicator.core_capi_net_amount is '核心资本净额';
comment on column ${iol_schema}.wind_hksharebankindicator.risk_weight_asset is '加权风险资产净额';
comment on column ${iol_schema}.wind_hksharebankindicator.interest_bearing_asset is '生息资产';
comment on column ${iol_schema}.wind_hksharebankindicator.net_interest_margin is '净息差(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.net_interest_spread is '净利差(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.loanreservesratio is '贷款减值准备对贷款总额比率(%)';
comment on column ${iol_schema}.wind_hksharebankindicator.coretier1_net_capi is '核心一级资本净额';
comment on column ${iol_schema}.wind_hksharebankindicator.tier1_net_capi is '一级资本净额';
comment on column ${iol_schema}.wind_hksharebankindicator.net_capital_2013 is '资本净额(资本管理办法)';
comment on column ${iol_schema}.wind_hksharebankindicator.coretier1capi_ade_ratio is '核心一级资本充足率';
comment on column ${iol_schema}.wind_hksharebankindicator.tier1capi_ade_ratio is '一级资本充足率';
comment on column ${iol_schema}.wind_hksharebankindicator.capi_ade_ratio_2013 is '资本充足率(资本管理办法)';
comment on column ${iol_schema}.wind_hksharebankindicator.risk_weight_net_asset_2013 is '加权风险资产净额(资本管理办法)';
comment on column ${iol_schema}.wind_hksharebankindicator.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hksharebankindicator.etl_timestamp is 'ETL处理时间戳';
