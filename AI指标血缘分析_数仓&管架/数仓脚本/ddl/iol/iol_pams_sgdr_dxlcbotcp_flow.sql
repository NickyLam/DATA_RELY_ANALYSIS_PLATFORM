/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_sgdr_dxlcbotcp_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_sgdr_dxlcbotcp_flow
whenever sqlerror continue none;
drop table ${iol_schema}.pams_sgdr_dxlcbotcp_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_sgdr_dxlcbotcp_flow(
    tjrq number(22) -- 数据日期
    ,tjksrq number(22) -- 产品导入日期
    ,cpdm varchar2(90) -- 产品代码
    ,xssxfzsbl number(25,4) -- 销售手续费中收比例
    ,glfzsfcbl number(25,4) -- 管理费中收分成比例
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
grant select on ${iol_schema}.pams_sgdr_dxlcbotcp_flow to ${iml_schema};
grant select on ${iol_schema}.pams_sgdr_dxlcbotcp_flow to ${icl_schema};
grant select on ${iol_schema}.pams_sgdr_dxlcbotcp_flow to ${idl_schema};
grant select on ${iol_schema}.pams_sgdr_dxlcbotcp_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_sgdr_dxlcbotcp_flow is '手工导入_代销理财BOT产品_回流';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.tjrq is '数据日期';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.tjksrq is '产品导入日期';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.cpdm is '产品代码';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.xssxfzsbl is '销售手续费中收比例';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.glfzsfcbl is '管理费中收分成比例';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_sgdr_dxlcbotcp_flow.etl_timestamp is 'ETL处理时间戳';
