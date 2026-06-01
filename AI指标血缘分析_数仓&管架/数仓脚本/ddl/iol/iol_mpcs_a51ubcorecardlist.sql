/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubcorecardlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubcorecardlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubcorecardlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubcorecardlist(
    acqinstid varchar2(17) -- 
    ,fwdinstid varchar2(17) -- 
    ,systrace varchar2(9) -- 
    ,transtime varchar2(15) -- 
    ,transcode varchar2(9) -- 
    ,transdate varchar2(12) -- 
    ,channels varchar2(5) -- 
    ,priacct varchar2(53) -- 
    ,procecode varchar2(9) -- 
    ,transamt number(15,2) -- 
    ,settlmtdate varchar2(6) -- 
    ,retrivarefnum varchar2(18) -- 
    ,authridresp varchar2(9) -- 
    ,respcode varchar2(3) -- 
    ,acptermnlid varchar2(12) -- 
    ,accptrid varchar2(23) -- 
    ,currcycode varchar2(5) -- 
    ,oldacqinstid varchar2(17) -- 
    ,oldfwdinstid varchar2(17) -- 
    ,oldsystrace varchar2(9) -- 
    ,oldtranstime varchar2(15) -- 
    ,status varchar2(2) -- 
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
grant select on ${iol_schema}.mpcs_a51ubcorecardlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubcorecardlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubcorecardlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubcorecardlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubcorecardlist is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.acqinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.fwdinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.systrace is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.transtime is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.transcode is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.transdate is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.channels is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.priacct is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.procecode is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.transamt is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.settlmtdate is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.retrivarefnum is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.authridresp is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.respcode is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.acptermnlid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.accptrid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.currcycode is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.oldacqinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.oldfwdinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.oldsystrace is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.oldtranstime is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.status is '';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubcorecardlist.etl_timestamp is 'ETL处理时间戳';
