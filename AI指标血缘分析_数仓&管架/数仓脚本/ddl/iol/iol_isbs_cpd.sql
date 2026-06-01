/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cpd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cpd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cpd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cpd(
    inr varchar2(12) -- 唯一id
    ,ownref varchar2(24) -- 交易参考号
    ,nam varchar2(60) -- 交易描述
    ,pyeptyinr varchar2(12) -- 收款人的inr
    ,pyeptainr varchar2(12) -- 收款人的地址
    ,pyenam varchar2(60) -- 收款人的描述
    ,pyeref varchar2(24) -- 收款人的参考号
    ,pybptyinr varchar2(12) -- 付款银行的inr
    ,pybptainr varchar2(12) -- 付款银行地址的inr
    ,pybnam varchar2(60) -- 付款银行名称
    ,pybref varchar2(24) -- 付款银行参考号
    ,orcptyinr varchar2(12) -- 汇款人ptyinr
    ,orcptainr varchar2(12) -- 汇款人ptainr
    ,orcnam varchar2(60) -- 汇款人名称
    ,orcref varchar2(24) -- 汇款人参考号
    ,oriptyinr varchar2(12) -- 汇款行ptyinr
    ,oriptainr varchar2(12) -- 汇款行ptainr
    ,orinam varchar2(60) -- 汇款行名称
    ,oriref varchar2(24) -- 汇款行参考号
    ,valdat date -- 起息日
    ,opndat date -- 交易开始时间
    ,clsdat date -- 交易关闭时间
    ,chato varchar2(2) -- 费用
    ,credat date -- 建立日期
    ,ownusr varchar2(12) -- 操作用户
    ,ver varchar2(6) -- 版本号
    ,detchgcod varchar2(5) -- 详细费用
    ,paytyp varchar2(2) -- 付款类型
    ,stagod varchar2(9) -- 货物代码
    ,stacty varchar2(3) -- 国家代码
    ,etyextkey varchar2(12) -- 实体关键字
    ,sysno varchar2(32) -- 清算编号
    ,othbch varchar2(12) -- 所属行
    ,gors varchar2(2) -- 收款对象
    ,feecur varchar2(5) -- 国外费用币种
    ,feeamt number(16,3) -- 国外费用金额
    ,trntyp varchar2(2) -- 汇款性质
    ,paytype varchar2(2) -- 汇款方式
    ,paydat date -- 付款日期
    ,clityp varchar2(2) -- 客户类型
    ,trdint varchar2(3) -- 结汇类型
    ,curf33b varchar2(5) -- 原始币种
    ,cur71f varchar2(5) -- 发报行扣费币种
    ,amt71f number(16,3) -- 发报行扣费金额
    ,amtf33b number(16,3) -- 原始金额
    ,f36 number(12,6) -- 汇率
    ,f23e varchar2(53) -- 指令代码
    ,f23b varchar2(6) -- 银行操作码
    ,trdout varchar2(3) -- 售汇类型
    ,swftyp varchar2(5) -- 报文类型
    ,trdinr varchar2(12) -- trd表inr
    ,rel21 varchar2(24) -- 参考号
    ,branchinr varchar2(12) -- 所属机构号
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,accmod varchar2(6) -- 处理类型
    ,sztyp varchar2(2) -- 收支类型
    ,sndbanref varchar2(24) -- 发报行原始编号
    ,orcact varchar2(53) -- 汇款人帐号
    ,pyeact varchar2(53) -- 收款人帐号
    ,canflg varchar2(2) -- 退汇标志
    ,nraflg varchar2(2) -- nra标志
    ,qsqdbh varchar2(5) -- 清算渠道
    ,zjcflg varchar2(2) -- 跨境资金池标识
    ,edtyp varchar2(2) -- 资金池业务类型
    ,basamt number(18,3) -- 资金池业务本金
    ,intamt number(18,3) -- 资金池业务利息
    ,stzfref varchar2(60) -- 受托支付编号
    ,duebillno varchar2(30) -- 受托支付出账借据号
    ,gpiflg varchar2(2) -- gpi业务标识
    ,acstyp varchar2(30) -- gpi mt199报文反馈码
    ,qufflg varchar2(2) -- 询价标识（线上汇款业务是否有做过询价）
    ,feeacc varchar2(51) -- 扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）
    ,resno varchar2(75) -- 限制编号
    ,isbxt varchar2(2) -- 是否北向通
    ,bxtamt number(18,3) -- 金额
    ,bxtsamt number(18,3) -- 北向通金额
    ,iskds varchar2(2) -- 是否跨境电商标识
    ,sbflg varchar2(2) -- 申报标识
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
grant select on ${iol_schema}.isbs_cpd to ${iml_schema};
grant select on ${iol_schema}.isbs_cpd to ${icl_schema};
grant select on ${iol_schema}.isbs_cpd to ${idl_schema};
grant select on ${iol_schema}.isbs_cpd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cpd is '汇款业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_cpd.inr is '唯一id';
comment on column ${iol_schema}.isbs_cpd.ownref is '交易参考号';
comment on column ${iol_schema}.isbs_cpd.nam is '交易描述';
comment on column ${iol_schema}.isbs_cpd.pyeptyinr is '收款人的inr';
comment on column ${iol_schema}.isbs_cpd.pyeptainr is '收款人的地址';
comment on column ${iol_schema}.isbs_cpd.pyenam is '收款人的描述';
comment on column ${iol_schema}.isbs_cpd.pyeref is '收款人的参考号';
comment on column ${iol_schema}.isbs_cpd.pybptyinr is '付款银行的inr';
comment on column ${iol_schema}.isbs_cpd.pybptainr is '付款银行地址的inr';
comment on column ${iol_schema}.isbs_cpd.pybnam is '付款银行名称';
comment on column ${iol_schema}.isbs_cpd.pybref is '付款银行参考号';
comment on column ${iol_schema}.isbs_cpd.orcptyinr is '汇款人ptyinr';
comment on column ${iol_schema}.isbs_cpd.orcptainr is '汇款人ptainr';
comment on column ${iol_schema}.isbs_cpd.orcnam is '汇款人名称';
comment on column ${iol_schema}.isbs_cpd.orcref is '汇款人参考号';
comment on column ${iol_schema}.isbs_cpd.oriptyinr is '汇款行ptyinr';
comment on column ${iol_schema}.isbs_cpd.oriptainr is '汇款行ptainr';
comment on column ${iol_schema}.isbs_cpd.orinam is '汇款行名称';
comment on column ${iol_schema}.isbs_cpd.oriref is '汇款行参考号';
comment on column ${iol_schema}.isbs_cpd.valdat is '起息日';
comment on column ${iol_schema}.isbs_cpd.opndat is '交易开始时间';
comment on column ${iol_schema}.isbs_cpd.clsdat is '交易关闭时间';
comment on column ${iol_schema}.isbs_cpd.chato is '费用';
comment on column ${iol_schema}.isbs_cpd.credat is '建立日期';
comment on column ${iol_schema}.isbs_cpd.ownusr is '操作用户';
comment on column ${iol_schema}.isbs_cpd.ver is '版本号';
comment on column ${iol_schema}.isbs_cpd.detchgcod is '详细费用';
comment on column ${iol_schema}.isbs_cpd.paytyp is '付款类型';
comment on column ${iol_schema}.isbs_cpd.stagod is '货物代码';
comment on column ${iol_schema}.isbs_cpd.stacty is '国家代码';
comment on column ${iol_schema}.isbs_cpd.etyextkey is '实体关键字';
comment on column ${iol_schema}.isbs_cpd.sysno is '清算编号';
comment on column ${iol_schema}.isbs_cpd.othbch is '所属行';
comment on column ${iol_schema}.isbs_cpd.gors is '收款对象';
comment on column ${iol_schema}.isbs_cpd.feecur is '国外费用币种';
comment on column ${iol_schema}.isbs_cpd.feeamt is '国外费用金额';
comment on column ${iol_schema}.isbs_cpd.trntyp is '汇款性质';
comment on column ${iol_schema}.isbs_cpd.paytype is '汇款方式';
comment on column ${iol_schema}.isbs_cpd.paydat is '付款日期';
comment on column ${iol_schema}.isbs_cpd.clityp is '客户类型';
comment on column ${iol_schema}.isbs_cpd.trdint is '结汇类型';
comment on column ${iol_schema}.isbs_cpd.curf33b is '原始币种';
comment on column ${iol_schema}.isbs_cpd.cur71f is '发报行扣费币种';
comment on column ${iol_schema}.isbs_cpd.amt71f is '发报行扣费金额';
comment on column ${iol_schema}.isbs_cpd.amtf33b is '原始金额';
comment on column ${iol_schema}.isbs_cpd.f36 is '汇率';
comment on column ${iol_schema}.isbs_cpd.f23e is '指令代码';
comment on column ${iol_schema}.isbs_cpd.f23b is '银行操作码';
comment on column ${iol_schema}.isbs_cpd.trdout is '售汇类型';
comment on column ${iol_schema}.isbs_cpd.swftyp is '报文类型';
comment on column ${iol_schema}.isbs_cpd.trdinr is 'trd表inr';
comment on column ${iol_schema}.isbs_cpd.rel21 is '参考号';
comment on column ${iol_schema}.isbs_cpd.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_cpd.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_cpd.accmod is '处理类型';
comment on column ${iol_schema}.isbs_cpd.sztyp is '收支类型';
comment on column ${iol_schema}.isbs_cpd.sndbanref is '发报行原始编号';
comment on column ${iol_schema}.isbs_cpd.orcact is '汇款人帐号';
comment on column ${iol_schema}.isbs_cpd.pyeact is '收款人帐号';
comment on column ${iol_schema}.isbs_cpd.canflg is '退汇标志';
comment on column ${iol_schema}.isbs_cpd.nraflg is 'nra标志';
comment on column ${iol_schema}.isbs_cpd.qsqdbh is '清算渠道';
comment on column ${iol_schema}.isbs_cpd.zjcflg is '跨境资金池标识';
comment on column ${iol_schema}.isbs_cpd.edtyp is '资金池业务类型';
comment on column ${iol_schema}.isbs_cpd.basamt is '资金池业务本金';
comment on column ${iol_schema}.isbs_cpd.intamt is '资金池业务利息';
comment on column ${iol_schema}.isbs_cpd.stzfref is '受托支付编号';
comment on column ${iol_schema}.isbs_cpd.duebillno is '受托支付出账借据号';
comment on column ${iol_schema}.isbs_cpd.gpiflg is 'gpi业务标识';
comment on column ${iol_schema}.isbs_cpd.acstyp is 'gpi mt199报文反馈码';
comment on column ${iol_schema}.isbs_cpd.qufflg is '询价标识（线上汇款业务是否有做过询价）';
comment on column ${iol_schema}.isbs_cpd.feeacc is '扣费账号（线上汇款业务的费用承担方为our时带入客户扣费账号）';
comment on column ${iol_schema}.isbs_cpd.resno is '限制编号';
comment on column ${iol_schema}.isbs_cpd.isbxt is '是否北向通';
comment on column ${iol_schema}.isbs_cpd.bxtamt is '金额';
comment on column ${iol_schema}.isbs_cpd.bxtsamt is '北向通金额';
comment on column ${iol_schema}.isbs_cpd.iskds is '是否跨境电商标识';
comment on column ${iol_schema}.isbs_cpd.sbflg is '申报标识';
comment on column ${iol_schema}.isbs_cpd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cpd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cpd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cpd.etl_timestamp is 'ETL处理时间戳';
