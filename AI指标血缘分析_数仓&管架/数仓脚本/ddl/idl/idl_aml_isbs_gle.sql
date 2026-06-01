/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_gle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_gle
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_gle purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_gle(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 内部唯一ID
    ,objtyp varchar2(6) -- 对象表名称
    ,objinr varchar2(8) -- 对象表INR
    ,trninr varchar2(8) -- TRN表的INR
    ,act varchar2(21) -- 帐号
    ,dbtcdt varchar2(1) -- 借贷标志
    ,cur varchar2(3) -- 记账币种
    ,amt number(18,3) -- 记账金额
    ,syscur varchar2(3) -- 规定币种
    ,sysamt number(18,3) -- 规定币种类型金额
    ,valdat date -- 起息日
    ,bucdat date -- 记录生成日期
    ,txt1 varchar2(40) -- 摘要1
    ,txt2 varchar2(400) -- 传票摘要
    ,txt3 varchar2(40) -- 摘要3
    ,prn varchar2(4) -- 分录顺序
    ,expses varchar2(8) -- 出口用户会话
    ,expflg varchar2(1) -- 出口状态
    ,acttrncod varchar2(4) -- 传票打印类型
    ,branchinr varchar2(8) -- 业务记账机构
    ,dbtdft varchar2(17) -- 借据号（融资时） 
    ,peeact varchar2(21) -- 对应帐号
    ,rat number(12,6) -- 汇率
    ,trdtyp varchar2(3) -- 交易类型
    ,cliextkey varchar2(24) -- 客户号
    ,whmtyp varchar2(2) -- 结售汇类型
    ,gleord varchar2(5) -- 分录顺序号
    ,newactcod varchar2(4) -- 核心系统交易代码
    ,trmtyp varchar2(5) -- 科目代号
    ,trnman varchar2(2) -- 结售汇交易主体
    ,midrat number(12,6) -- 中间价
    ,xrttim varchar2(20) -- 中间价的牌价时间
    ,income number(18,3) -- 结售汇损益
    ,sumtyp varchar2(6) -- 摘要类型
    ,acttyp varchar2(6) -- 帐目类型
    ,cshflg varchar2(1) -- 现金标志
    ,tracode varchar2(6) -- 交易代码
    ,ctycode varchar2(3) -- 国家标志
    ,apvnum varchar2(30) -- 批准号
    ,othfin varchar2(60) -- 对方银行名称
    ,selrat number(14,6) -- 卖出汇率
    ,buyrat number(14,6) -- 买入汇率
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
grant select on ${idl_schema}.aml_isbs_gle to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_gle is 'General Ledger会计分录信息';
comment on column ${idl_schema}.aml_isbs_gle.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_gle.inr is '内部唯一ID';
comment on column ${idl_schema}.aml_isbs_gle.objtyp is '对象表名称';
comment on column ${idl_schema}.aml_isbs_gle.objinr is '对象表INR';
comment on column ${idl_schema}.aml_isbs_gle.trninr is 'TRN表的INR';
comment on column ${idl_schema}.aml_isbs_gle.act is '帐号';
comment on column ${idl_schema}.aml_isbs_gle.dbtcdt is '借贷标志';
comment on column ${idl_schema}.aml_isbs_gle.cur is '记账币种';
comment on column ${idl_schema}.aml_isbs_gle.amt is '记账金额';
comment on column ${idl_schema}.aml_isbs_gle.syscur is '规定币种';
comment on column ${idl_schema}.aml_isbs_gle.sysamt is '规定币种类型金额';
comment on column ${idl_schema}.aml_isbs_gle.valdat is '起息日';
comment on column ${idl_schema}.aml_isbs_gle.bucdat is '记录生成日期';
comment on column ${idl_schema}.aml_isbs_gle.txt1 is '摘要1';
comment on column ${idl_schema}.aml_isbs_gle.txt2 is '传票摘要';
comment on column ${idl_schema}.aml_isbs_gle.txt3 is '摘要3';
comment on column ${idl_schema}.aml_isbs_gle.prn is '分录顺序';
comment on column ${idl_schema}.aml_isbs_gle.expses is '出口用户会话';
comment on column ${idl_schema}.aml_isbs_gle.expflg is '出口状态';
comment on column ${idl_schema}.aml_isbs_gle.acttrncod is '传票打印类型';
comment on column ${idl_schema}.aml_isbs_gle.branchinr is '业务记账机构';
comment on column ${idl_schema}.aml_isbs_gle.dbtdft is '借据号（融资时） ';
comment on column ${idl_schema}.aml_isbs_gle.peeact is '对应帐号';
comment on column ${idl_schema}.aml_isbs_gle.rat is '汇率';
comment on column ${idl_schema}.aml_isbs_gle.trdtyp is '交易类型';
comment on column ${idl_schema}.aml_isbs_gle.cliextkey is '客户号';
comment on column ${idl_schema}.aml_isbs_gle.whmtyp is '结售汇类型';
comment on column ${idl_schema}.aml_isbs_gle.gleord is '分录顺序号';
comment on column ${idl_schema}.aml_isbs_gle.newactcod is '核心系统交易代码';
comment on column ${idl_schema}.aml_isbs_gle.trmtyp is '科目代号';
comment on column ${idl_schema}.aml_isbs_gle.trnman is '结售汇交易主体';
comment on column ${idl_schema}.aml_isbs_gle.midrat is '中间价';
comment on column ${idl_schema}.aml_isbs_gle.xrttim is '中间价的牌价时间';
comment on column ${idl_schema}.aml_isbs_gle.income is '结售汇损益';
comment on column ${idl_schema}.aml_isbs_gle.sumtyp is '摘要类型';
comment on column ${idl_schema}.aml_isbs_gle.acttyp is '帐目类型';
comment on column ${idl_schema}.aml_isbs_gle.cshflg is '现金标志';
comment on column ${idl_schema}.aml_isbs_gle.tracode is '交易代码';
comment on column ${idl_schema}.aml_isbs_gle.ctycode is '国家标志';
comment on column ${idl_schema}.aml_isbs_gle.apvnum is '批准号';
comment on column ${idl_schema}.aml_isbs_gle.othfin is '对方银行名称';
comment on column ${idl_schema}.aml_isbs_gle.selrat is '卖出汇率';
comment on column ${idl_schema}.aml_isbs_gle.buyrat is '买入汇率';
comment on column ${idl_schema}.aml_isbs_gle.etl_timestamp is '数据处理时间';
