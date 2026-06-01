/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_lhwd_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_lhwd_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_lhwd_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_repay_plan(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,partner_dubil_id varchar2(100) -- 合作方借据编号
    ,curr_perds number(10) -- 当前期数
    ,currt_status_cd varchar2(30) -- 当期状态代码
    ,curr_cd varchar2(30) -- 币种代码
    ,repay_dt date -- 还款日期
    ,begin_dt date -- 起始日期
    ,exp_dt date -- 到期日期
    ,payoff_dt date -- 结清日期
    ,int_accr_end_dt date -- 计息结束日期
    ,rpbl_pric number(30,8) -- 应还本金
    ,pric_bal number(30,8) -- 本金余额
    ,int_recvbl number(30,8) -- 应收利息
    ,recvbl_pnlt number(30,8) -- 应收罚息
    ,recvbl_comp_int number(30,8) -- 应收复利
    ,paid_pric number(30,8) -- 实还本金
    ,paid_int number(30,8) -- 实还利息
    ,paid_pnlt number(30,8) -- 实还罚息
    ,paid_comp_int number(30,8) -- 实还复利
    ,derate_int number(30,8) -- 减免利息
    ,derate_pnlt number(30,8) -- 减免罚息
    ,derate_comp_int number(30,8) -- 减免复利
    ,int_bal number(30,8) -- 利息余额
    ,pnlt_bal number(30,8) -- 罚息余额
    ,comp_int_bal number(30,8) -- 复利余额
    ,pric_ovdue_days number(22) -- 本金逾期天数
    ,int_ovdue_days number(22) -- 利息逾期天数
    ,pric_turn_ovdue_dt date -- 本金转逾期日期
    ,int_turn_ovdue_dt date -- 利息转逾期日期
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
grant select on ${iml_schema}.agt_lhwd_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_lhwd_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_lhwd_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_lhwd_repay_plan is '联合网贷还款计划';
comment on column ${iml_schema}.agt_lhwd_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_lhwd_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_lhwd_repay_plan.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_lhwd_repay_plan.partner_dubil_id is '合作方借据编号';
comment on column ${iml_schema}.agt_lhwd_repay_plan.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_lhwd_repay_plan.currt_status_cd is '当期状态代码';
comment on column ${iml_schema}.agt_lhwd_repay_plan.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_lhwd_repay_plan.repay_dt is '还款日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.begin_dt is '起始日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.int_accr_end_dt is '计息结束日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_lhwd_repay_plan.pric_bal is '本金余额';
comment on column ${iml_schema}.agt_lhwd_repay_plan.int_recvbl is '应收利息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.recvbl_pnlt is '应收罚息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.recvbl_comp_int is '应收复利';
comment on column ${iml_schema}.agt_lhwd_repay_plan.paid_pric is '实还本金';
comment on column ${iml_schema}.agt_lhwd_repay_plan.paid_int is '实还利息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.paid_pnlt is '实还罚息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.paid_comp_int is '实还复利';
comment on column ${iml_schema}.agt_lhwd_repay_plan.derate_int is '减免利息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.derate_pnlt is '减免罚息';
comment on column ${iml_schema}.agt_lhwd_repay_plan.derate_comp_int is '减免复利';
comment on column ${iml_schema}.agt_lhwd_repay_plan.int_bal is '利息余额';
comment on column ${iml_schema}.agt_lhwd_repay_plan.pnlt_bal is '罚息余额';
comment on column ${iml_schema}.agt_lhwd_repay_plan.comp_int_bal is '复利余额';
comment on column ${iml_schema}.agt_lhwd_repay_plan.pric_ovdue_days is '本金逾期天数';
comment on column ${iml_schema}.agt_lhwd_repay_plan.int_ovdue_days is '利息逾期天数';
comment on column ${iml_schema}.agt_lhwd_repay_plan.pric_turn_ovdue_dt is '本金转逾期日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.int_turn_ovdue_dt is '利息转逾期日期';
comment on column ${iml_schema}.agt_lhwd_repay_plan.start_dt is '开始时间';
comment on column ${iml_schema}.agt_lhwd_repay_plan.end_dt is '结束时间';
comment on column ${iml_schema}.agt_lhwd_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_lhwd_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_lhwd_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_lhwd_repay_plan.etl_timestamp is 'ETL处理时间戳';
