/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl dmm_cust_loan_ovdue_his_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) --客户编号
	,acct_id varchar2(60) --账户编号
    ,dubil_num varchar2(60) --借据编号
    ,std_prod_id varchar2(60) --标准产品编号
    ,ovdue_dt date --逾期日期
    ,ovdue_days number(10,0) --逾期天数
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
grant select on ${idl_schema}.dmm_cust_loan_ovdue_his_dtl to ${iel_schema};
grant select on ${idl_schema}.dmm_cust_loan_ovdue_his_dtl to ${dqc_schema};
-- comment
comment on table ${idl_schema}.dmm_cust_loan_ovdue_his_dtl is '客户贷款逾期明细';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.cust_id is '客户编号';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.acct_id is '账户编号';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.dubil_num is '借据编号';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.ovdue_dt is '逾期日期';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.ovdue_days is '逾期天数';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.etl_timestamp is '数据处理时间';
--comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.dmm_cust_loan_ovdue_his_dtl.etl_timestamp is 'ETL处理时间戳';
