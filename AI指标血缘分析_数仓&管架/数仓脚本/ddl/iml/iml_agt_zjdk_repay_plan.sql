/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_zjdk_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_zjdk_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_zjdk_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_zjdk_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,intnal_dubil_id varchar2(100) -- 借据编号
    ,tenor number(10) -- 期限
    ,fin_dt date -- 财务日期
    ,plat_indent_id varchar2(100) -- 平台订单编号
    ,zjdk_prod_id varchar2(100) -- 字节产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,payoff_dt date -- 结清日期
    ,ovdue_days number(10) -- 贷款逾期天数
    ,curr_issue_status_cd varchar2(30) -- 本期状态代码
    ,rpbl_pric number(30,8) -- 应还本金
    ,paid_pric number(30,8) -- 已还本金
    ,plan_int number(30,8) -- 计划利息
    ,rpbl_int number(30,8) -- 应还利息
    ,paid_int number(30,8) -- 已还利息
    ,derate_int number(30,8) -- 减免利息
    ,int_bal number(30,8) -- 利息余额
    ,rpbl_pnlt number(30,8) -- 应还罚息
    ,paid_pnlt number(30,8) -- 已还罚息
    ,derate_pnlt number(30,8) -- 减免罚息
    ,pnlt_bal number(30,8) -- 罚息余额
    ,paid_adv_repay_comm_fee number(30,8) -- 已还提前还款手续费
    ,td_provi_int number(30,8) -- 当日计提利息
    ,td_provi_pnlt number(30,8) -- 当日计提罚息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_zjdk_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_zjdk_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_zjdk_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_zjdk_repay_plan is '字节小微贷还款计划';
comment on column ${iml_schema}.agt_zjdk_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_zjdk_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_zjdk_repay_plan.intnal_dubil_id is '借据编号';
comment on column ${iml_schema}.agt_zjdk_repay_plan.tenor is '期限';
comment on column ${iml_schema}.agt_zjdk_repay_plan.fin_dt is '财务日期';
comment on column ${iml_schema}.agt_zjdk_repay_plan.plat_indent_id is '平台订单编号';
comment on column ${iml_schema}.agt_zjdk_repay_plan.zjdk_prod_id is '字节产品编号';
comment on column ${iml_schema}.agt_zjdk_repay_plan.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_zjdk_repay_plan.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_zjdk_repay_plan.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_zjdk_repay_plan.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_zjdk_repay_plan.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_zjdk_repay_plan.curr_issue_status_cd is '本期状态代码';
comment on column ${iml_schema}.agt_zjdk_repay_plan.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_zjdk_repay_plan.paid_pric is '已还本金';
comment on column ${iml_schema}.agt_zjdk_repay_plan.plan_int is '计划利息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.paid_int is '已还利息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.derate_int is '减免利息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.int_bal is '利息余额';
comment on column ${iml_schema}.agt_zjdk_repay_plan.rpbl_pnlt is '应还罚息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.paid_pnlt is '已还罚息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.derate_pnlt is '减免罚息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_zjdk_repay_plan.paid_adv_repay_comm_fee is '已还提前还款手续费';
comment on column ${iml_schema}.agt_zjdk_repay_plan.td_provi_int is '当日计提利息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.td_provi_pnlt is '当日计提罚息';
comment on column ${iml_schema}.agt_zjdk_repay_plan.start_dt is '开始时间';
comment on column ${iml_schema}.agt_zjdk_repay_plan.end_dt is '结束时间';
comment on column ${iml_schema}.agt_zjdk_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_zjdk_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_zjdk_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_zjdk_repay_plan.etl_timestamp is 'ETL处理时间戳';
