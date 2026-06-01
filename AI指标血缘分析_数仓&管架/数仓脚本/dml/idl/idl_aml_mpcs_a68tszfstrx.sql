/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a68tszfstrx
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
alter table ${idl_schema}.aml_mpcs_a68tszfstrx drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a68tszfstrx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a68tszfstrx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a68tszfstrx partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,mainseq  -- 行内中台流水号
    ,transdt  -- 交易日期
    ,businesstrace  -- 行内业务序号
    ,pckno  -- 报文类型
    ,txtpcd  -- 业务类型
    ,txcd  -- 业务编号
    ,txid  -- 支付交易序号，明细标识号
    ,cnsdt  -- 委托日期，明细的委托日期
    ,instgpty  -- 委托方
    ,pkgbusinesstrace  -- 所属批量包业务序号
    ,pksqno  -- 包序号
    ,hosttrcd  -- 主机交易码
    ,fronttrcd  -- 中台交易码
    ,hostdate  -- 主机日期
    ,hostnbr  -- 主机流水
    ,crcycd  -- 币种
    ,transamt  -- 交易金额
    ,dbtrid  -- 付款行行号
    ,sndbrnname  -- 付款行行名
    ,cdtrid  -- 收款行行号
    ,rcvbrnname  -- 收款行行名
    ,payopenbank  -- 付款人开户行行号
    ,payopenbanknm  -- 付款人开户行名称
    ,payacct  -- 付款人账号
    ,payname  -- 付款人名称
    ,payaddr  -- 付款人地址
    ,rcvopenbank  -- 收款人开户行行号
    ,rcvopenbanknm  -- 收款人开户行名称
    ,rcvacct  -- 收款人账号
    ,rcvname  -- 收款人名称
    ,rcvaddr  -- 收款人地址
    ,orgnltxtpcd  -- 原业务类型
    ,orgnlcnsdt  -- 原委托日期
    ,orgnltxid  -- 原支付交易序号
    ,orgnlinstgpty  -- 原委托方
    ,orgnlpkgbustrace  -- 原所属包业务序号
    ,netgrnd  -- 轧差场次
    ,netgdt  -- 轧差日期/终态日期
    ,transt  -- 处理状态
    ,iotype  -- 往来账标识
    ,flag4  -- 借贷标志
    ,magebrn  -- 处理机构
    ,oprtlr  -- 录入柜员
    ,chktlr  -- 复核柜员
    ,sndtlr  -- 发送柜员
    ,auttlr  -- 授权柜员
    ,oprbrn  -- 录入复核柜员部门号
    ,sendbranch  -- 发送柜员部门号
    ,autbrn  -- 授权柜员部门号
    ,caclrs  -- 退汇原因代码
    ,processcode  -- 中心返回状态
    ,rspncd  -- 中心返回处理码
    ,rspninf  -- 中心返回处理码处理说明
    ,rtncd  -- 银行返回处理码
    ,rtninf  -- 银行返回处理码处理说明
    ,rtrltd  -- 回执日期
    ,diskno  -- 定期业务批次号
    ,clerdt  -- 清算日期
    ,bperno  -- 错误代码
    ,bpermg  -- 错误信息
    ,levels  -- 优先级别
    ,recdes  -- 支付密押
    ,chksta  -- 对账状态
    ,remark  -- 附言
    ,prtcnt  -- 打印次数
    ,transmitdt  -- 往账：发送时间、转发时间 来账：收到时间
    ,feeflag  -- 收费标志
    ,inoutflag  -- 行内行外标志    0行外  1行内
    ,sacact  -- 挂帐帐号或维护入账帐号
    ,sacana  -- 挂帐帐号或维护入账姓名
    ,clendt  -- 维护入账日期
    ,clenus  -- 维护入账柜员
    ,clrbrn  -- 维护入账部门号
    ,edhtno  -- 维护入账主机流水号/维护入账冲账主机流水号
    ,edhtdt  -- 维护入账主机日期/维护入账冲账主机日期
    ,endtlr  -- 维护入账冲账柜员号
    ,prdnbr  -- 代理标识 0 本行业务 1 代理他行
    ,bookcd  -- 凭证类型
    ,cobkdt  -- 委托凭证日期
    ,booknbr  -- 委托凭证号
    ,idtype  -- 证件种类
    ,idno  -- 证件号码
    ,transq  -- 交易流水套号
    ,sdtrsq  -- 发送交易流水
    ,paymod  -- 支付方式
    ,opnwin  -- 汇兑业务对应的窗口(交易渠道)
    ,feamt1  -- 手续费
    ,feamt2  -- 汇划费
    ,feamt3  -- 工本费
    ,calfee  -- 手续费总额
    ,chngti  -- 最近修改时间
    ,rcdsta  -- 记录状态
    ,prodcd  -- 产品代码
    ,isinout  -- 客户帐、内部帐标识
    ,inacct  -- 实际扣帐账号
    ,inname  -- 实际扣帐户名
    ,landdealsts  -- 落地处理状态
    ,checkdealsts  -- 查证处理状态
    ,appenddatatable  -- 登记附加数据的表名
    ,appenddatadtltab  -- 登记附加数据明细的表名
    ,hangupreason  -- 挂账原因
    ,modifytlr  -- 修改柜员
    ,feetype  -- 计费种类
    ,areacd  -- 地区代码
    ,acctchckflg  -- 帐户信息检查标志
    ,servmode  -- 业务类型(0-转账 1-现金)
    ,realtmcdtflg  -- 实时贷记实时入账标志(0允许落地处理 1不允许)
    ,chflag  -- 钞汇标志
    ,protocolnb  -- 定期借贷记协议号（明细）
    ,resndflg  -- 补发标识(0正常 1补发)
    ,bllind  -- 票据标志
    ,blltp  -- 票据种类
    ,billnb  -- 票据号码
    ,channeldt  -- 渠道日期
    ,tranflowno  -- 渠道流水号
    ,orgnlpksqno  -- 原业务包序号
    ,corprtnid  -- 企业单位代码
    ,pmtitmcd  -- 费项代码
    ,pmtitmnm  -- 费项名称
    ,billamount  -- 业务金额
    ,feeamount  -- 需付款行代扣的手续费
    ,info2  -- 冲账原因
    ,od_flag  -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam  -- 透支金额
    ,toaccountflag  -- 0：不延时 1：延时2小时 2：次日到账 3：延时24小时
    ,autoflag  -- 自动退汇标志 1-自动退汇
    ,autocount  -- 自动退汇次数
    ,automsg  -- 自动退汇信息
    ,bindacct  -- 绑定账户(实体账户)
    ,bindacctnm  -- 绑定账户名(实体账户名)
    ,eflag  -- 1个人e 2企业e
    ,upporderid  -- UPP返回订单标识
    ,intoaccounttype  -- 实际收款人账号类型
    ,accttype  -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn  -- 虚拟账户绑定的账户开户机构
    ,branchid  -- 开户机构
    ,tacctp  -- 账户类别
    ,handleflag  -- 后续操作标志
    ,custno  -- 客户号
    ,pmtid  -- 协议号
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.mainseq,chr(13),''),chr(10),'')  -- 行内中台流水号
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(t1.businesstrace,chr(13),''),chr(10),'')  -- 行内业务序号
    ,replace(replace(t1.pckno,chr(13),''),chr(10),'')  -- 报文类型
    ,replace(replace(t1.txtpcd,chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(t1.txcd,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.txid,chr(13),''),chr(10),'')  -- 支付交易序号，明细标识号
    ,replace(replace(t1.cnsdt,chr(13),''),chr(10),'')  -- 委托日期，明细的委托日期
    ,replace(replace(t1.instgpty,chr(13),''),chr(10),'')  -- 委托方
    ,replace(replace(t1.pkgbusinesstrace,chr(13),''),chr(10),'')  -- 所属批量包业务序号
    ,replace(replace(t1.pksqno,chr(13),''),chr(10),'')  -- 包序号
    ,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'')  -- 主机交易码
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'')  -- 中台交易码
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'')  -- 主机日期
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'')  -- 主机流水
    ,replace(replace(t1.crcycd,chr(13),''),chr(10),'')  -- 币种
    ,replace(replace(t1.transamt,chr(13),''),chr(10),'')  -- 交易金额
    ,replace(replace(t1.dbtrid,chr(13),''),chr(10),'')  -- 付款行行号
    ,replace(replace(t1.sndbrnname,chr(13),''),chr(10),'')  -- 付款行行名
    ,replace(replace(t1.cdtrid,chr(13),''),chr(10),'')  -- 收款行行号
    ,replace(replace(t1.rcvbrnname,chr(13),''),chr(10),'')  -- 收款行行名
    ,replace(replace(t1.payopenbank,chr(13),''),chr(10),'')  -- 付款人开户行行号
    ,replace(replace(t1.payopenbanknm,chr(13),''),chr(10),'')  -- 付款人开户行名称
    ,replace(replace(t1.payacct,chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(t1.payname,chr(13),''),chr(10),'')  -- 付款人名称
    ,replace(replace(t1.payaddr,chr(13),''),chr(10),'')  -- 付款人地址
    ,replace(replace(t1.rcvopenbank,chr(13),''),chr(10),'')  -- 收款人开户行行号
    ,replace(replace(t1.rcvopenbanknm,chr(13),''),chr(10),'')  -- 收款人开户行名称
    ,replace(replace(t1.rcvacct,chr(13),''),chr(10),'')  -- 收款人账号
    ,replace(replace(t1.rcvname,chr(13),''),chr(10),'')  -- 收款人名称
    ,replace(replace(t1.rcvaddr,chr(13),''),chr(10),'')  -- 收款人地址
    ,replace(replace(t1.orgnltxtpcd,chr(13),''),chr(10),'')  -- 原业务类型
    ,replace(replace(t1.orgnlcnsdt,chr(13),''),chr(10),'')  -- 原委托日期
    ,replace(replace(t1.orgnltxid,chr(13),''),chr(10),'')  -- 原支付交易序号
    ,replace(replace(t1.orgnlinstgpty,chr(13),''),chr(10),'')  -- 原委托方
    ,replace(replace(t1.orgnlpkgbustrace,chr(13),''),chr(10),'')  -- 原所属包业务序号
    ,t1.netgrnd  -- 轧差场次
    ,replace(replace(t1.netgdt,chr(13),''),chr(10),'')  -- 轧差日期/终态日期
    ,replace(replace(t1.transt,chr(13),''),chr(10),'')  -- 处理状态
    ,replace(replace(t1.iotype,chr(13),''),chr(10),'')  -- 往来账标识
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'')  -- 借贷标志
    ,replace(replace(t1.magebrn,chr(13),''),chr(10),'')  -- 处理机构
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'')  -- 录入柜员
    ,replace(replace(t1.chktlr,chr(13),''),chr(10),'')  -- 复核柜员
    ,replace(replace(t1.sndtlr,chr(13),''),chr(10),'')  -- 发送柜员
    ,replace(replace(t1.auttlr,chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(t1.oprbrn,chr(13),''),chr(10),'')  -- 录入复核柜员部门号
    ,replace(replace(t1.sendbranch,chr(13),''),chr(10),'')  -- 发送柜员部门号
    ,replace(replace(t1.autbrn,chr(13),''),chr(10),'')  -- 授权柜员部门号
    ,replace(replace(t1.caclrs,chr(13),''),chr(10),'')  -- 退汇原因代码
    ,replace(replace(t1.processcode,chr(13),''),chr(10),'')  -- 中心返回状态
    ,replace(replace(t1.rspncd,chr(13),''),chr(10),'')  -- 中心返回处理码
    ,replace(replace(t1.rspninf,chr(13),''),chr(10),'')  -- 中心返回处理码处理说明
    ,replace(replace(t1.rtncd,chr(13),''),chr(10),'')  -- 银行返回处理码
    ,replace(replace(t1.rtninf,chr(13),''),chr(10),'')  -- 银行返回处理码处理说明
    ,replace(replace(t1.rtrltd,chr(13),''),chr(10),'')  -- 回执日期
    ,replace(replace(t1.diskno,chr(13),''),chr(10),'')  -- 定期业务批次号
    ,replace(replace(t1.clerdt,chr(13),''),chr(10),'')  -- 清算日期
    ,replace(replace(t1.bperno,chr(13),''),chr(10),'')  -- 错误代码
    ,replace(replace(t1.bpermg,chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(t1.levels,chr(13),''),chr(10),'')  -- 优先级别
    ,replace(replace(t1.recdes,chr(13),''),chr(10),'')  -- 支付密押
    ,replace(replace(t1.chksta,chr(13),''),chr(10),'')  -- 对账状态
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 附言
    ,t1.prtcnt  -- 打印次数
    ,replace(replace(t1.transmitdt,chr(13),''),chr(10),'')  -- 往账：发送时间、转发时间 来账：收到时间
    ,replace(replace(t1.feeflag,chr(13),''),chr(10),'')  -- 收费标志
    ,replace(replace(t1.inoutflag,chr(13),''),chr(10),'')  -- 行内行外标志    0行外  1行内
    ,replace(replace(t1.sacact,chr(13),''),chr(10),'')  -- 挂帐帐号或维护入账帐号
    ,replace(replace(t1.sacana,chr(13),''),chr(10),'')  -- 挂帐帐号或维护入账姓名
    ,replace(replace(t1.clendt,chr(13),''),chr(10),'')  -- 维护入账日期
    ,replace(replace(t1.clenus,chr(13),''),chr(10),'')  -- 维护入账柜员
    ,replace(replace(t1.clrbrn,chr(13),''),chr(10),'')  -- 维护入账部门号
    ,replace(replace(t1.edhtno,chr(13),''),chr(10),'')  -- 维护入账主机流水号/维护入账冲账主机流水号
    ,replace(replace(t1.edhtdt,chr(13),''),chr(10),'')  -- 维护入账主机日期/维护入账冲账主机日期
    ,replace(replace(t1.endtlr,chr(13),''),chr(10),'')  -- 维护入账冲账柜员号
    ,replace(replace(t1.prdnbr,chr(13),''),chr(10),'')  -- 代理标识 0 本行业务 1 代理他行
    ,replace(replace(t1.bookcd,chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(t1.cobkdt,chr(13),''),chr(10),'')  -- 委托凭证日期
    ,replace(replace(t1.booknbr,chr(13),''),chr(10),'')  -- 委托凭证号
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'')  -- 证件种类
    ,replace(replace(t1.idno,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.transq,chr(13),''),chr(10),'')  -- 交易流水套号
    ,replace(replace(t1.sdtrsq,chr(13),''),chr(10),'')  -- 发送交易流水
    ,replace(replace(t1.paymod,chr(13),''),chr(10),'')  -- 支付方式
    ,replace(replace(t1.opnwin,chr(13),''),chr(10),'')  -- 汇兑业务对应的窗口(交易渠道)
    ,replace(replace(t1.feamt1,chr(13),''),chr(10),'')  -- 手续费
    ,replace(replace(t1.feamt2,chr(13),''),chr(10),'')  -- 汇划费
    ,replace(replace(t1.feamt3,chr(13),''),chr(10),'')  -- 工本费
    ,replace(replace(t1.calfee,chr(13),''),chr(10),'')  -- 手续费总额
    ,replace(replace(t1.chngti,chr(13),''),chr(10),'')  -- 最近修改时间
    ,replace(replace(t1.rcdsta,chr(13),''),chr(10),'')  -- 记录状态
    ,replace(replace(t1.prodcd,chr(13),''),chr(10),'')  -- 产品代码
    ,replace(replace(t1.isinout,chr(13),''),chr(10),'')  -- 客户帐、内部帐标识 
    ,replace(replace(t1.inacct,chr(13),''),chr(10),'')  -- 实际扣帐账号
    ,replace(replace(t1.inname,chr(13),''),chr(10),'')  -- 实际扣帐户名
    ,replace(replace(t1.landdealsts,chr(13),''),chr(10),'')  -- 落地处理状态
    ,replace(replace(t1.checkdealsts,chr(13),''),chr(10),'')  -- 查证处理状态
    ,replace(replace(t1.appenddatatable,chr(13),''),chr(10),'')  -- 登记附加数据的表名
    ,replace(replace(t1.appenddatadtltab,chr(13),''),chr(10),'')  -- 登记附加数据明细的表名
    ,replace(replace(t1.hangupreason,chr(13),''),chr(10),'')  -- 挂账原因
    ,replace(replace(t1.modifytlr,chr(13),''),chr(10),'')  -- 修改柜员
    ,replace(replace(t1.feetype,chr(13),''),chr(10),'')  -- 计费种类
    ,replace(replace(t1.areacd,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.acctchckflg,chr(13),''),chr(10),'')  -- 帐户信息检查标志
    ,replace(replace(t1.servmode,chr(13),''),chr(10),'')  -- 业务类型(0-转账 1-现金)
    ,replace(replace(t1.realtmcdtflg,chr(13),''),chr(10),'')  -- 实时贷记实时入账标志(0允许落地处理 1不允许)
    ,replace(replace(t1.chflag,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.protocolnb,chr(13),''),chr(10),'')  -- 定期借贷记协议号（明细）
    ,replace(replace(t1.resndflg,chr(13),''),chr(10),'')  -- 补发标识(0正常 1补发)
    ,replace(replace(t1.bllind,chr(13),''),chr(10),'')  -- 票据标志
    ,replace(replace(t1.blltp,chr(13),''),chr(10),'')  -- 票据种类
    ,replace(replace(t1.billnb,chr(13),''),chr(10),'')  -- 票据号码
    ,replace(replace(t1.channeldt,chr(13),''),chr(10),'')  -- 渠道日期
    ,replace(replace(t1.tranflowno,chr(13),''),chr(10),'')  -- 渠道流水号
    ,replace(replace(t1.orgnlpksqno,chr(13),''),chr(10),'')  -- 原业务包序号
    ,replace(replace(t1.corprtnid,chr(13),''),chr(10),'')  -- 企业单位代码
    ,replace(replace(t1.pmtitmcd,chr(13),''),chr(10),'')  -- 费项代码
    ,replace(replace(t1.pmtitmnm,chr(13),''),chr(10),'')  -- 费项名称
    ,replace(replace(t1.billamount,chr(13),''),chr(10),'')  -- 业务金额
    ,replace(replace(t1.feeamount,chr(13),''),chr(10),'')  -- 需付款行代扣的手续费
    ,replace(replace(t1.info2,chr(13),''),chr(10),'')  -- 冲账原因
    ,replace(replace(t1.od_flag,chr(13),''),chr(10),'')  -- 是否发生透支 0- 否 1- 是
    ,t1.od_ovtranam  -- 透支金额
    ,replace(replace(t1.toaccountflag,chr(13),''),chr(10),'')  -- 0：不延时 1：延时2小时 2：次日到账 3：延时24小时
    ,replace(replace(t1.autoflag,chr(13),''),chr(10),'')  -- 自动退汇标志 1-自动退汇
    ,replace(replace(t1.autocount,chr(13),''),chr(10),'')  -- 自动退汇次数
    ,replace(replace(t1.automsg,chr(13),''),chr(10),'')  -- 自动退汇信息
    ,replace(replace(t1.bindacct,chr(13),''),chr(10),'')  -- 绑定账户(实体账户)
    ,replace(replace(t1.bindacctnm,chr(13),''),chr(10),'')  -- 绑定账户名(实体账户名)
    ,replace(replace(t1.eflag,chr(13),''),chr(10),'')  -- 1个人e 2企业e
    ,replace(replace(t1.upporderid,chr(13),''),chr(10),'')  -- UPP返回订单标识
    ,replace(replace(t1.intoaccounttype,chr(13),''),chr(10),'')  -- 实际收款人账号类型
    ,replace(replace(t1.accttype,chr(13),''),chr(10),'')  -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,replace(replace(t1.bindacctopnbrn,chr(13),''),chr(10),'')  -- 虚拟账户绑定的账户开户机构
    ,replace(replace(t1.branchid,chr(13),''),chr(10),'')  -- 开户机构
    ,replace(replace(t1.tacctp,chr(13),''),chr(10),'')  -- 账户类别
    ,replace(replace(t1.handleflag,chr(13),''),chr(10),'')  -- 后续操作标志
    ,replace(replace(t1.custno,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(t1.pmtid,chr(13),''),chr(10),'')  -- 协议号
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a68tszfstrx t1    --深同城交易流水表
where t1.etl_dt =to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a68tszfstrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);