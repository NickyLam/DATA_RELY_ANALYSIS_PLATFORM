/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl f_agt_acct_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.f_agt_acct_rela
whenever sqlerror continue none;
drop table ${idl_schema}.f_agt_acct_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.f_agt_acct_rela(
    etl_dt date -- 数据日期
    ,rela_type varchar2(10) -- 关联类型
    ,ods_acctid varchar2(50) -- ODS账户ID
    ,ods_relaid varchar2(50) -- ODS关联ID
    ,src_acctid varchar2(50) -- 源系统平台ID
    ,src_relaid varchar2(50) -- 源系统关联ID
    ,src_acctno varchar2(50) -- 源系统账号
    ,src_subsac varchar2(5) -- 源系统子账号
    ,ods_src_dt varchar2(8) -- 业务日期
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.f_agt_acct_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.f_agt_acct_rela is 'FDM协议账户标识与源系统对照表';
comment on column ${idl_schema}.f_agt_acct_rela.etl_dt is '数据日期';
comment on column ${idl_schema}.f_agt_acct_rela.rela_type is '关联类型';
comment on column ${idl_schema}.f_agt_acct_rela.ods_acctid is 'ODS账户ID';
comment on column ${idl_schema}.f_agt_acct_rela.ods_relaid is 'ODS关联ID';
comment on column ${idl_schema}.f_agt_acct_rela.src_acctid is '源系统平台ID';
comment on column ${idl_schema}.f_agt_acct_rela.src_relaid is '源系统关联ID';
comment on column ${idl_schema}.f_agt_acct_rela.src_acctno is '源系统账号';
comment on column ${idl_schema}.f_agt_acct_rela.src_subsac is '源系统子账号';
comment on column ${idl_schema}.f_agt_acct_rela.ods_src_dt is '业务日期';
comment on column ${idl_schema}.f_agt_acct_rela.job_cd is '任务代码';
comment on column ${idl_schema}.f_agt_acct_rela.etl_timestamp is '数据处理时间';