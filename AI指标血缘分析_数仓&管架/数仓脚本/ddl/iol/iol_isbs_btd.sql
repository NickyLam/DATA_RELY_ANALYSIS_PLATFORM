/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_btd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_btd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_btd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_btd(
    approvcod varchar2(2) -- 
    ,totamt number(18,3) -- 
    ,orddatbe1 date -- 
    ,rcvdatbe1 date -- 
    ,ownusr varchar2(12) -- 
    ,disdat date -- 
    ,pntinr varchar2(12) -- 
    ,advtyp varchar2(5) -- 
    ,clsdat date -- 
    ,orddatbe2 date -- 
    ,opndat date -- 
    ,credat date -- 
    ,lescom number(18,3) -- 
    ,docprbrolbe1 varchar2(5) -- 
    ,nraflg varchar2(2) -- 
    ,totdat date -- 
    ,inr varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,mattxtflg varchar2(2) -- 
    ,bchkeyinr varchar2(12) -- 
    ,frepayflg varchar2(2) -- 
    ,branchinr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,etyextkey varchar2(12) -- 
    ,rcvdatbe2 date -- 
    ,rmbrol varchar2(5) -- 
    ,totcur varchar2(5) -- 
    ,doctypcod varchar2(2) -- 
    ,ver varchar2(6) -- 
    ,payrol varchar2(5) -- 
    ,shpdat date -- 
    ,dscinsflg varchar2(2) -- 
    ,docprbrol varchar2(5) -- 
    ,matdat date -- 
    ,predat date -- 
    ,pnttyp varchar2(9) -- 
    ,acpnowflg varchar2(2) -- 
    ,advdat date -- 
    ,docsta varchar2(60) -- 
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
grant select on ${iol_schema}.isbs_btd to ${iml_schema};
grant select on ${iol_schema}.isbs_btd to ${icl_schema};
grant select on ${iol_schema}.isbs_btd to ${idl_schema};
grant select on ${iol_schema}.isbs_btd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_btd is '转让信用证下单据信息(存放短字节)';
comment on column ${iol_schema}.isbs_btd.approvcod is '';
comment on column ${iol_schema}.isbs_btd.totamt is '';
comment on column ${iol_schema}.isbs_btd.orddatbe1 is '';
comment on column ${iol_schema}.isbs_btd.rcvdatbe1 is '';
comment on column ${iol_schema}.isbs_btd.ownusr is '';
comment on column ${iol_schema}.isbs_btd.disdat is '';
comment on column ${iol_schema}.isbs_btd.pntinr is '';
comment on column ${iol_schema}.isbs_btd.advtyp is '';
comment on column ${iol_schema}.isbs_btd.clsdat is '';
comment on column ${iol_schema}.isbs_btd.orddatbe2 is '';
comment on column ${iol_schema}.isbs_btd.opndat is '';
comment on column ${iol_schema}.isbs_btd.credat is '';
comment on column ${iol_schema}.isbs_btd.lescom is '';
comment on column ${iol_schema}.isbs_btd.docprbrolbe1 is '';
comment on column ${iol_schema}.isbs_btd.nraflg is '';
comment on column ${iol_schema}.isbs_btd.totdat is '';
comment on column ${iol_schema}.isbs_btd.inr is '';
comment on column ${iol_schema}.isbs_btd.nam is '';
comment on column ${iol_schema}.isbs_btd.mattxtflg is '';
comment on column ${iol_schema}.isbs_btd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_btd.frepayflg is '';
comment on column ${iol_schema}.isbs_btd.branchinr is '';
comment on column ${iol_schema}.isbs_btd.ownref is '';
comment on column ${iol_schema}.isbs_btd.etyextkey is '';
comment on column ${iol_schema}.isbs_btd.rcvdatbe2 is '';
comment on column ${iol_schema}.isbs_btd.rmbrol is '';
comment on column ${iol_schema}.isbs_btd.totcur is '';
comment on column ${iol_schema}.isbs_btd.doctypcod is '';
comment on column ${iol_schema}.isbs_btd.ver is '';
comment on column ${iol_schema}.isbs_btd.payrol is '';
comment on column ${iol_schema}.isbs_btd.shpdat is '';
comment on column ${iol_schema}.isbs_btd.dscinsflg is '';
comment on column ${iol_schema}.isbs_btd.docprbrol is '';
comment on column ${iol_schema}.isbs_btd.matdat is '';
comment on column ${iol_schema}.isbs_btd.predat is '';
comment on column ${iol_schema}.isbs_btd.pnttyp is '';
comment on column ${iol_schema}.isbs_btd.acpnowflg is '';
comment on column ${iol_schema}.isbs_btd.advdat is '';
comment on column ${iol_schema}.isbs_btd.docsta is '';
comment on column ${iol_schema}.isbs_btd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_btd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_btd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_btd.etl_timestamp is 'ETL处理时间戳';
