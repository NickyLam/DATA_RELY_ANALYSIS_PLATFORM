/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_cmm_unite_wl_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.crps_cmm_unite_wl_repay_plan
whenever sqlerror continue none;
drop table ${idl_schema}.crps_cmm_unite_wl_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.crps_cmm_unite_wl_repay_plan(
    etl_dt date -- ETL处理日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,prod_id varchar2(60) -- 产品编号
    ,tot_perds number(10) -- 总期数
    ,repay_perds number(10) -- 还款期数
    ,repay_sub_perds number(10) -- 还款子期数
    ,value_dt date -- 起息日期
    ,repaybl_dt date -- 应还款日期
    ,payoff_dt date -- 结清日期
    ,pric_turn_ovdue_dt date -- 本金转逾期日期
    ,int_turn_ovdue_dt date -- 利息转逾期日期
    ,inst_status_cd varchar2(30) -- 分期状态代码
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,repay_flg varchar2(10) -- 偿还标志
    ,curr_cd varchar2(10) -- 币种代码
    ,pric_ovdue_days number(22) -- 本金逾期天数
    ,int_ovdue_days number(22) -- 利息逾期天数
    ,curr_issue_recvbl_pric number(30,2) -- 本期应收本金
    ,curr_issue_int_recvbl number(30,2) -- 本期应收利息
    ,curr_issue_recvbl_pric_bal number(30,2) -- 本期应收本金余额
    ,curr_issue_int_recvbl_bal number(30,2) -- 本期应收利息余额
    ,curr_issue_ovdue_pric_pnlt number(30,2) -- 本期逾期本金罚息
    ,curr_issue_ovdue_int_pnlt number(30,2) -- 本期逾期利息罚息
    ,init_tot_perds number(10,0) -- 原始总期数
    ,init_repay_perds number(10,0) -- 原始还款期数
    ,init_value_dt date -- 原始起息日期
    ,grace_dt date -- 宽限日期
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_cmm_unite_wl_repay_plan to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_cmm_unite_wl_repay_plan is '联合网贷还款计划';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.lp_id is '法人编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.dubil_id is '借据编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.cust_id is '客户编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.prod_id is '产品编号';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.tot_perds is '总期数';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.repay_perds is '还款期数';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.repay_sub_perds is '还款子期数';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.value_dt is '起息日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.repaybl_dt is '应还款日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.payoff_dt is '结清日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.inst_status_cd is '分期状态代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.ovdue_flg is '逾期标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.repay_flg is '偿还标志';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_cd is '币种代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.pric_ovdue_days is '本金逾期天数';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.int_ovdue_days is '利息逾期天数';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_recvbl_pric is '本期应收本金';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_int_recvbl is '本期应收利息';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_recvbl_pric_bal is '本期应收本金余额';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_int_recvbl_bal is '本期应收利息余额';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_ovdue_pric_pnlt is '本期逾期本金罚息';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.curr_issue_ovdue_int_pnlt is '本期逾期利息罚息';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.job_cd is '任务代码';
comment on column ${idl_schema}.crps_cmm_unite_wl_repay_plan.etl_timestamp is 'ETL处理时间戳';