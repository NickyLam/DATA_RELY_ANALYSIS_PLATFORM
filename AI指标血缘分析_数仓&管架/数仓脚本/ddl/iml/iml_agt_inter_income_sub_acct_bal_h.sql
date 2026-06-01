/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_inter_income_sub_acct_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_inter_income_sub_acct_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_inter_income_sub_acct_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inter_income_sub_acct_bal_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_id varchar2(100) -- 账套编号
    ,bus_sys_id varchar2(100) -- 业务系统编号
    ,doc_id varchar2(100) -- 单据编号
    ,fin_dt date -- 财务日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,prod_id varchar2(100) -- 产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,amort_start_dt date -- 摊销开始日期
    ,amort_end_dt date -- 摊销结束日期
    ,actl_amort_start_dt date -- 实际摊销开始日期
    ,amorted_tot_amt number(30,2) -- 待摊总金额
    ,ths_tm_amort_amt number(30,2) -- 本次摊销金额
    ,acm_amort_amt number(30,2) -- 累计摊销金额
    ,inter_income_amort_status_cd varchar2(30) -- 中收摊销状态代码
    ,surp_amort_amt number(30,2) -- 剩余摊销金额
    ,amort_days number(10) -- 摊销天数
    ,amort_freq_cd varchar2(30) -- 摊销频度代码
    ,ths_tm_amort_amt_a_calc_idf_cd varchar2(30) -- 本次摊销金额重新计算标识代码
    ,bus_id varchar2(250) -- 业务编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,tran_org_id varchar2(100) -- 交易机构编号
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
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_h to ${icl_schema};
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_h to ${idl_schema};
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_inter_income_sub_acct_bal_h is '中收分户余额历史';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.sob_id is '账套编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.bus_sys_id is '业务系统编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.doc_id is '单据编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.fin_dt is '财务日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.amort_start_dt is '摊销开始日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.amort_end_dt is '摊销结束日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.actl_amort_start_dt is '实际摊销开始日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.amorted_tot_amt is '待摊总金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.ths_tm_amort_amt is '本次摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.acm_amort_amt is '累计摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.inter_income_amort_status_cd is '中收摊销状态代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.surp_amort_amt is '剩余摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.amort_days is '摊销天数';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.amort_freq_cd is '摊销频度代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.ths_tm_amort_amt_a_calc_idf_cd is '本次摊销金额重新计算标识代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_h.etl_timestamp is 'ETL处理时间戳';
