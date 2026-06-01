/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_yxyd_loan_collect
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_yxyd_loan_collect
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_yxyd_loan_collect purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_yxyd_loan_collect(
    month_due varchar2(4000) -- 统计月
    ,prin_amt number(38,2) -- 应还金额
    ,prin_cnt number(22,0) -- 应还人数
    ,dpd1_amt number(38,2) -- DPD1金额
    ,dpd4_amt number(38,2) -- DPD4金额
    ,dpd8_amt number(38,2) -- DPD8金额
    ,dpd1_cnt number(22,0) -- DPD1客户数
    ,dpd4_cnt number(22,0) -- DPD4客户数
    ,dpd8_cnt number(22,0) -- dpd8客户数
    ,delinquency_rate number(38,4) -- 入催率
    ,delinquency_3_rate number(38,4) -- 逾期3天转移率
    ,delinquency_7_rate number(38,4) -- 逾期7天转移率
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
grant select on ${iol_schema}.pcls_yxyd_loan_collect to ${iml_schema};
grant select on ${iol_schema}.pcls_yxyd_loan_collect to ${icl_schema};
grant select on ${iol_schema}.pcls_yxyd_loan_collect to ${idl_schema};
grant select on ${iol_schema}.pcls_yxyd_loan_collect to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_yxyd_loan_collect is '好易贷贷后入催表';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.month_due is '统计月';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.prin_amt is '应还金额';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.prin_cnt is '应还人数';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd1_amt is 'DPD1金额';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd4_amt is 'DPD4金额';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd8_amt is 'DPD8金额';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd1_cnt is 'DPD1客户数';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd4_cnt is 'DPD4客户数';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.dpd8_cnt is 'dpd8客户数';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.delinquency_rate is '入催率';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.delinquency_3_rate is '逾期3天转移率';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.delinquency_7_rate is '逾期7天转移率';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_yxyd_loan_collect.etl_timestamp is 'ETL处理时间戳';
