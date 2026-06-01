/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_loan_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_loan_total
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_loan_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_loan_total(
    jzno varchar2(10) -- 记账代码
    ,jzamt varchar2(20) -- 记账金额
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
grant select on ${iol_schema}.icms_jdjr_loan_total to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_loan_total to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_loan_total to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_loan_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_loan_total is '总账';
comment on column ${iol_schema}.icms_jdjr_loan_total.jzno is '记账代码';
comment on column ${iol_schema}.icms_jdjr_loan_total.jzamt is '记账金额';
comment on column ${iol_schema}.icms_jdjr_loan_total.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_jdjr_loan_total.etl_timestamp is 'ETL处理时间戳';
