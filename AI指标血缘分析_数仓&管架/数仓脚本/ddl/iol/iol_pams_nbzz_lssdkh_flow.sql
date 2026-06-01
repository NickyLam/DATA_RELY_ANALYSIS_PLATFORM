/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_lssdkh_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_lssdkh_flow
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_lssdkh_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_lssdkh_flow(
    tjrq number(22) -- 统计日期
    ,khh varchar2(90) -- 客户号
    ,ztbs varchar2(12) -- 状态标识：0-失效，1-有效
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
grant select on ${iol_schema}.pams_nbzz_lssdkh_flow to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_lssdkh_flow to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_lssdkh_flow to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_lssdkh_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_lssdkh_flow is '内部总账-零售收单客户-回流';
comment on column ${iol_schema}.pams_nbzz_lssdkh_flow.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_lssdkh_flow.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_lssdkh_flow.ztbs is '状态标识：0-失效，1-有效';
comment on column ${iol_schema}.pams_nbzz_lssdkh_flow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_lssdkh_flow.etl_timestamp is 'ETL处理时间戳';
