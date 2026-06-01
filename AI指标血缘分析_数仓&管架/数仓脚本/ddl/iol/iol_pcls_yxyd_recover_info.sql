/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_yxyd_recover_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_yxyd_recover_info
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_yxyd_recover_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_yxyd_recover_info(
    month_loan varchar2(4000) -- 放款月份
    ,loan_amt number(38,2） -- 放款金额
    ,m1_amt number(38,2） -- M1金额
    ,m2_amt number(38,2） -- M2金额
    ,m3_amt number(38,2） -- M3金额
    ,m3plus_amt number(38,2） -- M3+金额
    ,m1_recover_amt number(38,2） -- M1催回金额
    ,m2_recover_amt number(38,2） -- M2催回金额
    ,m3_recover_amt number(38,2） -- M3催回金额
    ,m3plus_recover_amt number(38,2） -- M3+催回金额
    ,m1_recover_percent number(38,4） -- M1催回率
    ,m2_recover_percent number(38,4） -- M2催回率
    ,m3_recover_percent number(38,4） -- M3催回率
    ,m3plus_recover_percent number(38,4） -- M3+催回率
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
grant select on ${iol_schema}.pcls_yxyd_recover_info to ${iml_schema};
grant select on ${iol_schema}.pcls_yxyd_recover_info to ${icl_schema};
grant select on ${iol_schema}.pcls_yxyd_recover_info to ${idl_schema};
grant select on ${iol_schema}.pcls_yxyd_recover_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_yxyd_recover_info is '好易贷贷后回收表';
comment on column ${iol_schema}.pcls_yxyd_recover_info.month_loan is '放款月份';
comment on column ${iol_schema}.pcls_yxyd_recover_info.loan_amt is '放款金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m1_amt is 'M1金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m2_amt is 'M2金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3_amt is 'M3金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3plus_amt is 'M3+金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m1_recover_amt is 'M1催回金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m2_recover_amt is 'M2催回金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3_recover_amt is 'M3催回金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3plus_recover_amt is 'M3+催回金额';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m1_recover_percent is 'M1催回率';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m2_recover_percent is 'M2催回率';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3_recover_percent is 'M3催回率';
comment on column ${iol_schema}.pcls_yxyd_recover_info.m3plus_recover_percent is 'M3+催回率';
comment on column ${iol_schema}.pcls_yxyd_recover_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_yxyd_recover_info.etl_timestamp is 'ETL处理时间戳';
