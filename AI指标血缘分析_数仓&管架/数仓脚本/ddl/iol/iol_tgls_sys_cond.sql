/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_cond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_cond
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_cond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_cond(
    condcd varchar2(20) -- 条件码
    ,condtp varchar2(30) -- 条件码类型
    ,condna varchar2(64) -- 条件名称
    ,desctx varchar2(255) -- 说明
    ,vermod number(19) -- 版本模式
    ,module varchar2(20) -- 模块
    ,projcd varchar2(10) -- 项目编号
    ,formul varchar2(1000) -- 执行条件公式
    ,formna varchar2(1000) -- 执行条件公式名称
    ,stacid number(19) -- 账套
    ,fumodu varchar2(1) -- 所属功能模块,0：会计引擎1：会计计量
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
grant select on ${iol_schema}.tgls_sys_cond to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_cond to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_cond to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_cond to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_cond is '系统条件表';
comment on column ${iol_schema}.tgls_sys_cond.condcd is '条件码';
comment on column ${iol_schema}.tgls_sys_cond.condtp is '条件码类型';
comment on column ${iol_schema}.tgls_sys_cond.condna is '条件名称';
comment on column ${iol_schema}.tgls_sys_cond.desctx is '说明';
comment on column ${iol_schema}.tgls_sys_cond.vermod is '版本模式';
comment on column ${iol_schema}.tgls_sys_cond.module is '模块';
comment on column ${iol_schema}.tgls_sys_cond.projcd is '项目编号';
comment on column ${iol_schema}.tgls_sys_cond.formul is '执行条件公式';
comment on column ${iol_schema}.tgls_sys_cond.formna is '执行条件公式名称';
comment on column ${iol_schema}.tgls_sys_cond.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_cond.fumodu is '所属功能模块,0：会计引擎1：会计计量';
comment on column ${iol_schema}.tgls_sys_cond.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_cond.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_cond.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_cond.etl_timestamp is 'ETL处理时间戳';
