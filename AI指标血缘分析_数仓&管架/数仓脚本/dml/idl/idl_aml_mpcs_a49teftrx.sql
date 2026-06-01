/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a49teftrx
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_mpcs_a49teftrx drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a49teftrx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a49teftrx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a49teftrx partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,unotnbr  -- 前置流水号
    ,unotdate  -- 前置日期
    ,unottime  -- 前置时间机器时间
    ,hostnbr  -- 主机流水号为主机记账流水号
    ,hostdate  -- 主机日期
    ,magbrn  -- 管理机构
    ,oprtlr  -- 柜员号
    ,oprbrn  -- 机构号
    ,auttlr  -- 授权柜员
    ,autbrn  -- 授权机构
    ,oprchl  -- 通道号
    ,bthdate  -- 批次日期
    ,bthseq  -- 批次流水号
    ,msgid  -- 支付报单号信息序号
    ,origmsgid  -- 原交易支付单号
    ,txntype  -- 交易类型细分
    ,trantype  -- 业务种类
    ,entrustdate  -- 委托日期
    ,vouchno  -- 凭证提交号
    ,msgno  -- 报文编号
    ,pkgno  -- 包序号
    ,pkgdate  -- 包日期
    ,moneyflag  -- 钞汇标志
    ,currencycd  -- 01或CNY--人民币,13港币,14美元
    ,amount  -- 交易金额
    ,chargetype  -- 手续费方式
    ,feeamt1  -- 手续费
    ,feeamt2  -- 邮电费
    ,feeamt3  -- 工本费
    ,bookcd  -- 凭证类型
    ,booknbr  -- 凭证号码
    ,sysid  -- 发起方系统号
    ,sndzone  -- 发起方地区码
    ,sendbank  -- 发起行行号/代理行
    ,payerbank  -- 付款行行号
    ,payeraccbank  -- 付款人开户行行号
    ,payeracc  -- 付款人账号
    ,payername  -- 付款人名称
    ,payeraddr  -- 付款人地址
    ,rcvzone  -- 收收方地区码
    ,payeebank  -- 收款行行号
    ,payeeaccbank  -- 收款人开户行行号
    ,payeeacc  -- 收款人账号
    ,payeename  -- 收款人名称
    ,payeeaddr  -- 收款人地址
    ,txnid  -- 中心受理号
    ,txndate  -- 清算日期
    ,txnround  -- 清算场次
    ,origsendbank  -- 原发起行行号
    ,origtxntype  -- 原交易类型细分
    ,origentrustdt  -- 原委托日期
    ,origvouchno  -- 原凭证提交号
    ,orighostnbr  -- 原主机流水号
    ,orighostdate  -- 原主机日期
    ,secondtrack  -- 第二磁道数据
    ,thirdtrack  -- 第三磁道数据
    ,pin  -- 个人识别号（PIN）
    ,entrymode  -- 服务点输入方式码
    ,cashflag  -- 现金/转账标识
    ,privateflag  -- 对公/对私标识
    ,authzcd  -- 授权码
    ,outmid  -- 回应行业务处理号
    ,outtime  -- 回应行交易受理时间
    ,cntrno  -- 合同(协议)号
    ,linkid  -- 连接号
    ,iotype  -- 来往标识
    ,status  -- 状态
    ,retcd  -- 错误代码
    ,msgtext  -- 错误信息
    ,remark  -- 附言
    ,rcvbrnname  -- 接收行行名
    ,media  -- 卡/折标识
    ,payerbankname  -- 付款行行名
    ,prtnum  -- 打印次数
    ,colldate  -- 对账日期
    ,identype  -- 证件类型
    ,idennbr  -- 证件号码
    ,isinout  -- 客户帐内部帐标识
    ,inacct  -- 实际账号
    ,inname  -- 实际户名
    ,transdt  -- 交易日期
    ,paymod  -- 支付方式
    ,calfee  -- 次总金额
    ,fronttrcd  -- 中台交易码
    ,rcvbrn  -- 接收行行号
    ,errcode  -- 行内错误代码
    ,remark2  -- 来帐附言
    ,sendpathfilename  -- 发送文件名
    ,eaccflg  -- 电子账户标志
    ,od_flag  -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam  -- 透支金额
    ,opnwin  -- 渠道
    ,nextdayflag  -- 次日达标识 ：0 次日达
    ,autoflag  -- 自动退汇标志 1-自动退汇
    ,autocount  -- 自动退汇次数
    ,automsg  -- 自动退汇信息
    ,bindacct  -- 虚拟账户绑定的账户
    ,bindacctnm  -- 虚拟账户绑定的账户名
    ,accttype  -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn  -- 虚拟账户绑定的账户开户机构
    ,limitorderid  -- 限额订单号 用于限额撤销使用
    ,globalseqno  -- 全局流水号
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.unotnbr,chr(13),''),chr(10),'')  -- 前置流水号
    ,replace(replace(t1.unotdate,chr(13),''),chr(10),'')  -- 前置日期
    ,replace(replace(t1.unottime,chr(13),''),chr(10),'')  -- 前置时间机器时间
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'')  -- 主机流水号为主机记账流水号
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'')  -- 主机日期
    ,replace(replace(t1.magbrn,chr(13),''),chr(10),'')  -- 管理机构
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'')  -- 柜员号
    ,replace(replace(t1.oprbrn,chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(t1.auttlr,chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(t1.autbrn,chr(13),''),chr(10),'')  -- 授权机构
    ,replace(replace(t1.oprchl,chr(13),''),chr(10),'')  -- 通道号
    ,replace(replace(t1.bthdate,chr(13),''),chr(10),'')  -- 批次日期
    ,replace(replace(t1.bthseq,chr(13),''),chr(10),'')  -- 批次流水号
    ,replace(replace(t1.msgid,chr(13),''),chr(10),'')  -- 支付报单号信息序号
    ,replace(replace(t1.origmsgid,chr(13),''),chr(10),'')  -- 原交易支付单号
    ,replace(replace(t1.txntype,chr(13),''),chr(10),'')  -- 交易类型细分
    ,replace(replace(t1.trantype,chr(13),''),chr(10),'')  -- 业务种类
    ,replace(replace(t1.entrustdate,chr(13),''),chr(10),'')  -- 委托日期
    ,replace(replace(t1.vouchno,chr(13),''),chr(10),'')  -- 凭证提交号
    ,replace(replace(t1.msgno,chr(13),''),chr(10),'')  -- 报文编号
    ,replace(replace(t1.pkgno,chr(13),''),chr(10),'')  -- 包序号
    ,replace(replace(t1.pkgdate,chr(13),''),chr(10),'')  -- 包日期
    ,replace(replace(t1.moneyflag,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.currencycd,chr(13),''),chr(10),'')  -- 01或CNY--人民币,13港币,14美元
    ,t1.amount  -- 交易金额
    ,replace(replace(t1.chargetype,chr(13),''),chr(10),'')  -- 手续费方式
    ,t1.feeamt1  -- 手续费
    ,t1.feeamt2  -- 邮电费
    ,t1.feeamt3  -- 工本费
    ,replace(replace(t1.bookcd,chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(t1.booknbr,chr(13),''),chr(10),'')  -- 凭证号码
    ,replace(replace(t1.sysid,chr(13),''),chr(10),'')  -- 发起方系统号
    ,replace(replace(t1.sndzone,chr(13),''),chr(10),'')  -- 发起方地区码
    ,replace(replace(t1.sendbank,chr(13),''),chr(10),'')  -- 发起行行号/代理行
    ,replace(replace(t1.payerbank,chr(13),''),chr(10),'')  -- 付款行行号
    ,replace(replace(t1.payeraccbank,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(t1.payeracc,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payername,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payeraddr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(t1.rcvzone,chr(13),''),chr(10),'')  -- 收收方地区码
    ,replace(replace(t1.payeebank,chr(13),''),chr(10),'')  -- 收款行行号
    ,replace(replace(t1.payeeaccbank,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.payeeacc,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.payeename,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.payeeaddr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(t1.txnid,chr(13),''),chr(10),'')  -- 中心受理号
    ,replace(replace(t1.txndate,chr(13),''),chr(10),'')  -- 清算日期
    ,replace(replace(t1.txnround,chr(13),''),chr(10),'')  -- 清算场次
    ,replace(replace(t1.origsendbank,chr(13),''),chr(10),'')  -- 原发起行行号
    ,replace(replace(t1.origtxntype,chr(13),''),chr(10),'')  -- 原交易类型细分
    ,replace(replace(t1.origentrustdt,chr(13),''),chr(10),'')  -- 原委托日期
    ,replace(replace(t1.origvouchno,chr(13),''),chr(10),'')  -- 原凭证提交号
    ,replace(replace(t1.orighostnbr,chr(13),''),chr(10),'')  -- 原主机流水号
    ,replace(replace(t1.orighostdate,chr(13),''),chr(10),'')  -- 原主机日期
    ,replace(replace(t1.secondtrack,chr(13),''),chr(10),'')  -- 第二磁道数据
    ,replace(replace(t1.thirdtrack,chr(13),''),chr(10),'')  -- 第三磁道数据
    ,replace(replace(t1.pin,chr(13),''),chr(10),'')  -- 个人识别号（PIN）
    ,replace(replace(t1.entrymode,chr(13),''),chr(10),'')  -- 服务点输入方式码
    ,replace(replace(t1.cashflag,chr(13),''),chr(10),'')  -- 现金/转账标识
    ,replace(replace(t1.privateflag,chr(13),''),chr(10),'')  -- 对公/对私标识
    ,replace(replace(t1.authzcd,chr(13),''),chr(10),'')  -- 授权码
    ,replace(replace(t1.outmid,chr(13),''),chr(10),'')  -- 回应行业务处理号
    ,replace(replace(t1.outtime,chr(13),''),chr(10),'')  -- 回应行交易受理时间
    ,replace(replace(t1.cntrno,chr(13),''),chr(10),'')  -- 合同(协议)号
    ,t1.linkid  -- 连接号
    ,replace(replace(t1.iotype,chr(13),''),chr(10),'')  -- 来往标识
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 状态
    ,replace(replace(t1.retcd,chr(13),''),chr(10),'')  -- 错误代码
    ,replace(replace(t1.msgtext,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 附言
    ,replace(replace(t1.rcvbrnname,chr(13),''),chr(10),'')  -- 接收行行名
    ,replace(replace(t1.media,chr(13),''),chr(10),'')  -- 卡/折标识
    ,replace(replace(t1.payerbankname,chr(13),''),chr(10),'')  -- 付款行行名
    ,t1.prtnum  -- 打印次数
    ,replace(replace(t1.colldate,chr(13),''),chr(10),'')  -- 对账日期
    ,replace(replace(t1.identype,chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(t1.idennbr,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.isinout,chr(13),''),chr(10),'')  -- 客户帐内部帐标识 
    ,replace(replace(t1.inacct,chr(13),''),chr(10),'')  -- 实际账号
    ,replace(replace(t1.inname,chr(13),''),chr(10),'')  -- 实际户名
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.paymod,chr(13),''),chr(10),'')  -- 支付方式
    ,t1.calfee  -- 次总金额
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'')  -- 接收行行号
    ,replace(replace(t1.errcode,chr(13),''),chr(10),'')  -- 行内错误代码
    ,replace(replace(t1.remark2,chr(13),''),chr(10),'')  -- 来帐附言
    ,replace(replace(t1.sendpathfilename,chr(13),''),chr(10),'')  -- 发送文件名
    ,replace(replace(t1.eaccflg,chr(13),''),chr(10),'')  -- 电子账户标志
    ,replace(replace(t1.od_flag,chr(13),''),chr(10),'')  -- 是否发生透支 0- 否 1- 是
    ,t1.od_ovtranam  -- 透支金额
    ,replace(replace(t1.opnwin,chr(13),''),chr(10),'')  -- 渠道
    ,replace(replace(t1.nextdayflag,chr(13),''),chr(10),'')  -- 次日达标识 ：0 次日达
    ,replace(replace(t1.autoflag,chr(13),''),chr(10),'')  -- 自动退汇标志 1-自动退汇
    ,replace(replace(t1.autocount,chr(13),''),chr(10),'')  -- 自动退汇次数
    ,replace(replace(t1.automsg,chr(13),''),chr(10),'')  -- 自动退汇信息
    ,replace(replace(t1.bindacct,chr(13),''),chr(10),'')  -- 虚拟账户绑定的账户
    ,replace(replace(t1.bindacctnm,chr(13),''),chr(10),'')  -- 虚拟账户绑定的账户名
    ,replace(replace(t1.accttype,chr(13),''),chr(10),'')  -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,replace(replace(t1.bindacctopnbrn,chr(13),''),chr(10),'')  -- 虚拟账户绑定的账户开户机构
    ,replace(replace(t1.limitorderid,chr(13),''),chr(10),'')  -- 限额订单号 用于限额撤销使用
    ,replace(replace(t1.globalseqno,chr(13),''),chr(10),'')  -- 全局流水号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a49teftrx t1    --金融服务平台eft基本业务交易表
where t1.unotdate>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and t1.unotdate<='${batch_date}' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a49teftrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);