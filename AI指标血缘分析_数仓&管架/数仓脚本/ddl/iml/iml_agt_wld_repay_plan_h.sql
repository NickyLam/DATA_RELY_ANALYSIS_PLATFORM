/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_repay_plan_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_repay_plan_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_repay_plan_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_repay_plan_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_dubil_id varchar2(100) -- 内部借据编号
    ,repay_plan_id varchar2(100) -- 还款计划编号
    ,acct_id varchar2(100) -- 账户编号
    ,acct_type_cd varchar2(30) -- 账户类型代码
    ,card_no varchar2(60) -- 卡号
    ,loan_tot_perds number(10) -- 贷款总期数
    ,curr_perds number(38) -- 当前期数
    ,loan_pric number(30,2) -- 贷款本金
    ,rpbl_pric number(30,2) -- 应还本金
    ,rpbl_fee_amt number(30,2) -- 应还费用金额
    ,rpbl_int number(30,2) -- 应还利息
    ,repaid_pric number(30,2) -- 已偿还本金
    ,repaid_int number(30,2) -- 已偿还利息
    ,repaid_pnlt number(30,2) -- 已偿还罚息
    ,repaid_comp_int number(30,2) -- 已偿还复利
    ,repaid_fee number(30,2) -- 已偿还费用
    ,reach_money_exp_repay_dt date -- 到款到期还款日期
    ,grace_dt date -- 宽限日期
    ,modif_tm timestamp -- 修改时间
    ,value_dt date -- 起息日期
    ,repay_plan_oper_act_cd varchar2(30) -- 还款计划操作动作代码
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
grant select on ${iml_schema}.agt_wld_repay_plan_h to ${icl_schema};
grant select on ${iml_schema}.agt_wld_repay_plan_h to ${idl_schema};
grant select on ${iml_schema}.agt_wld_repay_plan_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_repay_plan_h is '微粒贷还款计划历史';
comment on column ${iml_schema}.agt_wld_repay_plan_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.intnal_dubil_id is '内部借据编号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repay_plan_id is '还款计划编号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wld_repay_plan_h.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_repay_plan_h.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_wld_repay_plan_h.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_wld_repay_plan_h.loan_pric is '贷款本金';
comment on column ${iml_schema}.agt_wld_repay_plan_h.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_wld_repay_plan_h.rpbl_fee_amt is '应还费用金额';
comment on column ${iml_schema}.agt_wld_repay_plan_h.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repaid_pric is '已偿还本金';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repaid_int is '已偿还利息';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repaid_pnlt is '已偿还罚息';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repaid_comp_int is '已偿还复利';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repaid_fee is '已偿还费用';
comment on column ${iml_schema}.agt_wld_repay_plan_h.reach_money_exp_repay_dt is '到款到期还款日期';
comment on column ${iml_schema}.agt_wld_repay_plan_h.grace_dt is '宽限日期';
comment on column ${iml_schema}.agt_wld_repay_plan_h.modif_tm is '修改时间';
comment on column ${iml_schema}.agt_wld_repay_plan_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_wld_repay_plan_h.repay_plan_oper_act_cd is '还款计划操作动作代码';
comment on column ${iml_schema}.agt_wld_repay_plan_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_wld_repay_plan_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_wld_repay_plan_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_repay_plan_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_repay_plan_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_repay_plan_h.etl_timestamp is 'ETL处理时间戳';
