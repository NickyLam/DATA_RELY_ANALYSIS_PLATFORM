/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ded
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ded
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ded purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ded(
    inr varchar2(12) -- 
    ,ownref varchar2(24) -- 
    ,nam varchar2(60) -- 
    ,opndat date -- 
    ,clsdat date -- 
    ,ownusr varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,credat date -- 
    ,etyextkey varchar2(12) -- 
    ,cnfdat date -- 
    ,advdat date -- 
    ,issnam varchar2(60) -- 
    ,issref varchar2(24) -- 
    ,amedat date -- 
    ,amenbr number(3,0) -- 
    ,avbby varchar2(2) -- 
    ,avbwth varchar2(2) -- 
    ,bennam varchar2(60) -- 
    ,benref varchar2(24) -- 
    ,chato varchar2(2) -- 
    ,cnfflg varchar2(2) -- 
    ,cnfdet varchar2(2) -- 
    ,cnfsta varchar2(2) -- 
    ,expdat date -- 
    ,expplc varchar2(306) -- 
    ,lcrtyp varchar2(3) -- 
    ,nomspc varchar2(2) -- 
    ,nomtop number(2,0) -- 
    ,nomton number(2,0) -- 
    ,preadvdt date -- 
    ,shpdat date -- 
    ,shpfro varchar2(303) -- 
    ,shppar varchar2(53) -- 
    ,shpto varchar2(303) -- 
    ,shptrs varchar2(53) -- 
    ,stacty varchar2(3) -- 
    ,stagod varchar2(9) -- 
    ,utlnbr number(3,0) -- 
    ,aplbnkdirsnd varchar2(2) -- 
    ,tenmaxday number(4,0) -- 
    ,cnfsnd varchar2(2) -- 
    ,revflg varchar2(2) -- 
    ,revnbr number(2,0) -- 
    ,revtimes number(2,0) -- 
    ,revdat date -- 
    ,revcum varchar2(2) -- 
    ,revtyp varchar2(60) -- 
    ,cnfins varchar2(2) -- 
    ,redclsflg varchar2(2) -- 
    ,advnbr number(3,0) -- 
    ,resflg varchar2(2) -- 
    ,inctrf varchar2(2) -- 
    ,apprul varchar2(45) -- 
    ,apprultxt varchar2(53) -- 
    ,pordis varchar2(98) -- 
    ,porloa varchar2(98) -- 
    ,nonban varchar2(2) -- 
    ,partcon number(5,2) -- 
    ,collflg varchar2(2) -- 
    ,teskeyunc varchar2(2) -- 
    ,dbtflg varchar2(2) -- 
    ,branchinr varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,rskrat number(3,2) -- 
    ,tratyp varchar2(3) -- 
    ,negflg varchar2(2) -- 
    ,cretyp varchar2(2) -- 
    ,contractno varchar2(108) -- 
    ,shpins varchar2(53) -- 
    ,tadtyp varchar2(15) -- 
    ,sermod varchar2(98) -- 
    ,serfro varchar2(303) -- 
    ,comflg varchar2(8) -- 
    ,elcflg varchar2(2) -- 通过电证标志
    ,concur varchar2(5) -- 合同币种
    ,conamt number(18,3) -- 合同金额
    ,rejame varchar2(6) -- 拒绝修改标志
    ,rejnbr number(2,0) -- 拒绝修改次数
    ,cantyp varchar2(6) -- 闭卷类型
    ,rejflg varchar2(6) -- 拒绝通知标志
    ,dkflg varchar2(2) -- 是否代开
    ,nomtop1 number(8,5) -- 上浮金额（elcs）
    ,nomton1 number(8,5) -- 下浮金额（elcs）
    ,kzref varchar2(53) -- 信用证编号
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
grant select on ${iol_schema}.isbs_ded to ${iml_schema};
grant select on ${iol_schema}.isbs_ded to ${icl_schema};
grant select on ${iol_schema}.isbs_ded to ${idl_schema};
grant select on ${iol_schema}.isbs_ded to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ded is '国内证卖方信用证业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_ded.inr is '';
comment on column ${iol_schema}.isbs_ded.ownref is '';
comment on column ${iol_schema}.isbs_ded.nam is '';
comment on column ${iol_schema}.isbs_ded.opndat is '';
comment on column ${iol_schema}.isbs_ded.clsdat is '';
comment on column ${iol_schema}.isbs_ded.ownusr is '';
comment on column ${iol_schema}.isbs_ded.ver is '';
comment on column ${iol_schema}.isbs_ded.credat is '';
comment on column ${iol_schema}.isbs_ded.etyextkey is '';
comment on column ${iol_schema}.isbs_ded.cnfdat is '';
comment on column ${iol_schema}.isbs_ded.advdat is '';
comment on column ${iol_schema}.isbs_ded.issnam is '';
comment on column ${iol_schema}.isbs_ded.issref is '';
comment on column ${iol_schema}.isbs_ded.amedat is '';
comment on column ${iol_schema}.isbs_ded.amenbr is '';
comment on column ${iol_schema}.isbs_ded.avbby is '';
comment on column ${iol_schema}.isbs_ded.avbwth is '';
comment on column ${iol_schema}.isbs_ded.bennam is '';
comment on column ${iol_schema}.isbs_ded.benref is '';
comment on column ${iol_schema}.isbs_ded.chato is '';
comment on column ${iol_schema}.isbs_ded.cnfflg is '';
comment on column ${iol_schema}.isbs_ded.cnfdet is '';
comment on column ${iol_schema}.isbs_ded.cnfsta is '';
comment on column ${iol_schema}.isbs_ded.expdat is '';
comment on column ${iol_schema}.isbs_ded.expplc is '';
comment on column ${iol_schema}.isbs_ded.lcrtyp is '';
comment on column ${iol_schema}.isbs_ded.nomspc is '';
comment on column ${iol_schema}.isbs_ded.nomtop is '';
comment on column ${iol_schema}.isbs_ded.nomton is '';
comment on column ${iol_schema}.isbs_ded.preadvdt is '';
comment on column ${iol_schema}.isbs_ded.shpdat is '';
comment on column ${iol_schema}.isbs_ded.shpfro is '';
comment on column ${iol_schema}.isbs_ded.shppar is '';
comment on column ${iol_schema}.isbs_ded.shpto is '';
comment on column ${iol_schema}.isbs_ded.shptrs is '';
comment on column ${iol_schema}.isbs_ded.stacty is '';
comment on column ${iol_schema}.isbs_ded.stagod is '';
comment on column ${iol_schema}.isbs_ded.utlnbr is '';
comment on column ${iol_schema}.isbs_ded.aplbnkdirsnd is '';
comment on column ${iol_schema}.isbs_ded.tenmaxday is '';
comment on column ${iol_schema}.isbs_ded.cnfsnd is '';
comment on column ${iol_schema}.isbs_ded.revflg is '';
comment on column ${iol_schema}.isbs_ded.revnbr is '';
comment on column ${iol_schema}.isbs_ded.revtimes is '';
comment on column ${iol_schema}.isbs_ded.revdat is '';
comment on column ${iol_schema}.isbs_ded.revcum is '';
comment on column ${iol_schema}.isbs_ded.revtyp is '';
comment on column ${iol_schema}.isbs_ded.cnfins is '';
comment on column ${iol_schema}.isbs_ded.redclsflg is '';
comment on column ${iol_schema}.isbs_ded.advnbr is '';
comment on column ${iol_schema}.isbs_ded.resflg is '';
comment on column ${iol_schema}.isbs_ded.inctrf is '';
comment on column ${iol_schema}.isbs_ded.apprul is '';
comment on column ${iol_schema}.isbs_ded.apprultxt is '';
comment on column ${iol_schema}.isbs_ded.pordis is '';
comment on column ${iol_schema}.isbs_ded.porloa is '';
comment on column ${iol_schema}.isbs_ded.nonban is '';
comment on column ${iol_schema}.isbs_ded.partcon is '';
comment on column ${iol_schema}.isbs_ded.collflg is '';
comment on column ${iol_schema}.isbs_ded.teskeyunc is '';
comment on column ${iol_schema}.isbs_ded.dbtflg is '';
comment on column ${iol_schema}.isbs_ded.branchinr is '';
comment on column ${iol_schema}.isbs_ded.bchkeyinr is '';
comment on column ${iol_schema}.isbs_ded.rskrat is '';
comment on column ${iol_schema}.isbs_ded.tratyp is '';
comment on column ${iol_schema}.isbs_ded.negflg is '';
comment on column ${iol_schema}.isbs_ded.cretyp is '';
comment on column ${iol_schema}.isbs_ded.contractno is '';
comment on column ${iol_schema}.isbs_ded.shpins is '';
comment on column ${iol_schema}.isbs_ded.tadtyp is '';
comment on column ${iol_schema}.isbs_ded.sermod is '';
comment on column ${iol_schema}.isbs_ded.serfro is '';
comment on column ${iol_schema}.isbs_ded.comflg is '';
comment on column ${iol_schema}.isbs_ded.elcflg is '通过电证标志';
comment on column ${iol_schema}.isbs_ded.concur is '合同币种';
comment on column ${iol_schema}.isbs_ded.conamt is '合同金额';
comment on column ${iol_schema}.isbs_ded.rejame is '拒绝修改标志';
comment on column ${iol_schema}.isbs_ded.rejnbr is '拒绝修改次数';
comment on column ${iol_schema}.isbs_ded.cantyp is '闭卷类型';
comment on column ${iol_schema}.isbs_ded.rejflg is '拒绝通知标志';
comment on column ${iol_schema}.isbs_ded.dkflg is '是否代开';
comment on column ${iol_schema}.isbs_ded.nomtop1 is '上浮金额（elcs）';
comment on column ${iol_schema}.isbs_ded.nomton1 is '下浮金额（elcs）';
comment on column ${iol_schema}.isbs_ded.kzref is '信用证编号';
comment on column ${iol_schema}.isbs_ded.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ded.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ded.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ded.etl_timestamp is 'ETL处理时间戳';
