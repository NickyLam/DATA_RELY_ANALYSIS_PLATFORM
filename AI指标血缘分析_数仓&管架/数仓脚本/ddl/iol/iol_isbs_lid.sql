/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_lid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_lid
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_lid purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_lid(
    inr varchar2(12) -- 进口信用证id号
    ,ownref varchar2(24) -- 参考号
    ,nam varchar2(60) -- 标识交易的外部显示名称
    ,ownusr varchar2(12) -- 参考号
    ,credat date -- 开证或注册日期
    ,opndat date -- 开证日期
    ,clsdat date -- 结束日期
    ,advnam varchar2(60) -- 通知行名称
    ,advref varchar2(24) -- 通知行参考号
    ,amedat date -- 上次修改日期
    ,amenbr number(2,0) -- 修改次数
    ,aplnam varchar2(60) -- 申请人名称
    ,aplref varchar2(24) -- 申请人参考号
    ,avbby varchar2(2) -- 指定方式
    ,avbwth varchar2(2) -- 指定方式
    ,bennam varchar2(60) -- 收益人名字
    ,benref varchar2(24) -- 受益人参考号
    ,chato varchar2(2) -- 费用流向
    ,cnfdet varchar2(2) -- 保兑状态
    ,expdat date -- 效期，指定信用证的效期
    ,expplc varchar2(44) -- 交单地点
    ,lcrtyp varchar2(3) -- 信用证的格式
    ,nomspc varchar2(2) -- 规格数量
    ,nomtop number(2,0) -- 溢短装
    ,nomton number(2,0) -- 溢短装
    ,preadvdt date -- 预通知日期
    ,rmbact varchar2(53) -- 偿付行用户帐号
    ,rmbcha varchar2(5) -- 偿付行费用
    ,rmbflg varchar2(2) -- 偿付标志
    ,shpdat date -- 装船日期
    ,shpfro varchar2(213) -- 装船地点
    ,porloa varchar2(213) -- 装货港
    ,pordis varchar2(213) -- 卸货港
    ,shppar varchar2(53) -- 分装
    ,shpto varchar2(213) -- 运货地点
    ,shptrs varchar2(53) -- 转载[shptrs]
    ,stacty varchar2(3) -- 国家代码
    ,stagod varchar2(9) -- 货物代码
    ,utlnbr number(3,0) -- 利用数目
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
    ,tenmaxday number(3,0) -- 
    ,branchinr varchar2(12) -- 
    ,bchkeyinr varchar2(12) -- 
    ,decflg varchar2(2) -- 
    ,cshpct number(5,2) -- 
    ,isstyp varchar2(2) -- 
    ,fincod varchar2(48) -- 
    ,fintyp varchar2(11) -- 
    ,relcshpct number(7,2) -- 
    ,jjh varchar2(36) -- 
    ,dflg varchar2(2) -- 
    ,guaflg varchar2(2) -- 
    ,tratyp varchar2(3) -- 
    ,opnamo number(18,3) -- 
    ,ameflg varchar2(15) -- 
    ,cretyp varchar2(2) -- 
    ,tadtyp varchar2(15) -- 
    ,shpins varchar2(53) -- 
    ,sermod varchar2(98) -- 
    ,serfro varchar2(98) -- 
    ,negflg varchar2(8) -- 
    ,comflg varchar2(8) -- 
    ,insdat varchar2(60) -- 
    ,shppars18 varchar2(17) -- 
    ,shptrss18 varchar2(17) -- 
    ,spcbenflg varchar2(2) -- 
    ,spcrcbflg varchar2(2) -- 
    ,prepertxts18 varchar2(53) -- 
    ,prepers18 number(3,0) -- 
    ,zytyp varchar2(2) -- 
    ,productname varchar2(4000) -- 
    ,contractno varchar2(210) -- 
    ,concur varchar2(9) -- 
    ,conamt number(18,3) -- 
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
grant select on ${iol_schema}.isbs_lid to ${iml_schema};
grant select on ${iol_schema}.isbs_lid to ${icl_schema};
grant select on ${iol_schema}.isbs_lid to ${idl_schema};
grant select on ${iol_schema}.isbs_lid to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_lid is '进口信用证业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_lid.inr is '进口信用证id号';
comment on column ${iol_schema}.isbs_lid.ownref is '参考号';
comment on column ${iol_schema}.isbs_lid.nam is '标识交易的外部显示名称';
comment on column ${iol_schema}.isbs_lid.ownusr is '参考号';
comment on column ${iol_schema}.isbs_lid.credat is '开证或注册日期';
comment on column ${iol_schema}.isbs_lid.opndat is '开证日期';
comment on column ${iol_schema}.isbs_lid.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_lid.advnam is '通知行名称';
comment on column ${iol_schema}.isbs_lid.advref is '通知行参考号';
comment on column ${iol_schema}.isbs_lid.amedat is '上次修改日期';
comment on column ${iol_schema}.isbs_lid.amenbr is '修改次数';
comment on column ${iol_schema}.isbs_lid.aplnam is '申请人名称';
comment on column ${iol_schema}.isbs_lid.aplref is '申请人参考号';
comment on column ${iol_schema}.isbs_lid.avbby is '指定方式';
comment on column ${iol_schema}.isbs_lid.avbwth is '指定方式';
comment on column ${iol_schema}.isbs_lid.bennam is '收益人名字';
comment on column ${iol_schema}.isbs_lid.benref is '受益人参考号';
comment on column ${iol_schema}.isbs_lid.chato is '费用流向';
comment on column ${iol_schema}.isbs_lid.cnfdet is '保兑状态';
comment on column ${iol_schema}.isbs_lid.expdat is '效期，指定信用证的效期';
comment on column ${iol_schema}.isbs_lid.expplc is '交单地点';
comment on column ${iol_schema}.isbs_lid.lcrtyp is '信用证的格式';
comment on column ${iol_schema}.isbs_lid.nomspc is '规格数量';
comment on column ${iol_schema}.isbs_lid.nomtop is '溢短装';
comment on column ${iol_schema}.isbs_lid.nomton is '溢短装';
comment on column ${iol_schema}.isbs_lid.preadvdt is '预通知日期';
comment on column ${iol_schema}.isbs_lid.rmbact is '偿付行用户帐号';
comment on column ${iol_schema}.isbs_lid.rmbcha is '偿付行费用';
comment on column ${iol_schema}.isbs_lid.rmbflg is '偿付标志';
comment on column ${iol_schema}.isbs_lid.shpdat is '装船日期';
comment on column ${iol_schema}.isbs_lid.shpfro is '装船地点';
comment on column ${iol_schema}.isbs_lid.porloa is '装货港';
comment on column ${iol_schema}.isbs_lid.pordis is '卸货港';
comment on column ${iol_schema}.isbs_lid.shppar is '分装';
comment on column ${iol_schema}.isbs_lid.shpto is '运货地点';
comment on column ${iol_schema}.isbs_lid.shptrs is '转载[shptrs]';
comment on column ${iol_schema}.isbs_lid.stacty is '国家代码';
comment on column ${iol_schema}.isbs_lid.stagod is '货物代码';
comment on column ${iol_schema}.isbs_lid.utlnbr is '利用数目';
comment on column ${iol_schema}.isbs_lid.advnbr is '';
comment on column ${iol_schema}.isbs_lid.redclsflg is '';
comment on column ${iol_schema}.isbs_lid.ver is '';
comment on column ${iol_schema}.isbs_lid.lcityp is '';
comment on column ${iol_schema}.isbs_lid.b2binr is '';
comment on column ${iol_schema}.isbs_lid.b2bref is '';
comment on column ${iol_schema}.isbs_lid.revnbr is '';
comment on column ${iol_schema}.isbs_lid.revtimes is '';
comment on column ${iol_schema}.isbs_lid.revflg is '';
comment on column ${iol_schema}.isbs_lid.revawapl is '';
comment on column ${iol_schema}.isbs_lid.revdat is '';
comment on column ${iol_schema}.isbs_lid.revcum is '';
comment on column ${iol_schema}.isbs_lid.revtyp is '';
comment on column ${iol_schema}.isbs_lid.initpty is '';
comment on column ${iol_schema}.isbs_lid.resflg is '';
comment on column ${iol_schema}.isbs_lid.apprul is '';
comment on column ${iol_schema}.isbs_lid.apprulrmb is '';
comment on column ${iol_schema}.isbs_lid.apprultxt is '';
comment on column ${iol_schema}.isbs_lid.autdat is '';
comment on column ${iol_schema}.isbs_lid.etyextkey is '';
comment on column ${iol_schema}.isbs_lid.tenmaxday is '';
comment on column ${iol_schema}.isbs_lid.branchinr is '';
comment on column ${iol_schema}.isbs_lid.bchkeyinr is '';
comment on column ${iol_schema}.isbs_lid.decflg is '';
comment on column ${iol_schema}.isbs_lid.cshpct is '';
comment on column ${iol_schema}.isbs_lid.isstyp is '';
comment on column ${iol_schema}.isbs_lid.fincod is '';
comment on column ${iol_schema}.isbs_lid.fintyp is '';
comment on column ${iol_schema}.isbs_lid.relcshpct is '';
comment on column ${iol_schema}.isbs_lid.jjh is '';
comment on column ${iol_schema}.isbs_lid.dflg is '';
comment on column ${iol_schema}.isbs_lid.guaflg is '';
comment on column ${iol_schema}.isbs_lid.tratyp is '';
comment on column ${iol_schema}.isbs_lid.opnamo is '';
comment on column ${iol_schema}.isbs_lid.ameflg is '';
comment on column ${iol_schema}.isbs_lid.cretyp is '';
comment on column ${iol_schema}.isbs_lid.tadtyp is '';
comment on column ${iol_schema}.isbs_lid.shpins is '';
comment on column ${iol_schema}.isbs_lid.sermod is '';
comment on column ${iol_schema}.isbs_lid.serfro is '';
comment on column ${iol_schema}.isbs_lid.negflg is '';
comment on column ${iol_schema}.isbs_lid.comflg is '';
comment on column ${iol_schema}.isbs_lid.insdat is '';
comment on column ${iol_schema}.isbs_lid.shppars18 is '';
comment on column ${iol_schema}.isbs_lid.shptrss18 is '';
comment on column ${iol_schema}.isbs_lid.spcbenflg is '';
comment on column ${iol_schema}.isbs_lid.spcrcbflg is '';
comment on column ${iol_schema}.isbs_lid.prepertxts18 is '';
comment on column ${iol_schema}.isbs_lid.prepers18 is '';
comment on column ${iol_schema}.isbs_lid.zytyp is '';
comment on column ${iol_schema}.isbs_lid.productname is '';
comment on column ${iol_schema}.isbs_lid.contractno is '';
comment on column ${iol_schema}.isbs_lid.concur is '';
comment on column ${iol_schema}.isbs_lid.conamt is '';
comment on column ${iol_schema}.isbs_lid.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_lid.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_lid.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_lid.etl_timestamp is 'ETL处理时间戳';
