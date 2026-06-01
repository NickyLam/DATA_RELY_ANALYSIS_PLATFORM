/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_loan_repay_princ_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_loan_repay_princ_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_loan_repay_princ_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_loan_repay_princ_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,repay_princ_cust_no varchar2(60) -- 还款责任人客户号
    ,repay_princ_name varchar2(250) -- 还款责任人姓名
    ,repay_princ_cert_type varchar2(30) -- 还款责任人证件类型
    ,repay_princ_cert_no varchar2(60) -- 还款责任人证件号码
    ,repay_princ_idti_type_cd varchar2(30) -- 还款责任人身份类型代码
    ,repay_princ_type_cd varchar2(30) -- 还款责任人类型代码
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_loan_repay_princ_info to ${idl_schema};
grant select on ${icl_schema}.cmm_loan_repay_princ_info to ${iel_schema};
grant select on ${icl_schema}.cmm_loan_repay_princ_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_loan_repay_princ_info is '贷款还款责任人信息';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.dubil_id is '借据编号';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_cust_no is '还款责任人客户号';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_name is '还款责任人姓名';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_cert_type is '还款责任人证件类型';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_cert_no is '还款责任人证件号码';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_idti_type_cd is '还款责任人身份类型代码';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.repay_princ_type_cd is '还款责任人类型代码';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_loan_repay_princ_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_loan_repay_princ_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_loan_repay_princ_info.etl_timestamp is 'ETL处理时间戳';
