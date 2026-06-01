/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_per_acctdrawndnrel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_per_acctdrawndnrel
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_per_acctdrawndnrel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_per_acctdrawndnrel(
    acctcode varchar2(100) -- 账户标识码
    ,drawndnseqno varchar2(100) -- 支用编号
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
grant select on ${iol_schema}.icms_credit_per_acctdrawndnrel to ${iml_schema};
grant select on ${iol_schema}.icms_credit_per_acctdrawndnrel to ${icl_schema};
grant select on ${iol_schema}.icms_credit_per_acctdrawndnrel to ${idl_schema};
grant select on ${iol_schema}.icms_credit_per_acctdrawndnrel to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_per_acctdrawndnrel is '网商贷二代征信-合并账户与支用关系表';
comment on column ${iol_schema}.icms_credit_per_acctdrawndnrel.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_per_acctdrawndnrel.drawndnseqno is '支用编号';
comment on column ${iol_schema}.icms_credit_per_acctdrawndnrel.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_per_acctdrawndnrel.etl_timestamp is 'ETL处理时间戳';
