/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_evt_core_cap_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_evt_core_cap_tran_flow
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_evt_core_cap_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_evt_core_cap_tran_flow(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,tran_curr_cd varchar2(10) -- 交易币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,tran_acct_id varchar2(60) -- 交易账户编号
    ,tran_sub_acct_id varchar2(60) -- 交易子账户编号
    ,tran_acct_name varchar2(100) -- 交易账户户名
    ,tran_acct_open_bank_id varchar2(60) -- 交易账户开户行编号
    ,open_acct_vouch_kind_cd varchar2(10) -- 开户凭证种类代码
    ,open_acct_vouch_id varchar2(60) -- 开户凭证编号
    ,tran_vouch_kind_cd varchar2(10) -- 交易凭证种类代码
    ,tran_vouch_id varchar2(60) -- 交易凭证编号
    ,draw_dt date -- 出票日期
    ,cntpty_acct_id varchar2(60) -- 交易对手账户编号
    ,cntpty_sub_acct_id varchar2(60) -- 交易对手子账户编号
    ,cntpty_acct_name varchar2(100) -- 交易对手账户户名
    ,cntpty_acct_open_bank_id varchar2(60) -- 交易对手账户开户行编号
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_evt_core_cap_tran_flow to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_evt_core_cap_tran_flow is '核心资金交易流水';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.evt_id is '事件编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_dt is '交易日期';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_flow_num is '交易流水号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_curr_cd is '交易币种代码';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_amt is '交易金额';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_acct_id is '交易账户编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_sub_acct_id is '交易子账户编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_acct_name is '交易账户户名';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_acct_open_bank_id is '交易账户开户行编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.open_acct_vouch_kind_cd is '开户凭证种类代码';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.open_acct_vouch_id is '开户凭证编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_vouch_kind_cd is '交易凭证种类代码';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.tran_vouch_id is '交易凭证编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.draw_dt is '出票日期';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.cntpty_sub_acct_id is '交易对手子账户编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.cntpty_acct_name is '交易对手账户户名';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.cntpty_acct_open_bank_id is '交易对手账户开户行编号';
comment on column ${itl_schema}.itl_edw_evt_core_cap_tran_flow.etl_timestamp is 'ETL处理时间戳';