/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_rpbl_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_rpbl_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_rpbl_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_rpbl_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,rpbl_dtl_seq_num varchar2(60) -- 应还明细序号
    ,tran_dt date -- 交易日期
    ,acct_id varchar2(100) -- 账户编号
    ,cust_id varchar2(100) -- 客户编号
    ,advise_odd_no varchar2(60) -- 通知单号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,stl_acct_flg_idf varchar2(60) -- 结算账户标识符
    ,stl_acct_num varchar2(60) -- 结算账号
    ,stl_acct_prod_id varchar2(100) -- 结算账户产品编号
    ,stl_acct_curr_cd varchar2(30) -- 结算账户币种代码
    ,stl_acct_sub_acct_num varchar2(60) -- 结算账户子账号
    ,acct_rpbl_amt number(30,2) -- 账户应还金额
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_tm timestamp -- 交易时间
    ,final_modif_dt date -- 最后修改日期
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
grant select on ${iml_schema}.evt_loan_rpbl_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_loan_rpbl_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_loan_rpbl_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_rpbl_dtl is '贷款应还明细';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.rpbl_dtl_seq_num is '应还明细序号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.acct_id is '账户编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.advise_odd_no is '通知单号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.stl_acct_flg_idf is '结算账户标识符';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.stl_acct_num is '结算账号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.stl_acct_prod_id is '结算账户产品编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.stl_acct_curr_cd is '结算账户币种代码';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.stl_acct_sub_acct_num is '结算账户子账号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.acct_rpbl_amt is '账户应还金额';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_rpbl_dtl.etl_timestamp is 'ETL处理时间戳';
