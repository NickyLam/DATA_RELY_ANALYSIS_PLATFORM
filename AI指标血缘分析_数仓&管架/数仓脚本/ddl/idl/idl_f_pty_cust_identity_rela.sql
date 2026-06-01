/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl f_pty_cust_identity_rela
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.f_pty_cust_identity_rela
whenever sqlerror continue none;
drop table ${idl_schema}.f_pty_cust_identity_rela purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.f_pty_cust_identity_rela(
    etl_dt date -- 数据日期
    ,party_id varchar2(35) -- 团体标识
    ,cust_no varchar2(30) -- 源系统客户号
    ,ods_src_id varchar2(10) -- 源系统简称
    ,ods_src_dt date -- 数据业务日期
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
grant select on ${idl_schema}.f_pty_cust_identity_rela to ${iel_schema};

-- comment
comment on table ${idl_schema}.f_pty_cust_identity_rela is '客户标识与各源客户关系';
comment on column ${idl_schema}.f_pty_cust_identity_rela.etl_dt is '数据日期';
comment on column ${idl_schema}.f_pty_cust_identity_rela.party_id is '团体标识';
comment on column ${idl_schema}.f_pty_cust_identity_rela.cust_no is '源系统客户号';
comment on column ${idl_schema}.f_pty_cust_identity_rela.ods_src_id is '源系统简称';
comment on column ${idl_schema}.f_pty_cust_identity_rela.ods_src_dt is '数据业务日期';
comment on column ${idl_schema}.f_pty_cust_identity_rela.job_cd is '任务代码';
comment on column ${idl_schema}.f_pty_cust_identity_rela.etl_timestamp is '数据处理时间';