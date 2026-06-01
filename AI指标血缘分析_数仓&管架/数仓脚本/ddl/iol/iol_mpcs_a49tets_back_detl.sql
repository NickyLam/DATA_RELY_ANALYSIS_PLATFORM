/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tets_back_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tets_back_detl
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tets_back_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tets_back_detl(
    trandt varchar2(12) -- 
    ,transq varchar2(12) -- 
    ,trantm varchar2(12) -- 
    ,txntype varchar2(9) -- 
    ,iotype varchar2(2) -- 
    ,transt varchar2(2) -- 
    ,msgno varchar2(9) -- 
    ,magbrn varchar2(15) -- 
    ,colldate varchar2(12) -- 
    ,txndate varchar2(12) -- 
    ,txnround varchar2(3) -- 
    ,hostdt varchar2(12) -- 
    ,hostsq varchar2(105) -- 
    ,colldt varchar2(12) -- 
    ,collsq varchar2(105) -- 
    ,msgcode varchar2(30) -- 
    ,msgtext varchar2(150) -- 
    ,mainbr varchar2(18) -- 
    ,bankdt varchar2(12) -- 
    ,tranid varchar2(24) -- 
    ,origcd varchar2(18) -- 
    ,origdt varchar2(12) -- 
    ,origsq varchar2(24) -- 
    ,fisccd varchar2(18) -- 
    ,oprtype varchar2(3) -- 
    ,reserve varchar2(12) -- 
    ,origmsgid varchar2(24) -- 
    ,payeeacc varchar2(53) -- 
    ,payeename varchar2(150) -- 
    ,acctbr varchar2(15) -- 
    ,payeracc varchar2(53) -- 
    ,payername varchar2(150) -- 
    ,currencycd varchar2(5) -- 
    ,amount number(18,2) -- 
    ,payecd varchar2(2) -- 
    ,prtflg varchar2(2) -- 
    ,txpycd varchar2(30) -- 
    ,txpyna varchar2(120) -- 
    ,correg varchar2(30) -- 
    ,detlct number(22) -- 
    ,retcd varchar2(12) -- 
    ,remark varchar2(450) -- 
    ,bachdt varchar2(12) -- 
    ,bachsq varchar2(12) -- 
    ,oritrdt varchar2(12) -- 
    ,oritrsq varchar2(12) -- 
    ,brchno varchar2(15) -- 
    ,userid varchar2(15) -- 
    ,prtcnt number(22) -- 
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
grant select on ${iol_schema}.mpcs_a49tets_back_detl to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tets_back_detl to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tets_back_detl to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tets_back_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tets_back_detl is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.trandt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.transq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.trantm is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.txntype is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.iotype is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.transt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.msgno is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.magbrn is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.colldate is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.txndate is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.txnround is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.hostdt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.hostsq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.colldt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.collsq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.msgcode is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.msgtext is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.mainbr is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.bankdt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.tranid is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.origcd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.origdt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.origsq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.fisccd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.oprtype is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.reserve is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.origmsgid is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.payeeacc is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.payeename is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.acctbr is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.payeracc is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.payername is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.currencycd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.amount is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.payecd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.prtflg is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.txpycd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.txpyna is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.correg is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.detlct is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.retcd is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.remark is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.bachdt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.bachsq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.oritrdt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.oritrsq is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.brchno is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.userid is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.prtcnt is '';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tets_back_detl.etl_timestamp is 'ETL处理时间戳';
