/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1gtaudpayorder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1gtaudpayorder
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1gtaudpayorder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1gtaudpayorder(
    trxcode varchar2(8) -- 指令代码
    ,transdt varchar2(15) -- 交易日期
    ,finaid varchar2(18) -- 财政局代码
    ,finano varchar2(96) -- 财政流水号
    ,operator varchar2(45) -- 操作员
    ,bankid varchar2(6) -- 银行标识号
    ,billno varchar2(30) -- 单据号
    ,bgorgcode varchar2(45) -- 业务科室代码
    ,bgdeptcode varchar2(45) -- 预算单位代码
    ,procdate varchar2(15) -- 业务日期
    ,captorgion varchar2(6) -- 资金性质
    ,fiscal varchar2(6) -- 会计年度
    ,fisperd varchar2(3) -- 会计期间
    ,paymenttype varchar2(3) -- 支付方式 01授权支付 02直接支付
    ,bgacccode varchar2(45) -- 预算科目代码
    ,projectcode varchar2(45) -- 预算项目代码
    ,typeofpay varchar2(6) -- 支出类型
    ,outlaycode varchar2(45) -- 经费类型
    ,payusage varchar2(600) -- 支出用途
    ,recebankaccount varchar2(75) -- 收款人账号
    ,recename varchar2(600) -- 收款人名称
    ,recebanknodename varchar2(150) -- 收款人开户行
    ,paybankaccount varchar2(75) -- 付款人账号
    ,payname varchar2(600) -- 付款人名称
    ,paybanknodename varchar2(150) -- 付款人开户行
    ,rationsum varchar2(27) -- 额度
    ,paysum varchar2(27) -- 支付金额
    ,remark varchar2(600) -- 备注
    ,transtype varchar2(3) -- 业务类型 00=正常支付 01=取消支付
    ,wayofpay varchar2(3) -- 结算方式 01=现金 02=转账 9=公务卡
    ,billsno varchar2(30) -- 单位支付凭证字号
    ,banktrxcode varchar2(5) -- 银行返回码
    ,paydatetime varchar2(21) -- 银行处理时间
    ,bankpaystatus varchar2(15) -- 银行处理状态
    ,finatrxcode varchar2(5) -- 财政返回码
    ,updt varchar2(21) -- 最后修改时间
    ,brcno varchar2(9) -- 修改机构
    ,tlrno varchar2(15) -- 修改柜员
    ,status varchar2(5) -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
    ,transeqno varchar2(96) -- upp记账的流水号
    ,bgdeptname varchar2(300) -- 预算单位名称
    ,projectname varchar2(300) -- 预算项目名称
    ,bgorgname varchar2(300) -- 业务科室名称
    ,bgaccname varchar2(300) -- 预算科目名称
    ,dataid varchar2(60) -- 第三方标识号
    ,banksequ varchar2(30) -- 银行发送财政的流水号
    ,outlayname varchar2(300) -- 经费类型名称
    ,recebanknode varchar2(18) -- 收款人开行行号
    ,bankflg varchar2(3) -- 行内行外标志 1-行内 0-行外
    ,hostdate varchar2(12) -- 主机日期
    ,hostnbr varchar2(60) -- 主机流水
    ,cnapstransq varchar2(45) -- 支付序号
    ,operationtypecode varchar2(15) -- 业务标识
    ,yztype varchar2(3) -- 零余额标志
    ,globalseqno varchar2(96) -- 
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
grant select on ${iol_schema}.mpcs_a1gtaudpayorder to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1gtaudpayorder to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1gtaudpayorder to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1gtaudpayorder to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1gtaudpayorder is '';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.trxcode is '指令代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.finaid is '财政局代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.finano is '财政流水号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.operator is '操作员';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bankid is '银行标识号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.billno is '单据号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgorgcode is '业务科室代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgdeptcode is '预算单位代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.procdate is '业务日期';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.captorgion is '资金性质';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.fiscal is '会计年度';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.fisperd is '会计期间';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.paymenttype is '支付方式 01授权支付 02直接支付';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgacccode is '预算科目代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.projectcode is '预算项目代码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.typeofpay is '支出类型';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.outlaycode is '经费类型';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.payusage is '支出用途';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.recebankaccount is '收款人账号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.recename is '收款人名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.recebanknodename is '收款人开户行';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.paybankaccount is '付款人账号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.paybanknodename is '付款人开户行';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.rationsum is '额度';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.paysum is '支付金额';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.remark is '备注';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.transtype is '业务类型 00=正常支付 01=取消支付';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.wayofpay is '结算方式 01=现金 02=转账 9=公务卡';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.billsno is '单位支付凭证字号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.banktrxcode is '银行返回码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.paydatetime is '银行处理时间';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bankpaystatus is '银行处理状态';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.finatrxcode is '财政返回码';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.updt is '最后修改时间';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.brcno is '修改机构';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.tlrno is '修改柜员';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.status is '交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.transeqno is 'upp记账的流水号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgdeptname is '预算单位名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.projectname is '预算项目名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgorgname is '业务科室名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bgaccname is '预算科目名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.dataid is '第三方标识号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.banksequ is '银行发送财政的流水号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.outlayname is '经费类型名称';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.recebanknode is '收款人开行行号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.bankflg is '行内行外标志 1-行内 0-行外';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.cnapstransq is '支付序号';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.operationtypecode is '业务标识';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.yztype is '零余额标志';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.globalseqno is '';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1gtaudpayorder.etl_timestamp is 'ETL处理时间戳';
