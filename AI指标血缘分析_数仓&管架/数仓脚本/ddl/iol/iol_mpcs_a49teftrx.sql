/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teftrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teftrx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teftrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teftrx(
    unotnbr varchar2(15) -- 前置流水号
    ,unotdate varchar2(12) -- 前置日期
    ,unottime varchar2(9) -- 前置时间机器时间
    ,hostnbr varchar2(105) -- 主机流水号为主机记账流水号
    ,hostdate varchar2(12) -- 主机日期
    ,magbrn varchar2(15) -- 管理机构
    ,oprtlr varchar2(15) -- 柜员号
    ,oprbrn varchar2(15) -- 机构号
    ,auttlr varchar2(15) -- 授权柜员
    ,autbrn varchar2(15) -- 授权机构
    ,oprchl varchar2(6) -- 通道号
    ,bthdate varchar2(12) -- 批次日期
    ,bthseq varchar2(12) -- 批次流水号
    ,msgid varchar2(30) -- 支付报单号信息序号
    ,origmsgid varchar2(30) -- 原交易支付单号
    ,txntype varchar2(9) -- 交易类型细分
    ,trantype varchar2(8) -- 业务种类
    ,entrustdate varchar2(12) -- 委托日期
    ,vouchno varchar2(24) -- 凭证提交号
    ,msgno varchar2(9) -- 报文编号
    ,pkgno varchar2(12) -- 包序号
    ,pkgdate varchar2(12) -- 包日期
    ,moneyflag varchar2(2) -- 钞汇标志
    ,currencycd varchar2(5) -- 01或cny--人民币,13港币,14美元
    ,amount number(15,2) -- 交易金额
    ,chargetype varchar2(5) -- 手续费方式
    ,feeamt1 number(15,2) -- 手续费
    ,feeamt2 number(15,2) -- 邮电费
    ,feeamt3 number(15,2) -- 工本费
    ,bookcd varchar2(6) -- 凭证类型
    ,booknbr varchar2(30) -- 凭证号码
    ,sysid varchar2(6) -- 发起方系统号
    ,sndzone varchar2(6) -- 发起方地区码
    ,sendbank varchar2(18) -- 发起行行号/代理行
    ,payerbank varchar2(18) -- 付款行行号
    ,payeraccbank varchar2(18) -- 付款人开户行行号
    ,payeracc varchar2(53) -- 付款人账号
    ,payername varchar2(90) -- 付款人名称
    ,payeraddr varchar2(90) -- 付款人地址
    ,rcvzone varchar2(6) -- 收收方地区码
    ,payeebank varchar2(18) -- 收款行行号
    ,payeeaccbank varchar2(18) -- 收款人开户行行号
    ,payeeacc varchar2(53) -- 收款人账号
    ,payeename varchar2(90) -- 收款人名称
    ,payeeaddr varchar2(90) -- 收款人地址
    ,txnid varchar2(30) -- 中心受理号
    ,txndate varchar2(12) -- 清算日期
    ,txnround varchar2(3) -- 清算场次
    ,origsendbank varchar2(18) -- 原发起行行号
    ,origtxntype varchar2(9) -- 原交易类型细分
    ,origentrustdt varchar2(12) -- 原委托日期
    ,origvouchno varchar2(24) -- 原凭证提交号
    ,orighostnbr varchar2(105) -- 原主机流水号
    ,orighostdate varchar2(12) -- 原主机日期
    ,secondtrack varchar2(111) -- 第二磁道数据
    ,thirdtrack varchar2(312) -- 第三磁道数据
    ,pin varchar2(96) -- 个人识别号（pin）
    ,entrymode varchar2(5) -- 服务点输入方式码
    ,cashflag varchar2(2) -- 现金/转账标识
    ,privateflag varchar2(2) -- 对公/对私标识
    ,authzcd varchar2(9) -- 授权码
    ,outmid varchar2(30) -- 回应行业务处理号
    ,outtime varchar2(21) -- 回应行交易受理时间
    ,cntrno varchar2(90) -- 合同(协议)号
    ,linkid number(22,0) -- 连接号
    ,iotype varchar2(2) -- 来往标识
    ,status varchar2(3) -- 状态
    ,retcd varchar2(30) -- 错误代码
    ,msgtext varchar2(150) -- 错误信息
    ,remark varchar2(450) -- 附言
    ,rcvbrnname varchar2(90) -- 接收行行名
    ,media varchar2(5) -- 卡/折标识
    ,payerbankname varchar2(90) -- 付款行行名
    ,prtnum number(22,0) -- 打印次数
    ,colldate varchar2(12) -- 对账日期
    ,identype varchar2(15) -- 证件类型
    ,idennbr varchar2(90) -- 证件号码
    ,isinout varchar2(2) -- 客户帐内部帐标识
    ,inacct varchar2(90) -- 实际账号
    ,inname varchar2(90) -- 实际户名
    ,transdt varchar2(12) -- 交易日期
    ,paymod varchar2(2) -- 支付方式
    ,calfee number(15,2) -- 次总金额
    ,fronttrcd varchar2(15) -- 中台交易码
    ,rcvbrn varchar2(18) -- 接收行行号
    ,errcode varchar2(30) -- 行内错误代码
    ,remark2 varchar2(450) -- 来帐附言
    ,sendpathfilename varchar2(317) -- 发送文件名
    ,eaccflg varchar2(3) -- 电子账户标志
    ,od_flag varchar2(2) -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam number(18,2) -- 透支金额
    ,opnwin varchar2(12) -- 渠道
    ,nextdayflag varchar2(2) -- 次日达标识 ：0 次日达
    ,autoflag varchar2(2) -- 自动退汇标志 1-自动退汇
    ,autocount varchar2(2) -- 自动退汇次数
    ,automsg varchar2(300) -- 自动退汇信息
    ,bindacct varchar2(53) -- 虚拟账户绑定的账户
    ,bindacctnm varchar2(180) -- 虚拟账户绑定的账户名
    ,accttype varchar2(30) -- 账户类型 edme-存管+账户 qstp-广清所
    ,bindacctopnbrn varchar2(12) -- 虚拟账户绑定的账户开户机构
    ,limitorderid varchar2(48) -- 限额订单号 用于限额撤销使用
    ,globalseqno varchar2(105) -- 全局流水号
    ,transseqno varchar2(105) -- 业务流水号
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
grant select on ${iol_schema}.mpcs_a49teftrx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teftrx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teftrx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teftrx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teftrx is '金融服务平台EFT基本业务交易表';
comment on column ${iol_schema}.mpcs_a49teftrx.unotnbr is '前置流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.unotdate is '前置日期';
comment on column ${iol_schema}.mpcs_a49teftrx.unottime is '前置时间机器时间';
comment on column ${iol_schema}.mpcs_a49teftrx.hostnbr is '主机流水号为主机记账流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a49teftrx.magbrn is '管理机构';
comment on column ${iol_schema}.mpcs_a49teftrx.oprtlr is '柜员号';
comment on column ${iol_schema}.mpcs_a49teftrx.oprbrn is '机构号';
comment on column ${iol_schema}.mpcs_a49teftrx.auttlr is '授权柜员';
comment on column ${iol_schema}.mpcs_a49teftrx.autbrn is '授权机构';
comment on column ${iol_schema}.mpcs_a49teftrx.oprchl is '通道号';
comment on column ${iol_schema}.mpcs_a49teftrx.bthdate is '批次日期';
comment on column ${iol_schema}.mpcs_a49teftrx.bthseq is '批次流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.msgid is '支付报单号信息序号';
comment on column ${iol_schema}.mpcs_a49teftrx.origmsgid is '原交易支付单号';
comment on column ${iol_schema}.mpcs_a49teftrx.txntype is '交易类型细分';
comment on column ${iol_schema}.mpcs_a49teftrx.trantype is '业务种类';
comment on column ${iol_schema}.mpcs_a49teftrx.entrustdate is '委托日期';
comment on column ${iol_schema}.mpcs_a49teftrx.vouchno is '凭证提交号';
comment on column ${iol_schema}.mpcs_a49teftrx.msgno is '报文编号';
comment on column ${iol_schema}.mpcs_a49teftrx.pkgno is '包序号';
comment on column ${iol_schema}.mpcs_a49teftrx.pkgdate is '包日期';
comment on column ${iol_schema}.mpcs_a49teftrx.moneyflag is '钞汇标志';
comment on column ${iol_schema}.mpcs_a49teftrx.currencycd is '01或cny--人民币,13港币,14美元';
comment on column ${iol_schema}.mpcs_a49teftrx.amount is '交易金额';
comment on column ${iol_schema}.mpcs_a49teftrx.chargetype is '手续费方式';
comment on column ${iol_schema}.mpcs_a49teftrx.feeamt1 is '手续费';
comment on column ${iol_schema}.mpcs_a49teftrx.feeamt2 is '邮电费';
comment on column ${iol_schema}.mpcs_a49teftrx.feeamt3 is '工本费';
comment on column ${iol_schema}.mpcs_a49teftrx.bookcd is '凭证类型';
comment on column ${iol_schema}.mpcs_a49teftrx.booknbr is '凭证号码';
comment on column ${iol_schema}.mpcs_a49teftrx.sysid is '发起方系统号';
comment on column ${iol_schema}.mpcs_a49teftrx.sndzone is '发起方地区码';
comment on column ${iol_schema}.mpcs_a49teftrx.sendbank is '发起行行号/代理行';
comment on column ${iol_schema}.mpcs_a49teftrx.payerbank is '付款行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.payeraccbank is '付款人开户行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.payeracc is '付款人账号';
comment on column ${iol_schema}.mpcs_a49teftrx.payername is '付款人名称';
comment on column ${iol_schema}.mpcs_a49teftrx.payeraddr is '付款人地址';
comment on column ${iol_schema}.mpcs_a49teftrx.rcvzone is '收收方地区码';
comment on column ${iol_schema}.mpcs_a49teftrx.payeebank is '收款行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.payeeaccbank is '收款人开户行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.payeeacc is '收款人账号';
comment on column ${iol_schema}.mpcs_a49teftrx.payeename is '收款人名称';
comment on column ${iol_schema}.mpcs_a49teftrx.payeeaddr is '收款人地址';
comment on column ${iol_schema}.mpcs_a49teftrx.txnid is '中心受理号';
comment on column ${iol_schema}.mpcs_a49teftrx.txndate is '清算日期';
comment on column ${iol_schema}.mpcs_a49teftrx.txnround is '清算场次';
comment on column ${iol_schema}.mpcs_a49teftrx.origsendbank is '原发起行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.origtxntype is '原交易类型细分';
comment on column ${iol_schema}.mpcs_a49teftrx.origentrustdt is '原委托日期';
comment on column ${iol_schema}.mpcs_a49teftrx.origvouchno is '原凭证提交号';
comment on column ${iol_schema}.mpcs_a49teftrx.orighostnbr is '原主机流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.orighostdate is '原主机日期';
comment on column ${iol_schema}.mpcs_a49teftrx.secondtrack is '第二磁道数据';
comment on column ${iol_schema}.mpcs_a49teftrx.thirdtrack is '第三磁道数据';
comment on column ${iol_schema}.mpcs_a49teftrx.pin is '个人识别号（pin）';
comment on column ${iol_schema}.mpcs_a49teftrx.entrymode is '服务点输入方式码';
comment on column ${iol_schema}.mpcs_a49teftrx.cashflag is '现金/转账标识';
comment on column ${iol_schema}.mpcs_a49teftrx.privateflag is '对公/对私标识';
comment on column ${iol_schema}.mpcs_a49teftrx.authzcd is '授权码';
comment on column ${iol_schema}.mpcs_a49teftrx.outmid is '回应行业务处理号';
comment on column ${iol_schema}.mpcs_a49teftrx.outtime is '回应行交易受理时间';
comment on column ${iol_schema}.mpcs_a49teftrx.cntrno is '合同(协议)号';
comment on column ${iol_schema}.mpcs_a49teftrx.linkid is '连接号';
comment on column ${iol_schema}.mpcs_a49teftrx.iotype is '来往标识';
comment on column ${iol_schema}.mpcs_a49teftrx.status is '状态';
comment on column ${iol_schema}.mpcs_a49teftrx.retcd is '错误代码';
comment on column ${iol_schema}.mpcs_a49teftrx.msgtext is '错误信息';
comment on column ${iol_schema}.mpcs_a49teftrx.remark is '附言';
comment on column ${iol_schema}.mpcs_a49teftrx.rcvbrnname is '接收行行名';
comment on column ${iol_schema}.mpcs_a49teftrx.media is '卡/折标识';
comment on column ${iol_schema}.mpcs_a49teftrx.payerbankname is '付款行行名';
comment on column ${iol_schema}.mpcs_a49teftrx.prtnum is '打印次数';
comment on column ${iol_schema}.mpcs_a49teftrx.colldate is '对账日期';
comment on column ${iol_schema}.mpcs_a49teftrx.identype is '证件类型';
comment on column ${iol_schema}.mpcs_a49teftrx.idennbr is '证件号码';
comment on column ${iol_schema}.mpcs_a49teftrx.isinout is '客户帐内部帐标识';
comment on column ${iol_schema}.mpcs_a49teftrx.inacct is '实际账号';
comment on column ${iol_schema}.mpcs_a49teftrx.inname is '实际户名';
comment on column ${iol_schema}.mpcs_a49teftrx.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a49teftrx.paymod is '支付方式';
comment on column ${iol_schema}.mpcs_a49teftrx.calfee is '次总金额';
comment on column ${iol_schema}.mpcs_a49teftrx.fronttrcd is '中台交易码';
comment on column ${iol_schema}.mpcs_a49teftrx.rcvbrn is '接收行行号';
comment on column ${iol_schema}.mpcs_a49teftrx.errcode is '行内错误代码';
comment on column ${iol_schema}.mpcs_a49teftrx.remark2 is '来帐附言';
comment on column ${iol_schema}.mpcs_a49teftrx.sendpathfilename is '发送文件名';
comment on column ${iol_schema}.mpcs_a49teftrx.eaccflg is '电子账户标志';
comment on column ${iol_schema}.mpcs_a49teftrx.od_flag is '是否发生透支 0- 否 1- 是';
comment on column ${iol_schema}.mpcs_a49teftrx.od_ovtranam is '透支金额';
comment on column ${iol_schema}.mpcs_a49teftrx.opnwin is '渠道';
comment on column ${iol_schema}.mpcs_a49teftrx.nextdayflag is '次日达标识 ：0 次日达';
comment on column ${iol_schema}.mpcs_a49teftrx.autoflag is '自动退汇标志 1-自动退汇';
comment on column ${iol_schema}.mpcs_a49teftrx.autocount is '自动退汇次数';
comment on column ${iol_schema}.mpcs_a49teftrx.automsg is '自动退汇信息';
comment on column ${iol_schema}.mpcs_a49teftrx.bindacct is '虚拟账户绑定的账户';
comment on column ${iol_schema}.mpcs_a49teftrx.bindacctnm is '虚拟账户绑定的账户名';
comment on column ${iol_schema}.mpcs_a49teftrx.accttype is '账户类型 edme-存管+账户 qstp-广清所';
comment on column ${iol_schema}.mpcs_a49teftrx.bindacctopnbrn is '虚拟账户绑定的账户开户机构';
comment on column ${iol_schema}.mpcs_a49teftrx.limitorderid is '限额订单号 用于限额撤销使用';
comment on column ${iol_schema}.mpcs_a49teftrx.globalseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.transseqno is '业务流水号';
comment on column ${iol_schema}.mpcs_a49teftrx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a49teftrx.etl_timestamp is 'ETL处理时间戳';
