/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a08thvtrx
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
alter table ${idl_schema}.aml_mpcs_a08thvtrx drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a08thvtrx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a08thvtrx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a08thvtrx partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 支付报单号
    ,transdt  -- 交易日期
    ,transseq  -- 支付交易序号（行外）
    ,businesstrace  -- 行内业务序号
    ,cmtno  -- 报文编号（报文类型）
    ,hosttrcd  -- 主机交易码
    ,fronttrcd  -- 中台交易码
    ,consigndt  -- 委托日期
    ,hostdate  -- 主机日期
    ,hostnbr  -- 主机流水
    ,ccynbr  -- 币种
    ,transamt  -- 交易金额
    ,spbrn  -- 特许参与者
    ,sndct  -- 发报中心（被借记行所在中心）
    ,sndupbrn  -- 发起清算行行号
    ,sndbrn  -- 发起行行号（被借记行）
    ,paybrn  -- 付款人开户行部门号
    ,payopenbrn  -- 付款人开户行行号
    ,payopenbanknm  -- 付款人开户行名称
    ,payacct  -- 付款人账号
    ,payname  -- 付款人名称
    ,payaddr  -- 付款人地址
    ,rcvct  -- 收报中心（被贷记行所在中心）
    ,rcvupbrn  -- 接收清算行行号
    ,rcvbrn  -- 接收行行号（被贷记行）
    ,incobrn  -- 收款人开户行行号
    ,recvopenbanknm  -- 收款人开户行名称
    ,incoacct  -- 收款人账号
    ,inconame  -- 收款人名称
    ,incoaddr  -- 收款人地址
    ,servtype  -- 业务种类
    ,bustype  -- 业务类型
    ,billdt  -- 原委托日期
    ,billcode  -- 原支付交易序号
    ,orasndbrn  -- 原发起参与机构
    ,oracmtno  -- 原报文类型
    ,cmpsamt  -- 赔偿金金额、拆借利息、出票金额
    ,inrate  -- 利率
    ,refuseamt  -- 拒付金额
    ,status  -- 处理状态
    ,processcode  -- 人行业务状态
    ,varseal  -- 处理码
    ,ckrvnbr  -- 复核冲正流水号
    ,sndrvnbr  -- 发送冲正流水号
    ,cleardt  -- 清算日期
    ,errcode  -- 错误代码
    ,errms  -- 错误信息
    ,levels  -- 优先级别
    ,oprtlr  -- 录入柜员
    ,chktlr  -- 复核柜员
    ,sndtlr  -- 发送柜员
    ,auttlr  -- 授权柜员
    ,stoptlr  -- 滞留柜员
    ,oprbrn  -- 录入复核柜员部门号
    ,sndtlrbrn  -- 发送柜员部门号
    ,autbrn  -- 授权柜员部门号
    ,seccode  -- 支付密押
    ,chkstatus  -- 对账状态
    ,info  -- 附言
    ,note  -- 备注
    ,note2  -- 备注2
    ,prtcnt  -- 打印次数
    ,rcvdt  -- 收到时间
    ,transmitdt  -- 发送时间、转发时间
    ,billseccode  -- 汇票密押
    ,paydt  -- 提示付款日期
    ,wlflag  -- 往来帐标志
    ,flag2  -- 实时联机标记
    ,flag3  -- 收费标志
    ,flag4  -- 借贷标记
    ,billrqcode  -- 汇票申请书号码
    ,sacacct  -- 挂帐帐号或确认后入帐帐号
    ,sacname  -- 挂帐帐号或维护入账姓名
    ,crdt  -- 维护入账日期
    ,crtlr  -- 维护入账柜员
    ,crbrn  -- 维护入账部门号
    ,cracct  -- 清分入帐帐号
    ,crseq  -- 清分流水
    ,prodnbr  -- 代理标识
    ,tracenbr  -- 日志流水号
    ,sndtracenbr  -- 发送日志流水
    ,bookcode  -- 凭证类型
    ,bookdate  -- 凭证日期
    ,bookseqno  -- 凭证号码
    ,idtype  -- 证件种类
    ,idno  -- 证件号码
    ,maxtransamt  -- 转帐限额
    ,transnbr  -- 交易流水套号
    ,sndtransnbr  -- 发送交易流水
    ,changtime  -- 修改时间
    ,reserv40  -- 城商行汇票号
    ,rcdver  -- 记录更新版本号
    ,rcdstatus  -- 记录状态
    ,paymod  -- 支付方式
    ,openwintype  -- 汇兑业务对应的窗口(交易渠道)
    ,changdate  -- 修改日期
    ,servnbr  -- 业务流水号
    ,magebrn  -- 管理机构
    ,feeamt  -- 手续费用金额
    ,feeamt1  -- 汇划费用金额
    ,feeamt2  -- 工本费
    ,feeamt3  -- 备用
    ,linkid  -- 链路ID
    ,endtlr  -- 取消（冲正）柜员
    ,edhostnbr  -- 取消（冲正）交易流水
    ,edhostdt  -- 取消（冲正）交易日期
    ,prodcd  -- 产品代码
    ,isinout  -- 客户帐、内部帐标识
    ,inacct  -- 实际扣帐账号
    ,inname  -- 实际扣帐户名
    ,ourcnapsver  -- 行内系统版本
    ,othercnapsver  -- 对手系统版本
    ,landdealsts  -- 落地处理状态
    ,checkdealsts  -- 查证处理状态
    ,appenddatatable  -- 登记附加数据的表名
    ,hangupreason  -- 挂账原因代码
    ,modifytlr  -- 修改柜员
    ,info2  -- 附言2
    ,cmtno2  -- 二代报文号
    ,bustype2  -- 二代业务类型
    ,servtype2  -- 二代业务种类
    ,feetype  -- 收费标志
    ,eaccflg  -- 电子账户标志
    ,srcsysssn  -- 渠道流水号
    ,od_flag  -- 是否触发透支业务
    ,od_ovtranam  -- 透支金额
    ,nextdayflag  -- 次日转账标识
    ,crotransamt  -- 额度变化值
    ,autoflag  -- 自动退汇处理标识
    ,autocount  -- 自动退汇处理次数
    ,automsg  -- 自动退汇处理信息
    ,bindacct  -- 绑定账户
    ,bindacctnm  -- 绑定账户名
    ,accttype  -- 账户类型
    ,bindacctopnbrn  -- 绑定账户开户机构
    ,tacctp  -- 账户分类标识
    ,limitorderid  -- 限额订单号
    ,globalseqno  -- 全局流水号
    ,returncode  -- ESB接口返回码
    ,returnmsg  -- ESB接口返回信息
    ,transseqno  -- ESB接口交易流水号
    ,sendouttm  -- 发送人行时间
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 支付报单号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.transseq,chr(13),''),chr(10),'')  -- 支付交易序号（行外）
    ,replace(replace(t1.businesstrace,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(t1.cmtno,chr(13),''),chr(10),'')  -- 报文编号（报文类型）
    ,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'')  -- 主机交易码
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.consigndt,chr(13),''),chr(10),'')  -- 委托日期
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'')  -- 主机日期
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'')  -- 主机流水
    ,replace(replace(t1.ccynbr,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.transamt,chr(13),''),chr(10),'')  -- 交易金额
    ,replace(replace(t1.spbrn,chr(13),''),chr(10),'')  -- 特许参与者
    ,replace(replace(t1.sndct,chr(13),''),chr(10),'')  -- 发报中心（被借记行所在中心）
    ,replace(replace(t1.sndupbrn,chr(13),''),chr(10),'')  -- 发起清算行行号
    ,replace(replace(t1.sndbrn,chr(13),''),chr(10),'')  -- 发起行行号（被借记行）
    ,replace(replace(t1.paybrn,chr(13),''),chr(10),'')  -- 付款人开户行部门号
    ,replace(replace(t1.payopenbrn,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(t1.payopenbanknm,chr(13),''),chr(10),'')  -- 付款人开户行名称
    ,replace(replace(t1.payacct,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payname,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payaddr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(t1.rcvct,chr(13),''),chr(10),'')  -- 收报中心（被贷记行所在中心）
    ,replace(replace(t1.rcvupbrn,chr(13),''),chr(10),'')  -- 接收清算行行号
    ,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'')  -- 接收行行号（被贷记行）
    ,replace(replace(t1.incobrn,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.recvopenbanknm,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.incoacct,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.inconame,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.incoaddr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(t1.servtype,chr(13),''),chr(10),'')  -- 业务种类
    ,replace(replace(t1.bustype,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.billdt,chr(13),''),chr(10),'')  -- 原委托日期
    ,replace(replace(t1.billcode,chr(13),''),chr(10),'')  -- 原支付交易序号
    ,replace(replace(t1.orasndbrn,chr(13),''),chr(10),'')  -- 原发起参与机构
    ,replace(replace(t1.oracmtno,chr(13),''),chr(10),'')  -- 原报文类型
    ,replace(replace(t1.cmpsamt,chr(13),''),chr(10),'')  -- 赔偿金金额、拆借利息、出票金额
    ,replace(replace(t1.inrate,chr(13),''),chr(10),'')  -- 利率
    ,replace(replace(t1.refuseamt,chr(13),''),chr(10),'')  -- 拒付金额
    ,replace(replace(t1.status,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.processcode,chr(13),''),chr(10),'')  -- 人行业务状态
    ,replace(replace(t1.varseal,chr(13),''),chr(10),'')  -- 处理码
    ,replace(replace(t1.ckrvnbr,chr(13),''),chr(10),'')  -- 复核冲正流水号
    ,replace(replace(t1.sndrvnbr,chr(13),''),chr(10),'')  -- 发送冲正流水号
    ,replace(replace(t1.cleardt,chr(13),''),chr(10),'')  -- 清算日期
    ,replace(replace(t1.errcode,chr(13),''),chr(10),'')  -- 错误代码
    ,replace(replace(t1.errms,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(t1.levels,chr(13),''),chr(10),'')  -- 优先级别
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'')  -- 录入柜员
    ,replace(replace(t1.chktlr,chr(13),''),chr(10),'')  -- 复核柜员
    ,replace(replace(t1.sndtlr,chr(13),''),chr(10),'')  -- 发送柜员
    ,replace(replace(t1.auttlr,chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(t1.stoptlr,chr(13),''),chr(10),'')  -- 滞留柜员
    ,replace(replace(t1.oprbrn,chr(13),''),chr(10),'')  -- 录入复核柜员部门号
    ,replace(replace(t1.sndtlrbrn,chr(13),''),chr(10),'')  -- 发送柜员部门号
    ,replace(replace(t1.autbrn,chr(13),''),chr(10),'')  -- 授权柜员部门号
    ,replace(replace(t1.seccode,chr(13),''),chr(10),'')  -- 支付密押
    ,replace(replace(t1.chkstatus,chr(13),''),chr(10),'')  -- 对账状态
    ,replace(replace(t1.info,chr(13),''),chr(10),'')  -- 附言
    ,replace(replace(t1.note,chr(13),''),chr(10),'')  -- 备注
    ,replace(replace(t1.note2,chr(13),''),chr(10),'')  -- 备注2
    ,t1.prtcnt  -- 打印次数
    ,replace(replace(t1.rcvdt,chr(13),''),chr(10),'')  -- 收到时间
    ,replace(replace(t1.transmitdt,chr(13),''),chr(10),'')  -- 发送时间、转发时间
    ,replace(replace(t1.billseccode,chr(13),''),chr(10),'')  -- 汇票密押
    ,replace(replace(t1.paydt,chr(13),''),chr(10),'')  -- 提示付款日期
    ,replace(replace(t1.wlflag,chr(13),''),chr(10),'')  -- 往来帐标志
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'')  -- 实时联机标记
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'')  -- 收费标志
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 借贷标记
    ,replace(replace(t1.billrqcode,chr(13),''),chr(10),'')  -- 汇票申请书号码
    ,replace(replace(t1.sacacct,chr(13),''),chr(10),'')  -- 挂帐帐号或确认后入帐帐号
    ,replace(replace(t1.sacname,chr(13),''),chr(10),'')  -- 挂帐帐号或维护入账姓名
    ,replace(replace(t1.crdt,chr(13),''),chr(10),'')  -- 维护入账日期
    ,replace(replace(t1.crtlr,chr(13),''),chr(10),'')  -- 维护入账柜员
    ,replace(replace(t1.crbrn,chr(13),''),chr(10),'')  -- 维护入账部门号
    ,replace(replace(t1.cracct,chr(13),''),chr(10),'')  -- 清分入帐帐号
    ,replace(replace(t1.crseq,chr(13),''),chr(10),'')  -- 清分流水
    ,replace(replace(t1.prodnbr,chr(13),''),chr(10),'')  -- 代理标识
    ,replace(replace(t1.tracenbr,chr(13),''),chr(10),'')  -- 日志流水号
    ,replace(replace(t1.sndtracenbr,chr(13),''),chr(10),'')  -- 发送日志流水
    ,replace(replace(t1.bookcode,chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(t1.bookdate,chr(13),''),chr(10),'')  -- 凭证日期
    ,replace(replace(t1.bookseqno,chr(13),''),chr(10),'')  -- 凭证号码
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'')  -- 证件种类
    ,replace(replace(t1.idno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.maxtransamt,chr(13),''),chr(10),'')  -- 转帐限额
    ,replace(replace(t1.transnbr,chr(13),''),chr(10),'')  -- 交易流水套号
    ,replace(replace(t1.sndtransnbr,chr(13),''),chr(10),'')  -- 发送交易流水
    ,replace(replace(t1.changtime,chr(13),''),chr(10),'')  -- 修改时间
    ,replace(replace(t1.reserv40,chr(13),''),chr(10),'')  -- 城商行汇票号
    ,replace(replace(t1.rcdver,chr(13),''),chr(10),'')  -- 记录更新版本号
    ,replace(replace(t1.rcdstatus,chr(13),''),chr(10),'')  -- 记录状态
    ,replace(replace(t1.paymod,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.openwintype,chr(13),''),chr(10),'')  -- 汇兑业务对应的窗口(交易渠道)
    ,replace(replace(t1.changdate,chr(13),''),chr(10),'')  -- 修改日期
    ,replace(replace(t1.servnbr,chr(13),''),chr(10),'')  -- 业务流水号
    ,replace(replace(t1.magebrn,chr(13),''),chr(10),'')  -- 管理机构
    ,replace(replace(t1.feeamt,chr(13),''),chr(10),'')  -- 手续费用金额
    ,replace(replace(t1.feeamt1,chr(13),''),chr(10),'')  -- 汇划费用金额
    ,replace(replace(t1.feeamt2,chr(13),''),chr(10),'')  -- 工本费
    ,replace(replace(t1.feeamt3,chr(13),''),chr(10),'')  -- 备用
    ,replace(replace(t1.linkid,chr(13),''),chr(10),'')  -- 链路ID
    ,replace(replace(t1.endtlr,chr(13),''),chr(10),'')  -- 取消（冲正）柜员
    ,replace(replace(t1.edhostnbr,chr(13),''),chr(10),'')  -- 取消（冲正）交易流水
    ,replace(replace(t1.edhostdt,chr(13),''),chr(10),'')  -- 取消（冲正）交易日期
    ,replace(replace(t1.prodcd,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(t1.isinout,chr(13),''),chr(10),'')  -- 客户帐、内部帐标识
    ,replace(replace(t1.inacct,chr(13),''),chr(10),'')  -- 实际扣帐账号
    ,replace(replace(t1.inname,chr(13),''),chr(10),'')  -- 实际扣帐户名
    ,replace(replace(t1.ourcnapsver,chr(13),''),chr(10),'')  -- 行内系统版本
    ,replace(replace(t1.othercnapsver,chr(13),''),chr(10),'')  -- 对手系统版本
    ,replace(replace(t1.landdealsts,chr(13),''),chr(10),'')  -- 落地处理状态
    ,replace(replace(t1.checkdealsts,chr(13),''),chr(10),'')  -- 查证处理状态
    ,replace(replace(t1.appenddatatable,chr(13),''),chr(10),'')  -- 登记附加数据的表名
    ,replace(replace(t1.hangupreason,chr(13),''),chr(10),'')  -- 挂账原因代码
    ,replace(replace(t1.modifytlr,chr(13),''),chr(10),'')  -- 修改柜员
    ,replace(replace(t1.info2,chr(13),''),chr(10),'')  -- 附言2
    ,replace(replace(t1.cmtno2,chr(13),''),chr(10),'')  -- 二代报文号
    ,replace(replace(t1.bustype2,chr(13),''),chr(10),'')  -- 二代业务类型
    ,replace(replace(t1.servtype2,chr(13),''),chr(10),'')  -- 二代业务种类
    ,replace(replace(t1.feetype,chr(13),''),chr(10),'')  -- 收费标志
    ,replace(replace(t1.eaccflg,chr(13),''),chr(10),'')  -- 电子账户标志
    ,replace(replace(t1.srcsysssn,chr(13),''),chr(10),'')  -- 渠道流水号
    ,replace(replace(t1.od_flag,chr(13),''),chr(10),'')  -- 是否触发透支业务
    ,t1.od_ovtranam  -- 透支金额
    ,replace(replace(t1.nextdayflag,chr(13),''),chr(10),'')  -- 次日转账标识
    ,t1.crotransamt  -- 额度变化值
    ,replace(replace(t1.autoflag,chr(13),''),chr(10),'')  -- 自动退汇处理标识
    ,replace(replace(t1.autocount,chr(13),''),chr(10),'')  -- 自动退汇处理次数
    ,replace(replace(t1.automsg,chr(13),''),chr(10),'')  -- 自动退汇处理信息
    ,replace(replace(t1.bindacct,chr(13),''),chr(10),'')  -- 绑定账户
    ,replace(replace(t1.bindacctnm,chr(13),''),chr(10),'')  -- 绑定账户名
    ,replace(replace(t1.accttype,chr(13),''),chr(10),'')  -- 账户类型
    ,replace(replace(t1.bindacctopnbrn,chr(13),''),chr(10),'')  -- 绑定账户开户机构
    ,replace(replace(t1.tacctp,chr(13),''),chr(10),'')  -- 账户分类标识
    ,replace(replace(t1.limitorderid,chr(13),''),chr(10),'')  -- 限额订单号
    ,replace(replace(t1.globalseqno,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.returncode,chr(13),''),chr(10),'')  -- ESB接口返回码
    ,replace(replace(t1.returnmsg,chr(13),''),chr(10),'')  -- ESB接口返回信息
    ,replace(replace(t1.transseqno,chr(13),''),chr(10),'')  -- ESB接口交易流水号
    ,replace(replace(t1.sendouttm,chr(13),''),chr(10),'')  -- 发送人行时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a08thvtrx t1    --大额交易流水表
where t1.transdt>=to_char(to_date('${batch_date}','yyyymmdd')-14,'yyyymmdd') and t1.transdt<='${batch_date}' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a08thvtrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);