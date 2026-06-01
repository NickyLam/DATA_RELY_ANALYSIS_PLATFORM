/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a09tentrustedpaylog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a09tentrustedpaylog
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a09tentrustedpaylog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a09tentrustedpaylog(
    opdt varchar2(12) -- 
    ,seqno number(8,0) -- 
    ,trncd varchar2(23) -- 
    ,hosttrncd varchar2(23) -- 
    ,magebrn varchar2(9) -- 
    ,tlrno varchar2(9) -- 
    ,chktlrno varchar2(9) -- 
    ,sndtlrno varchar2(9) -- 
    ,authtlrno varchar2(9) -- 
    ,ccy varchar2(5) -- 
    ,trnamt number(15,2) -- 
    ,trnstat varchar2(3) -- 
    ,trntm varchar2(9) -- 
    ,transseq varchar2(12) -- 
    ,trandt varchar2(12) -- 
    ,ioflag varchar2(2) -- 
    ,sndbrn varchar2(18) -- 
    ,paybrn varchar2(18) -- 
    ,payacct varchar2(53) -- 
    ,payname varchar2(180) -- 
    ,payaddr varchar2(90) -- 
    ,paybknm varchar2(90) -- 
    ,rcvbrn varchar2(18) -- 
    ,incobrn varchar2(18) -- 
    ,incoacct varchar2(53) -- 
    ,inconame varchar2(180) -- 
    ,incoaddr varchar2(90) -- 
    ,rcvbknm varchar2(90) -- 
    ,memo varchar2(90) -- 
    ,voutype varchar2(15) -- 
    ,voudt varchar2(12) -- 
    ,voucode varchar2(30) -- 
    ,lncfno varchar2(60) -- 
    ,zfdate varchar2(12) -- 
    ,zfsqno varchar2(30) -- 
    ,hostdt varchar2(12) -- 
    ,hostseqno varchar2(18) -- 
    ,oraopdt varchar2(12) -- 
    ,oraseqno varchar2(15) -- 
    ,errcode varchar2(12) -- 
    ,errms varchar2(450) -- 
    ,chkstatus varchar2(3) -- 
    ,prodcd varchar2(15) -- 
    ,abscde varchar2(6) -- 
    ,srcsysid varchar2(15) -- 
    ,printnum number(2,0) -- 
    ,remark1 varchar2(90) -- 
    ,reserv1 varchar2(15) -- 
    ,reserv2 varchar2(15) -- 
    ,reserv3 varchar2(96) -- 
    ,reserv4 varchar2(45) -- 
    ,reserv5 varchar2(90) -- 
    ,bustype varchar2(8) -- 业务种类
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
grant select on ${iol_schema}.mpcs_a09tentrustedpaylog to ${iml_schema};
grant select on ${iol_schema}.mpcs_a09tentrustedpaylog to ${icl_schema};
grant select on ${iol_schema}.mpcs_a09tentrustedpaylog to ${idl_schema};
grant select on ${iol_schema}.mpcs_a09tentrustedpaylog to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a09tentrustedpaylog is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.opdt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.seqno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.trncd is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.hosttrncd is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.magebrn is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.tlrno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.chktlrno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.sndtlrno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.authtlrno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.ccy is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.trnamt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.trnstat is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.trntm is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.transseq is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.trandt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.ioflag is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.sndbrn is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.paybrn is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.payacct is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.payname is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.payaddr is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.paybknm is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.incobrn is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.incoacct is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.inconame is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.incoaddr is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.rcvbknm is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.memo is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.voutype is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.voudt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.voucode is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.lncfno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.zfdate is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.zfsqno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.hostdt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.hostseqno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.oraopdt is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.oraseqno is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.errcode is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.errms is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.chkstatus is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.prodcd is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.abscde is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.srcsysid is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.printnum is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.remark1 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.reserv1 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.reserv2 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.reserv3 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.reserv4 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.reserv5 is '';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.bustype is '业务种类';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a09tentrustedpaylog.etl_timestamp is 'ETL处理时间戳';
