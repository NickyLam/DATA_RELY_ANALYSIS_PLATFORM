/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_nowoverdue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_nowoverdue
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_nowoverdue purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_nowoverdue(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,month_due varchar2(10) -- 放款月
    ,loan_bal number(38,2) -- 在贷余额
    ,loan_cnt number(20) -- 在贷笔数
    ,dpd3plus_cnt number(20) -- 3+逾期笔数
    ,dpd3plus_amt number(38,2) -- 3+逾期金额
    ,dpd3plus_amt_percent number(38,4) -- 3+逾期率_amt
    ,dpd7plus_cnt number(20) -- 7+逾期笔数
    ,dpd7plus_amt number(38,2) -- 7+逾期金额
    ,dpd7plus_amt_percent number(38,4) -- 7+逾期率_amt
    ,dpd30plus_cnt number(20) -- 30+逾期笔数
    ,dpd30plus_amt number(38,2) -- 30+逾期金额
    ,dpd30plus_amt_percent number(38,4) -- 30+逾期率_amt
    ,dpd90plus_cnt number(20) -- 90+逾期笔数
    ,dpd90plus_amt number(38,2) -- 90+逾期金额
    ,dpd90plus_amt_percent number(38,4) -- 90+逾期率_amt
    ,prod_cls_name varchar2(150) -- 产品分类(易贷，字节)
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
grant select on ${idl_schema}.mckb_nowoverdue to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_nowoverdue is '时点逾期率';
comment on column ${idl_schema}.mckb_nowoverdue.org_id is '机构编号';
comment on column ${idl_schema}.mckb_nowoverdue.org_name is '机构名称';
comment on column ${idl_schema}.mckb_nowoverdue.month_due is '放款月';
comment on column ${idl_schema}.mckb_nowoverdue.loan_bal is '在贷余额';
comment on column ${idl_schema}.mckb_nowoverdue.loan_cnt is '在贷笔数';
comment on column ${idl_schema}.mckb_nowoverdue.dpd3plus_cnt is '3+逾期笔数';
comment on column ${idl_schema}.mckb_nowoverdue.dpd3plus_amt is '3+逾期金额';
comment on column ${idl_schema}.mckb_nowoverdue.dpd3plus_amt_percent is '3+逾期率_amt';
comment on column ${idl_schema}.mckb_nowoverdue.dpd7plus_cnt is '7+逾期笔数';
comment on column ${idl_schema}.mckb_nowoverdue.dpd7plus_amt is '7+逾期金额';
comment on column ${idl_schema}.mckb_nowoverdue.dpd7plus_amt_percent is '7+逾期率_amt';
comment on column ${idl_schema}.mckb_nowoverdue.dpd30plus_cnt is '30+逾期笔数';
comment on column ${idl_schema}.mckb_nowoverdue.dpd30plus_amt is '30+逾期金额';
comment on column ${idl_schema}.mckb_nowoverdue.dpd30plus_amt_percent is '30+逾期率_amt';
comment on column ${idl_schema}.mckb_nowoverdue.dpd90plus_cnt is '90+逾期笔数';
comment on column ${idl_schema}.mckb_nowoverdue.dpd90plus_amt is '90+逾期金额';
comment on column ${idl_schema}.mckb_nowoverdue.dpd90plus_amt_percent is '90+逾期率_amt';
comment on column ${idl_schema}.mckb_nowoverdue.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_nowoverdue.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_nowoverdue.etl_timestamp is 'ETL处理时间戳';