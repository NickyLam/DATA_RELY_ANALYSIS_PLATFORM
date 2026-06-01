/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_upl_accountno_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_upl_accountno_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_upl_accountno_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_upl_accountno_record(
    serialno varchar2(40) -- 流水号
    ,deductdate varchar2(10) -- 扣款日期
    ,payaccountnoname varchar2(200) -- 扣款账户户名
    ,ubdserialno varchar2(30) -- 贷款借据号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,deductamt number(17,2) -- 扣款金额
    ,payaccountno varchar2(32) -- 扣款账号
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
grant select on ${iol_schema}.icms_upl_accountno_record to ${iml_schema};
grant select on ${iol_schema}.icms_upl_accountno_record to ${icl_schema};
grant select on ${iol_schema}.icms_upl_accountno_record to ${idl_schema};
grant select on ${iol_schema}.icms_upl_accountno_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_upl_accountno_record is '微贷账户扣款记录';
comment on column ${iol_schema}.icms_upl_accountno_record.serialno is '流水号';
comment on column ${iol_schema}.icms_upl_accountno_record.deductdate is '扣款日期';
comment on column ${iol_schema}.icms_upl_accountno_record.payaccountnoname is '扣款账户户名';
comment on column ${iol_schema}.icms_upl_accountno_record.ubdserialno is '贷款借据号';
comment on column ${iol_schema}.icms_upl_accountno_record.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_upl_accountno_record.deductamt is '扣款金额';
comment on column ${iol_schema}.icms_upl_accountno_record.payaccountno is '扣款账号';
comment on column ${iol_schema}.icms_upl_accountno_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_upl_accountno_record.etl_timestamp is 'ETL处理时间戳';
