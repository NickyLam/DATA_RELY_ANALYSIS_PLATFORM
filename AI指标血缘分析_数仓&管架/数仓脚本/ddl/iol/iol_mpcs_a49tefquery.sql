/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefquery
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefquery
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefquery purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefquery(
    unotnbr varchar2(15) -- 
    ,unotdate varchar2(12) -- 
    ,msgseq varchar2(30) -- 
    ,nsgdate varchar2(12) -- 
    ,opmsgseq varchar2(30) -- 
    ,tlrnbr varchar2(15) -- 
    ,magbrn varchar2(15) -- 
    ,sendbank varchar2(18) -- 
    ,recvbank varchar2(18) -- 
    ,oprchl varchar2(6) -- 
    ,origunotnbr varchar2(15) -- 
    ,origunotdate varchar2(12) -- 
    ,origsendbank varchar2(18) -- 
    ,origentrustdate varchar2(12) -- 
    ,origtxntype varchar2(9) -- 
    ,origvouchno varchar2(24) -- 
    ,origcurrencycd varchar2(5) -- 
    ,origamount number(15,2) -- 
    ,info varchar2(750) -- 
    ,ansinfo varchar2(750) -- 
    ,linkid number(22) -- 
    ,iotype varchar2(2) -- 
    ,status varchar2(3) -- 
    ,errcode varchar2(12) -- 
    ,errmsg varchar2(383) -- 
    ,qaflay varchar2(2) -- 
    ,rcvdt varchar2(21) -- 
    ,snddt varchar2(21) -- 
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
grant select on ${iol_schema}.mpcs_a49tefquery to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefquery to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefquery to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefquery to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefquery is '';
comment on column ${iol_schema}.mpcs_a49tefquery.unotnbr is '';
comment on column ${iol_schema}.mpcs_a49tefquery.unotdate is '';
comment on column ${iol_schema}.mpcs_a49tefquery.msgseq is '';
comment on column ${iol_schema}.mpcs_a49tefquery.nsgdate is '';
comment on column ${iol_schema}.mpcs_a49tefquery.opmsgseq is '';
comment on column ${iol_schema}.mpcs_a49tefquery.tlrnbr is '';
comment on column ${iol_schema}.mpcs_a49tefquery.magbrn is '';
comment on column ${iol_schema}.mpcs_a49tefquery.sendbank is '';
comment on column ${iol_schema}.mpcs_a49tefquery.recvbank is '';
comment on column ${iol_schema}.mpcs_a49tefquery.oprchl is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origunotnbr is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origunotdate is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origsendbank is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origentrustdate is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origtxntype is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origvouchno is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origcurrencycd is '';
comment on column ${iol_schema}.mpcs_a49tefquery.origamount is '';
comment on column ${iol_schema}.mpcs_a49tefquery.info is '';
comment on column ${iol_schema}.mpcs_a49tefquery.ansinfo is '';
comment on column ${iol_schema}.mpcs_a49tefquery.linkid is '';
comment on column ${iol_schema}.mpcs_a49tefquery.iotype is '';
comment on column ${iol_schema}.mpcs_a49tefquery.status is '';
comment on column ${iol_schema}.mpcs_a49tefquery.errcode is '';
comment on column ${iol_schema}.mpcs_a49tefquery.errmsg is '';
comment on column ${iol_schema}.mpcs_a49tefquery.qaflay is '';
comment on column ${iol_schema}.mpcs_a49tefquery.rcvdt is '';
comment on column ${iol_schema}.mpcs_a49tefquery.snddt is '';
comment on column ${iol_schema}.mpcs_a49tefquery.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefquery.etl_timestamp is 'ETL处理时间戳';
