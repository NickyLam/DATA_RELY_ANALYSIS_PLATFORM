/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_crdt_loan_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_crdt_loan_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_crdt_loan_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_loan_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,perds number(10) -- 期数
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,grace_dt_term date -- 宽限日期
    ,payoff_dt date -- 结清日期
    ,curr_cd varchar2(30) -- 币种代码
    ,exec_int_rat number(38,8) -- 执行利率
    ,nomal_pric number(30,8) -- 正常本金
    ,dubil_surp_loan_pric number(30,8) -- 借据剩余贷款本金
    ,eh_issue_repay_tot number(30,8) -- 每期还款总额
    ,surp_rpbl_int number(30,8) -- 剩余应还利息
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,curr_issue_recvbl_pric number(30,8) -- 本期应收本金
    ,curr_issue_int_recvbl number(30,8) -- 本期应收利息
    ,curr_issue_surp_pric number(30,8) -- 本期剩余本金
    ,thrinto_int_sub_amt number(30,8) -- 其中贴息金额
    ,aldy_proc_flg varchar2(10) -- 已处理标志
    ,paid_pric number(30,8) -- 实还本金
    ,paid_int number(30,8) -- 实还利息
    ,paid_pnlt number(30,8) -- 实还罚息
    ,paid_comp_int number(30,8) -- 实还复息
    ,acru_int number(30,2) -- 应计利息
    ,acru_pnlt number(30,2) -- 应计罚息
    ,acru_comp_int number(30,2) -- 应计复利
    ,recvbl_pnlt number(30,2) -- 应收罚息
    ,recvbl_comp_int number(30,2) -- 应收复利
    ,recvbl_over_int number(30,8) -- 应收欠息
    ,remark varchar2(1000) -- 备注
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
grant select on ${iml_schema}.agt_crdt_loan_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_crdt_loan_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_crdt_loan_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_crdt_loan_repay_plan is '信贷贷款还款计划';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.perds is '期数';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.grace_dt_term is '宽限日期';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.nomal_pric is '正常本金';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.dubil_surp_loan_pric is '借据剩余贷款本金';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.eh_issue_repay_tot is '每期还款总额';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.surp_rpbl_int is '剩余应还利息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.curr_issue_recvbl_pric is '本期应收本金';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.curr_issue_int_recvbl is '本期应收利息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.curr_issue_surp_pric is '本期剩余本金';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.thrinto_int_sub_amt is '其中贴息金额';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.aldy_proc_flg is '已处理标志';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.paid_pric is '实还本金';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.paid_int is '实还利息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.paid_comp_int is '实还复息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.acru_int is '应计利息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.acru_pnlt is '应计罚息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.acru_comp_int is '应计复利';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.recvbl_comp_int is '应收复利';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.recvbl_over_int is '应收欠息';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.remark is '备注';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.start_dt is '开始时间';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.end_dt is '结束时间';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_crdt_loan_repay_plan.etl_timestamp is 'ETL处理时间戳';
