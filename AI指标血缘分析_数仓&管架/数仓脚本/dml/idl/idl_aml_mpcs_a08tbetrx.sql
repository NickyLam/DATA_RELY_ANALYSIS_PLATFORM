/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a08tbetrx
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
alter table ${idl_schema}.aml_mpcs_a08tbetrx drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a08tbetrx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a08tbetrx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a08tbetrx partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainsq  -- 支付报单号(中台流水号)
    ,transdt  -- 交易日期
    ,opersq  -- 支付交易序号（行外），明细标识号
    ,businesstrace  -- 行内业务序号
    ,bustype  -- 业务类型
    ,servtype  -- 业务种类
    ,dtlcmtno  -- 业务要素集
    ,transseq  -- 包序号
    ,pkcodt  -- 包委托日期
    ,pktype  -- 包类型
    ,hosttrcd  -- 主机交易码
    ,fronttrcd  -- 中台交易码
    ,consigndt  -- 委托日期
    ,hostdate  -- 主机日期
    ,hostnbr  -- 主机流水
    ,crcycd  -- 币种
    ,transamt  -- 交易金额
    ,paybrn  -- 付款人开户行部门号
    ,payopenbrn  -- 付款人开户行行
    ,payacct  -- 付款人账号
    ,payname  -- 付款人名称
    ,payaddr  -- 付款人地址
    ,incobrn  -- 收款人开户行行号
    ,incoacct  -- 收款人账号
    ,inconame  -- 收款人名称
    ,incoaddr  -- 收款人地址
    ,sndct  -- 发报中心
    ,sndupbrn  -- 发起清算行行号
    ,sndbrn  -- 发起行行号
    ,rcvct  -- 收报中心
    ,rcvupbrn  -- 接收清算行行号
    ,rcvbrn  -- 接收行行号
    ,billdt  -- 原(包)委托日期
    ,billcd  -- 原支付交易序号
    ,orabustype  -- 原业务类型编码
    ,ptrasq  -- 票据号码
    ,obaltp  -- 轧差节点类型
    ,obalod  -- 轧差场次
    ,obaldt  -- 轧差日期/终态日期
    ,caclrs  -- 退汇原因代码
    ,cmpsam  -- 赔偿金金额、拆借利息、出票金额
    ,inrate  -- 利率
    ,refuam  -- 拒付金额
    ,transt  -- 处理状态
    ,processcode  -- 人行业务状态
    ,advest  -- 回执码
    ,vrseal  -- 处理代码(一般为人行返回码)
    ,ckrvno  -- 复核冲正流水号
    ,rndday  -- 回执期限
    ,retudt  -- 回执日期
    ,sdrvno  -- 发送冲正流水号
    ,clerdt  -- 清算日期
    ,bperno  -- 错误代码
    ,bpermg  -- 错误信息
    ,levels  -- 优先级别
    ,oprtlr  -- 录入柜员
    ,chktlr  -- 复核柜员
    ,sndtlr  -- 发送柜员
    ,auttlr  -- 授权柜员
    ,stptlr  -- 滞留柜员
    ,oprbrn  -- 录入复核柜员部门号
    ,sendbranch  -- 发送柜员部门号
    ,autbrn  -- 授权柜员部门号
    ,recdes  -- 支付密押
    ,chksta  -- 对账状态
    ,remark  -- 附言
    ,protocolnb  -- 提示付款日期、协议号
    ,prtcnt  -- 打印次数
    ,recvdt  -- 收到时间
    ,transmitdt  -- 发送时间、转发时间
    ,blsecd  -- 
    ,paydat  -- 提示付款日期
    ,iotype  -- 往来帐标志
    ,flag2  -- 实时联机标记
    ,flag3  -- 收费标志
    ,flag4  -- 借贷标记
    ,inoutflag  -- 行内行外标志
    ,blrqno  -- 汇票申请书号码
    ,sacact  -- 挂帐帐号或维护入账帐号
    ,sacana  -- 挂帐帐号或维护入账姓名
    ,clendt  -- 维护入账日期
    ,clenus  -- 维护入账柜员
    ,clrbrn  -- 维护入账部门号
    ,clract  -- 清分入帐帐号
    ,clrseq  -- 清分流水
    ,prdnbr  -- 代理标识 0 本行业务 1 代理他行
    ,tranbr  -- 日志流水号
    ,sdtrno  -- 发送日志流水
    ,bkcode  -- 凭证类型
    ,cobkdt  -- 委托凭证日期
    ,cobkcd  -- 委托凭证号
    ,idtype  -- 证件种类
    ,idno  -- 证件号码
    ,mxtram  -- 转帐限额
    ,transq  -- 交易流水套号
    ,sdtrsq  -- 发送交易流水
    ,paymod  -- 支付方式
    ,opnwin  -- 汇兑业务对应的窗口(交易渠道)
    ,chngdt  -- 最近修改日期
    ,bepssq  -- 业务流水号
    ,linkid  -- ID号
    ,feamt1  -- 手续费
    ,feamt2  -- 汇划费
    ,feamt3  -- 工本费
    ,feamt4  -- 费用（备用）
    ,priamt  -- 原托金额
    ,payamt  -- 支付金额
    ,spiamt  -- 多付金额
    ,edhtno  -- 取消交易流水
    ,edhtdt  -- 取消交易日期
    ,endtlr  -- 取消柜员
    ,chngti  -- 最近修改时间
    ,magbrn  -- 处理机构
    ,resv40  -- 特殊码
    ,rcdver  -- 记录更新版本号
    ,rcdsta  -- 记录状态
    ,prpktp  -- 原包类型
    ,prclbk  -- 原包发起清算行
    ,prpkdt  -- 原包委托日期
    ,prpksq  -- 原包序号
    ,prodcd  -- 产品代码
    ,isinout  -- 客户帐、内部帐标识
    ,inacct  -- 实际扣帐账号
    ,inname  -- 实际扣帐户名
    ,ourcnapsver  -- 行内系统版本
    ,othercnapsver  -- 对手系统版本
    ,landdealsts  -- 落地处理状态
    ,checkdealsts  -- 查证处理状态
    ,appenddatatable  -- 登记附加数据的表名
    ,appenddatadtltab  -- 登记附加数据明细的表名
    ,hangupreason  -- 挂账原因
    ,pkgbusinesstrace  -- 包行内序号
    ,pktype2  -- 二代报文号
    ,bustype2  -- 二代业务类型
    ,servtype2  -- 二代业务种类
    ,payopenbanknm  -- 付款人开户行名称
    ,recvopenbanknm  -- 收款人开户行名称
    ,modifytlr  -- 修改柜员
    ,feetype  -- 收费方式
    ,eaccflg  -- 电子账户标志
    ,od_flag  -- 是否触发透支业务
    ,od_ovtranam  -- 透支金额
    ,nextdayflag  -- 次日转账标识
    ,autoflag  -- 自动退汇处理标识
    ,autocount  -- 自动退汇处理次数
    ,automsg  -- 自动退汇处理信息
    ,bindacct  -- 绑定账户
    ,bindacctnm  -- 绑定账户名
    ,accttype  -- 账户类型
    ,bindacctopnbrn  -- 绑定账户开户机构
    ,lsttranst  -- 上一交易状态
    ,tacctp  -- 账户分类标识
    ,limitorderid  -- 限额订单号
    ,isbindcard  -- 绑定标志
    ,globalseqno  -- 全局流水号
    ,returncode  -- ESB接口返回码
    ,returnmsg  -- ESB接口返回信息
    ,transseqno  -- ESB接口交易流水号
    ,sendouttm  -- 发送人行时间
    ,unique_seq_num  -- 业务流水号(交易订单号)
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainsq,chr(13),''),chr(10),'')  -- 支付报单号(中台流水号)
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.opersq,chr(13),''),chr(10),'')  -- 支付交易序号（行外），明细标识号
    ,replace(replace(t1.businesstrace,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(t1.bustype,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.servtype,chr(13),''),chr(10),'')  -- 业务种类
    ,replace(replace(t1.dtlcmtno,chr(13),''),chr(10),'')  -- 业务要素集
    ,replace(replace(t1.transseq,chr(13),''),chr(10),'')  -- 包序号
    ,replace(replace(t1.pkcodt,chr(13),''),chr(10),'')  -- 包委托日期
    ,replace(replace(t1.pktype,chr(13),''),chr(10),'')  -- 包类型
    ,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'')  -- 主机交易码
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.consigndt,chr(13),''),chr(10),'')  -- 委托日期
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'')  -- 主机日期
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'')  -- 主机流水
    ,replace(replace(t1.crcycd,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.transamt,chr(13),''),chr(10),'')  -- 交易金额
    ,replace(replace(t1.paybrn,chr(13),''),chr(10),'')  -- 付款人开户行部门号
    ,replace(replace(t1.payopenbrn,chr(13),''),chr(10),'')  -- 付款人开户行行
    ,replace(replace(t1.payacct,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payname,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payaddr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(t1.incobrn,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.incoacct,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.inconame,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.incoaddr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(t1.sndct,chr(13),''),chr(10),'')  -- 发报中心
    ,replace(replace(t1.sndupbrn,chr(13),''),chr(10),'')  -- 发起清算行行号
    ,replace(replace(t1.sndbrn,chr(13),''),chr(10),'')  -- 发起行行号
    ,replace(replace(t1.rcvct,chr(13),''),chr(10),'')  -- 收报中心
    ,replace(replace(t1.rcvupbrn,chr(13),''),chr(10),'')  -- 接收清算行行号
    ,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'')  -- 接收行行号
    ,replace(replace(t1.billdt,chr(13),''),chr(10),'')  -- 原(包)委托日期
    ,replace(replace(t1.billcd,chr(13),''),chr(10),'')  -- 原支付交易序号
    ,replace(replace(t1.orabustype,chr(13),''),chr(10),'')  -- 原业务类型编码
    ,replace(replace(t1.ptrasq,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.obaltp,chr(13),''),chr(10),'')  -- 轧差节点类型
    ,replace(replace(t1.obalod,chr(13),''),chr(10),'')  -- 轧差场次
    ,replace(replace(t1.obaldt,chr(13),''),chr(10),'')  -- 轧差日期/终态日期
    ,replace(replace(t1.caclrs,chr(13),''),chr(10),'')  -- 退汇原因代码
    ,replace(replace(t1.cmpsam,chr(13),''),chr(10),'')  -- 赔偿金金额、拆借利息、出票金额
    ,replace(replace(t1.inrate,chr(13),''),chr(10),'')  -- 利率
    ,replace(replace(t1.refuam,chr(13),''),chr(10),'')  -- 拒付金额
    ,replace(replace(t1.transt,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.processcode,chr(13),''),chr(10),'')  -- 人行业务状态
    ,replace(replace(t1.advest,chr(13),''),chr(10),'')  -- 回执码
    ,replace(replace(t1.vrseal,chr(13),''),chr(10),'')  -- 处理代码(一般为人行返回码)
    ,replace(replace(t1.ckrvno,chr(13),''),chr(10),'')  -- 复核冲正流水号
    ,replace(replace(t1.rndday,chr(13),''),chr(10),'')  -- 回执期限
    ,replace(replace(t1.retudt,chr(13),''),chr(10),'')  -- 回执日期
    ,replace(replace(t1.sdrvno,chr(13),''),chr(10),'')  -- 发送冲正流水号
    ,replace(replace(t1.clerdt,chr(13),''),chr(10),'')  -- 清算日期
    ,replace(replace(t1.bperno,chr(13),''),chr(10),'')  -- 错误代码
    ,replace(replace(t1.bpermg,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(t1.levels,chr(13),''),chr(10),'')  -- 优先级别
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'')  -- 录入柜员
    ,replace(replace(t1.chktlr,chr(13),''),chr(10),'')  -- 复核柜员
    ,replace(replace(t1.sndtlr,chr(13),''),chr(10),'')  -- 发送柜员
    ,replace(replace(t1.auttlr,chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(t1.stptlr,chr(13),''),chr(10),'')  -- 滞留柜员
    ,replace(replace(t1.oprbrn,chr(13),''),chr(10),'')  -- 录入复核柜员部门号
    ,replace(replace(t1.sendbranch,chr(13),''),chr(10),'')  -- 发送柜员部门号
    ,replace(replace(t1.autbrn,chr(13),''),chr(10),'')  -- 授权柜员部门号
    ,replace(replace(t1.recdes,chr(13),''),chr(10),'')  -- 支付密押
    ,replace(replace(t1.chksta,chr(13),''),chr(10),'')  -- 对账状态
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 附言
    ,replace(replace(t1.protocolnb,chr(13),''),chr(10),'')  -- 提示付款日期、协议号
    ,t1.prtcnt  -- 打印次数
    ,replace(replace(t1.recvdt,chr(13),''),chr(10),'')  -- 收到时间
    ,replace(replace(t1.transmitdt,chr(13),''),chr(10),'')  -- 发送时间、转发时间
    ,replace(replace(t1.blsecd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.paydat,chr(13),''),chr(10),'')  -- 提示付款日期
    ,replace(replace(t1.iotype,chr(13),''),chr(10),'')  -- 往来帐标志
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 实时联机标记
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 收费标志
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 借贷标记
    ,replace(replace(t1.inoutflag,chr(13),''),chr(10),'')  -- 行内行外标志
    ,replace(replace(t1.blrqno,chr(13),''),chr(10),'')  -- 汇票申请书号码
    ,replace(replace(t1.sacact,chr(13),''),chr(10),'')  -- 挂帐帐号或维护入账帐号
    ,replace(replace(t1.sacana,chr(13),''),chr(10),'')  -- 挂帐帐号或维护入账姓名
    ,replace(replace(t1.clendt,chr(13),''),chr(10),'')  -- 维护入账日期
    ,replace(replace(t1.clenus,chr(13),''),chr(10),'')  -- 维护入账柜员
    ,replace(replace(t1.clrbrn,chr(13),''),chr(10),'')  -- 维护入账部门号
    ,replace(replace(t1.clract,chr(13),''),chr(10),'')  -- 清分入帐帐号
    ,replace(replace(t1.clrseq,chr(13),''),chr(10),'')  -- 清分流水
    ,replace(replace(t1.prdnbr,chr(13),''),chr(10),'')  -- 代理标识 0 本行业务 1 代理他行
    ,replace(replace(t1.tranbr,chr(13),''),chr(10),'')  -- 日志流水号
    ,replace(replace(t1.sdtrno,chr(13),''),chr(10),'')  -- 发送日志流水
    ,replace(replace(t1.bkcode,chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(t1.cobkdt,chr(13),''),chr(10),'')  -- 委托凭证日期
    ,replace(replace(t1.cobkcd,chr(13),''),chr(10),'')  -- 委托凭证号
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'')  -- 证件种类
    ,replace(replace(t1.idno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.mxtram,chr(13),''),chr(10),'')  -- 转帐限额
    ,replace(replace(t1.transq,chr(13),''),chr(10),'')  -- 交易流水套号
    ,replace(replace(t1.sdtrsq,chr(13),''),chr(10),'')  -- 发送交易流水
    ,replace(replace(t1.paymod,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.opnwin,chr(13),''),chr(10),'')  -- 汇兑业务对应的窗口(交易渠道)
    ,replace(replace(t1.chngdt,chr(13),''),chr(10),'')  -- 最近修改日期
    ,replace(replace(t1.bepssq,chr(13),''),chr(10),'')  -- 业务流水号
    ,t1.linkid  -- ID号
    ,replace(replace(t1.feamt1,chr(13),''),chr(10),'')  -- 手续费
    ,replace(replace(t1.feamt2,chr(13),''),chr(10),'')  -- 汇划费
    ,replace(replace(t1.feamt3,chr(13),''),chr(10),'')  -- 工本费
    ,replace(replace(t1.feamt4,chr(13),''),chr(10),'')  -- 费用（备用）
    ,replace(replace(t1.priamt,chr(13),''),chr(10),'')  -- 原托金额
    ,replace(replace(t1.payamt,chr(13),''),chr(10),'')  -- 支付金额
    ,replace(replace(t1.spiamt,chr(13),''),chr(10),'')  -- 多付金额
    ,replace(replace(t1.edhtno,chr(13),''),chr(10),'')  -- 取消交易流水
    ,replace(replace(t1.edhtdt,chr(13),''),chr(10),'')  -- 取消交易日期
    ,replace(replace(t1.endtlr,chr(13),''),chr(10),'')  -- 取消柜员
    ,replace(replace(t1.chngti,chr(13),''),chr(10),'')  -- 最近修改时间
    ,replace(replace(t1.magbrn,chr(13),''),chr(10),'')  -- 处理机构
    ,replace(replace(t1.resv40,chr(13),''),chr(10),'')  -- 特殊码
    ,t1.rcdver  -- 记录更新版本号
    ,replace(replace(t1.rcdsta,chr(13),''),chr(10),'')  -- 记录状态
    ,replace(replace(t1.prpktp,chr(13),''),chr(10),'')  -- 原包类型
    ,replace(replace(t1.prclbk,chr(13),''),chr(10),'')  -- 原包发起清算行
    ,replace(replace(t1.prpkdt,chr(13),''),chr(10),'')  -- 原包委托日期
    ,replace(replace(t1.prpksq,chr(13),''),chr(10),'')  -- 原包序号
    ,replace(replace(t1.prodcd,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(t1.isinout,chr(13),''),chr(10),'')  -- 客户帐、内部帐标识
    ,replace(replace(t1.inacct,chr(13),''),chr(10),'')  -- 实际扣帐账号
    ,replace(replace(t1.inname,chr(13),''),chr(10),'')  -- 实际扣帐户名
    ,replace(replace(t1.ourcnapsver,chr(13),''),chr(10),'')  -- 行内系统版本
    ,replace(replace(t1.othercnapsver,chr(13),''),chr(10),'')  -- 对手系统版本
    ,replace(replace(t1.landdealsts,chr(13),''),chr(10),'')  -- 落地处理状态
    ,replace(replace(t1.checkdealsts,chr(13),''),chr(10),'')  -- 查证处理状态
    ,replace(replace(t1.appenddatatable,chr(13),''),chr(10),'')  -- 登记附加数据的表名
    ,replace(replace(t1.appenddatadtltab,chr(13),''),chr(10),'')  -- 登记附加数据明细的表名
    ,replace(replace(t1.hangupreason,chr(13),''),chr(10),'')  -- 挂账原因
    ,replace(replace(t1.pkgbusinesstrace,chr(13),''),chr(10),'')  -- 包行内序号
    ,replace(replace(t1.pktype2,chr(13),''),chr(10),'')  -- 二代报文号
    ,replace(replace(t1.bustype2,chr(13),''),chr(10),'')  -- 二代业务类型
    ,replace(replace(t1.servtype2,chr(13),''),chr(10),'')  -- 二代业务种类
    ,replace(replace(t1.payopenbanknm,chr(13),''),chr(10),'')  -- 付款人开户行名称
    ,replace(replace(t1.recvopenbanknm,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.modifytlr,chr(13),''),chr(10),'')  -- 修改柜员
    ,replace(replace(t1.feetype,chr(13),''),chr(10),'')  -- 收费方式
    ,replace(replace(t1.eaccflg,chr(13),''),chr(10),'')  -- 电子账户标志
    ,replace(replace(t1.od_flag,chr(13),''),chr(10),'')  -- 是否触发透支业务
    ,t1.od_ovtranam  -- 透支金额
    ,replace(replace(t1.nextdayflag,chr(13),''),chr(10),'')  -- 次日转账标识
    ,replace(replace(t1.autoflag,chr(13),''),chr(10),'')  -- 自动退汇处理标识
    ,replace(replace(t1.autocount,chr(13),''),chr(10),'')  -- 自动退汇处理次数
    ,replace(replace(t1.automsg,chr(13),''),chr(10),'')  -- 自动退汇处理信息
    ,replace(replace(t1.bindacct,chr(13),''),chr(10),'')  -- 绑定账户
    ,replace(replace(t1.bindacctnm,chr(13),''),chr(10),'')  -- 绑定账户名
    ,replace(replace(t1.accttype,chr(13),''),chr(10),'')  -- 账户类型
    ,replace(replace(t1.bindacctopnbrn,chr(13),''),chr(10),'')  -- 绑定账户开户机构
    ,replace(replace(t1.lsttranst,chr(13),''),chr(10),'')  -- 上一交易状态
    ,replace(replace(t1.tacctp,chr(13),''),chr(10),'')  -- 账户分类标识
    ,replace(replace(t1.limitorderid,chr(13),''),chr(10),'')  -- 限额订单号
    ,replace(replace(t1.isbindcard,chr(13),''),chr(10),'')  -- 绑定标志
    ,replace(replace(t1.globalseqno,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.returncode,chr(13),''),chr(10),'')  -- ESB接口返回码
    ,replace(replace(t1.returnmsg,chr(13),''),chr(10),'')  -- ESB接口返回信息
    ,replace(replace(t1.transseqno,chr(13),''),chr(10),'')  -- ESB接口交易流水号
    ,replace(replace(t1.sendouttm,chr(13),''),chr(10),'')  -- 发送人行时间
    ,replace(replace(t1.unique_seq_num,chr(13),''),chr(10),'')  -- 业务流水号(交易订单号)
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a08tbetrx t1    --小额交易流水表
where t1.transdt>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and t1.transdt<='${batch_date}' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a08tbetrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);