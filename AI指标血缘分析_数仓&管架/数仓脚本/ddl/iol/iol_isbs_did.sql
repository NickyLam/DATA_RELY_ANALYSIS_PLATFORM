/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_did
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_did
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_did purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_did(
    inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,nam varchar2(60) -- 
    ,ownusr varchar2(12) -- 
    ,credat date -- 
    ,opndat date -- 
    ,clsdat date -- 
    ,advnam varchar2(60) -- 
    ,advref varchar2(24) -- 
    ,amedat date -- 
    ,amenbr number(2,0) -- 
    ,aplnam varchar2(60) -- 
    ,aplref varchar2(24) -- 
    ,avbby varchar2(2) -- 
    ,avbwth varchar2(2) -- 
    ,bennam varchar2(60) -- 
    ,benref varchar2(24) -- 
    ,chato varchar2(2) -- 
    ,cnfdet varchar2(2) -- 
    ,expdat date -- 
    ,expplc varchar2(306) -- 
    ,lcrtyp varchar2(3) -- 
    ,nomspc varchar2(2) -- 
    ,nomtop number(2,0) -- 
    ,nomton number(2,0) -- 
    ,preadvdt date -- 
    ,rmbact varchar2(53) -- 
    ,rmbcha varchar2(5) -- 
    ,rmbflg varchar2(2) -- 
    ,shpdat date -- 
    ,shpfro varchar2(303) -- 
    ,porloa varchar2(98) -- 
    ,pordis varchar2(98) -- 
    ,shppar varchar2(53) -- 
    ,shpto varchar2(303) -- 
    ,shptrs varchar2(53) -- 
    ,stacty varchar2(3) -- 
    ,stagod varchar2(9) -- 
    ,utlnbr number(3,0) -- 
    ,advnbr number(3,0) -- 
    ,redclsflg varchar2(2) -- 
    ,ver varchar2(6) -- 
    ,lcityp varchar2(2) -- 
    ,b2binr varchar2(12) -- 
    ,b2bref varchar2(24) -- 
    ,revnbr number(2,0) -- 
    ,revtimes number(2,0) -- 
    ,revflg varchar2(2) -- 
    ,revawapl varchar2(2) -- 
    ,revdat date -- 
    ,revcum varchar2(2) -- 
    ,revtyp varchar2(60) -- 
    ,initpty varchar2(5) -- 
    ,resflg varchar2(2) -- 
    ,apprul varchar2(45) -- 
    ,apprulrmb varchar2(45) -- 
    ,apprultxt varchar2(53) -- 
    ,autdat date -- 
    ,etyextkey varchar2(12) -- 
    ,tenmaxday number(4,0) -- 
    ,branchinr varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,decflg varchar2(2) -- 
    ,cshpct number(5,2) -- 
    ,isstyp varchar2(2) -- 
    ,fincod varchar2(48) -- 
    ,fintyp varchar2(11) -- 
    ,relcshpct number(7,2) -- 
    ,jjh varchar2(36) -- 
    ,guaflg varchar2(2) -- 
    ,tratyp varchar2(3) -- 
    ,opnamo number(18,3) -- 
    ,ameflg varchar2(15) -- 
    ,cretyp varchar2(2) -- 
    ,tadtyp varchar2(15) -- 
    ,shpins varchar2(53) -- 
    ,sermod varchar2(98) -- 
    ,serfro varchar2(303) -- 
    ,comflg varchar2(8) -- 
    ,insdat varchar2(60) -- 
    ,contractno varchar2(216) -- 
    ,negflg varchar2(2) -- 
    ,elcflg varchar2(2) -- 通过电证标志
    ,concur varchar2(5) -- 合同币种
    ,conamt number(18,3) -- 合同金额
    ,rejame varchar2(6) -- 拒绝修改标志
    ,cantyp varchar2(6) -- 闭卷类型
    ,rejflg varchar2(6) -- 拒绝通知标志
    ,tzref varchar2(53) -- 通知行编号
    ,nomtop1 number(8,5) -- 上浮金额（elcs）
    ,nomton1 number(8,5) -- 下浮金额（elcs）
    ,zytyp varchar2(2) -- 质押类型
    ,productname varchar2(4000) -- 货物名称
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
grant select on ${iol_schema}.isbs_did to ${iml_schema};
grant select on ${iol_schema}.isbs_did to ${icl_schema};
grant select on ${iol_schema}.isbs_did to ${idl_schema};
grant select on ${iol_schema}.isbs_did to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_did is '国内证买方信用证业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_did.inr is '';
comment on column ${iol_schema}.isbs_did.ownref is '';
comment on column ${iol_schema}.isbs_did.nam is '';
comment on column ${iol_schema}.isbs_did.ownusr is '';
comment on column ${iol_schema}.isbs_did.credat is '';
comment on column ${iol_schema}.isbs_did.opndat is '';
comment on column ${iol_schema}.isbs_did.clsdat is '';
comment on column ${iol_schema}.isbs_did.advnam is '';
comment on column ${iol_schema}.isbs_did.advref is '';
comment on column ${iol_schema}.isbs_did.amedat is '';
comment on column ${iol_schema}.isbs_did.amenbr is '';
comment on column ${iol_schema}.isbs_did.aplnam is '';
comment on column ${iol_schema}.isbs_did.aplref is '';
comment on column ${iol_schema}.isbs_did.avbby is '';
comment on column ${iol_schema}.isbs_did.avbwth is '';
comment on column ${iol_schema}.isbs_did.bennam is '';
comment on column ${iol_schema}.isbs_did.benref is '';
comment on column ${iol_schema}.isbs_did.chato is '';
comment on column ${iol_schema}.isbs_did.cnfdet is '';
comment on column ${iol_schema}.isbs_did.expdat is '';
comment on column ${iol_schema}.isbs_did.expplc is '';
comment on column ${iol_schema}.isbs_did.lcrtyp is '';
comment on column ${iol_schema}.isbs_did.nomspc is '';
comment on column ${iol_schema}.isbs_did.nomtop is '';
comment on column ${iol_schema}.isbs_did.nomton is '';
comment on column ${iol_schema}.isbs_did.preadvdt is '';
comment on column ${iol_schema}.isbs_did.rmbact is '';
comment on column ${iol_schema}.isbs_did.rmbcha is '';
comment on column ${iol_schema}.isbs_did.rmbflg is '';
comment on column ${iol_schema}.isbs_did.shpdat is '';
comment on column ${iol_schema}.isbs_did.shpfro is '';
comment on column ${iol_schema}.isbs_did.porloa is '';
comment on column ${iol_schema}.isbs_did.pordis is '';
comment on column ${iol_schema}.isbs_did.shppar is '';
comment on column ${iol_schema}.isbs_did.shpto is '';
comment on column ${iol_schema}.isbs_did.shptrs is '';
comment on column ${iol_schema}.isbs_did.stacty is '';
comment on column ${iol_schema}.isbs_did.stagod is '';
comment on column ${iol_schema}.isbs_did.utlnbr is '';
comment on column ${iol_schema}.isbs_did.advnbr is '';
comment on column ${iol_schema}.isbs_did.redclsflg is '';
comment on column ${iol_schema}.isbs_did.ver is '';
comment on column ${iol_schema}.isbs_did.lcityp is '';
comment on column ${iol_schema}.isbs_did.b2binr is '';
comment on column ${iol_schema}.isbs_did.b2bref is '';
comment on column ${iol_schema}.isbs_did.revnbr is '';
comment on column ${iol_schema}.isbs_did.revtimes is '';
comment on column ${iol_schema}.isbs_did.revflg is '';
comment on column ${iol_schema}.isbs_did.revawapl is '';
comment on column ${iol_schema}.isbs_did.revdat is '';
comment on column ${iol_schema}.isbs_did.revcum is '';
comment on column ${iol_schema}.isbs_did.revtyp is '';
comment on column ${iol_schema}.isbs_did.initpty is '';
comment on column ${iol_schema}.isbs_did.resflg is '';
comment on column ${iol_schema}.isbs_did.apprul is '';
comment on column ${iol_schema}.isbs_did.apprulrmb is '';
comment on column ${iol_schema}.isbs_did.apprultxt is '';
comment on column ${iol_schema}.isbs_did.autdat is '';
comment on column ${iol_schema}.isbs_did.etyextkey is '';
comment on column ${iol_schema}.isbs_did.tenmaxday is '';
comment on column ${iol_schema}.isbs_did.branchinr is '';
comment on column ${iol_schema}.isbs_did.bchkeyinr is '';
comment on column ${iol_schema}.isbs_did.decflg is '';
comment on column ${iol_schema}.isbs_did.cshpct is '';
comment on column ${iol_schema}.isbs_did.isstyp is '';
comment on column ${iol_schema}.isbs_did.fincod is '';
comment on column ${iol_schema}.isbs_did.fintyp is '';
comment on column ${iol_schema}.isbs_did.relcshpct is '';
comment on column ${iol_schema}.isbs_did.jjh is '';
comment on column ${iol_schema}.isbs_did.guaflg is '';
comment on column ${iol_schema}.isbs_did.tratyp is '';
comment on column ${iol_schema}.isbs_did.opnamo is '';
comment on column ${iol_schema}.isbs_did.ameflg is '';
comment on column ${iol_schema}.isbs_did.cretyp is '';
comment on column ${iol_schema}.isbs_did.tadtyp is '';
comment on column ${iol_schema}.isbs_did.shpins is '';
comment on column ${iol_schema}.isbs_did.sermod is '';
comment on column ${iol_schema}.isbs_did.serfro is '';
comment on column ${iol_schema}.isbs_did.comflg is '';
comment on column ${iol_schema}.isbs_did.insdat is '';
comment on column ${iol_schema}.isbs_did.contractno is '';
comment on column ${iol_schema}.isbs_did.negflg is '';
comment on column ${iol_schema}.isbs_did.elcflg is '通过电证标志';
comment on column ${iol_schema}.isbs_did.concur is '合同币种';
comment on column ${iol_schema}.isbs_did.conamt is '合同金额';
comment on column ${iol_schema}.isbs_did.rejame is '拒绝修改标志';
comment on column ${iol_schema}.isbs_did.cantyp is '闭卷类型';
comment on column ${iol_schema}.isbs_did.rejflg is '拒绝通知标志';
comment on column ${iol_schema}.isbs_did.tzref is '通知行编号';
comment on column ${iol_schema}.isbs_did.nomtop1 is '上浮金额（elcs）';
comment on column ${iol_schema}.isbs_did.nomton1 is '下浮金额（elcs）';
comment on column ${iol_schema}.isbs_did.zytyp is '质押类型';
comment on column ${iol_schema}.isbs_did.productname is '货物名称';
comment on column ${iol_schema}.isbs_did.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_did.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_did.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_did.etl_timestamp is 'ETL处理时间戳';
