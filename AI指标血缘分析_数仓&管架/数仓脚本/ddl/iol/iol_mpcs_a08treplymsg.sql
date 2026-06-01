/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08treplymsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08treplymsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08treplymsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08treplymsg(
    replyseq varchar2(24) -- 
    ,replydt varchar2(12) -- 
    ,oldqueryseq varchar2(24) -- 
    ,sndct varchar2(6) -- 
    ,sndupbrn varchar2(21) -- 
    ,sndbrn varchar2(21) -- 
    ,rcvct varchar2(6) -- 
    ,rcvupbrn varchar2(21) -- 
    ,rcvbrn varchar2(21) -- 
    ,oldconsigndt varchar2(12) -- 
    ,oldsndbrn varchar2(21) -- 
    ,oldrcvbrn varchar2(24) -- 
    ,transtype varchar2(2) -- 
    ,oldtransseq varchar2(24) -- 
    ,oldclramt varchar2(21) -- 
    ,repinfo varchar2(1536) -- 
    ,qurinfo varchar2(1536) -- 
    ,oprtlr varchar2(750) -- 
    ,sndtlr varchar2(15) -- 
    ,status varchar2(3) -- 
    ,processcode varchar2(6) -- 
    ,msgsrc varchar2(2) -- 
    ,magebrn varchar2(9) -- 
    ,bepsdt varchar2(12) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,errcode varchar2(30) -- 
    ,errms varchar2(384) -- 
    ,ourcnapsver varchar2(3) -- 
    ,othercnapsver varchar2(3) -- 
    ,dealdate varchar2(12) -- 
    ,chkflag varchar2(2) -- 对账标志 0-对平 1-人行多账 2-行内状态不符
    ,snddt varchar2(21) -- 
    ,rcvdt varchar2(21) -- 
    ,ccynbr varchar2(5) -- 
    ,billnb varchar2(48) -- 
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
grant select on ${iol_schema}.mpcs_a08treplymsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08treplymsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08treplymsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08treplymsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08treplymsg is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.replyseq is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.replydt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldqueryseq is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.sndct is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.sndupbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.sndbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.rcvct is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.rcvupbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.rcvbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldconsigndt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldsndbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldrcvbrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.transtype is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldtransseq is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oldclramt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.repinfo is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.qurinfo is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.oprtlr is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.sndtlr is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.status is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.processcode is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.msgsrc is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.magebrn is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.bepsdt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.refdid is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.msgno is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.errcode is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.errms is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.ourcnapsver is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.dealdate is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.chkflag is '对账标志 0-对平 1-人行多账 2-行内状态不符';
comment on column ${iol_schema}.mpcs_a08treplymsg.snddt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.rcvdt is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.ccynbr is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.billnb is '';
comment on column ${iol_schema}.mpcs_a08treplymsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08treplymsg.etl_timestamp is 'ETL处理时间戳';
