/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_recover_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_recover_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_recover_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_recover_info(
    etl_dt date
    ,month_loan varchar2(4000)
    ,loan_amt number(38,2)
    ,m1_amt number(38,2)
    ,m2_amt number(38,2)
    ,m3_amt number(38,2)
    ,m3plus_amt number(38,2)
    ,m1_recover_amt number(38,2)
    ,m2_recover_amt number(38,2)
    ,m3_recover_amt number(38,2)
    ,m3plus_recover_amt number(38,2)
    ,m1_recover_percent number(38,4)
    ,m2_recover_percent number(38,4)
    ,m3_recover_percent number(38,4)
    ,m3plus_recover_percent number(38,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_recover_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_recover_info is '好易贷贷后回收表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.month_loan is '放款月份';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.loan_amt is '放款金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m1_amt is 'm1金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m2_amt is 'm2金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3_amt is 'm3金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3plus_amt is 'm3+金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m1_recover_amt is 'm1催回金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m2_recover_amt is 'm2催回金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3_recover_amt is 'm3催回金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3plus_recover_amt is 'm3+催回金额';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m1_recover_percent is 'm1催回率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m2_recover_percent is 'm2催回率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3_recover_percent is 'm3催回率';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_recover_info.m3plus_recover_percent is 'm3+催回率';
