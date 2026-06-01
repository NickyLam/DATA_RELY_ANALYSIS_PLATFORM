/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pcls_nowoverdue_byte
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pcls_nowoverdue_byte
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pcls_nowoverdue_byte purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pcls_nowoverdue_byte(
    datecreated varchar2(4000) -- 日期
    ,loan_bal number(38,6) -- 余额
    ,loan_cnt number(20) -- 在贷客户数
    ,dpd3plus_cnt number(20) -- dpd3+逾期客户数
    ,dpd3plus_amt number(20) -- dpd3+逾期金额
    ,dpd3plus_amt_percent number(38,6) -- dpd3+逾期率（金额口径）
    ,dpd7plus_cnt number(20) -- dpd7+逾期客户数
    ,dpd7plus_amt number(20) -- dpd7+逾期金额
    ,dpd7plus_amt_percent number(38,6) -- dpd7+逾期率（金额口径）
    ,dpd30plus_cnt number(20) -- dpd30+逾期客户数
    ,dpd30plus_amt number(20) -- dpd30+逾期金额
    ,dpd30plus_amt_percent number(38,6) -- dpd30+逾期率（金额口径）
    ,dpd90plus_cnt number(20) -- dpd90+逾期客户数
    ,dpd90plus_amt number(20) -- dpd90+逾期金额
    ,dpd90plus_amt_percent number(38,6) -- dpd90+逾期率（金额口径）
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
grant select on ${itl_schema}.itl_edw_pcls_nowoverdue_byte to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pcls_nowoverdue_byte is '字节小微时点逾期表';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.datecreated is '日期';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.loan_bal is '余额';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.loan_cnt is '在贷客户数';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd3plus_cnt is 'dpd3+逾期客户数';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd3plus_amt is 'dpd3+逾期金额';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd3plus_amt_percent is 'dpd3+逾期率（金额口径）';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd7plus_cnt is 'dpd7+逾期客户数';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd7plus_amt is 'dpd7+逾期金额';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd7plus_amt_percent is 'dpd7+逾期率（金额口径）';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd30plus_cnt is 'dpd30+逾期客户数';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd30plus_amt is 'dpd30+逾期金额';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd30plus_amt_percent is 'dpd30+逾期率（金额口径）';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd90plus_cnt is 'dpd90+逾期客户数';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd90plus_amt is 'dpd90+逾期金额';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.dpd90plus_amt_percent is 'dpd90+逾期率（金额口径）';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pcls_nowoverdue_byte.etl_timestamp is 'ETL处理时间戳';
