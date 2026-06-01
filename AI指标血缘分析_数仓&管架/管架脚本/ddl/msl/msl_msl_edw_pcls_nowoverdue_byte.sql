/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_nowoverdue_byte
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_nowoverdue_byte
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_nowoverdue_byte purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_nowoverdue_byte(
    etl_dt date
    ,datecreated varchar2(4000)
    ,loan_bal number(38,6)
    ,loan_cnt number(20)
    ,dpd3plus_cnt number(20)
    ,dpd3plus_amt number(20)
    ,dpd3plus_amt_percent number(38,6)
    ,dpd7plus_cnt number(20)
    ,dpd7plus_amt number(20)
    ,dpd7plus_amt_percent number(38,6)
    ,dpd30plus_cnt number(20)
    ,dpd30plus_amt number(20)
    ,dpd30plus_amt_percent number(38,6)
    ,dpd90plus_cnt number(20)
    ,dpd90plus_amt number(20)
    ,dpd90plus_amt_percent number(38,6)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_nowoverdue_byte to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_nowoverdue_byte is '字节小微时点逾期表';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.datecreated is '日期';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.loan_bal is '余额';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.loan_cnt is '在贷客户数';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd3plus_cnt is 'dpd3+逾期客户数';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd3plus_amt is 'dpd3+逾期金额';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd3plus_amt_percent is 'dpd3+逾期率（金额口径）';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd7plus_cnt is 'dpd7+逾期客户数';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd7plus_amt is 'dpd7+逾期金额';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd7plus_amt_percent is 'dpd7+逾期率（金额口径）';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd30plus_cnt is 'dpd30+逾期客户数';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd30plus_amt is 'dpd30+逾期金额';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd30plus_amt_percent is 'dpd30+逾期率（金额口径）';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd90plus_cnt is 'dpd90+逾期客户数';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd90plus_amt is 'dpd90+逾期金额';
comment on column ${msl_schema}.msl_edw_pcls_nowoverdue_byte.dpd90plus_amt_percent is 'dpd90+逾期率（金额口径）';
