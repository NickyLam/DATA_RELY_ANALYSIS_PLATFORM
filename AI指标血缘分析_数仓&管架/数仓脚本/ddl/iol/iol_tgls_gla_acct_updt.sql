/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_acct_updt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_acct_updt
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_acct_updt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct_updt(
    trandt varchar2(8) -- 维护日期
    ,transq varchar2(20) -- 维护流水
    ,acctno varchar2(40) -- 维护主题
    ,updcol varchar2(120) -- 维护字段
    ,oldval varchar2(300) -- 维护前内容
    ,newval varchar2(300) -- 维护后内容
    ,tranus varchar2(20) -- 维护柜员
    ,tranbr varchar2(12) -- 维护机构编号
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
grant select on ${iol_schema}.tgls_gla_acct_updt to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_acct_updt to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_acct_updt to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_acct_updt to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_acct_updt is '账户变更表';
comment on column ${iol_schema}.tgls_gla_acct_updt.trandt is '维护日期';
comment on column ${iol_schema}.tgls_gla_acct_updt.transq is '维护流水';
comment on column ${iol_schema}.tgls_gla_acct_updt.acctno is '维护主题';
comment on column ${iol_schema}.tgls_gla_acct_updt.updcol is '维护字段';
comment on column ${iol_schema}.tgls_gla_acct_updt.oldval is '维护前内容';
comment on column ${iol_schema}.tgls_gla_acct_updt.newval is '维护后内容';
comment on column ${iol_schema}.tgls_gla_acct_updt.tranus is '维护柜员';
comment on column ${iol_schema}.tgls_gla_acct_updt.tranbr is '维护机构编号';
comment on column ${iol_schema}.tgls_gla_acct_updt.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gla_acct_updt.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gla_acct_updt.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gla_acct_updt.etl_timestamp is 'ETL处理时间戳';
