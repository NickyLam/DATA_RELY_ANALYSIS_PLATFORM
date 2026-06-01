/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_tbst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_tbst
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_tbst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_tbst(
    stacid number(19) -- 账套
    ,tablcd varchar2(30) -- 表代码
    ,tablna varchar2(255) -- 表名称
    ,busitp varchar2(20) -- 业务类型
    ,tabltp varchar2(20) -- 表类型
    ,status varchar2(1) -- 是否启用
    ,usedtp varchar2(1) -- 使用状态
    ,desctx varchar2(255) -- 说明
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
grant select on ${iol_schema}.tgls_amc_tbst to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_tbst to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_tbst to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_tbst to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_tbst is '会计计量涉及表定义';
comment on column ${iol_schema}.tgls_amc_tbst.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_tbst.tablcd is '表代码';
comment on column ${iol_schema}.tgls_amc_tbst.tablna is '表名称';
comment on column ${iol_schema}.tgls_amc_tbst.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_tbst.tabltp is '表类型';
comment on column ${iol_schema}.tgls_amc_tbst.status is '是否启用';
comment on column ${iol_schema}.tgls_amc_tbst.usedtp is '使用状态';
comment on column ${iol_schema}.tgls_amc_tbst.desctx is '说明';
comment on column ${iol_schema}.tgls_amc_tbst.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_tbst.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_tbst.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_tbst.etl_timestamp is 'ETL处理时间戳';
