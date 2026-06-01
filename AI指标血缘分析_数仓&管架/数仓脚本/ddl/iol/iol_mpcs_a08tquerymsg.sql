/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tquerymsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tquerymsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tquerymsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tquerymsg(
    queryseq varchar2(24) -- 
    ,querydt varchar2(12) -- 
    ,sndct varchar2(6) -- 
    ,sndupbrn varchar2(21) -- 
    ,sndbrn varchar2(21) -- 
    ,rcvct varchar2(6) -- 
    ,rcvupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,transtype varchar2(2) -- 
    ,querytype varchar2(6) -- 
    ,status varchar2(3) -- 
    ,processcode varchar2(6) -- 
    ,oldmainseq varchar2(24) -- 
    ,oldmsgtp varchar2(30) -- 
    ,oldconsigndt varchar2(12) -- 
    ,oldsndbrn varchar2(21) -- 
    ,oldrcvbrn varchar2(21) -- 
    ,oldtransseq varchar2(24) -- 
    ,oldpksqno varchar2(24) -- 
    ,oldcmtnum varchar2(8) -- 
    ,oldclramt varchar2(26) -- 
    ,ccynbr varchar2(5) -- 
    ,info varchar2(1536) -- 
    ,repinfo varchar2(1536) -- 
    ,oprtlr varchar2(750) -- 
    ,sndtlr varchar2(750) -- 
    ,msgsrc varchar2(2) -- 
    ,magebrn varchar2(9) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,bepsdt varchar2(12) -- 
    ,errcode varchar2(12) -- 
    ,errms varchar2(384) -- 
    ,billnb varchar2(48) -- 
    ,billpaydt varchar2(12) -- 
    ,billdt varchar2(12) -- 
    ,billenddt varchar2(12) -- 
    ,billacctname varchar2(180) -- 
    ,recvname varchar2(180) -- 
    ,paybkname varchar2(180) -- 
    ,ourcnapsver varchar2(3) -- 
    ,othercnapsver varchar2(3) -- 
    ,dealdate varchar2(12) -- 
    ,billflag varchar2(2) -- 
    ,chkflag varchar2(2) -- 对账标志 0-对平 1-人行多账 2-行内状态不符
    ,snddt varchar2(21) -- 
    ,rcvdt varchar2(21) -- 
    ,pjcflag varchar2(2) -- 
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
grant select on ${iol_schema}.mpcs_a08tquerymsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tquerymsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tquerymsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tquerymsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tquerymsg is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.queryseq is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.querydt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.sndct is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.sndbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.rcvct is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.transtype is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.querytype is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.status is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.processcode is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldmainseq is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldmsgtp is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldconsigndt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldsndbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldrcvbrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldtransseq is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldpksqno is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldcmtnum is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oldclramt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.ccynbr is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.info is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.repinfo is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.oprtlr is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.sndtlr is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.msgsrc is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.magebrn is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.refdid is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.msgno is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.bepsdt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.errcode is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.errms is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billnb is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billpaydt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billdt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billenddt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billacctname is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.recvname is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.paybkname is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.ourcnapsver is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.dealdate is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.billflag is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.chkflag is '对账标志 0-对平 1-人行多账 2-行内状态不符';
comment on column ${iol_schema}.mpcs_a08tquerymsg.snddt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.rcvdt is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.pjcflag is '';
comment on column ${iol_schema}.mpcs_a08tquerymsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tquerymsg.etl_timestamp is 'ETL处理时间戳';
