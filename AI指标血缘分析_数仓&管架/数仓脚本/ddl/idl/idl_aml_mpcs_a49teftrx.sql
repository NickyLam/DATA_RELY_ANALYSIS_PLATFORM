/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a49teftrx
CreateDate: 20221228
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a49teftrx purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a49teftrx(
etl_dt date --数据日期
,unotnbr varchar2(10) --前置流水号
,unotdate varchar2(8) --前置日期
,unottime varchar2(6) --前置时间机器时间
,hostnbr varchar2(70) --
,hostdate varchar2(8) --主机日期
,magbrn varchar2(10) --管理机构
,oprtlr varchar2(10) --柜员号
,oprbrn varchar2(10) --机构号
,auttlr varchar2(10) --授权柜员
,autbrn varchar2(10) --授权机构
,oprchl varchar2(4) --通道号
,bthdate varchar2(8) --批次日期
,bthseq varchar2(8) --批次流水号
,msgid varchar2(20) --支付报单号信息序号
,origmsgid varchar2(20) --原交易支付单号
,txntype varchar2(6) --交易类型细分
,trantype varchar2(5) --业务种类
,entrustdate varchar2(8) --委托日期
,vouchno varchar2(16) --凭证提交号
,msgno varchar2(6) --报文编号
,pkgno varchar2(8) --包序号
,pkgdate varchar2(8) --包日期
,moneyflag varchar2(1) --钞汇标志
,currencycd varchar2(3) --01或CNY--人民币,13港币,14美元
,amount number(15,2) --交易金额
,chargetype varchar2(3) --手续费方式
,feeamt1 number(15,2) --手续费
,feeamt2 number(15,2) --邮电费
,feeamt3 number(15,2) --工本费
,bookcd varchar2(4) --凭证类型
,booknbr varchar2(20) --凭证号码
,sysid varchar2(4) --发起方系统号
,sndzone varchar2(4) --发起方地区码
,sendbank varchar2(12) --发起行行号/代理行
,payerbank varchar2(12) --付款行行号
,payeraccbank varchar2(12) --付款人开户行行号
,payeracc varchar2(35) --付款人账号
,payername varchar2(60) --付款人名称
,payeraddr varchar2(60) --付款人地址
,rcvzone varchar2(4) --收收方地区码
,payeebank varchar2(12) --收款行行号
,payeeaccbank varchar2(12) --收款人开户行行号
,payeeacc varchar2(35) --收款人账号
,payeename varchar2(60) --收款人名称
,payeeaddr varchar2(60) --收款人地址
,txnid varchar2(20) --中心受理号
,txndate varchar2(8) --清算日期
,txnround varchar2(2) --清算场次
,origsendbank varchar2(12) --原发起行行号
,origtxntype varchar2(6) --原交易类型细分
,origentrustdt varchar2(8) --原委托日期
,origvouchno varchar2(16) --原凭证提交号
,orighostnbr varchar2(70) --
,orighostdate varchar2(8) --原主机日期
,secondtrack varchar2(74) --第二磁道数据
,thirdtrack varchar2(208) --第三磁道数据
,pin varchar2(64) --个人识别号（PIN）
,entrymode varchar2(3) --服务点输入方式码
,cashflag varchar2(1) --现金/转账标识
,privateflag varchar2(1) --对公/对私标识
,authzcd varchar2(6) --授权码
,outmid varchar2(20) --回应行业务处理号
,outtime varchar2(14) --回应行交易受理时间
,cntrno varchar2(60) --合同(协议)号
,linkid number(22) --连接号
,iotype varchar2(1) --来往标识
,status varchar2(2) --状态
,retcd varchar2(20) --
,msgtext varchar2(100) --错误信息
,remark varchar2(300) --附言
,rcvbrnname varchar2(60) --接收行行名
,media varchar2(3) --卡/折标识
,payerbankname varchar2(60) --付款行行名
,prtnum number(22) --打印次数
,colldate varchar2(8) --对账日期
,identype varchar2(10) --证件类型
,idennbr varchar2(60) --证件号码
,isinout varchar2(1) --客户帐内部帐标识 
,inacct varchar2(60) --实际账号
,inname varchar2(60) --实际户名
,transdt varchar2(8) --交易日期
,paymod varchar2(1) --支付方式
,calfee number(15,2) --次总金额
,fronttrcd varchar2(10) --中台交易码
,rcvbrn varchar2(12) --接收行行号
,errcode varchar2(20) --
,remark2 varchar2(300) --来帐附言
,sendpathfilename varchar2(211) --发送文件名
,eaccflg varchar2(2) --电子账户标志
,od_flag varchar2(1) --是否发生透支 0- 否 1- 是
,od_ovtranam number(18,2) --透支金额
,opnwin varchar2(8) --渠道
,nextdayflag varchar2(1) --次日达标识 ：0 次日达
,autoflag varchar2(1) --自动退汇标志 1-自动退汇
,autocount varchar2(1) --自动退汇次数
,automsg varchar2(200) --自动退汇信息
,bindacct varchar2(35) --虚拟账户绑定的账户
,bindacctnm varchar2(120) --虚拟账户绑定的账户名
,accttype varchar2(20) --账户类型 EDME-存管+账户 QSTP-广清所
,bindacctopnbrn varchar2(8) --虚拟账户绑定的账户开户机构
,limitorderid varchar2(32) --限额订单号 用于限额撤销使用
,globalseqno varchar2(70) --
,etl_timestamp timestamp(6) -- 任务处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a49teftrx to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a49teftrx is '金融服务平台eft基本业务交易表';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.unotnbr is '前置流水号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.unotdate is '前置日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.unottime is '前置时间机器时间';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.hostnbr is '';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.hostdate is '主机日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.magbrn is '管理机构';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.oprtlr is '柜员号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.oprbrn is '机构号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.auttlr is '授权柜员';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.autbrn is '授权机构';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.oprchl is '通道号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bthdate is '批次日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bthseq is '批次流水号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.msgid is '支付报单号信息序号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.origmsgid is '原交易支付单号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.txntype is '交易类型细分';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.trantype is '业务种类';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.entrustdate is '委托日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.vouchno is '凭证提交号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.msgno is '报文编号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.pkgno is '包序号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.pkgdate is '包日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.moneyflag is '钞汇标志';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.currencycd is '01或CNY--人民币,13港币,14美元';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.amount is '交易金额';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.chargetype is '手续费方式';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.feeamt1 is '手续费';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.feeamt2 is '邮电费';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.feeamt3 is '工本费';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bookcd is '凭证类型';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.booknbr is '凭证号码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.sysid is '发起方系统号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.sndzone is '发起方地区码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.sendbank is '发起行行号/代理行';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payerbank is '付款行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeraccbank is '付款人开户行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeracc is '付款人账号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payername is '付款人名称';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeraddr is '付款人地址';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.rcvzone is '收收方地区码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeebank is '收款行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeeaccbank is '收款人开户行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeeacc is '收款人账号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeename is '收款人名称';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payeeaddr is '收款人地址';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.txnid is '中心受理号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.txndate is '清算日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.txnround is '清算场次';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.origsendbank is '原发起行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.origtxntype is '原交易类型细分';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.origentrustdt is '原委托日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.origvouchno is '原凭证提交号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.orighostnbr is '';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.orighostdate is '原主机日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.secondtrack is '第二磁道数据';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.thirdtrack is '第三磁道数据';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.pin is '个人识别号（PIN）';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.entrymode is '服务点输入方式码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.cashflag is '现金/转账标识';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.privateflag is '对公/对私标识';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.authzcd is '授权码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.outmid is '回应行业务处理号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.outtime is '回应行交易受理时间';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.cntrno is '合同(协议)号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.linkid is '连接号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.iotype is '来往标识';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.status is '状态';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.retcd is '';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.msgtext is '错误信息';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.remark is '附言';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.rcvbrnname is '接收行行名';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.media is '卡/折标识';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.payerbankname is '付款行行名';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.prtnum is '打印次数';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.colldate is '对账日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.identype is '证件类型';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.idennbr is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.isinout is '客户帐内部帐标识 ';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.inacct is '实际账号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.inname is '实际户名';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.paymod is '支付方式';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.calfee is '次总金额';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.fronttrcd is '中台交易码';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.rcvbrn is '接收行行号';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.errcode is '';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.remark2 is '来帐附言';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.sendpathfilename is '发送文件名';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.eaccflg is '电子账户标志';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.od_flag is '是否发生透支 0- 否 1- 是';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.od_ovtranam is '透支金额';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.opnwin is '渠道';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.nextdayflag is '次日达标识 ：0 次日达';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.autoflag is '自动退汇标志 1-自动退汇';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.autocount is '自动退汇次数';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.automsg is '自动退汇信息';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bindacct is '虚拟账户绑定的账户';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bindacctnm is '虚拟账户绑定的账户名';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.accttype is '账户类型 EDME-存管+账户 QSTP-广清所';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.bindacctopnbrn is '虚拟账户绑定的账户开户机构';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.limitorderid is '限额订单号 用于限额撤销使用';
comment on column ${idl_schema}.aml_mpcs_a49teftrx.globalseqno is '';

