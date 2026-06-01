/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gle
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gle(
    inr varchar2(12) -- 内部唯一id
    ,objtyp varchar2(9) -- 对象表名称
    ,objinr varchar2(12) -- 对象表inr
    ,trninr varchar2(12) -- trn表的inr
    ,act varchar2(32) -- 帐号
    ,dbtcdt varchar2(2) -- 借贷标志
    ,cur varchar2(5) -- 记账币种
    ,amt number(18,3) -- 记账金额
    ,syscur varchar2(5) -- 规定币种
    ,sysamt number(18,3) -- 规定币种类型金额
    ,valdat date -- 起息日
    ,bucdat date -- 记录生成日期
    ,txt1 varchar2(60) -- 摘要1
    ,txt2 varchar2(600) -- 传票摘要
    ,txt3 varchar2(60) -- 摘要3
    ,prn varchar2(6) -- 分录顺序
    ,expses varchar2(12) -- 出口用户会话
    ,expflg varchar2(2) -- 出口状态
    ,acttrncod varchar2(6) -- 传票打印类型
    ,branchinr varchar2(12) -- 业务记账机构
    ,dbtdft varchar2(26) -- 借据号（融资时）
    ,peeact varchar2(32) -- 对应帐号
    ,rat number(12,6) -- 汇率
    ,trdtyp varchar2(5) -- 交易类型
    ,cliextkey varchar2(36) -- 客户号
    ,whmtyp varchar2(3) -- 结售汇类型
    ,gleord varchar2(8) -- 分录顺序号
    ,newactcod varchar2(6) -- 核心系统交易代码
    ,trmtyp varchar2(8) -- 科目代号
    ,trnman varchar2(3) -- 结售汇交易主体
    ,midrat number(12,6) -- 中间价
    ,xrttim varchar2(30) -- 中间价的牌价时间
    ,income number(18,3) -- 结售汇损益
    ,sumtyp varchar2(9) -- 摘要类型
    ,acttyp varchar2(9) -- 帐目类型
    ,cshflg varchar2(2) -- 现金标志
    ,tracode varchar2(9) -- 交易代码
    ,ctycode varchar2(5) -- 国家标志
    ,apvnum varchar2(45) -- 批准号
    ,othfin varchar2(90) -- 对方银行名称
    ,selrat number(14,6) -- 卖出汇率
    ,buyrat number(14,6) -- 买入汇率
    ,bp number(7,2) -- 优惠点数
    ,stzflg varchar2(2) -- 受托支付标识
    ,settyp varchar2(12) -- 账务类型 lia-表外 fee-费用 jsh-结售汇 通用记账
    ,actseqno varchar2(3) -- 账户序号
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
grant select on ${iol_schema}.isbs_gle to ${iml_schema};
grant select on ${iol_schema}.isbs_gle to ${icl_schema};
grant select on ${iol_schema}.isbs_gle to ${idl_schema};
grant select on ${iol_schema}.isbs_gle to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gle is 'General Ledger会计分录信息';
comment on column ${iol_schema}.isbs_gle.inr is '内部唯一id';
comment on column ${iol_schema}.isbs_gle.objtyp is '对象表名称';
comment on column ${iol_schema}.isbs_gle.objinr is '对象表inr';
comment on column ${iol_schema}.isbs_gle.trninr is 'trn表的inr';
comment on column ${iol_schema}.isbs_gle.act is '帐号';
comment on column ${iol_schema}.isbs_gle.dbtcdt is '借贷标志';
comment on column ${iol_schema}.isbs_gle.cur is '记账币种';
comment on column ${iol_schema}.isbs_gle.amt is '记账金额';
comment on column ${iol_schema}.isbs_gle.syscur is '规定币种';
comment on column ${iol_schema}.isbs_gle.sysamt is '规定币种类型金额';
comment on column ${iol_schema}.isbs_gle.valdat is '起息日';
comment on column ${iol_schema}.isbs_gle.bucdat is '记录生成日期';
comment on column ${iol_schema}.isbs_gle.txt1 is '摘要1';
comment on column ${iol_schema}.isbs_gle.txt2 is '传票摘要';
comment on column ${iol_schema}.isbs_gle.txt3 is '摘要3';
comment on column ${iol_schema}.isbs_gle.prn is '分录顺序';
comment on column ${iol_schema}.isbs_gle.expses is '出口用户会话';
comment on column ${iol_schema}.isbs_gle.expflg is '出口状态';
comment on column ${iol_schema}.isbs_gle.acttrncod is '传票打印类型';
comment on column ${iol_schema}.isbs_gle.branchinr is '业务记账机构';
comment on column ${iol_schema}.isbs_gle.dbtdft is '借据号（融资时）';
comment on column ${iol_schema}.isbs_gle.peeact is '对应帐号';
comment on column ${iol_schema}.isbs_gle.rat is '汇率';
comment on column ${iol_schema}.isbs_gle.trdtyp is '交易类型';
comment on column ${iol_schema}.isbs_gle.cliextkey is '客户号';
comment on column ${iol_schema}.isbs_gle.whmtyp is '结售汇类型';
comment on column ${iol_schema}.isbs_gle.gleord is '分录顺序号';
comment on column ${iol_schema}.isbs_gle.newactcod is '核心系统交易代码';
comment on column ${iol_schema}.isbs_gle.trmtyp is '科目代号';
comment on column ${iol_schema}.isbs_gle.trnman is '结售汇交易主体';
comment on column ${iol_schema}.isbs_gle.midrat is '中间价';
comment on column ${iol_schema}.isbs_gle.xrttim is '中间价的牌价时间';
comment on column ${iol_schema}.isbs_gle.income is '结售汇损益';
comment on column ${iol_schema}.isbs_gle.sumtyp is '摘要类型';
comment on column ${iol_schema}.isbs_gle.acttyp is '帐目类型';
comment on column ${iol_schema}.isbs_gle.cshflg is '现金标志';
comment on column ${iol_schema}.isbs_gle.tracode is '交易代码';
comment on column ${iol_schema}.isbs_gle.ctycode is '国家标志';
comment on column ${iol_schema}.isbs_gle.apvnum is '批准号';
comment on column ${iol_schema}.isbs_gle.othfin is '对方银行名称';
comment on column ${iol_schema}.isbs_gle.selrat is '卖出汇率';
comment on column ${iol_schema}.isbs_gle.buyrat is '买入汇率';
comment on column ${iol_schema}.isbs_gle.bp is '优惠点数';
comment on column ${iol_schema}.isbs_gle.stzflg is '受托支付标识';
comment on column ${iol_schema}.isbs_gle.settyp is '账务类型 lia-表外 fee-费用 jsh-结售汇 通用记账';
comment on column ${iol_schema}.isbs_gle.actseqno is '账户序号';
comment on column ${iol_schema}.isbs_gle.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_gle.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_gle.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_gle.etl_timestamp is 'ETL处理时间戳';
