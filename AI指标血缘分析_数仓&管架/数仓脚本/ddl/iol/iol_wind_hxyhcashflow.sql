/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hxyhcashflow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hxyhcashflow
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hxyhcashflow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hxyhcashflow(
    object_id varchar2(150) -- 对象ID
    ,comp_id varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(60) -- 报表类型
    ,iflisted_data varchar2(3) -- 是否上市后数据
    ,crncy_code varchar2(15) -- 货币代码
    ,net_cash_flows_oper_act number(20,4) -- 经营活动产生的现金流量净额
    ,net_cash_flows_inv_act number(20,4) -- 投资活动产生的现金流量净额
    ,net_cash_flows_fnc_act number(20,4) -- 筹资活动产生的现金流量净额
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
grant select on ${iol_schema}.wind_hxyhcashflow to ${iml_schema};
grant select on ${iol_schema}.wind_hxyhcashflow to ${icl_schema};
grant select on ${iol_schema}.wind_hxyhcashflow to ${idl_schema};
grant select on ${iol_schema}.wind_hxyhcashflow to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hxyhcashflow is '华兴银行企业库现金流量表';
comment on column ${iol_schema}.wind_hxyhcashflow.object_id is '对象ID';
comment on column ${iol_schema}.wind_hxyhcashflow.comp_id is '公司ID';
comment on column ${iol_schema}.wind_hxyhcashflow.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_hxyhcashflow.report_period is '报告期';
comment on column ${iol_schema}.wind_hxyhcashflow.statement_type is '报表类型';
comment on column ${iol_schema}.wind_hxyhcashflow.iflisted_data is '是否上市后数据';
comment on column ${iol_schema}.wind_hxyhcashflow.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_hxyhcashflow.net_cash_flows_oper_act is '经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hxyhcashflow.net_cash_flows_inv_act is '投资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hxyhcashflow.net_cash_flows_fnc_act is '筹资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_hxyhcashflow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_hxyhcashflow.etl_timestamp is 'ETL处理时间戳';
