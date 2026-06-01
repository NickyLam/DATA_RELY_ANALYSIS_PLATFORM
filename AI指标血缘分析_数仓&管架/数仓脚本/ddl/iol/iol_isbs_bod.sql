/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bod
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bod(
    inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,nam varchar2(60) -- 
    ,agtref varchar2(24) -- 
    ,agtact varchar2(53) -- 
    ,agtcom varchar2(60) -- 
    ,shpdat date -- 
    ,predat date -- 
    ,rcvdat date -- 
    ,opndat date -- 
    ,advdat date -- 
    ,matdat date -- 
    ,clsdat date -- 
    ,doctypcod varchar2(2) -- 
    ,matperbeg varchar2(3) -- 
    ,matpercnt number(3,0) -- 
    ,matpertyp varchar2(2) -- 
    ,trpdoctyp varchar2(9) -- 
    ,trpdocnum varchar2(60) -- 
    ,tradat date -- 
    ,tramod varchar2(9) -- 
    ,shpfro varchar2(60) -- 
    ,shpto varchar2(60) -- 
    ,waicolcod varchar2(2) -- 
    ,wairmtcod varchar2(2) -- 
    ,chato varchar2(2) -- 
    ,stacty varchar2(3) -- 
    ,stagod varchar2(9) -- 
    ,credat date -- 
    ,ownusr varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,focflg varchar2(2) -- 
    ,dircolflg varchar2(2) -- 
    ,ccdpurflg varchar2(2) -- 
    ,ccdndrflg varchar2(2) -- 
    ,issdat date -- 
    ,paydocnum varchar2(24) -- 
    ,paydoctyp varchar2(9) -- 
    ,mattxtflg varchar2(2) -- 
    ,othins varchar2(5) -- 
    ,docsta varchar2(60) -- 
    ,resflg varchar2(2) -- 
    ,amenbr number(2,0) -- 
    ,msgrol varchar2(5) -- 
    ,etyextkey varchar2(12) -- 
    ,lescom number(18,3) -- 
    ,branchinr varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,nraflg varchar2(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_bod to ${iml_schema};
grant select on ${iol_schema}.isbs_bod to ${icl_schema};
grant select on ${iol_schema}.isbs_bod to ${idl_schema};
grant select on ${iol_schema}.isbs_bod to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bod is '出口托收业务信息(存放短字节内容)';
comment on column ${iol_schema}.isbs_bod.inr is '';
comment on column ${iol_schema}.isbs_bod.ownref is '';
comment on column ${iol_schema}.isbs_bod.nam is '';
comment on column ${iol_schema}.isbs_bod.agtref is '';
comment on column ${iol_schema}.isbs_bod.agtact is '';
comment on column ${iol_schema}.isbs_bod.agtcom is '';
comment on column ${iol_schema}.isbs_bod.shpdat is '';
comment on column ${iol_schema}.isbs_bod.predat is '';
comment on column ${iol_schema}.isbs_bod.rcvdat is '';
comment on column ${iol_schema}.isbs_bod.opndat is '';
comment on column ${iol_schema}.isbs_bod.advdat is '';
comment on column ${iol_schema}.isbs_bod.matdat is '';
comment on column ${iol_schema}.isbs_bod.clsdat is '';
comment on column ${iol_schema}.isbs_bod.doctypcod is '';
comment on column ${iol_schema}.isbs_bod.matperbeg is '';
comment on column ${iol_schema}.isbs_bod.matpercnt is '';
comment on column ${iol_schema}.isbs_bod.matpertyp is '';
comment on column ${iol_schema}.isbs_bod.trpdoctyp is '';
comment on column ${iol_schema}.isbs_bod.trpdocnum is '';
comment on column ${iol_schema}.isbs_bod.tradat is '';
comment on column ${iol_schema}.isbs_bod.tramod is '';
comment on column ${iol_schema}.isbs_bod.shpfro is '';
comment on column ${iol_schema}.isbs_bod.shpto is '';
comment on column ${iol_schema}.isbs_bod.waicolcod is '';
comment on column ${iol_schema}.isbs_bod.wairmtcod is '';
comment on column ${iol_schema}.isbs_bod.chato is '';
comment on column ${iol_schema}.isbs_bod.stacty is '';
comment on column ${iol_schema}.isbs_bod.stagod is '';
comment on column ${iol_schema}.isbs_bod.credat is '';
comment on column ${iol_schema}.isbs_bod.ownusr is '';
comment on column ${iol_schema}.isbs_bod.ver is '';
comment on column ${iol_schema}.isbs_bod.focflg is '';
comment on column ${iol_schema}.isbs_bod.dircolflg is '';
comment on column ${iol_schema}.isbs_bod.ccdpurflg is '';
comment on column ${iol_schema}.isbs_bod.ccdndrflg is '';
comment on column ${iol_schema}.isbs_bod.issdat is '';
comment on column ${iol_schema}.isbs_bod.paydocnum is '';
comment on column ${iol_schema}.isbs_bod.paydoctyp is '';
comment on column ${iol_schema}.isbs_bod.mattxtflg is '';
comment on column ${iol_schema}.isbs_bod.othins is '';
comment on column ${iol_schema}.isbs_bod.docsta is '';
comment on column ${iol_schema}.isbs_bod.resflg is '';
comment on column ${iol_schema}.isbs_bod.amenbr is '';
comment on column ${iol_schema}.isbs_bod.msgrol is '';
comment on column ${iol_schema}.isbs_bod.etyextkey is '';
comment on column ${iol_schema}.isbs_bod.lescom is '';
comment on column ${iol_schema}.isbs_bod.branchinr is '';
comment on column ${iol_schema}.isbs_bod.bchkeyinr is '';
comment on column ${iol_schema}.isbs_bod.nraflg is '';
comment on column ${iol_schema}.isbs_bod.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bod.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bod.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bod.etl_timestamp is 'ETL处理时间戳';
