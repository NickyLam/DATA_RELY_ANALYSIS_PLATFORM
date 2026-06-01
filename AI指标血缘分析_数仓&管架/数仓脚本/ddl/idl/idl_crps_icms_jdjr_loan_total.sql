/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_icms_jdjr_loan_total
CreateDate: 20230608
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_icms_jdjr_loan_total purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_icms_jdjr_loan_total(
etl_dt date --etl处理日期
,jzno varchar2(10) --记账代码
,jzamt varchar2(20) --记账金额

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_icms_jdjr_loan_total to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_icms_jdjr_loan_total is '总账';
comment on column ${idl_schema}.crps_icms_jdjr_loan_total.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.crps_icms_jdjr_loan_total.jzno is '记账代码';
comment on column ${idl_schema}.crps_icms_jdjr_loan_total.jzamt is '记账金额';

