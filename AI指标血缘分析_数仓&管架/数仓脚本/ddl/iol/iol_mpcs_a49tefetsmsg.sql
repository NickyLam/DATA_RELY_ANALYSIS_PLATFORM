/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49tefetsmsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49tefetsmsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49tefetsmsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49tefetsmsg(
    trandt varchar2(12) -- 交易日期
    ,transq varchar2(12) -- 交易流水号
    ,trantm varchar2(9) -- 交易时间
    ,iotype varchar2(2) -- 来往标识
    ,transt varchar2(2) -- 交易状态
    ,sysid varchar2(6) -- 发起方系统号
    ,sndzone varchar2(6) -- 发起地区代码
    ,rcvzone varchar2(6) -- 接收地区代码
    ,msgno varchar2(9) -- 报文编号
    ,msgid varchar2(30) -- 信息序号
    ,origmsgid varchar2(30) -- 原信息序号
    ,txntype varchar2(9) -- 交易类型细分
    ,entrustdate varchar2(12) -- 委托日期
    ,sendbank varchar2(18) -- 发起行行号/机构号
    ,recvbank varchar2(18) -- 接收行行号/机构号
    ,oprchl varchar2(6) -- 业务渠道
    ,recvaccbank varchar2(18) -- 接收账户行
    ,msgtype varchar2(5) -- ets信息类型
    ,origdt varchar2(12) -- 征收机关提交日期
    ,origcd varchar2(18) -- 征收机关代码
    ,origsq varchar2(36) -- 征收机关流水号(申报流水号)
    ,mainbr varchar2(18) -- 经收处银行号
    ,tranid varchar2(24) -- 银行交易识别号
    ,txpycd varchar2(30) -- 纳税人编码
    ,oprtype varchar2(3) -- 交易类型
    ,txbrch varchar2(2) -- 机关类别
    ,torigdt varchar2(18) -- 对照征收机关提交日期
    ,torigsq varchar2(36) -- 对照流水号
    ,fisccd varchar2(18) -- 收款国库代码
    ,prodcd varchar2(8) -- 处理返回码
    ,payeracc varchar2(53) -- 付款账号
    ,amount number(18,2) -- 交易金额
    ,payecd varchar2(2) -- 缴款方式代码
    ,txndate varchar2(12) -- 清算日期
    ,logadt varchar2(12) -- ets资金对数日期
    ,logact varchar2(3) -- ets资金对数场次
    ,tolcnt number(22) -- 交易合计的笔数
    ,tolamt number(18,2) -- 交易合计的金额
    ,retcd varchar2(12) -- 返回码
    ,remark varchar2(450) -- 附言
    ,brchno varchar2(15) -- 营业点
    ,userid varchar2(15) -- 柜员号
    ,ckbkus varchar2(15) -- 授权柜员
    ,ckbkbr varchar2(15) -- 授权网点
    ,linkid number(22) -- 链路id
    ,txpyna varchar2(120) -- 纳税人名称
    ,bustype varchar2(2) -- 业务类型
    ,cpnytp varchar2(6) -- 企业注册类型代码
    ,dtlrmk varchar2(75) -- 明细备注
    ,dtllng varchar2(6) -- 明细长度
    ,idtype varchar2(6) -- 证件类型
    ,idno varchar2(27) -- 证件号码
    ,name varchar2(105) -- 姓名
    ,cnpysbid varchar2(45) -- 单位社保号
    ,bizid varchar2(6) -- 业务种类代码
    ,lmtpaydt varchar2(12) -- 限缴日期
    ,orignm varchar2(105) -- 征收机关名称
    ,oribkid varchar2(24) -- 原业务银行交易识别号
    ,oribkdt varchar2(12) -- 原业务银行提交日期
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
grant select on ${iol_schema}.mpcs_a49tefetsmsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49tefetsmsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsmsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49tefetsmsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49tefetsmsg is '财税业务信息流水登记簿';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.trandt is '交易日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.transq is '交易流水号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.trantm is '交易时间';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.iotype is '来往标识';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.transt is '交易状态';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.sysid is '发起方系统号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.sndzone is '发起地区代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.rcvzone is '接收地区代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.msgno is '报文编号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.msgid is '信息序号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.origmsgid is '原信息序号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.sendbank is '发起行行号/机构号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.recvbank is '接收行行号/机构号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.oprchl is '业务渠道';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.recvaccbank is '接收账户行';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.msgtype is 'ets信息类型';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.origdt is '征收机关提交日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.origcd is '征收机关代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.origsq is '征收机关流水号(申报流水号)';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.mainbr is '经收处银行号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.tranid is '银行交易识别号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.txpycd is '纳税人编码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.oprtype is '交易类型';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.txbrch is '机关类别';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.torigdt is '对照征收机关提交日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.torigsq is '对照流水号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.fisccd is '收款国库代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.prodcd is '处理返回码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.payeracc is '付款账号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.payecd is '缴款方式代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.txndate is '清算日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.logadt is 'ets资金对数日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.logact is 'ets资金对数场次';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.tolcnt is '交易合计的笔数';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.tolamt is '交易合计的金额';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.retcd is '返回码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.remark is '附言';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.brchno is '营业点';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.userid is '柜员号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.ckbkbr is '授权网点';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.txpyna is '纳税人名称';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.cpnytp is '企业注册类型代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.dtlrmk is '明细备注';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.dtllng is '明细长度';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.name is '姓名';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.cnpysbid is '单位社保号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.bizid is '业务种类代码';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.lmtpaydt is '限缴日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.orignm is '征收机关名称';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.oribkid is '原业务银行交易识别号';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.oribkdt is '原业务银行提交日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49tefetsmsg.etl_timestamp is 'ETL处理时间戳';
