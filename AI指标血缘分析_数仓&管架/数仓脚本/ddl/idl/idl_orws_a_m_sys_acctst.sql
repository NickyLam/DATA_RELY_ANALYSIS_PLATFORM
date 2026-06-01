/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl orws_a_m_sys_acctst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.orws_a_m_sys_acctst
whenever sqlerror continue none;
drop table ${idl_schema}.orws_a_m_sys_acctst purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.orws_a_m_sys_acctst(
    etl_dt date -- ETL处理日期
    ,type varchar2(10) -- 类型
    ,name varchar2(50) -- 名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.orws_a_m_sys_acctst to ${iel_schema};

-- comment
comment on table ${idl_schema}.orws_a_m_sys_acctst is '账户状态配置表';
comment on column ${idl_schema}.orws_a_m_sys_acctst.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.orws_a_m_sys_acctst.type is '类型';
comment on column ${idl_schema}.orws_a_m_sys_acctst.name is '名称';
comment on column ${idl_schema}.orws_a_m_sys_acctst.job_cd is '任务代码';
comment on column ${idl_schema}.orws_a_m_sys_acctst.etl_timestamp is 'ETL处理时间戳';
