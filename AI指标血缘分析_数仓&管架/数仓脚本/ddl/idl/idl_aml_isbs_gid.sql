/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_gid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_gid
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_gid purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_gid(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 保函内部ID号
    ,ownref varchar2(16) -- 参考号
    ,nam varchar2(40) -- 交易名称
    ,ownusr varchar2(8) -- 负责人
    ,credat date -- 创建日期
    ,opndat date -- 保函生效日，定义保函有效的开始日期
    ,clsdat date -- 结束日期
    ,oldref varchar2(16) -- 以前的业务号
    ,amedat date -- 最后一次修改日期
    ,orddat date -- 客户订单日期
    ,amenbr number(3) -- 修改次数
    ,pndclm number(2) -- 为决的索偿次数
    ,chato varchar2(1) -- 费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O
    ,expdat date -- 保函的到期日，定义保函的期满日期
    ,liadat date -- liability定义负载的有效期
    ,stacty varchar2(2) -- Country Code
    ,ver varchar2(4) -- 版本号
    ,hndtyp varchar2(2) -- 保函开立类型
    ,gidtxtmodflg varchar2(1) -- 修改交易文本
    ,gtxinr varchar2(8) -- 产生文本INR
    ,giduil varchar2(2) -- 语言
    ,expflg varchar2(1) -- 效期标志
    ,liaflg varchar2(1) -- 选择赋值X,不选赋值空
    ,orcdat date -- 初始交易日期, 显示初始保函的日期
    ,orcref varchar2(35) -- 合同号
    ,orccur varchar2(3) -- 初始交易币种
    ,orcamt number(18,3) -- 初始交易金额
    ,orcrat number(14,6) -- 初始交易汇率
    ,sndto varchar2(3) -- 保函发给
    ,purcan varchar2(35) -- 取消原因
    ,tenref varchar2(35) -- 
    ,tendat date -- 
    ,avidat date -- 
    ,tenclsdat date -- 
    ,decrea varchar2(1) -- 
    ,jurplc varchar2(65) -- 权限位置
    ,jurlaw varchar2(35) -- 
    ,acc varchar2(35) -- 预付款帐号
    ,resflg varchar2(1) -- 预留标志
    ,stagod varchar2(6) -- 货物代号
    ,redamt number(18,3) -- 减额
    ,redcur varchar2(3) -- 减额币种
    ,reddat date -- 减额日期
    ,outcur varchar2(3) -- 余额币种
    ,outamt number(18,3) -- 余额
    ,cnfsta varchar2(1) -- 承兑状态
    ,partcon number(5,2) -- 部分承兑
    ,cnfdat date -- 开立日期
    ,cnfflg varchar2(1) -- 按百分比还是金额承兑的标志
    ,revflg varchar2(40) -- 声明索偿标志位
    ,etyextkey varchar2(8) -- 实体交易
    ,gartyp varchar2(1) -- 保函类型
    ,trmdat date -- 上次发送日
    ,legfrm varchar2(4) -- 所遵循的国际惯例
    ,inudat date -- 生效日
    ,feecoldat date -- 收费日期
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,branchinr varchar2(8) -- 所属机构号
    ,teskeyunc varchar2(1) -- 测试标志
    ,juscod varchar2(10) -- 组织机构
    ,cunqii varchar2(3) -- 流动资金贷款利率档次
    ,bilvvv number(8,5) -- 利率
    ,decflg varchar2(1) -- 减额标志
    ,rskrat number(3,2) -- 风险额度占用率
    ,cshpct number(5,2) -- 保证金应收比例
    ,guaflg varchar2(1) -- 货押业务标志
    ,fincod varchar2(32) -- 借据号
    ,fintyp varchar2(7) -- 业务品种
    ,relcshpct number(7,2) -- 保证金实收比例
    ,garfin varchar2(1) -- 融资/非融资保函标志
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_gid to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_gid is '保函业务信息(存放短字节)';
comment on column ${idl_schema}.aml_isbs_gid.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_gid.inr is '保函内部ID号';
comment on column ${idl_schema}.aml_isbs_gid.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_gid.nam is '交易名称';
comment on column ${idl_schema}.aml_isbs_gid.ownusr is '负责人';
comment on column ${idl_schema}.aml_isbs_gid.credat is '创建日期';
comment on column ${idl_schema}.aml_isbs_gid.opndat is '保函生效日，定义保函有效的开始日期';
comment on column ${idl_schema}.aml_isbs_gid.clsdat is '结束日期';
comment on column ${idl_schema}.aml_isbs_gid.oldref is '以前的业务号';
comment on column ${idl_schema}.aml_isbs_gid.amedat is '最后一次修改日期';
comment on column ${idl_schema}.aml_isbs_gid.orddat is '客户订单日期';
comment on column ${idl_schema}.aml_isbs_gid.amenbr is '修改次数';
comment on column ${idl_schema}.aml_isbs_gid.pndclm is '为决的索偿次数';
comment on column ${idl_schema}.aml_isbs_gid.chato is '费用流向，保函开立GITOPN交易中业务人员手工选择                                                                          1. On applicant side      赋值U                                                                                                                 2.On beneficariy side   赋值B                                                                                                      3.Other  赋值O';
comment on column ${idl_schema}.aml_isbs_gid.expdat is '保函的到期日，定义保函的期满日期';
comment on column ${idl_schema}.aml_isbs_gid.liadat is 'liability定义负载的有效期';
comment on column ${idl_schema}.aml_isbs_gid.stacty is 'Country Code';
comment on column ${idl_schema}.aml_isbs_gid.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_gid.hndtyp is '保函开立类型';
comment on column ${idl_schema}.aml_isbs_gid.gidtxtmodflg is '修改交易文本';
comment on column ${idl_schema}.aml_isbs_gid.gtxinr is '产生文本INR';
comment on column ${idl_schema}.aml_isbs_gid.giduil is '语言';
comment on column ${idl_schema}.aml_isbs_gid.expflg is '效期标志';
comment on column ${idl_schema}.aml_isbs_gid.liaflg is '选择赋值X,不选赋值空';
comment on column ${idl_schema}.aml_isbs_gid.orcdat is '初始交易日期, 显示初始保函的日期';
comment on column ${idl_schema}.aml_isbs_gid.orcref is '合同号';
comment on column ${idl_schema}.aml_isbs_gid.orccur is '初始交易币种';
comment on column ${idl_schema}.aml_isbs_gid.orcamt is '初始交易金额';
comment on column ${idl_schema}.aml_isbs_gid.orcrat is '初始交易汇率';
comment on column ${idl_schema}.aml_isbs_gid.sndto is '保函发给';
comment on column ${idl_schema}.aml_isbs_gid.purcan is '取消原因';
comment on column ${idl_schema}.aml_isbs_gid.tenref is '';
comment on column ${idl_schema}.aml_isbs_gid.tendat is '';
comment on column ${idl_schema}.aml_isbs_gid.avidat is '';
comment on column ${idl_schema}.aml_isbs_gid.tenclsdat is '';
comment on column ${idl_schema}.aml_isbs_gid.decrea is '';
comment on column ${idl_schema}.aml_isbs_gid.jurplc is '权限位置';
comment on column ${idl_schema}.aml_isbs_gid.jurlaw is '';
comment on column ${idl_schema}.aml_isbs_gid.acc is '预付款帐号';
comment on column ${idl_schema}.aml_isbs_gid.resflg is '预留标志';
comment on column ${idl_schema}.aml_isbs_gid.stagod is '货物代号';
comment on column ${idl_schema}.aml_isbs_gid.redamt is '减额';
comment on column ${idl_schema}.aml_isbs_gid.redcur is '减额币种';
comment on column ${idl_schema}.aml_isbs_gid.reddat is '减额日期';
comment on column ${idl_schema}.aml_isbs_gid.outcur is '余额币种';
comment on column ${idl_schema}.aml_isbs_gid.outamt is '余额';
comment on column ${idl_schema}.aml_isbs_gid.cnfsta is '承兑状态';
comment on column ${idl_schema}.aml_isbs_gid.partcon is '部分承兑';
comment on column ${idl_schema}.aml_isbs_gid.cnfdat is '开立日期';
comment on column ${idl_schema}.aml_isbs_gid.cnfflg is '按百分比还是金额承兑的标志';
comment on column ${idl_schema}.aml_isbs_gid.revflg is '声明索偿标志位';
comment on column ${idl_schema}.aml_isbs_gid.etyextkey is '实体交易';
comment on column ${idl_schema}.aml_isbs_gid.gartyp is '保函类型';
comment on column ${idl_schema}.aml_isbs_gid.trmdat is '上次发送日';
comment on column ${idl_schema}.aml_isbs_gid.legfrm is '所遵循的国际惯例';
comment on column ${idl_schema}.aml_isbs_gid.inudat is '生效日';
comment on column ${idl_schema}.aml_isbs_gid.feecoldat is '收费日期';
comment on column ${idl_schema}.aml_isbs_gid.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_gid.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_gid.teskeyunc is '测试标志';
comment on column ${idl_schema}.aml_isbs_gid.juscod is '组织机构';
comment on column ${idl_schema}.aml_isbs_gid.cunqii is '流动资金贷款利率档次';
comment on column ${idl_schema}.aml_isbs_gid.bilvvv is '利率';
comment on column ${idl_schema}.aml_isbs_gid.decflg is '减额标志';
comment on column ${idl_schema}.aml_isbs_gid.rskrat is '风险额度占用率';
comment on column ${idl_schema}.aml_isbs_gid.cshpct is '保证金应收比例';
comment on column ${idl_schema}.aml_isbs_gid.guaflg is '货押业务标志';
comment on column ${idl_schema}.aml_isbs_gid.fincod is '借据号';
comment on column ${idl_schema}.aml_isbs_gid.fintyp is '业务品种';
comment on column ${idl_schema}.aml_isbs_gid.relcshpct is '保证金实收比例';
comment on column ${idl_schema}.aml_isbs_gid.garfin is '融资/非融资保函标志';
comment on column ${idl_schema}.aml_isbs_gid.etl_timestamp is '数据处理时间';
