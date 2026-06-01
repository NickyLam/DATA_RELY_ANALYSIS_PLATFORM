/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_acel_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_acel_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_acel_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_acel_detl(
    stacid number(19) -- 账套
    ,elemcd varchar2(16) -- 分户要素编码
    ,condcd varchar2(100) -- 执行条件
    ,relatp varchar2(20) -- 对应关系
    ,varicd varchar2(120) -- 对应计量后交易明细表字段
    ,desctx varchar2(255) -- 说明
    ,varina varchar2(120) -- 对应计量后交易明细表字段名称
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
grant select on ${iol_schema}.tgls_amc_acel_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_acel_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_acel_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_acel_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_acel_detl is '分户要素与计量对应关系表';
comment on column ${iol_schema}.tgls_amc_acel_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_acel_detl.elemcd is '分户要素编码';
comment on column ${iol_schema}.tgls_amc_acel_detl.condcd is '执行条件';
comment on column ${iol_schema}.tgls_amc_acel_detl.relatp is '对应关系';
comment on column ${iol_schema}.tgls_amc_acel_detl.varicd is '对应计量后交易明细表字段';
comment on column ${iol_schema}.tgls_amc_acel_detl.desctx is '说明';
comment on column ${iol_schema}.tgls_amc_acel_detl.varina is '对应计量后交易明细表字段名称';
comment on column ${iol_schema}.tgls_amc_acel_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_acel_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_acel_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_acel_detl.etl_timestamp is 'ETL处理时间戳';
