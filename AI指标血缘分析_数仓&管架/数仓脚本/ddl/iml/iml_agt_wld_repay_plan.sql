/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wld_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wld_repay_plan
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wld_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_repay_plan(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_dubil_id varchar2(60) -- 内部借据编号
    ,repay_plan_id varchar2(60) -- 还款计划编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_type_cd varchar2(10) -- 账户类型代码
    ,card_no varchar2(60) -- 卡号
    ,loan_tot_perds number(10) -- 贷款总期数
    ,curr_perds number(10) -- 当前期数
    ,loan_pric number(30,2) -- 贷款本金
    ,rpbl_pric number(30,2) -- 应还本金
    ,rpbl_fee_amt number(30,2) -- 应还费用金额
    ,rpbl_int number(30,8) -- 应还利息
    ,repaid_pric number(30,2) -- 已偿还本金
    ,repaid_int number(30,8) -- 已偿还利息
    ,repaid_pnlt number(30,2) -- 已偿还罚息
    ,repaid_comp_int number(30,2) -- 已偿还复利
    ,repaid_fee number(30,2) -- 已偿还费用
    ,reach_money_exp_repay_dt date -- 到款到期还款日期
    ,grace_dt date -- 宽限日期
    ,modif_tm timestamp -- 修改时间
    ,value_dt date -- 起息日期
    ,batch_doc_name varchar2(90) -- 批量文件名称
    ,ser_num varchar2(60) -- 序列号
    ,repay_plan_oper_act_cd varchar2(10) -- 还款计划操作动作代码
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_wld_repay_plan to ${icl_schema};
grant select on ${iml_schema}.agt_wld_repay_plan to ${idl_schema};
grant select on ${iml_schema}.agt_wld_repay_plan to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wld_repay_plan is '微粒贷还款计划';
comment on column ${iml_schema}.agt_wld_repay_plan.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wld_repay_plan.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wld_repay_plan.intnal_dubil_id is '内部借据编号';
comment on column ${iml_schema}.agt_wld_repay_plan.repay_plan_id is '还款计划编号';
comment on column ${iml_schema}.agt_wld_repay_plan.acct_id is '账户编号';
comment on column ${iml_schema}.agt_wld_repay_plan.acct_type_cd is '账户类型代码';
comment on column ${iml_schema}.agt_wld_repay_plan.card_no is '卡号';
comment on column ${iml_schema}.agt_wld_repay_plan.loan_tot_perds is '贷款总期数';
comment on column ${iml_schema}.agt_wld_repay_plan.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_wld_repay_plan.loan_pric is '贷款本金';
comment on column ${iml_schema}.agt_wld_repay_plan.rpbl_pric is '应还本金';
comment on column ${iml_schema}.agt_wld_repay_plan.rpbl_fee_amt is '应还费用金额';
comment on column ${iml_schema}.agt_wld_repay_plan.rpbl_int is '应还利息';
comment on column ${iml_schema}.agt_wld_repay_plan.repaid_pric is '已偿还本金';
comment on column ${iml_schema}.agt_wld_repay_plan.repaid_int is '已偿还利息';
comment on column ${iml_schema}.agt_wld_repay_plan.repaid_pnlt is '已偿还罚息';
comment on column ${iml_schema}.agt_wld_repay_plan.repaid_comp_int is '已偿还复利';
comment on column ${iml_schema}.agt_wld_repay_plan.repaid_fee is '已偿还费用';
comment on column ${iml_schema}.agt_wld_repay_plan.reach_money_exp_repay_dt is '到款到期还款日期';
comment on column ${iml_schema}.agt_wld_repay_plan.grace_dt is '宽限日期';
comment on column ${iml_schema}.agt_wld_repay_plan.modif_tm is '修改时间';
comment on column ${iml_schema}.agt_wld_repay_plan.value_dt is '起息日期';
comment on column ${iml_schema}.agt_wld_repay_plan.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.agt_wld_repay_plan.ser_num is '序列号';
comment on column ${iml_schema}.agt_wld_repay_plan.repay_plan_oper_act_cd is '还款计划操作动作代码';
comment on column ${iml_schema}.agt_wld_repay_plan.create_dt is '创建日期';
comment on column ${iml_schema}.agt_wld_repay_plan.update_dt is '更新日期';
comment on column ${iml_schema}.agt_wld_repay_plan.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wld_repay_plan.id_mark is '增删标志';
comment on column ${iml_schema}.agt_wld_repay_plan.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wld_repay_plan.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wld_repay_plan.etl_timestamp is 'ETL处理时间戳';
