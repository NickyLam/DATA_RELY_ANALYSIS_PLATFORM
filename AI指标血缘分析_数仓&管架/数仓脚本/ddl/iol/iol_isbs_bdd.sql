/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bdd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bdd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bdd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bdd(
    inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,nam varchar2(60) -- 
    ,ownusr varchar2(12) -- 
    ,credat date -- 
    ,opndat date -- 
    ,clsdat date -- 
    ,pnttyp varchar2(9) -- 
    ,pntinr varchar2(12) -- 
    ,predat date -- 
    ,shpdat date -- 
    ,spddat date -- 
    ,totdat date -- 
    ,advdat date -- 
    ,matdat date -- 
    ,rcvdat date -- 
    ,disdat date -- 
    ,docflg varchar2(2) -- 
    ,rejflg varchar2(2) -- 
    ,approvcod varchar2(2) -- 
    ,relgodflg varchar2(2) -- 
    ,relgoddat date -- 
    ,trpdocnum varchar2(60) -- 
    ,frepayflg varchar2(2) -- 
    ,ver varchar2(6) -- 
    ,advtyp varchar2(5) -- 
    ,reltyp varchar2(3) -- 
    ,expdat date -- 
    ,rtoaplflg varchar2(2) -- 
    ,trpdoctyp varchar2(38) -- 
    ,tradat date -- 
    ,tramod varchar2(30) -- 
    ,mattxtflg varchar2(2) -- 
    ,dscinsflg varchar2(2) -- 
    ,docprbrol varchar2(5) -- 
    ,docsta varchar2(2) -- 
    ,igndisflg varchar2(2) -- 
    ,totcur varchar2(5) -- 
    ,totamt number(18,3) -- 
    ,payrol varchar2(5) -- 
    ,acpnowflg varchar2(2) -- 
    ,orddat date -- 
    ,advdocflg varchar2(2) -- 
    ,etyextkey varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,branchinr varchar2(12) -- 
    ,ngrcod varchar2(9) -- 
    ,sgdinr varchar2(12) -- 
    ,blnum varchar2(30) -- 
    ,shgref varchar2(24) -- 
    ,fincod varchar2(30) -- 
    ,fintyp varchar2(11) -- 
    ,nraflg varchar2(2) -- 
    ,qsqdbh varchar2(5) -- 
    ,invnum varchar2(45) -- 
    ,concur varchar2(5) -- 
    ,conamt number(18,3) -- 
    ,comno varchar2(60) -- 
    ,expmno varchar2(183) -- 快递单号
    ,rcssta varchar2(6) -- 追索权
    ,paytyp varchar2(6) -- 付款类型
    ,clrmtd varchar2(6) -- 清算方式
    ,bilpro varchar2(6) -- 单据处理类型
    ,sndref varchar2(30) -- 寄单索款编号
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
grant select on ${iol_schema}.isbs_bdd to ${iml_schema};
grant select on ${iol_schema}.isbs_bdd to ${icl_schema};
grant select on ${iol_schema}.isbs_bdd to ${idl_schema};
grant select on ${iol_schema}.isbs_bdd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bdd is '国内证买方信用证下单据业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_bdd.inr is '';
comment on column ${iol_schema}.isbs_bdd.ownref is '';
comment on column ${iol_schema}.isbs_bdd.nam is '';
comment on column ${iol_schema}.isbs_bdd.ownusr is '';
comment on column ${iol_schema}.isbs_bdd.credat is '';
comment on column ${iol_schema}.isbs_bdd.opndat is '';
comment on column ${iol_schema}.isbs_bdd.clsdat is '';
comment on column ${iol_schema}.isbs_bdd.pnttyp is '';
comment on column ${iol_schema}.isbs_bdd.pntinr is '';
comment on column ${iol_schema}.isbs_bdd.predat is '';
comment on column ${iol_schema}.isbs_bdd.shpdat is '';
comment on column ${iol_schema}.isbs_bdd.spddat is '';
comment on column ${iol_schema}.isbs_bdd.totdat is '';
comment on column ${iol_schema}.isbs_bdd.advdat is '';
comment on column ${iol_schema}.isbs_bdd.matdat is '';
comment on column ${iol_schema}.isbs_bdd.rcvdat is '';
comment on column ${iol_schema}.isbs_bdd.disdat is '';
comment on column ${iol_schema}.isbs_bdd.docflg is '';
comment on column ${iol_schema}.isbs_bdd.rejflg is '';
comment on column ${iol_schema}.isbs_bdd.approvcod is '';
comment on column ${iol_schema}.isbs_bdd.relgodflg is '';
comment on column ${iol_schema}.isbs_bdd.relgoddat is '';
comment on column ${iol_schema}.isbs_bdd.trpdocnum is '';
comment on column ${iol_schema}.isbs_bdd.frepayflg is '';
comment on column ${iol_schema}.isbs_bdd.ver is '';
comment on column ${iol_schema}.isbs_bdd.advtyp is '';
comment on column ${iol_schema}.isbs_bdd.reltyp is '';
comment on column ${iol_schema}.isbs_bdd.expdat is '';
comment on column ${iol_schema}.isbs_bdd.rtoaplflg is '';
comment on column ${iol_schema}.isbs_bdd.trpdoctyp is '';
comment on column ${iol_schema}.isbs_bdd.tradat is '';
comment on column ${iol_schema}.isbs_bdd.tramod is '';
comment on column ${iol_schema}.isbs_bdd.mattxtflg is '';
comment on column ${iol_schema}.isbs_bdd.dscinsflg is '';
comment on column ${iol_schema}.isbs_bdd.docprbrol is '';
comment on column ${iol_schema}.isbs_bdd.docsta is '';
comment on column ${iol_schema}.isbs_bdd.igndisflg is '';
comment on column ${iol_schema}.isbs_bdd.totcur is '';
comment on column ${iol_schema}.isbs_bdd.totamt is '';
comment on column ${iol_schema}.isbs_bdd.payrol is '';
comment on column ${iol_schema}.isbs_bdd.acpnowflg is '';
comment on column ${iol_schema}.isbs_bdd.orddat is '';
comment on column ${iol_schema}.isbs_bdd.advdocflg is '';
comment on column ${iol_schema}.isbs_bdd.etyextkey is '';
comment on column ${iol_schema}.isbs_bdd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_bdd.branchinr is '';
comment on column ${iol_schema}.isbs_bdd.ngrcod is '';
comment on column ${iol_schema}.isbs_bdd.sgdinr is '';
comment on column ${iol_schema}.isbs_bdd.blnum is '';
comment on column ${iol_schema}.isbs_bdd.shgref is '';
comment on column ${iol_schema}.isbs_bdd.fincod is '';
comment on column ${iol_schema}.isbs_bdd.fintyp is '';
comment on column ${iol_schema}.isbs_bdd.nraflg is '';
comment on column ${iol_schema}.isbs_bdd.qsqdbh is '';
comment on column ${iol_schema}.isbs_bdd.invnum is '';
comment on column ${iol_schema}.isbs_bdd.concur is '';
comment on column ${iol_schema}.isbs_bdd.conamt is '';
comment on column ${iol_schema}.isbs_bdd.comno is '';
comment on column ${iol_schema}.isbs_bdd.expmno is '快递单号';
comment on column ${iol_schema}.isbs_bdd.rcssta is '追索权';
comment on column ${iol_schema}.isbs_bdd.paytyp is '付款类型';
comment on column ${iol_schema}.isbs_bdd.clrmtd is '清算方式';
comment on column ${iol_schema}.isbs_bdd.bilpro is '单据处理类型';
comment on column ${iol_schema}.isbs_bdd.sndref is '寄单索款编号';
comment on column ${iol_schema}.isbs_bdd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bdd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bdd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bdd.etl_timestamp is 'ETL处理时间戳';
