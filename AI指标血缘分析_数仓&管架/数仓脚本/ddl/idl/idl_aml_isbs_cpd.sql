/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_cpd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_cpd
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_cpd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_cpd(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 唯一ID
    ,ownref varchar2(16) -- 交易参考号
    ,nam varchar2(40) -- 交易描述
    ,pyeptyinr varchar2(8) -- 收款人的INR
    ,pyeptainr varchar2(8) -- 收款人的地址
    ,pyenam varchar2(40) -- 收款人的描述
    ,pyeref varchar2(16) -- 收款人的参考号
    ,pybptyinr varchar2(8) -- 付款银行的INR
    ,pybptainr varchar2(8) -- 付款银行地址的INR
    ,pybnam varchar2(40) -- 付款银行名称
    ,pybref varchar2(16) -- 付款银行参考号
    ,orcptyinr varchar2(8) -- 汇款人PTYINR
    ,orcptainr varchar2(8) -- 汇款人PTAINR
    ,orcnam varchar2(40) -- 汇款人名称
    ,orcref varchar2(16) -- 汇款人参考号
    ,oriptyinr varchar2(8) -- 汇款行ptyinr
    ,oriptainr varchar2(8) -- 汇款行ptainr
    ,orinam varchar2(40) -- 汇款行名称
    ,oriref varchar2(16) -- 汇款行参考号
    ,valdat date -- 起息日
    ,opndat date -- 交易开始时间
    ,clsdat date -- 交易关闭时间
    ,chato varchar2(1) -- 费用
    ,credat date -- 建立日期
    ,ownusr varchar2(8) -- 操作用户
    ,ver varchar2(4) -- 版本号
    ,detchgcod varchar2(3) -- 详细费用
    ,paytyp varchar2(1) -- 付款类型
    ,stagod varchar2(6) -- 货物代码
    ,stacty varchar2(2) -- 国家代码
    ,etyextkey varchar2(8) -- 实体关键字
    ,sysno varchar2(21) -- 清算编号
    ,othbch varchar2(8) -- 所属行
    ,gors varchar2(1) -- 收款对象
    ,feecur varchar2(3) -- 国外费用币种
    ,feeamt number(16,3) -- 国外费用金额
    ,trntyp varchar2(1) -- 汇款性质
    ,paytype varchar2(1) -- 汇款方式
    ,paydat date -- 付款日期
    ,clityp varchar2(1) -- 客户类型
    ,trdint varchar2(2) -- 结汇类型
    ,curf33b varchar2(3) -- 原始币种
    ,cur71f varchar2(3) -- 发报行扣费币种
    ,amt71f number(16,3) -- 发报行扣费金额
    ,amtf33b number(16,3) -- 原始金额
    ,f36 number(12,6) -- 汇率
    ,f23e varchar2(35) -- 指令代码
    ,f23b varchar2(4) -- 银行操作码
    ,trdout varchar2(2) -- 售汇类型
    ,swftyp varchar2(3) -- 报文类型
    ,trdinr varchar2(8) -- Trd表inr
    ,rel21 varchar2(16) -- 参考号
    ,branchinr varchar2(8) -- 所属机构号
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,accmod varchar2(4) -- 帐号类型
    ,sztyp varchar2(1) -- 收支类型
    ,sndbanref varchar2(16) -- 发报行原始编号
    ,orcact varchar2(35) -- 汇款人帐号
    ,pyeact varchar2(35) -- 收款人帐号
    ,canflg varchar2(1) -- 退汇标志
    ,nraflg varchar2(1) -- NRA标志
    ,qsqdbh varchar2(3) -- 清算渠道
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
grant select on ${idl_schema}.aml_isbs_cpd to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_cpd is '汇款业务信息(存放短字节)';
comment on column ${idl_schema}.aml_isbs_cpd.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_cpd.inr is '唯一ID';
comment on column ${idl_schema}.aml_isbs_cpd.ownref is '交易参考号';
comment on column ${idl_schema}.aml_isbs_cpd.nam is '交易描述';
comment on column ${idl_schema}.aml_isbs_cpd.pyeptyinr is '收款人的INR';
comment on column ${idl_schema}.aml_isbs_cpd.pyeptainr is '收款人的地址';
comment on column ${idl_schema}.aml_isbs_cpd.pyenam is '收款人的描述';
comment on column ${idl_schema}.aml_isbs_cpd.pyeref is '收款人的参考号';
comment on column ${idl_schema}.aml_isbs_cpd.pybptyinr is '付款银行的INR';
comment on column ${idl_schema}.aml_isbs_cpd.pybptainr is '付款银行地址的INR';
comment on column ${idl_schema}.aml_isbs_cpd.pybnam is '付款银行名称';
comment on column ${idl_schema}.aml_isbs_cpd.pybref is '付款银行参考号';
comment on column ${idl_schema}.aml_isbs_cpd.orcptyinr is '汇款人PTYINR';
comment on column ${idl_schema}.aml_isbs_cpd.orcptainr is '汇款人PTAINR';
comment on column ${idl_schema}.aml_isbs_cpd.orcnam is '汇款人名称';
comment on column ${idl_schema}.aml_isbs_cpd.orcref is '汇款人参考号';
comment on column ${idl_schema}.aml_isbs_cpd.oriptyinr is '汇款行ptyinr';
comment on column ${idl_schema}.aml_isbs_cpd.oriptainr is '汇款行ptainr';
comment on column ${idl_schema}.aml_isbs_cpd.orinam is '汇款行名称';
comment on column ${idl_schema}.aml_isbs_cpd.oriref is '汇款行参考号';
comment on column ${idl_schema}.aml_isbs_cpd.valdat is '起息日';
comment on column ${idl_schema}.aml_isbs_cpd.opndat is '交易开始时间';
comment on column ${idl_schema}.aml_isbs_cpd.clsdat is '交易关闭时间';
comment on column ${idl_schema}.aml_isbs_cpd.chato is '费用';
comment on column ${idl_schema}.aml_isbs_cpd.credat is '建立日期';
comment on column ${idl_schema}.aml_isbs_cpd.ownusr is '操作用户';
comment on column ${idl_schema}.aml_isbs_cpd.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_cpd.detchgcod is '详细费用';
comment on column ${idl_schema}.aml_isbs_cpd.paytyp is '付款类型';
comment on column ${idl_schema}.aml_isbs_cpd.stagod is '货物代码';
comment on column ${idl_schema}.aml_isbs_cpd.stacty is '国家代码';
comment on column ${idl_schema}.aml_isbs_cpd.etyextkey is '实体关键字';
comment on column ${idl_schema}.aml_isbs_cpd.sysno is '清算编号';
comment on column ${idl_schema}.aml_isbs_cpd.othbch is '所属行';
comment on column ${idl_schema}.aml_isbs_cpd.gors is '收款对象';
comment on column ${idl_schema}.aml_isbs_cpd.feecur is '国外费用币种';
comment on column ${idl_schema}.aml_isbs_cpd.feeamt is '国外费用金额';
comment on column ${idl_schema}.aml_isbs_cpd.trntyp is '汇款性质';
comment on column ${idl_schema}.aml_isbs_cpd.paytype is '汇款方式';
comment on column ${idl_schema}.aml_isbs_cpd.paydat is '付款日期';
comment on column ${idl_schema}.aml_isbs_cpd.clityp is '客户类型';
comment on column ${idl_schema}.aml_isbs_cpd.trdint is '结汇类型';
comment on column ${idl_schema}.aml_isbs_cpd.curf33b is '原始币种';
comment on column ${idl_schema}.aml_isbs_cpd.cur71f is '发报行扣费币种';
comment on column ${idl_schema}.aml_isbs_cpd.amt71f is '发报行扣费金额';
comment on column ${idl_schema}.aml_isbs_cpd.amtf33b is '原始金额';
comment on column ${idl_schema}.aml_isbs_cpd.f36 is '汇率';
comment on column ${idl_schema}.aml_isbs_cpd.f23e is '指令代码';
comment on column ${idl_schema}.aml_isbs_cpd.f23b is '银行操作码';
comment on column ${idl_schema}.aml_isbs_cpd.trdout is '售汇类型';
comment on column ${idl_schema}.aml_isbs_cpd.swftyp is '报文类型';
comment on column ${idl_schema}.aml_isbs_cpd.trdinr is 'Trd表inr';
comment on column ${idl_schema}.aml_isbs_cpd.rel21 is '参考号';
comment on column ${idl_schema}.aml_isbs_cpd.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_cpd.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_cpd.accmod is '帐号类型';
comment on column ${idl_schema}.aml_isbs_cpd.sztyp is '收支类型';
comment on column ${idl_schema}.aml_isbs_cpd.sndbanref is '发报行原始编号';
comment on column ${idl_schema}.aml_isbs_cpd.orcact is '汇款人帐号';
comment on column ${idl_schema}.aml_isbs_cpd.pyeact is '收款人帐号';
comment on column ${idl_schema}.aml_isbs_cpd.canflg is '退汇标志';
comment on column ${idl_schema}.aml_isbs_cpd.nraflg is 'NRA标志';
comment on column ${idl_schema}.aml_isbs_cpd.qsqdbh is '清算渠道';
comment on column ${idl_schema}.aml_isbs_cpd.etl_timestamp is '数据处理时间';
