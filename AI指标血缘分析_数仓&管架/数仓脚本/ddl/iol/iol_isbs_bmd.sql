/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bmd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bmd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bmd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bmd(
    inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,nam varchar2(60) -- 
    ,pnttyp varchar2(9) -- 
    ,pntinr varchar2(12) -- 
    ,predat date -- 
    ,rcvdat date -- 
    ,shpdat date -- 
    ,advdat date -- 
    ,matdat date -- 
    ,doctypcod varchar2(2) -- 
    ,opndat date -- 
    ,clsdat date -- 
    ,credat date -- 
    ,ownusr varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,approvcod varchar2(2) -- 
    ,frepayflg varchar2(2) -- 
    ,docprbrol varchar2(5) -- 
    ,payrol varchar2(5) -- 
    ,orddat date -- 
    ,mattxtflg varchar2(2) -- 
    ,dscinsflg varchar2(2) -- 
    ,acpnowflg varchar2(2) -- 
    ,advtyp varchar2(5) -- 
    ,disdat date -- 
    ,totcur varchar2(5) -- 
    ,totamt number(18,3) -- 
    ,totdat date -- 
    ,docsta varchar2(60) -- 
    ,docrol varchar2(5) -- 
    ,docrolflg varchar2(2) -- 
    ,dta770snd date -- 
    ,advdocflg varchar2(2) -- 
    ,etyextkey varchar2(12) -- 
    ,rmbrol varchar2(5) -- 
    ,lescom number(18,3) -- 
    ,bchkeyinr varchar2(12) -- 
    ,branchinr varchar2(12) -- 
    ,nraflg varchar2(2) -- 
    ,clmcur varchar2(5) -- 
    ,clmamt number(18,3) -- 
    ,expmno varchar2(183) -- 快递单号
    ,rcssta varchar2(6) -- 追索权
    ,paytyp varchar2(6) -- 付款类型
    ,clrmtd varchar2(6) -- 清算方式
    ,bilpro varchar2(6) -- 单据处理类型
    ,dckref varchar2(30) -- 到单编号
    ,isnegflg varchar2(2) -- 议付标志
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
grant select on ${iol_schema}.isbs_bmd to ${iml_schema};
grant select on ${iol_schema}.isbs_bmd to ${icl_schema};
grant select on ${iol_schema}.isbs_bmd to ${idl_schema};
grant select on ${iol_schema}.isbs_bmd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bmd is '国内证卖方信用证下单据业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_bmd.inr is '';
comment on column ${iol_schema}.isbs_bmd.ownref is '';
comment on column ${iol_schema}.isbs_bmd.nam is '';
comment on column ${iol_schema}.isbs_bmd.pnttyp is '';
comment on column ${iol_schema}.isbs_bmd.pntinr is '';
comment on column ${iol_schema}.isbs_bmd.predat is '';
comment on column ${iol_schema}.isbs_bmd.rcvdat is '';
comment on column ${iol_schema}.isbs_bmd.shpdat is '';
comment on column ${iol_schema}.isbs_bmd.advdat is '';
comment on column ${iol_schema}.isbs_bmd.matdat is '';
comment on column ${iol_schema}.isbs_bmd.doctypcod is '';
comment on column ${iol_schema}.isbs_bmd.opndat is '';
comment on column ${iol_schema}.isbs_bmd.clsdat is '';
comment on column ${iol_schema}.isbs_bmd.credat is '';
comment on column ${iol_schema}.isbs_bmd.ownusr is '';
comment on column ${iol_schema}.isbs_bmd.ver is '';
comment on column ${iol_schema}.isbs_bmd.approvcod is '';
comment on column ${iol_schema}.isbs_bmd.frepayflg is '';
comment on column ${iol_schema}.isbs_bmd.docprbrol is '';
comment on column ${iol_schema}.isbs_bmd.payrol is '';
comment on column ${iol_schema}.isbs_bmd.orddat is '';
comment on column ${iol_schema}.isbs_bmd.mattxtflg is '';
comment on column ${iol_schema}.isbs_bmd.dscinsflg is '';
comment on column ${iol_schema}.isbs_bmd.acpnowflg is '';
comment on column ${iol_schema}.isbs_bmd.advtyp is '';
comment on column ${iol_schema}.isbs_bmd.disdat is '';
comment on column ${iol_schema}.isbs_bmd.totcur is '';
comment on column ${iol_schema}.isbs_bmd.totamt is '';
comment on column ${iol_schema}.isbs_bmd.totdat is '';
comment on column ${iol_schema}.isbs_bmd.docsta is '';
comment on column ${iol_schema}.isbs_bmd.docrol is '';
comment on column ${iol_schema}.isbs_bmd.docrolflg is '';
comment on column ${iol_schema}.isbs_bmd.dta770snd is '';
comment on column ${iol_schema}.isbs_bmd.advdocflg is '';
comment on column ${iol_schema}.isbs_bmd.etyextkey is '';
comment on column ${iol_schema}.isbs_bmd.rmbrol is '';
comment on column ${iol_schema}.isbs_bmd.lescom is '';
comment on column ${iol_schema}.isbs_bmd.bchkeyinr is '';
comment on column ${iol_schema}.isbs_bmd.branchinr is '';
comment on column ${iol_schema}.isbs_bmd.nraflg is '';
comment on column ${iol_schema}.isbs_bmd.clmcur is '';
comment on column ${iol_schema}.isbs_bmd.clmamt is '';
comment on column ${iol_schema}.isbs_bmd.expmno is '快递单号';
comment on column ${iol_schema}.isbs_bmd.rcssta is '追索权';
comment on column ${iol_schema}.isbs_bmd.paytyp is '付款类型';
comment on column ${iol_schema}.isbs_bmd.clrmtd is '清算方式';
comment on column ${iol_schema}.isbs_bmd.bilpro is '单据处理类型';
comment on column ${iol_schema}.isbs_bmd.dckref is '到单编号';
comment on column ${iol_schema}.isbs_bmd.isnegflg is '议付标志';
comment on column ${iol_schema}.isbs_bmd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bmd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bmd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bmd.etl_timestamp is 'ETL处理时间戳';
