/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_nowoverdue_yxyd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_nowoverdue_yxyd
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_nowoverdue_yxyd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_nowoverdue_yxyd(
    datecreated varchar2(4000) -- 日期
    ,loan_bal number(38,6) -- 余额
    ,loan_cnt number(22,0) -- 在贷客户数
    ,dpd3plus_cnt number(22,0) -- dpd3+逾期客户数
    ,dpd3plus_amt number(38,8) -- dpd3+逾期金额
    ,dpd3plus_amt_percent number(38,6) -- dpd3+逾期率（金额口径）
    ,dpd7plus_cnt number(22,0) -- dpd7+逾期客户数
    ,dpd7plus_amt number(38,8) -- dpd7+逾期金额
    ,dpd7plus_amt_percent number(38,6) -- dpd7+逾期率（金额口径）
    ,dpd30plus_cnt number(22,0) -- dpd30+逾期客户数
    ,dpd30plus_amt number(38,8) -- dpd30+逾期金额
    ,dpd30plus_amt_percent number(38,6) -- dpd30+逾期率（金额口径）
    ,dpd90plus_cnt number(22,0) -- dpd90+逾期客户数
    ,dpd90plus_amt number(38,8) -- dpd90+逾期金额
    ,dpd90plus_amt_percent number(38,6) -- dpd90+逾期率（金额口径）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pcls_nowoverdue_yxyd to ${iml_schema};
grant select on ${iol_schema}.pcls_nowoverdue_yxyd to ${icl_schema};
grant select on ${iol_schema}.pcls_nowoverdue_yxyd to ${idl_schema};
grant select on ${iol_schema}.pcls_nowoverdue_yxyd to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_nowoverdue_yxyd is '好易贷自营时点逾期表';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.datecreated is '日期';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.loan_bal is '余额';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.loan_cnt is '在贷客户数';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd3plus_cnt is 'dpd3+逾期客户数';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd3plus_amt is 'dpd3+逾期金额';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd3plus_amt_percent is 'dpd3+逾期率（金额口径）';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd7plus_cnt is 'dpd7+逾期客户数';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd7plus_amt is 'dpd7+逾期金额';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd7plus_amt_percent is 'dpd7+逾期率（金额口径）';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd30plus_cnt is 'dpd30+逾期客户数';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd30plus_amt is 'dpd30+逾期金额';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd30plus_amt_percent is 'dpd30+逾期率（金额口径）';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd90plus_cnt is 'dpd90+逾期客户数';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd90plus_amt is 'dpd90+逾期金额';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.dpd90plus_amt_percent is 'dpd90+逾期率（金额口径）';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_nowoverdue_yxyd.etl_timestamp is 'ETL处理时间戳';
