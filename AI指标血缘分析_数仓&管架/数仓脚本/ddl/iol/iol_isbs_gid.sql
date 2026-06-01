/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gid
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gid purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gid(
    inr varchar2(12) -- 保函内部id号
    ,ownref varchar2(24) -- 参考号
    ,nam varchar2(60) -- 交易名称
    ,ownusr varchar2(12) -- 负责人
    ,credat date -- 创建日期
    ,opndat date -- 保函生效日，定义保函有效的开始日期
    ,clsdat date -- 结束日期
    ,oldref varchar2(24) -- 以前的业务号
    ,amedat date -- 最后一次修改日期
    ,orddat date -- 客户订单日期
    ,amenbr number(3,0) -- 修改次数
    ,pndclm number(2,0) -- 为决的索偿次数
    ,chato varchar2(2) -- 费用流向，保函开立gitopn交易中业务人员手工选择                                                                          1. on applicant side      赋值u                                                                                                                 2.on beneficariy side   赋值b                                                                                                      3.other  赋值o
    ,expdat date -- 保函的到期日，定义保函的期满日期
    ,liadat date -- liability定义负载的有效期
    ,stacty varchar2(3) -- country code
    ,ver varchar2(6) -- 版本号
    ,hndtyp varchar2(3) -- 保函开立类型
    ,gidtxtmodflg varchar2(2) -- 修改交易文本
    ,gtxinr varchar2(12) -- 产生文本inr
    ,giduil varchar2(3) -- 语言
    ,expflg varchar2(2) -- 效期标志
    ,liaflg varchar2(2) -- 选择赋值x,不选赋值空
    ,orcdat date -- 初始交易日期, 显示初始保函的日期
    ,orcref varchar2(53) -- 合同号
    ,orccur varchar2(5) -- 初始交易币种
    ,orcamt number(18,3) -- 初始交易金额
    ,orcrat number(14,6) -- 初始交易汇率
    ,sndto varchar2(5) -- 保函发给
    ,purcan varchar2(53) -- 取消原因
    ,tenref varchar2(53) -- 
    ,tendat date -- 
    ,avidat date -- 
    ,tenclsdat date -- 
    ,decrea varchar2(2) -- 
    ,jurplc varchar2(98) -- 
    ,jurlaw varchar2(53) -- 
    ,acc varchar2(53) -- 
    ,resflg varchar2(2) -- 
    ,stagod varchar2(9) -- 
    ,redamt number(18,3) -- 
    ,redcur varchar2(5) -- 
    ,reddat date -- 
    ,outcur varchar2(5) -- 
    ,outamt number(18,3) -- 
    ,cnfsta varchar2(2) -- 
    ,partcon number(5,2) -- 
    ,cnfdat date -- 
    ,cnfflg varchar2(2) -- 
    ,revflg varchar2(60) -- 
    ,etyextkey varchar2(12) -- 
    ,gartyp varchar2(2) -- 
    ,trmdat date -- 
    ,legfrm varchar2(6) -- 
    ,inudat date -- 
    ,feecoldat date -- 
    ,bchkeyinr varchar2(12) -- 
    ,branchinr varchar2(12) -- 
    ,teskeyunc varchar2(2) -- 
    ,juscod varchar2(15) -- 
    ,cunqii varchar2(5) -- 
    ,bilvvv number(8,5) -- 
    ,decflg varchar2(2) -- 
    ,rskrat number(3,2) -- 
    ,cshpct number(5,2) -- 
    ,guaflg varchar2(2) -- 
    ,fincod varchar2(48) -- 
    ,fintyp varchar2(11) -- 
    ,relcshpct number(7,2) -- 
    ,garfin varchar2(2) -- 
    ,purpos varchar2(6) -- 
    ,plsiss varchar2(2) -- 代开标志
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
grant select on ${iol_schema}.isbs_gid to ${iml_schema};
grant select on ${iol_schema}.isbs_gid to ${icl_schema};
grant select on ${iol_schema}.isbs_gid to ${idl_schema};
grant select on ${iol_schema}.isbs_gid to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gid is '保函业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_gid.inr is '保函内部id号';
comment on column ${iol_schema}.isbs_gid.ownref is '参考号';
comment on column ${iol_schema}.isbs_gid.nam is '交易名称';
comment on column ${iol_schema}.isbs_gid.ownusr is '负责人';
comment on column ${iol_schema}.isbs_gid.credat is '创建日期';
comment on column ${iol_schema}.isbs_gid.opndat is '保函生效日，定义保函有效的开始日期';
comment on column ${iol_schema}.isbs_gid.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_gid.oldref is '以前的业务号';
comment on column ${iol_schema}.isbs_gid.amedat is '最后一次修改日期';
comment on column ${iol_schema}.isbs_gid.orddat is '客户订单日期';
comment on column ${iol_schema}.isbs_gid.amenbr is '修改次数';
comment on column ${iol_schema}.isbs_gid.pndclm is '为决的索偿次数';
comment on column ${iol_schema}.isbs_gid.chato is '费用流向，保函开立gitopn交易中业务人员手工选择                                                                          1. on applicant side      赋值u                                                                                                                 2.on beneficariy side   赋值b                                                                                                      3.other  赋值o';
comment on column ${iol_schema}.isbs_gid.expdat is '保函的到期日，定义保函的期满日期';
comment on column ${iol_schema}.isbs_gid.liadat is 'liability定义负载的有效期';
comment on column ${iol_schema}.isbs_gid.stacty is 'country code';
comment on column ${iol_schema}.isbs_gid.ver is '版本号';
comment on column ${iol_schema}.isbs_gid.hndtyp is '保函开立类型';
comment on column ${iol_schema}.isbs_gid.gidtxtmodflg is '修改交易文本';
comment on column ${iol_schema}.isbs_gid.gtxinr is '产生文本inr';
comment on column ${iol_schema}.isbs_gid.giduil is '语言';
comment on column ${iol_schema}.isbs_gid.expflg is '效期标志';
comment on column ${iol_schema}.isbs_gid.liaflg is '选择赋值x,不选赋值空';
comment on column ${iol_schema}.isbs_gid.orcdat is '初始交易日期, 显示初始保函的日期';
comment on column ${iol_schema}.isbs_gid.orcref is '合同号';
comment on column ${iol_schema}.isbs_gid.orccur is '初始交易币种';
comment on column ${iol_schema}.isbs_gid.orcamt is '初始交易金额';
comment on column ${iol_schema}.isbs_gid.orcrat is '初始交易汇率';
comment on column ${iol_schema}.isbs_gid.sndto is '保函发给';
comment on column ${iol_schema}.isbs_gid.purcan is '取消原因';
comment on column ${iol_schema}.isbs_gid.tenref is '';
comment on column ${iol_schema}.isbs_gid.tendat is '';
comment on column ${iol_schema}.isbs_gid.avidat is '';
comment on column ${iol_schema}.isbs_gid.tenclsdat is '';
comment on column ${iol_schema}.isbs_gid.decrea is '';
comment on column ${iol_schema}.isbs_gid.jurplc is '';
comment on column ${iol_schema}.isbs_gid.jurlaw is '';
comment on column ${iol_schema}.isbs_gid.acc is '';
comment on column ${iol_schema}.isbs_gid.resflg is '';
comment on column ${iol_schema}.isbs_gid.stagod is '';
comment on column ${iol_schema}.isbs_gid.redamt is '';
comment on column ${iol_schema}.isbs_gid.redcur is '';
comment on column ${iol_schema}.isbs_gid.reddat is '';
comment on column ${iol_schema}.isbs_gid.outcur is '';
comment on column ${iol_schema}.isbs_gid.outamt is '';
comment on column ${iol_schema}.isbs_gid.cnfsta is '';
comment on column ${iol_schema}.isbs_gid.partcon is '';
comment on column ${iol_schema}.isbs_gid.cnfdat is '';
comment on column ${iol_schema}.isbs_gid.cnfflg is '';
comment on column ${iol_schema}.isbs_gid.revflg is '';
comment on column ${iol_schema}.isbs_gid.etyextkey is '';
comment on column ${iol_schema}.isbs_gid.gartyp is '';
comment on column ${iol_schema}.isbs_gid.trmdat is '';
comment on column ${iol_schema}.isbs_gid.legfrm is '';
comment on column ${iol_schema}.isbs_gid.inudat is '';
comment on column ${iol_schema}.isbs_gid.feecoldat is '';
comment on column ${iol_schema}.isbs_gid.bchkeyinr is '';
comment on column ${iol_schema}.isbs_gid.branchinr is '';
comment on column ${iol_schema}.isbs_gid.teskeyunc is '';
comment on column ${iol_schema}.isbs_gid.juscod is '';
comment on column ${iol_schema}.isbs_gid.cunqii is '';
comment on column ${iol_schema}.isbs_gid.bilvvv is '';
comment on column ${iol_schema}.isbs_gid.decflg is '';
comment on column ${iol_schema}.isbs_gid.rskrat is '';
comment on column ${iol_schema}.isbs_gid.cshpct is '';
comment on column ${iol_schema}.isbs_gid.guaflg is '';
comment on column ${iol_schema}.isbs_gid.fincod is '';
comment on column ${iol_schema}.isbs_gid.fintyp is '';
comment on column ${iol_schema}.isbs_gid.relcshpct is '';
comment on column ${iol_schema}.isbs_gid.garfin is '';
comment on column ${iol_schema}.isbs_gid.purpos is '';
comment on column ${iol_schema}.isbs_gid.plsiss is '代开标志';
comment on column ${iol_schema}.isbs_gid.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_gid.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_gid.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_gid.etl_timestamp is 'ETL处理时间戳';
