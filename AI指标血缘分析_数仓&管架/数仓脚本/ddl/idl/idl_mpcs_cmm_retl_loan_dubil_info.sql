/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mpcs_cmm_retl_loan_dubil_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info
whenever sqlerror continue none;
drop table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info(
    etl_dt date -- 数据日期
    ,dubil_id varchar2(60) -- 借据编号
    ,cust_name varchar2(100) -- 客户名称
    ,cert_no varchar2(40) -- 证件号码
    ,cont_id varchar2(60) -- 合同编号
    ,dubil_amt number(18,2) -- 借据金额
    ,col_store_addr varchar2(400) -- 押品存放地址
    ,distr_dt varchar2(19) -- 放款日期
    ,operate varchar2(1) -- 1代表新增
    ,open_acct_org_id varchar2(30) -- 开户机构编号
    ,mgmt_org_id varchar2(30) -- 管理机构编号
    ,acct_instit_id varchar2(30) -- 账务机构编号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mpcs_cmm_retl_loan_dubil_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mpcs_cmm_retl_loan_dubil_info is '零售贷款借据信息-惠州网点开户';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.etl_dt is '数据日期';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.dubil_id is '借据编号';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.cust_name is '客户名称';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.cert_no is '证件号码';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.cont_id is '合同编号';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.dubil_amt is '借据金额';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.col_store_addr is '押品存放地址';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.distr_dt is '放款日期';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.operate is '1代表新增';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.acct_instit_id is '账务机构编号';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.job_cd is '任务代码';
comment on column ${idl_schema}.mpcs_cmm_retl_loan_dubil_info.etl_timestamp is 'ETL处理时间戳';