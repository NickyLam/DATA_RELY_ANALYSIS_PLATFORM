/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_rdw_rdw_topten_crdt_loan_cust_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list
whenever sqlerror continue none;
drop table ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list(
    cust_no varchar2(150) -- 客户号
    ,cust_name varchar2(200) -- 客户名称
    ,loan_crdt_type varchar2(30) -- 客户贷款类型
    ,cust_type varchar2(30) -- 客户类型
    ,org_no varchar2(30) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,curr_bal number(33,4) -- 贷款余额
    ,crdt_amt number(33,4) -- 授信金额
    ,ratio number(33,4) -- 比例
    ,comp_last_year number(33,4) -- 对比上年末
    ,comp_last_qua number(33,4) -- 对比上季末
    ,comp_last_month number(33,4) -- 对比上月末
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
grant select on ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list is '前十大授信贷款客户名单';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.cust_no is '客户号';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.cust_name is '客户名称';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.loan_crdt_type is '客户贷款类型';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.cust_type is '客户类型';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.org_no is '机构编号';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.org_name is '机构名称';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.curr_bal is '贷款余额';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.crdt_amt is '授信金额';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.ratio is '比例';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.comp_last_year is '对比上年末';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.comp_last_qua is '对比上季末';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.comp_last_month is '对比上月末';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_rdw_rdw_topten_crdt_loan_cust_list.etl_timestamp is 'ETL处理时间戳';
