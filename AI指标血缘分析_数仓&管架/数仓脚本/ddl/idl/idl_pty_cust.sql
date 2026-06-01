/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pty_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.pty_cust
whenever sqlerror continue none;
drop table ${idl_schema}.pty_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pty_cust(
    etl_dt date -- 数据日期   
    ,party_id varchar2(60) -- 当事人编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,sorc_sys_cd varchar2(10) -- 源系统代码   
    ,cust_id varchar2(60) -- 客户编号   
    ,cust_cate_cd varchar2(10) -- 客户类别代码   
    ,cust_type_cd varchar2(10) -- 客户类型代码   
    ,cert_no varchar2(60) -- 证件号码   
    ,cert_name varchar2(500) -- 证件名称   
    ,cert_type_cd varchar2(10) -- 证件类型代码   
    ,open_acct_user_id varchar2(60) -- 开户用户编号   
    ,open_acct_org_id varchar2(100) -- 开户机构编号   
    ,open_acct_dt date -- 开户日期   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识
    ,job_cd varchar2(10) -- 任务编码   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pty_cust to ${iel_schema};

-- comment
comment on table ${idl_schema}.pty_cust is '客户';
comment on column ${idl_schema}.pty_cust.etl_dt is '数据日期';
comment on column ${idl_schema}.pty_cust.party_id is '当事人编号';
comment on column ${idl_schema}.pty_cust.lp_id is '法人编号';
comment on column ${idl_schema}.pty_cust.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.pty_cust.cust_id is '客户编号';
comment on column ${idl_schema}.pty_cust.cust_cate_cd is '客户类别代码';
comment on column ${idl_schema}.pty_cust.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.pty_cust.cert_no is '证件号码';
comment on column ${idl_schema}.pty_cust.cert_name is '证件名称';
comment on column ${idl_schema}.pty_cust.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.pty_cust.open_acct_user_id is '开户用户编号';
comment on column ${idl_schema}.pty_cust.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.pty_cust.open_acct_dt is '开户日期';
comment on column ${idl_schema}.pty_cust.create_dt is '创建日期';
comment on column ${idl_schema}.pty_cust.update_dt is '更新日期';
comment on column ${idl_schema}.pty_cust.id_mark is '删除标识';