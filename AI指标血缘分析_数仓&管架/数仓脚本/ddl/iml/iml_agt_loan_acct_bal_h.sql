/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_bal_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,distr_amt number(30,2) -- 发放金额
    ,ld_distr_amt number(30,2) -- 上日发放金额
    ,nomal_pric number(30,2) -- 正常本金
    ,ld_nomal_pric number(30,2) -- 上日正常本金
    ,ovdue_pric number(30,2) -- 逾期本金
    ,ld_ovdue_pric number(30,2) -- 上日逾期本金
    ,ovdue_int number(30,2) -- 逾期利息
    ,ld_ovdue_int number(30,2) -- 上日逾期利息
    ,ovdue_pnlt number(30,2) -- 逾期罚息
    ,ld_ovdue_pnlt number(30,2) -- 上日逾期罚息
    ,ovdue_comp_int number(30,2) -- 逾期复利
    ,ld_ovdue_comp_int number(30,2) -- 上日逾期复利
    ,grace_period_pric number(30,2) -- 宽限期本金
    ,ld_grace_period_pric number(30,2) -- 上日宽限期本金
    ,grace_period_int number(30,2) -- 宽限期利息
    ,ld_grace_period_int number(30,2) -- 上日宽限期利息
    ,grace_period_pnlt number(30,2) -- 宽限期罚息
    ,ld_grace_period_pnlt number(30,2) -- 上日宽限期罚息
    ,grace_period_comp_int number(30,2) -- 宽限期复利
    ,ld_grace_period_comp_int number(30,2) -- 上日宽限期复利
    ,last_activ_acct_dt date -- 上一动户日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
    ,final_modif_dt date -- 最后修改日期
    ,up_ld_distr_amt number(30,2) -- 上上日发放金额
    ,up_ld_unexp_pric number(30,2) -- 上上日未到期本金
    ,up_ld_ovdue_pric number(30,2) -- 上上日逾期本金
    ,up_ld_ovdue_int number(30,2) -- 上上日逾期利息
    ,up_ld_ovdue_pnlt number(30,2) -- 上上日逾期罚息
    ,up_ld_ovdue_comp_int number(30,2) -- 上上日逾期复利
    ,up_ld_grace_period_pric number(30,2) -- 上上日宽限期本金
    ,up_ld_grace_period_int number(30,2) -- 上上日宽限期利息
    ,up_ld_grace_period_pnlt number(30,2) -- 上上日宽限期罚息
    ,up_ld_grace_period_comp_int number(30,2) -- 上上日宽限期复利
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
grant select on ${iml_schema}.agt_loan_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_bal_h is '贷款账户余额历史';
comment on column ${iml_schema}.agt_loan_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_bal_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_bal_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_bal_h.distr_amt is '发放金额';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_distr_amt is '上日发放金额';
comment on column ${iml_schema}.agt_loan_acct_bal_h.nomal_pric is '正常本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_nomal_pric is '上日正常本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ovdue_pric is '逾期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_ovdue_pric is '上日逾期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_ovdue_int is '上日逾期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ovdue_pnlt is '逾期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_ovdue_pnlt is '上日逾期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ovdue_comp_int is '逾期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_ovdue_comp_int is '上日逾期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.grace_period_pric is '宽限期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_grace_period_pric is '上日宽限期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.grace_period_int is '宽限期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_grace_period_int is '上日宽限期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.grace_period_pnlt is '宽限期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_grace_period_pnlt is '上日宽限期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.grace_period_comp_int is '宽限期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.ld_grace_period_comp_int is '上日宽限期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.last_activ_acct_dt is '上一动户日期';
comment on column ${iml_schema}.agt_loan_acct_bal_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.agt_loan_acct_bal_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_distr_amt is '上上日发放金额';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_unexp_pric is '上上日未到期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_ovdue_pric is '上上日逾期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_ovdue_int is '上上日逾期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_ovdue_pnlt is '上上日逾期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_ovdue_comp_int is '上上日逾期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_grace_period_pric is '上上日宽限期本金';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_grace_period_int is '上上日宽限期利息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_grace_period_pnlt is '上上日宽限期罚息';
comment on column ${iml_schema}.agt_loan_acct_bal_h.up_ld_grace_period_comp_int is '上上日宽限期复利';
comment on column ${iml_schema}.agt_loan_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
