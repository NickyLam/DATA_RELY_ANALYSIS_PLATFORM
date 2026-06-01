/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_retl_loan_acct_tran_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl(
    etl_dt date -- 数据日期   
    ,evt_id varchar2(60) -- 事件编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,acct_dt date -- 账务日期   
    ,dtl_id varchar2(60) -- 明细编号   
    ,acct_id varchar2(60) -- 账户编号   
    ,dubil_id varchar2(60) -- 借据编号   
    ,prod_id varchar2(60) -- 产品编号   
    ,acctnt_cate_cd varchar2(10) -- 会计类别代码   
    ,cust_id varchar2(60) -- 客户编号   
    ,curr_cd varchar2(10) -- 币种代码   
    ,tran_dir_cd varchar2(10) -- 交易方向代码   
    ,tran_amt number(30,2) -- 交易金额   
    ,acct_bal number(30,2) -- 账户余额   
    ,bal_field_name varchar2(100) -- 余额字段名   
    ,bal_field_cn_name varchar2(100) -- 余额字段中文名   
    ,tran_org_id varchar2(60) -- 交易机构编号   
    ,tran_teller_id varchar2(60) -- 交易柜员编号   
    ,tran_flow_num varchar2(60) -- 交易流水号   
    ,tran_evt_cd varchar2(10) -- 交易事件代码   
    ,evt_descb varchar2(250) -- 事件描述   
    ,tran_cd varchar2(10) -- 交易代码   
    ,revs_flg varchar2(10) -- 冲正标志   
    ,brevs_flg varchar2(10) -- 被冲正标志   
    ,tran_tm timestamp -- 交易时间   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl is '零售贷款账户交易明细';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.acct_dt is '账务日期';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.dtl_id is '明细编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.acct_id is '账户编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.dubil_id is '借据编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.prod_id is '产品编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.acctnt_cate_cd is '会计类别代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.cust_id is '客户编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_dir_cd is '交易方向代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.acct_bal is '账户余额';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.bal_field_name is '余额字段名';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.bal_field_cn_name is '余额字段中文名';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_org_id is '交易机构编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_teller_id is '交易柜员编号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_evt_cd is '交易事件代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.evt_descb is '事件描述';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_cd is '交易代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.revs_flg is '冲正标志';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.brevs_flg is '被冲正标志';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_retl_loan_acct_tran_dtl.etl_timestamp is '数据处理时间';