/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_doc_paid_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_doc_paid_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_doc_paid_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_doc_paid_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,aldy_paid_dtl_seq_num varchar2(60) -- 已还明细序号
    ,tran_dt date -- 交易日期
    ,rpbl_dtl_seq_num varchar2(60) -- 应还明细序号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,advise_odd_no varchar2(60) -- 通知单号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,tran_cd varchar2(30) -- 交易码
    ,stl_acct_flg varchar2(60) -- 结算账户标识符
    ,stl_cust_acct_num varchar2(60) -- 结算客户账号
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,aldy_paid_amt number(30,2) -- 已还金额
    ,callbk_num varchar2(60) -- 回收号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,revs_flg varchar2(10) -- 冲正标志
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
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
grant select on ${iml_schema}.evt_doc_paid_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_doc_paid_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_doc_paid_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_doc_paid_dtl is '单据已还明细';
comment on column ${iml_schema}.evt_doc_paid_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.aldy_paid_dtl_seq_num is '已还明细序号';
comment on column ${iml_schema}.evt_doc_paid_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_doc_paid_dtl.rpbl_dtl_seq_num is '应还明细序号';
comment on column ${iml_schema}.evt_doc_paid_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.advise_odd_no is '通知单号';
comment on column ${iml_schema}.evt_doc_paid_dtl.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_doc_paid_dtl.tran_cd is '交易码';
comment on column ${iml_schema}.evt_doc_paid_dtl.stl_acct_flg is '结算账户标识符';
comment on column ${iml_schema}.evt_doc_paid_dtl.stl_cust_acct_num is '结算客户账号';
comment on column ${iml_schema}.evt_doc_paid_dtl.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.evt_doc_paid_dtl.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.evt_doc_paid_dtl.aldy_paid_amt is '已还金额';
comment on column ${iml_schema}.evt_doc_paid_dtl.callbk_num is '回收号';
comment on column ${iml_schema}.evt_doc_paid_dtl.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.evt_doc_paid_dtl.revs_flg is '冲正标志';
comment on column ${iml_schema}.evt_doc_paid_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_doc_paid_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_doc_paid_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_doc_paid_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_doc_paid_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_doc_paid_dtl.etl_timestamp is 'ETL处理时间戳';
