/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08trtnapply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08trtnapply
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08trtnapply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08trtnapply(
    rqseq varchar2(60) -- 
    ,consigndt varchar2(12) -- 
    ,sndct varchar2(6) -- 
    ,sndupbrn varchar2(21) -- 
    ,sndbrn varchar2(21) -- 
    ,rcvct varchar2(6) -- 
    ,rcvupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,rettype varchar2(6) -- 
    ,retnum varchar2(12) -- 
    ,succsretnum varchar2(12) -- 
    ,payacct varchar2(53) -- 
    ,payname varchar2(180) -- 
    ,incoacct varchar2(53) -- 
    ,inconame varchar2(180) -- 
    ,oldconsigndt varchar2(12) -- 
    ,oldtranstype varchar2(2) -- 
    ,oldtransseq varchar2(60) -- 
    ,oldopersq varchar2(24) -- 
    ,oldmsgtp varchar2(30) -- 
    ,oldsndbrn varchar2(21) -- 
    ,oldsndupbrn varchar2(21) -- 
    ,oldrcvbrn varchar2(21) -- 
    ,oldrcvupbrn varchar2(21) -- 
    ,oldcmtnum varchar2(9) -- 
    ,oldclramt varchar2(26) -- 
    ,oprtlr varchar2(750) -- 
    ,sndtlr varchar2(15) -- 
    ,magbrn varchar2(9) -- 
    ,status varchar2(3) -- 
    ,dotime varchar2(12) -- 
    ,rqtime varchar2(21) -- 
    ,rettime varchar2(21) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,rplydt varchar2(12) -- 
    ,rplysq varchar2(24) -- 
    ,errcode varchar2(30) -- 
    ,errms varchar2(300) -- 
    ,info varchar2(315) -- 申请附言
    ,msgsrc varchar2(12) -- 
    ,ccynbr varchar2(5) -- 
    ,ourcnapsver varchar2(3) -- 
    ,othercnapsver varchar2(3) -- 
    ,info2 varchar2(315) -- 应答附言
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
grant select on ${iol_schema}.mpcs_a08trtnapply to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08trtnapply to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08trtnapply to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08trtnapply to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08trtnapply is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rqseq is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.consigndt is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.sndct is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.sndbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rcvct is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rettype is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.retnum is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.succsretnum is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.payacct is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.payname is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.incoacct is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.inconame is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldconsigndt is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldtranstype is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldtransseq is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldopersq is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldmsgtp is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldsndbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldsndupbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldrcvbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldrcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldcmtnum is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oldclramt is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.oprtlr is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.sndtlr is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.magbrn is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.status is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.dotime is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rqtime is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rettime is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.refdid is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.msgno is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rplydt is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.rplysq is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.errcode is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.errms is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.info is '申请附言';
comment on column ${iol_schema}.mpcs_a08trtnapply.msgsrc is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.ccynbr is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.ourcnapsver is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08trtnapply.info2 is '应答附言';
comment on column ${iol_schema}.mpcs_a08trtnapply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08trtnapply.etl_timestamp is 'ETL处理时间戳';
