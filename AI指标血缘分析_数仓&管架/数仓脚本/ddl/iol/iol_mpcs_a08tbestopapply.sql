/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbestopapply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbestopapply
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbestopapply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbestopapply(
    operdt varchar2(12) -- 
    ,opersq varchar2(24) -- 
    ,cmtstp varchar2(5) -- 
    ,iotype varchar2(2) -- 
    ,stpydt varchar2(12) -- 
    ,stclbk varchar2(21) -- 
    ,stbkno varchar2(21) -- 
    ,stpysq varchar2(24) -- 
    ,rpclbk varchar2(21) -- 
    ,rpbkno varchar2(24) -- 
    ,stpytp varchar2(6) -- 
    ,stpnum varchar2(12) -- 
    ,succstpnum varchar2(12) -- 
    ,orsndbk varchar2(21) -- 
    ,orpktp varchar2(24) -- 
    ,orpkdt varchar2(12) -- 
    ,orpksq varchar2(24) -- 
    ,orasndbrn varchar2(21) -- 
    ,orarcvbrn varchar2(21) -- 
    ,oraconsigndt varchar2(12) -- 
    ,oraopersq varchar2(24) -- 
    ,orabustype varchar2(8) -- 
    ,oraapplyamount varchar2(26) -- 
    ,pscrtx varchar2(420) -- 
    ,rspttx varchar2(420) -- 
    ,transt varchar2(6) -- 
    ,sdtlbr varchar2(9) -- 
    ,userid varchar2(15) -- 
    ,rplyst varchar2(3) -- 
    ,erortx varchar2(90) -- 
    ,senddt varchar2(12) -- 
    ,sendtm varchar2(21) -- 
    ,entertm varchar2(21) -- 
    ,refdid varchar2(30) -- 
    ,msgno varchar2(30) -- 
    ,retpcd varchar2(12) -- 
    ,rplydt varchar2(12) -- 
    ,rplysq varchar2(24) -- 
    ,ourcnapsver varchar2(3) -- 
    ,othercnapsver varchar2(3) -- 
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
grant select on ${iol_schema}.mpcs_a08tbestopapply to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbestopapply to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbestopapply to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbestopapply to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbestopapply is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.operdt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.opersq is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.cmtstp is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.iotype is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stpydt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stclbk is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stbkno is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stpysq is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rpclbk is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rpbkno is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stpytp is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.stpnum is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.succstpnum is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orsndbk is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orpktp is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orpkdt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orpksq is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orasndbrn is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orarcvbrn is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.oraconsigndt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.oraopersq is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.orabustype is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.oraapplyamount is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.pscrtx is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rspttx is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.transt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.sdtlbr is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.userid is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rplyst is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.erortx is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.senddt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.sendtm is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.entertm is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.refdid is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.msgno is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.retpcd is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rplydt is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.rplysq is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.ourcnapsver is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.othercnapsver is '';
comment on column ${iol_schema}.mpcs_a08tbestopapply.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a08tbestopapply.etl_timestamp is 'ETL处理时间戳';
