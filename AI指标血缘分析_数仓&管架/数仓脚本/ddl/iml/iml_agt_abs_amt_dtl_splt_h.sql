/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_abs_amt_dtl_splt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_abs_amt_dtl_splt_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_abs_amt_dtl_splt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_amt_dtl_splt_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,asset_amt_dtl_seq_num varchar2(60) -- 资产金额明细序号
    ,asset_bag_cont_dtl_seq_num varchar2(60) -- 资产包合同明细序号
    ,cust_id varchar2(100) -- 客户编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,paybl_bank_int_amt number(30,2) -- 应付行内金额
    ,loan_surp_amt number(30,2) -- 贷款剩余金额
    ,redem_paybl_cntpty_int number(30,2) -- 赎回应付对手利息
    ,redem_surp_cntpty_int number(30,2) -- 赎回剩余对手利息
    ,pkg_tran_in_suspd_crdt_acct_amt number(30,2) -- 封包转入暂收款账户金额
    ,final_modif_dt date -- 最后修改日期
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.agt_abs_amt_dtl_splt_h to ${icl_schema};
grant select on ${iml_schema}.agt_abs_amt_dtl_splt_h to ${idl_schema};
grant select on ${iml_schema}.agt_abs_amt_dtl_splt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_abs_amt_dtl_splt_h is '资产证券化金额明细拆分历史';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.asset_amt_dtl_seq_num is '资产金额明细序号';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.asset_bag_cont_dtl_seq_num is '资产包合同明细序号';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.paybl_bank_int_amt is '应付行内金额';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.loan_surp_amt is '贷款剩余金额';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.redem_paybl_cntpty_int is '赎回应付对手利息';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.redem_surp_cntpty_int is '赎回剩余对手利息';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.pkg_tran_in_suspd_crdt_acct_amt is '封包转入暂收款账户金额';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_abs_amt_dtl_splt_h.etl_timestamp is 'ETL处理时间戳';
