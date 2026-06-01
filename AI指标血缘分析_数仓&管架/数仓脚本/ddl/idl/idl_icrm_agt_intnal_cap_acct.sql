/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_agt_intnal_cap_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_agt_intnal_cap_acct
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_agt_intnal_cap_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_agt_intnal_cap_acct(
    etl_dt date -- 数据日期
    ,agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(500) -- 账户名称
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,cap_type_cd varchar2(10) -- 资金类型代码
    ,belong_org_id varchar2(60) -- 所属机构编号
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
grant select on ${idl_schema}.icrm_agt_intnal_cap_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_agt_intnal_cap_acct is '内部资金账户';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.agt_id is '协议编号';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.acct_id is '账户编号';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.acct_name is '账户名称';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.cap_type_cd is '资金类型代码';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_agt_intnal_cap_acct.etl_timestamp is '数据处理时间';
