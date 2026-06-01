/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_pty_fx_cap_cntpty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_pty_fx_cap_cntpty
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_pty_fx_cap_cntpty purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_pty_fx_cap_cntpty(
    etl_dt date -- 数据日期
    ,party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,dept_id varchar2(60) -- 部门编号
    ,cn_name varchar2(500) -- 中文名称
    ,en_name varchar2(500) -- 英文名称
    ,cn_abbr varchar2(500) -- 中文简称
    ,en_abbr varchar2(500) -- 英文简称
    ,fx_id varchar2(60) -- 外汇编号
    ,cust_id varchar2(100) -- 客户编号
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
grant select on ${idl_schema}.icrm_pty_fx_cap_cntpty to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_pty_fx_cap_cntpty is '外汇资金交易对手';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.party_id is '当事人编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.dept_id is '部门编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.cn_name is '中文名称';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.en_name is '英文名称';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.cn_abbr is '中文简称';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.en_abbr is '英文简称';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.fx_id is '外汇编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.cust_id is '客户编号';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_pty_fx_cap_cntpty.etl_timestamp is '数据处理时间';
