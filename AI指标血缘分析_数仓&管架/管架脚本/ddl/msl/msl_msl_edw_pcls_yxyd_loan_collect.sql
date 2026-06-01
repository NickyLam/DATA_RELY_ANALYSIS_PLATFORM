/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_loan_collect
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_loan_collect
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_loan_collect purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_loan_collect(
    etl_dt date
    ,month_due varchar2(4000)
    ,prin_amt number(38,2)
    ,prin_cnt number(20)
    ,dpd1_amt number(38,2)
    ,dpd4_amt number(38,2)
    ,dpd8_amt number(38,2)
    ,dpd1_cnt number(20)
    ,dpd4_cnt number(20)
    ,dpd8_cnt number(20)
    ,delinquency_rate number(38,4)
    ,delinquency_3_rate number(38,4)
    ,delinquency_7_rate number(38,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_loan_collect to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_loan_collect is '好易贷贷后入催表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.month_due is '统计月';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.prin_amt is '应还金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.prin_cnt is '应还人数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd1_amt is 'dpd1金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd4_amt is 'dpd4金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd8_amt is 'dpd8金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd1_cnt is 'dpd1客户数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd4_cnt is 'dpd4客户数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.dpd8_cnt is 'dpd8客户数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.delinquency_rate is '入催率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.delinquency_3_rate is '逾期3天转移率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_loan_collect.delinquency_7_rate is '逾期7天转移率';
