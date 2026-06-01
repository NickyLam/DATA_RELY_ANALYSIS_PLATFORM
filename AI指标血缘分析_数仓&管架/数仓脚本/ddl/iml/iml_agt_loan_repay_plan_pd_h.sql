/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_repay_plan_pd_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_repay_plan_pd_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_repay_plan_pd_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_repay_plan_pd_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,curr_pd number(10) -- 当前期次
    ,cust_id varchar2(100) -- 客户编号
    ,accti_status_cd varchar2(30) -- 核算状态代码
    ,last_accti_status_cd varchar2(30) -- 上一核算状态代码
    ,exp_dt date -- 到期日期
    ,ovdue_pric number(30,2) -- 逾期本金
    ,ld_ovdue_pric number(30,2) -- 上日逾期本金
    ,ovdue_int number(30,2) -- 逾期利息
    ,ld_ovdue_int number(30,2) -- 上日逾期利息
    ,ovdue_pnlt_bal number(30,2) -- 逾期罚息余额
    ,ld_ovdue_pnlt number(30,2) -- 上日逾期罚息
    ,comp_int_bal number(30,2) -- 复利余额
    ,ld_ovdue_comp_int number(30,2) -- 上日逾期复利
    ,grace_period_int number(30,2) -- 宽限期利息
    ,ld_grace_period_int number(30,2) -- 上日宽限期利息
    ,grace_period_comp_int number(30,2) -- 宽限期复利
    ,ld_grace_period_comp_int number(30,2) -- 上日宽限期复利
    ,grace_period_pnlt number(30,2) -- 宽限期罚息
    ,ld_grace_period_pnlt number(30,2) -- 上日宽限期罚息
    ,grace_period_pric number(30,2) -- 宽限期本金
    ,ld_grace_period_pric number(30,2) -- 上日宽限期本金
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_repay_plan_pd_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_repay_plan_pd_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_repay_plan_pd_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_repay_plan_pd_h is '贷款还款计划期次历史';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.curr_pd is '当前期次';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.accti_status_cd is '核算状态代码';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.last_accti_status_cd is '上一核算状态代码';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ovdue_pric is '逾期本金';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_ovdue_pric is '上日逾期本金';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_ovdue_int is '上日逾期利息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ovdue_pnlt_bal is '逾期罚息余额';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_ovdue_pnlt is '上日逾期罚息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.comp_int_bal is '复利余额';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_ovdue_comp_int is '上日逾期复利';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.grace_period_int is '宽限期利息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_grace_period_int is '上日宽限期利息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.grace_period_comp_int is '宽限期复利';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_grace_period_comp_int is '上日宽限期复利';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.grace_period_pnlt is '宽限期罚息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_grace_period_pnlt is '上日宽限期罚息';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.grace_period_pric is '宽限期本金';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.ld_grace_period_pric is '上日宽限期本金';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_repay_plan_pd_h.etl_timestamp is 'ETL处理时间戳';
