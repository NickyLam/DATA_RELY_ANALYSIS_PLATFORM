/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubcupscardlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubcupscardlist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubcupscardlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubcupscardlist(
    tranway varchar2(30) -- 
    ,acqinstid varchar2(17) -- 
    ,fwdinstid varchar2(17) -- 
    ,systrace varchar2(9) -- 
    ,transtime varchar2(15) -- 
    ,transcode varchar2(9) -- 
    ,transdate varchar2(12) -- 
    ,channels varchar2(5) -- 
    ,msgtype varchar2(6) -- 
    ,priacct varchar2(53) -- 
    ,procecode varchar2(9) -- 
    ,transamt number(15,2) -- 
    ,localtime varchar2(9) -- 
    ,localdate varchar2(9) -- 
    ,settlmtdate varchar2(6) -- 
    ,mchnttype varchar2(6) -- 
    ,retrivarefnum varchar2(18) -- 
    ,authridresp varchar2(9) -- 
    ,respcode varchar2(3) -- 
    ,acptermnlid varchar2(12) -- 
    ,accptrid varchar2(23) -- 
    ,accttrnameloc varchar2(60) -- 
    ,addtnlrespcd varchar2(38) -- 
    ,privatedate varchar2(768) -- 
    ,currcycode varchar2(5) -- 
    ,oldacqinstid varchar2(17) -- 
    ,oldfwdinstid varchar2(17) -- 
    ,oldsystrace varchar2(9) -- 
    ,oldtranstime varchar2(15) -- 
    ,outacctnbr varchar2(53) -- 
    ,inacctnbr varchar2(53) -- 
    ,atmctrace varchar2(12) -- 
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
grant select on ${iol_schema}.mpcs_a51ubcupscardlist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubcupscardlist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubcupscardlist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubcupscardlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubcupscardlist is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.tranway is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.acqinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.fwdinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.systrace is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.transtime is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.transcode is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.transdate is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.channels is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.msgtype is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.priacct is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.procecode is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.transamt is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.localtime is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.localdate is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.settlmtdate is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.mchnttype is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.retrivarefnum is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.authridresp is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.respcode is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.acptermnlid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.accptrid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.accttrnameloc is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.addtnlrespcd is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.privatedate is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.currcycode is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.oldacqinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.oldfwdinstid is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.oldsystrace is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.oldtranstime is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.outacctnbr is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.inacctnbr is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.atmctrace is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.status is '';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubcupscardlist.etl_timestamp is 'ETL处理时间戳';
