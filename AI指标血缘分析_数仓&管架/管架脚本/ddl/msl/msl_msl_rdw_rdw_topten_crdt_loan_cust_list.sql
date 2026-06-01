/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_rdw_rdw_topten_crdt_loan_cust_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list
whenever sqlerror continue none;
drop table ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list(
    ETL_DT DATE
    ,CUST_NO VARCHAR2(150)
    ,CUST_NAME VARCHAR2(200)
    ,LOAN_CRDT_TYPE VARCHAR2(30)
    ,CUST_TYPE VARCHAR2(30)
    ,ORG_NO VARCHAR2(30)
    ,ORG_NAME VARCHAR2(200)
    ,CURR_BAL NUMBER(33,4)
    ,CRDT_AMT NUMBER(33,4)
    ,RATIO NUMBER(33,4)
    ,COMP_LAST_YEAR NUMBER(33,4)
    ,COMP_LAST_QUA NUMBER(33,4)
    ,COMP_LAST_MONTH NUMBER(33,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list is '前十大授信贷款客户名单';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.CUST_NO is '客户号';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.CUST_NAME is '客户名称';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.LOAN_CRDT_TYPE is '客户贷款类型';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.CUST_TYPE is '客户类型';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.ORG_NO is '机构编号';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.ORG_NAME is '机构名称';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.CURR_BAL is '贷款余额';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.CRDT_AMT is '授信金额';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.RATIO is '比例';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.COMP_LAST_YEAR is '对比上年末';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.COMP_LAST_QUA is '对比上季末';
comment on column ${msl_schema}.msl_rdw_rdw_topten_crdt_loan_cust_list.COMP_LAST_MONTH is '对比上月末';
