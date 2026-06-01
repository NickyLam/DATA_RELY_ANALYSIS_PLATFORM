/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_evt_fx_ib_lend_provi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_evt_fx_ib_lend_provi
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_evt_fx_ib_lend_provi purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_evt_fx_ib_lend_provi(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,tran_flow_num varchar2(60) -- 交易流水号
    ,dept_id varchar2(60) -- 部门编号
    ,org_id varchar2(60) -- 机构编号
    ,curr_cd varchar2(10) -- 币种代码
    ,tran_amt number(30,2) -- 交易金额
    ,term_end_stl_amt number(30,2) -- 期末结算金额
    ,ib_lend_int_rat number(18,8) -- 拆借利率
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,tran_aim_cd varchar2(10) -- 交易目的代码
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,int_accr_base_cd varchar2(10) -- 计息基准代码
    ,portf_id varchar2(60) -- 投组编号
    ,provi_dt date -- 计提日期
    ,provi_amt number(30,2) -- 计提金额
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,ib_lend_type_cd varchar2(10) -- 拆借类型代码
    ,bag_id varchar2(60) -- 成交编号
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
grant select on ${idl_schema}.icrm_evt_fx_ib_lend_provi to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_evt_fx_ib_lend_provi is '外汇同业拆借计提事件';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.evt_id is '事件编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.dept_id is '部门编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.org_id is '机构编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.curr_cd is '币种代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.tran_amt is '交易金额';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.term_end_stl_amt is '期末结算金额';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.ib_lend_int_rat is '拆借利率';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.tran_dt is '交易日期';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.value_dt is '起息日期';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.exp_dt is '到期日期';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.tran_aim_cd is '交易目的代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.cntpty_id is '交易对手编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.int_accr_base_cd is '计息基准代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.portf_id is '投组编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.provi_dt is '计提日期';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.provi_amt is '计提金额';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.tran_dir_cd is '交易方向代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.ib_lend_type_cd is '拆借类型代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.bag_id is '成交编号';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_evt_fx_ib_lend_provi.etl_timestamp is '数据处理时间';
