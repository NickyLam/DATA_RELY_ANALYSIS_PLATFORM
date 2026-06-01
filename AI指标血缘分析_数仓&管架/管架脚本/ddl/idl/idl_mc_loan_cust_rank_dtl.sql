/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_loan_cust_rank_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_loan_cust_rank_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_loan_cust_rank_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_loan_cust_rank_dtl(
    cust_id varchar2(150) -- 客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,cust_type varchar2(30) -- 客户类型(对公、零售)
    ,org_id varchar2(30) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,brch_org_id varchar2(30) -- 分行机构编号
    ,brch_org_name varchar2(200) -- 分行机构名称
    ,loan_bal number(38,8) -- 贷款余额
    ,ratio number(38,8) -- 比例
    ,etl_dt date -- ETL处理日期
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
grant select on ${idl_schema}.mc_loan_cust_rank_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_loan_cust_rank_dtl is '贷款客户排名明细表';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.cust_id is '客户编号';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.cust_name is '客户名称';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.cust_type is '客户类型(对公、零售)';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.org_id is '机构编号';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.org_name is '机构名称';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.brch_org_id is '分行机构编号';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.brch_org_name is '分行机构名称';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.loan_bal is '贷款余额';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.ratio is '比例';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_loan_cust_rank_dtl.etl_timestamp is 'ETL处理时间戳';