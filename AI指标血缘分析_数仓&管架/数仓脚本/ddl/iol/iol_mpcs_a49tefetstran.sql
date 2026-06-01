/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefetstran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefetstran
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefetstran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefetstran(
    trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水号
    ,trantm varchar2(9) -- 交易时间
    ,txntype varchar2(9) -- 交易类型细分
    ,iotype varchar2(2) -- 往来标志
    ,transt varchar2(2) -- 交易状态
    ,magbrn varchar2(15) -- 管理机构
    ,colldate varchar2(12) -- 对账日期
    ,hostdt varchar2(12) -- 主机日期
    ,hostsq varchar2(105) -- 主机流水号
    ,colldt varchar2(12) -- 冲正日期
    ,collsq varchar2(105) -- 冲正流水
    ,msgcode varchar2(30) -- 响应码
    ,msgtext varchar2(150) -- 响应描述
    ,sysid varchar2(6) -- 发起方系统号
    ,sndzone varchar2(6) -- 发起地区代码
    ,rcvzone varchar2(6) -- 接收地区代码
    ,msgno varchar2(9) -- 报文编号
    ,msgid varchar2(30) -- 信息序号
    ,origmsgid varchar2(30) -- 原信息序号
    ,entrustdate varchar2(12) -- 委托日期
    ,vouchno varchar2(24) -- 凭证提交号
    ,trantp varchar2(3) -- 交易类型
    ,currencycd varchar2(5) -- 交易货币
    ,amount number(18,2) -- 交易金额
    ,feeamt number(18,2) -- 手续费
    ,postam number(18,2) -- 邮电费
    ,handam number(18,2) -- 工本费
    ,sendbank varchar2(18) -- 发起行行号/代理行
    ,payerbank varchar2(18) -- 付款行行号
    ,payeraccbank varchar2(18) -- 付款人开户行行号
    ,payeracc varchar2(53) -- 付款人账号
    ,payername varchar2(120) -- 付款人名称
    ,acctbr varchar2(15) -- 付款人账号开户机构
    ,payeebank varchar2(18) -- 收款行行号
    ,payeeaccbank varchar2(18) -- 收款人开户行行号
    ,payeeacc varchar2(53) -- 收款人账号
    ,payeename varchar2(120) -- 收款人名称
    ,oprchl varchar2(6) -- 业务渠道
    ,mainbr varchar2(18) -- 经收处银行号
    ,bankdt varchar2(18) -- 银行提交日期
    ,tranid varchar2(24) -- 交易识别号
    ,txbrch varchar2(2) -- 机关类别
    ,origcd varchar2(18) -- 征收机关代码
    ,origdt varchar2(12) -- 征收机关提交日期
    ,origsq varchar2(36) -- 征收机关流水号
    ,fisccd varchar2(18) -- 收款国库代码
    ,oprtype varchar2(3) -- 交易类型
    ,torigdt varchar2(18) -- 征收机关提交日期
    ,torigsq varchar2(36) -- 征收机关流水号
    ,txpycd varchar2(30) -- 纳税人编码
    ,txpyna varchar2(120) -- 纳税人名称
    ,declacd varchar2(2) -- 申报方式代码
    ,declasq varchar2(36) -- 申报流水号
    ,payecd varchar2(2) -- 缴款方式代码
    ,logadt varchar2(12) -- ets资金对数日期
    ,logact varchar2(3) -- ets资金对数场次
    ,txnid varchar2(30) -- 中心受理号
    ,txndate varchar2(12) -- 清算日期
    ,txnround varchar2(3) -- 清算场次
    ,outmid varchar2(30) -- 回应方业务处理号
    ,outtime varchar2(21) -- 回应行交易受理时间
    ,retcd varchar2(12) -- 返回码
    ,remark varchar2(450) -- 附言
    ,brchno varchar2(15) -- 营业点
    ,userid varchar2(15) -- 柜员号
    ,ckbkus varchar2(15) -- 授权柜员
    ,ckbkbr varchar2(15) -- 授权网点
    ,linkid number(22) -- 链路id
    ,prtcnt number(22) -- 打印次数
    ,bustype varchar2(2) -- 业务类型
    ,cpnytp varchar2(6) -- 企业注册类型代码
    ,dtlrmk varchar2(75) -- 明细备注
    ,dtllng varchar2(6) -- 明细长度
    ,bugdltlr varchar2(15) -- 异常处理柜员
    ,bugdlmk varchar2(150) -- 异常处理附言
    ,bugdltp varchar2(2) -- 异常处理方式
    ,bugdlsq varchar2(105) -- 退款处理流水（记账流水）
    ,bugdldt varchar2(12) -- 退款处理日期（记账日期）
    ,bugauth varchar2(15) -- 异常处理授权柜员
    ,bugbrc varchar2(15) -- 异常处理机构
    ,bugacctno varchar2(53) -- 退款账号
    ,bugacctna varchar2(180) -- 退款户名
    ,bugaccttms number(22,0) -- 退款异常记账次数
    ,payertel varchar2(45) -- 缴款人电话
    ,idtftp varchar2(6) -- 缴款人证件类型
    ,idtfno varchar2(27) -- 缴款人证件号码
    ,bookcd varchar2(6) -- 凭证类型
    ,bookno varchar2(30) -- 凭证号码
    ,bookoutdt varchar2(12) -- 出票日期
    ,trnchl varchar2(6) -- 交易渠道
    ,srcsysid varchar2(6) -- 源渠道码
    ,retmsg varchar2(450) -- 中心返回信息
    ,chnlsq varchar2(48) -- 渠道流水号
    ,transeqno varchar2(105) -- 业务流水号
    ,globalseqno varchar2(105) -- 全局流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a49tefetstran to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefetstran to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefetstran to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefetstran to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefetstran is '财税业务交易流水登记簿';
comment on column ${iol_schema}.mpcs_a49tefetstran.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.transq is '交易流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.trantm is '交易时间';
comment on column ${iol_schema}.mpcs_a49tefetstran.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49tefetstran.iotype is '往来标志';
comment on column ${iol_schema}.mpcs_a49tefetstran.transt is '交易状态';
comment on column ${iol_schema}.mpcs_a49tefetstran.magbrn is '管理机构';
comment on column ${iol_schema}.mpcs_a49tefetstran.colldate is '对账日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.hostdt is '主机日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.hostsq is '主机流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.colldt is '冲正日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.collsq is '冲正流水';
comment on column ${iol_schema}.mpcs_a49tefetstran.msgcode is '响应码';
comment on column ${iol_schema}.mpcs_a49tefetstran.msgtext is '响应描述';
comment on column ${iol_schema}.mpcs_a49tefetstran.sysid is '发起方系统号';
comment on column ${iol_schema}.mpcs_a49tefetstran.sndzone is '发起地区代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.rcvzone is '接收地区代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.msgno is '报文编号';
comment on column ${iol_schema}.mpcs_a49tefetstran.msgid is '信息序号';
comment on column ${iol_schema}.mpcs_a49tefetstran.origmsgid is '原信息序号';
comment on column ${iol_schema}.mpcs_a49tefetstran.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.vouchno is '凭证提交号';
comment on column ${iol_schema}.mpcs_a49tefetstran.trantp is '交易类型';
comment on column ${iol_schema}.mpcs_a49tefetstran.currencycd is '交易货币';
comment on column ${iol_schema}.mpcs_a49tefetstran.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a49tefetstran.feeamt is '手续费';
comment on column ${iol_schema}.mpcs_a49tefetstran.postam is '邮电费';
comment on column ${iol_schema}.mpcs_a49tefetstran.handam is '工本费';
comment on column ${iol_schema}.mpcs_a49tefetstran.sendbank is '发起行行号/代理行';
comment on column ${iol_schema}.mpcs_a49tefetstran.payerbank is '付款行行号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeraccbank is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeracc is '付款人账号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payername is '付款人名称';
comment on column ${iol_schema}.mpcs_a49tefetstran.acctbr is '付款人账号开户机构';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeebank is '收款行行号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeeaccbank is '收款人开户行行号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeeacc is '收款人账号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payeename is '收款人名称';
comment on column ${iol_schema}.mpcs_a49tefetstran.oprchl is '业务渠道';
comment on column ${iol_schema}.mpcs_a49tefetstran.mainbr is '经收处银行号';
comment on column ${iol_schema}.mpcs_a49tefetstran.bankdt is '银行提交日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.tranid is '交易识别号';
comment on column ${iol_schema}.mpcs_a49tefetstran.txbrch is '机关类别';
comment on column ${iol_schema}.mpcs_a49tefetstran.origcd is '征收机关代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.origdt is '征收机关提交日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.origsq is '征收机关流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.fisccd is '收款国库代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.oprtype is '交易类型';
comment on column ${iol_schema}.mpcs_a49tefetstran.torigdt is '征收机关提交日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.torigsq is '征收机关流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.txpycd is '纳税人编码';
comment on column ${iol_schema}.mpcs_a49tefetstran.txpyna is '纳税人名称';
comment on column ${iol_schema}.mpcs_a49tefetstran.declacd is '申报方式代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.declasq is '申报流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.payecd is '缴款方式代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.logadt is 'ets资金对数日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.logact is 'ets资金对数场次';
comment on column ${iol_schema}.mpcs_a49tefetstran.txnid is '中心受理号';
comment on column ${iol_schema}.mpcs_a49tefetstran.txndate is '清算日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.txnround is '清算场次';
comment on column ${iol_schema}.mpcs_a49tefetstran.outmid is '回应方业务处理号';
comment on column ${iol_schema}.mpcs_a49tefetstran.outtime is '回应行交易受理时间';
comment on column ${iol_schema}.mpcs_a49tefetstran.retcd is '返回码';
comment on column ${iol_schema}.mpcs_a49tefetstran.remark is '附言';
comment on column ${iol_schema}.mpcs_a49tefetstran.brchno is '营业点';
comment on column ${iol_schema}.mpcs_a49tefetstran.userid is '柜员号';
comment on column ${iol_schema}.mpcs_a49tefetstran.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a49tefetstran.ckbkbr is '授权网点';
comment on column ${iol_schema}.mpcs_a49tefetstran.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a49tefetstran.prtcnt is '打印次数';
comment on column ${iol_schema}.mpcs_a49tefetstran.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a49tefetstran.cpnytp is '企业注册类型代码';
comment on column ${iol_schema}.mpcs_a49tefetstran.dtlrmk is '明细备注';
comment on column ${iol_schema}.mpcs_a49tefetstran.dtllng is '明细长度';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugdltlr is '异常处理柜员';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugdlmk is '异常处理附言';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugdltp is '异常处理方式';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugdlsq is '退款处理流水（记账流水）';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugdldt is '退款处理日期（记账日期）';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugauth is '异常处理授权柜员';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugbrc is '异常处理机构';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugacctno is '退款账号';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugacctna is '退款户名';
comment on column ${iol_schema}.mpcs_a49tefetstran.bugaccttms is '退款异常记账次数';
comment on column ${iol_schema}.mpcs_a49tefetstran.payertel is '缴款人电话';
comment on column ${iol_schema}.mpcs_a49tefetstran.idtftp is '缴款人证件类型';
comment on column ${iol_schema}.mpcs_a49tefetstran.idtfno is '缴款人证件号码';
comment on column ${iol_schema}.mpcs_a49tefetstran.bookcd is '凭证类型';
comment on column ${iol_schema}.mpcs_a49tefetstran.bookno is '凭证号码';
comment on column ${iol_schema}.mpcs_a49tefetstran.bookoutdt is '出票日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.trnchl is '交易渠道';
comment on column ${iol_schema}.mpcs_a49tefetstran.srcsysid is '源渠道码';
comment on column ${iol_schema}.mpcs_a49tefetstran.retmsg is '中心返回信息';
comment on column ${iol_schema}.mpcs_a49tefetstran.chnlsq is '渠道流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.transeqno is '业务流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a49tefetstran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefetstran.etl_timestamp is 'ETL处理时间戳';
