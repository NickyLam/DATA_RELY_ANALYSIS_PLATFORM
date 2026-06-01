/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbetotallog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbetotallog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbetotallog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbetotallog(
    pktype varchar2(30) -- 
    ,dtlcmtno varchar2(6) -- 
    ,sdclbk varchar2(21) -- 
    ,sendct varchar2(6) -- 
    ,rdclbk varchar2(21) -- 
    ,recvct varchar2(6) -- 
    ,date0 varchar2(12) -- 
    ,trandt varchar2(12) -- 
    ,pkgbusinesstrace varchar2(24) -- 
    ,pksqno varchar2(24) -- 
    ,rstpwd varchar2(90) -- 
    ,deadline varchar2(12) -- 
    ,backdate varchar2(12) -- 
    ,totalnum varchar2(12) -- 
    ,totalamt varchar2(26) -- 
    ,succtotalnum varchar2(12) -- 
    ,succtotalamt varchar2(26) -- 
    ,failtotalnum varchar2(12) -- 
    ,failtotalamt varchar2(26) -- 
    ,crcycd varchar2(5) -- 
    ,obaltp varchar2(3) -- 
    ,obalod varchar2(3) -- 
    ,obaldt varchar2(12) -- 
    ,reissusflag varchar2(2) -- 
    ,clerdt varchar2(12) -- 
    ,node varchar2(9) -- 
    ,transstatus varchar2(6) -- 
    ,status varchar2(3) -- 
    ,iotype varchar2(2) -- 
    ,flag4 varchar2(2) -- 
    ,orapkgtype varchar2(30) -- 
    ,orasdclbk varchar2(21) -- 
    ,oradate0 varchar2(12) -- 
    ,orapkgbusinesstrace varchar2(24) -- 
    ,orapksqno varchar2(24) -- 
    ,diskno varchar2(24) -- 
    ,transq varchar2(30) -- 
    ,sdtrsq varchar2(30) -- 
    ,colstatus varchar2(2) -- 
    ,coldate varchar2(12) -- 
    ,note varchar2(384) -- 
    ,othercnapsver varchar2(3) -- 
    ,dealerrflag varchar2(2) -- 账务处理调用失败标志，1-记账失败
    ,rejectnum varchar2(3) -- 回执次数
    ,orastatus varchar2(3) -- 原包处理状态
    ,dealflag varchar2(3) -- 处理过标志（可用非重复处理关系），1-已处理，y-处理成功，n-不处理
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
grant select on ${iol_schema}.mpcs_a08tbetotallog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbetotallog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbetotallog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbetotallog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbetotallog is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.pktype is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.dtlcmtno is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.sdclbk is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.sendct is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.rdclbk is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.recvct is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.date0 is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.trandt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.pkgbusinesstrace is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.pksqno is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.rstpwd is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.deadline is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.backdate is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.totalnum is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.totalamt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.succtotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.succtotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.failtotalnum is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.failtotalamt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.crcycd is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.obaltp is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.obalod is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.obaldt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.reissusflag is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.clerdt is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.node is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.transstatus is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.status is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.iotype is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.flag4 is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.orapkgtype is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.orasdclbk is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.oradate0 is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.orapkgbusinesstrace is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.orapksqno is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.diskno is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.transq is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.sdtrsq is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.colstatus is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.coldate is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.note is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08tbetotallog.dealerrflag is '账务处理调用失败标志，1-记账失败';
comment on column ${iol_schema}.mpcs_a08tbetotallog.rejectnum is '回执次数';
comment on column ${iol_schema}.mpcs_a08tbetotallog.orastatus is '原包处理状态';
comment on column ${iol_schema}.mpcs_a08tbetotallog.dealflag is '处理过标志（可用非重复处理关系），1-已处理，y-处理成功，n-不处理';
comment on column ${iol_schema}.mpcs_a08tbetotallog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tbetotallog.etl_timestamp is 'ETL处理时间戳';
