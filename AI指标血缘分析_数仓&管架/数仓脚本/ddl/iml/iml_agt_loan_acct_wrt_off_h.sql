/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_acct_wrt_off_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_acct_wrt_off_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_acct_wrt_off_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_wrt_off_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,wrt_off_seq_num varchar2(60) -- 核销序号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,wrt_off_dt date -- 核销日期
    ,wrt_off_pric number(30,2) -- 核销本金
    ,ld_wrt_off_pric number(30,2) -- 上日核销本金
    ,wrt_off_tm_point_amt number(30,2) -- 核销时点金额
    ,wrt_off_nomal_int number(30,2) -- 核销正常利息
    ,ld_wrt_off_nomal_int number(30,2) -- 上日核销正常利息
    ,wrt_off_tm_point_int_amt number(30,2) -- 核销时点利息金额
    ,wrt_off_comp_int_int number(30,2) -- 核销复利利息
    ,ld_wrt_off_comp_int_int number(30,2) -- 上日核销复利利息
    ,wrt_off_tm_point_comp_int_amt number(30,2) -- 核销时点复利金额
    ,wrt_off_comp_int_comp_int number(30,2) -- 核销复利的复利
    ,ld_wrt_off_comp_int_comp_int number(30,2) -- 上日核销复利的复利
    ,wrt_off_tm_point_comp_int_comp_int_amt number(30,2) -- 核销时点复利的复利金额
    ,wrt_off_pnlt_comp_int number(30,2) -- 核销罚息的复利
    ,ld_wrt_off_pnlt_comp_int number(30,2) -- 上日核销罚息的复利
    ,wrt_off_tm_point_pnlt_comp_int_amt number(30,2) -- 核销时点罚息的复利金额
    ,wrt_off_pnlt_int number(30,2) -- 核销罚息利息
    ,ld_wrt_off_pnlt_int number(30,2) -- 上日核销罚息利息
    ,wrt_off_tm_point_pnlt_amt number(30,2) -- 核销时点罚息金额
    ,wrt_off_type_cd varchar2(30) -- 核销类型代码
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
grant select on ${iml_schema}.agt_loan_acct_wrt_off_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_acct_wrt_off_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_acct_wrt_off_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_acct_wrt_off_h is '贷款账户核销历史';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_seq_num is '核销序号';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_pric is '核销本金';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_pric is '上日核销本金';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_amt is '核销时点金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_nomal_int is '核销正常利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_nomal_int is '上日核销正常利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_int_amt is '核销时点利息金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_comp_int_int is '核销复利利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_comp_int_int is '上日核销复利利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_comp_int_amt is '核销时点复利金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_comp_int_comp_int is '核销复利的复利';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_comp_int_comp_int is '上日核销复利的复利';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_comp_int_comp_int_amt is '核销时点复利的复利金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_pnlt_comp_int is '核销罚息的复利';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_pnlt_comp_int is '上日核销罚息的复利';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_pnlt_comp_int_amt is '核销时点罚息的复利金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_pnlt_int is '核销罚息利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.ld_wrt_off_pnlt_int is '上日核销罚息利息';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_tm_point_pnlt_amt is '核销时点罚息金额';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.wrt_off_type_cd is '核销类型代码';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_acct_wrt_off_h.etl_timestamp is 'ETL处理时间戳';
