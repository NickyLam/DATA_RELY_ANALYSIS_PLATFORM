/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_balance
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_balance(
    accountcode varchar2(40) -- 
    ,adjustperiod varchar2(3) -- 
    ,assid varchar2(20) -- 
    ,creditamount number(28,8) -- 
    ,creditquantity number(20,8) -- 
    ,debitamount number(28,8) -- 
    ,debitquantity number(20,8) -- 
    ,dr number(10) -- 
    ,fraccreditamount number(28,8) -- 
    ,fracdebitamount number(28,8) -- 
    ,free1 varchar2(60) -- 
    ,free2 varchar2(60) -- 
    ,free3 varchar2(60) -- 
    ,free4 varchar2(60) -- 
    ,free5 varchar2(60) -- 
    ,globalcreditamount number(28,8) -- 
    ,globaldebitamount number(28,8) -- 
    ,groupcreditamount number(28,8) -- 
    ,groupdebitamount number(28,8) -- 
    ,localcreditamount number(28,8) -- 
    ,localdebitamount number(28,8) -- 
    ,period varchar2(2) -- 
    ,pk_accasoa varchar2(20) -- 
    ,pk_accchart varchar2(20) -- 
    ,pk_account varchar2(20) -- 
    ,pk_accountingbook varchar2(20) -- 
    ,pk_balance varchar2(20) -- 
    ,pk_currtype varchar2(20) -- 
    ,pk_group varchar2(20) -- 
    ,pk_org varchar2(20) -- 
    ,pk_org_v varchar2(20) -- 
    ,pk_setofbook varchar2(20) -- 
    ,pk_unit varchar2(20) -- 
    ,ts varchar2(19) -- 
    ,voucherkind number(38) -- 
    ,year varchar2(4) -- 
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
grant select on ${iol_schema}.iers_gl_balance to ${iml_schema};
grant select on ${iol_schema}.iers_gl_balance to ${icl_schema};
grant select on ${iol_schema}.iers_gl_balance to ${idl_schema};
grant select on ${iol_schema}.iers_gl_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_balance is '凭证余额';
comment on column ${iol_schema}.iers_gl_balance.accountcode is '';
comment on column ${iol_schema}.iers_gl_balance.adjustperiod is '';
comment on column ${iol_schema}.iers_gl_balance.assid is '';
comment on column ${iol_schema}.iers_gl_balance.creditamount is '';
comment on column ${iol_schema}.iers_gl_balance.creditquantity is '';
comment on column ${iol_schema}.iers_gl_balance.debitamount is '';
comment on column ${iol_schema}.iers_gl_balance.debitquantity is '';
comment on column ${iol_schema}.iers_gl_balance.dr is '';
comment on column ${iol_schema}.iers_gl_balance.fraccreditamount is '';
comment on column ${iol_schema}.iers_gl_balance.fracdebitamount is '';
comment on column ${iol_schema}.iers_gl_balance.free1 is '';
comment on column ${iol_schema}.iers_gl_balance.free2 is '';
comment on column ${iol_schema}.iers_gl_balance.free3 is '';
comment on column ${iol_schema}.iers_gl_balance.free4 is '';
comment on column ${iol_schema}.iers_gl_balance.free5 is '';
comment on column ${iol_schema}.iers_gl_balance.globalcreditamount is '';
comment on column ${iol_schema}.iers_gl_balance.globaldebitamount is '';
comment on column ${iol_schema}.iers_gl_balance.groupcreditamount is '';
comment on column ${iol_schema}.iers_gl_balance.groupdebitamount is '';
comment on column ${iol_schema}.iers_gl_balance.localcreditamount is '';
comment on column ${iol_schema}.iers_gl_balance.localdebitamount is '';
comment on column ${iol_schema}.iers_gl_balance.period is '';
comment on column ${iol_schema}.iers_gl_balance.pk_accasoa is '';
comment on column ${iol_schema}.iers_gl_balance.pk_accchart is '';
comment on column ${iol_schema}.iers_gl_balance.pk_account is '';
comment on column ${iol_schema}.iers_gl_balance.pk_accountingbook is '';
comment on column ${iol_schema}.iers_gl_balance.pk_balance is '';
comment on column ${iol_schema}.iers_gl_balance.pk_currtype is '';
comment on column ${iol_schema}.iers_gl_balance.pk_group is '';
comment on column ${iol_schema}.iers_gl_balance.pk_org is '';
comment on column ${iol_schema}.iers_gl_balance.pk_org_v is '';
comment on column ${iol_schema}.iers_gl_balance.pk_setofbook is '';
comment on column ${iol_schema}.iers_gl_balance.pk_unit is '';
comment on column ${iol_schema}.iers_gl_balance.ts is '';
comment on column ${iol_schema}.iers_gl_balance.voucherkind is '';
comment on column ${iol_schema}.iers_gl_balance.year is '';
comment on column ${iol_schema}.iers_gl_balance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.iers_gl_balance.etl_timestamp is 'ETL处理时间戳';
