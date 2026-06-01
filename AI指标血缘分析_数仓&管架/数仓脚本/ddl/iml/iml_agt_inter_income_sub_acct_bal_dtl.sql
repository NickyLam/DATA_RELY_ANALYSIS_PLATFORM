/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_inter_income_sub_acct_bal_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_id varchar2(100) -- 账套编号
    ,bus_sys_id varchar2(100) -- 业务系统编号
    ,fin_dt date -- 财务日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,doc_id varchar2(250) -- 单据编号
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,prod_id varchar2(100) -- 产品编号
    ,acct_instit_id varchar2(100) -- 账务机构编号
    ,curr_cd varchar2(30) -- 币种代码
    ,amort_start_dt date -- 摊销开始日期
    ,amort_end_dt date -- 摊销结束日期
    ,actl_amort_start_dt date -- 实际摊销开始日期
    ,amorted_tot_amt number(30,2) -- 待摊总金额
    ,ths_tm_amort_amt number(30,2) -- 本次摊销金额
    ,acm_amort_amt number(30,2) -- 累计摊销金额
    ,inter_income_amort_status_cd varchar2(30) -- 中收摊销状态代码
    ,remark1 varchar2(500) -- 备注1
    ,remark2 varchar2(500) -- 备注2
    ,surp_amort_amt number(30,2) -- 剩余摊销金额
    ,amort_days number(10) -- 摊销天数
    ,amort_freq_cd varchar2(30) -- 摊销频度代码
    ,ths_tm_amort_amt_a_calc_idf_cd varchar2(30) -- 本次摊销金额重新计算标识代码
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,sub_tran_type_cd varchar2(30) -- 子交易类型代码
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(250) -- 交易机构编号
    ,charge_way_cd varchar2(30) -- 收费方式代码
    ,batch_no varchar2(60) -- 批次号
    ,seq_num varchar2(60) -- 序号
    ,cust_id varchar2(100) -- 客户编号
    ,measure_post_seq_num varchar2(60) -- 计量后_序号
    ,measure_post_fee number(30,2) -- 计量后_费用
    ,measure_post_fee_inco number(30,2) -- 计量后_费用收入
    ,measure_post_revs_flg_cd varchar2(30) -- 计量后_冲正标志代码
    ,measure_post_addit_attr_5 varchar2(500) -- 计量后_附加属性5
    ,prod_attr_comnt_1 varchar2(500) -- 产品属性说明1
    ,addit_attr_comnt_1 varchar2(500) -- 附加属性说明1
    ,sub_acct_bal_chg_comnt varchar2(500) -- 分户余额变动说明
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_dtl to ${icl_schema};
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_dtl to ${idl_schema};
grant select on ${iml_schema}.agt_inter_income_sub_acct_bal_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_inter_income_sub_acct_bal_dtl is '中收分户余额明细';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.agt_id is '协议编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.sob_id is '账套编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.bus_sys_id is '业务系统编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.fin_dt is '财务日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.doc_id is '单据编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.prod_id is '产品编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.amort_start_dt is '摊销开始日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.amort_end_dt is '摊销结束日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.actl_amort_start_dt is '实际摊销开始日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.amorted_tot_amt is '待摊总金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.ths_tm_amort_amt is '本次摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.acm_amort_amt is '累计摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.inter_income_amort_status_cd is '中收摊销状态代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.remark1 is '备注1';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.remark2 is '备注2';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.surp_amort_amt is '剩余摊销金额';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.amort_days is '摊销天数';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.amort_freq_cd is '摊销频度代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.ths_tm_amort_amt_a_calc_idf_cd is '本次摊销金额重新计算标识代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.sub_tran_type_cd is '子交易类型代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.charge_way_cd is '收费方式代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.batch_no is '批次号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.seq_num is '序号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.measure_post_seq_num is '计量后_序号';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.measure_post_fee is '计量后_费用';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.measure_post_fee_inco is '计量后_费用收入';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.measure_post_revs_flg_cd is '计量后_冲正标志代码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.measure_post_addit_attr_5 is '计量后_附加属性5';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.prod_attr_comnt_1 is '产品属性说明1';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.addit_attr_comnt_1 is '附加属性说明1';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.sub_acct_bal_chg_comnt is '分户余额变动说明';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.agt_inter_income_sub_acct_bal_dtl.etl_timestamp is 'ETL处理时间戳';
