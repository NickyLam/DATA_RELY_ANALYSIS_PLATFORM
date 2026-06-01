/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_trcd_rule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_trcd_rule
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_trcd_rule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trcd_rule(
    stacid number(19) -- 账套
    ,trancd varchar2(20) -- 子交易代码
    ,sortno number -- 序号
    ,condcd varchar2(20) -- 条件代码
    ,beanid varchar2(30) -- 处理规则
    ,vermod number(19) -- 版本模式
    ,module varchar2(20) -- 业务类型
    ,projcd varchar2(10) -- 项目
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
grant select on ${iol_schema}.tgls_sys_trcd_rule to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_trcd_rule to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_rule to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_trcd_rule to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_trcd_rule is '子交易分录行模板';
comment on column ${iol_schema}.tgls_sys_trcd_rule.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_trcd_rule.trancd is '子交易代码';
comment on column ${iol_schema}.tgls_sys_trcd_rule.sortno is '序号';
comment on column ${iol_schema}.tgls_sys_trcd_rule.condcd is '条件代码';
comment on column ${iol_schema}.tgls_sys_trcd_rule.beanid is '处理规则';
comment on column ${iol_schema}.tgls_sys_trcd_rule.vermod is '版本模式';
comment on column ${iol_schema}.tgls_sys_trcd_rule.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_trcd_rule.projcd is '项目';
comment on column ${iol_schema}.tgls_sys_trcd_rule.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_sys_trcd_rule.etl_timestamp is 'ETL处理时间戳';
