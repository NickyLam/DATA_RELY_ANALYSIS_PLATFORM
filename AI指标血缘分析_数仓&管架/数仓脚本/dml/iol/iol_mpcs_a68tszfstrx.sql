/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a68tszfstrx
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a68tszfstrx_ex purge;
alter table ${iol_schema}.mpcs_a68tszfstrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a68tszfstrx;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a68tszfstrx_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a68tszfstrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a68tszfstrx_ex(
    mainseq -- 行内中台流水号
    ,transdt -- 交易日期
    ,businesstrace -- 行内业务序号
    ,pckno -- 报文类型
    ,txtpcd -- 业务类型
    ,txcd -- 业务编号
    ,txid -- 支付交易序号，明细标识号
    ,cnsdt -- 委托日期，明细的委托日期
    ,instgpty -- 委托方
    ,pkgbusinesstrace -- 所属批量包业务序号
    ,pksqno -- 包序号
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,crcycd -- 币种
    ,transamt -- 交易金额
    ,dbtrid -- 付款行行号
    ,sndbrnname -- 付款行行名
    ,cdtrid -- 收款行行号
    ,rcvbrnname -- 收款行行名
    ,payopenbank -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,rcvopenbank -- 收款人开户行行号
    ,rcvopenbanknm -- 收款人开户行名称
    ,rcvacct -- 收款人账号
    ,rcvname -- 收款人名称
    ,rcvaddr -- 收款人地址
    ,orgnltxtpcd -- 原业务类型
    ,orgnlcnsdt -- 原委托日期
    ,orgnltxid -- 原支付交易序号
    ,orgnlinstgpty -- 原委托方
    ,orgnlpkgbustrace -- 原所属包业务序号
    ,netgrnd -- 轧差场次
    ,netgdt -- 轧差日期/终态日期
    ,transt -- 处理状态
    ,iotype -- 往来账标识
    ,flag4 -- 借贷标志
    ,magebrn -- 处理机构
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sendbranch -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,caclrs -- 退汇原因代码
    ,processcode -- 中心返回状态
    ,rspncd -- 中心返回处理码
    ,rspninf -- 中心返回处理码处理说明
    ,rtncd -- 银行返回处理码
    ,rtninf -- 银行返回处理码处理说明
    ,rtrltd -- 回执日期
    ,diskno -- 定期业务批次号
    ,clerdt -- 清算日期
    ,bperno -- 错误代码
    ,bpermg -- 错误信息
    ,levels -- 优先级别
    ,recdes -- 支付密押
    ,chksta -- 对账状态
    ,remark -- 附言
    ,prtcnt -- 打印次数
    ,transmitdt -- 往账：发送时间、转发时间 来账：收到时间
    ,feeflag -- 收费标志
    ,inoutflag -- 行内行外标志    0行外  1行内
    ,sacact -- 挂帐帐号或维护入账帐号
    ,sacana -- 挂帐帐号或维护入账姓名
    ,clendt -- 维护入账日期
    ,clenus -- 维护入账柜员
    ,clrbrn -- 维护入账部门号
    ,edhtno -- 维护入账主机流水号/维护入账冲账主机流水号
    ,edhtdt -- 维护入账主机日期/维护入账冲账主机日期
    ,endtlr -- 维护入账冲账柜员号
    ,prdnbr -- 代理标识 0 本行业务 1 代理他行
    ,bookcd -- 凭证类型
    ,cobkdt -- 委托凭证日期
    ,booknbr -- 委托凭证号
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,transq -- 交易流水套号
    ,sdtrsq -- 发送交易流水
    ,paymod -- 支付方式
    ,opnwin -- 汇兑业务对应的窗口(交易渠道)
    ,feamt1 -- 手续费
    ,feamt2 -- 汇划费
    ,feamt3 -- 工本费
    ,calfee -- 手续费总额
    ,chngti -- 最近修改时间
    ,rcdsta -- 记录状态
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,appenddatadtltab -- 登记附加数据明细的表名
    ,hangupreason -- 挂账原因
    ,modifytlr -- 修改柜员
    ,feetype -- 计费种类
    ,areacd -- 地区代码
    ,acctchckflg -- 帐户信息检查标志
    ,servmode -- 业务类型(0-转账 1-现金)
    ,realtmcdtflg -- 实时贷记实时入账标志(0允许落地处理 1不允许)
    ,chflag -- 钞汇标志
    ,protocolnb -- 定期借贷记协议号（明细）
    ,resndflg -- 补发标识(0正常 1补发)
    ,bllind -- 票据标志
    ,blltp -- 票据种类
    ,billnb -- 票据号码
    ,channeldt -- 渠道日期
    ,tranflowno -- 渠道流水号
    ,orgnlpksqno -- 原业务包序号
    ,corprtnid -- 企业单位代码
    ,pmtitmcd -- 费项代码
    ,pmtitmnm -- 费项名称
    ,billamount -- 业务金额
    ,feeamount -- 需付款行代扣的手续费
    ,info2 -- 冲账原因
    ,od_flag -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam -- 透支金额
    ,toaccountflag -- 0：不延时 1：延时2小时 2：次日到账 3：延时24小时
    ,autoflag -- 自动退汇标志 1-自动退汇
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,bindacct -- 绑定账户(实体账户)
    ,bindacctnm -- 绑定账户名(实体账户名)
    ,eflag -- 1个人e 2企业e
    ,upporderid -- UPP返回订单标识
    ,intoaccounttype -- 实际收款人账号类型
    ,accttype -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn -- 虚拟账户绑定的账户开户机构
    ,branchid -- 开户机构
    ,tacctp -- 账户类别
    ,handleflag -- 后续操作标志
    ,custno -- 客户号
    ,pmtid -- 协议号
    ,chn_id -- 渠道号
    ,globseq -- 全局流水号
    ,srvcallseq -- 渠道流水号
    ,uniqueseq -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainseq -- 行内中台流水号
    ,transdt -- 交易日期
    ,businesstrace -- 行内业务序号
    ,pckno -- 报文类型
    ,txtpcd -- 业务类型
    ,txcd -- 业务编号
    ,txid -- 支付交易序号，明细标识号
    ,cnsdt -- 委托日期，明细的委托日期
    ,instgpty -- 委托方
    ,pkgbusinesstrace -- 所属批量包业务序号
    ,pksqno -- 包序号
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,crcycd -- 币种
    ,transamt -- 交易金额
    ,dbtrid -- 付款行行号
    ,sndbrnname -- 付款行行名
    ,cdtrid -- 收款行行号
    ,rcvbrnname -- 收款行行名
    ,payopenbank -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,rcvopenbank -- 收款人开户行行号
    ,rcvopenbanknm -- 收款人开户行名称
    ,rcvacct -- 收款人账号
    ,rcvname -- 收款人名称
    ,rcvaddr -- 收款人地址
    ,orgnltxtpcd -- 原业务类型
    ,orgnlcnsdt -- 原委托日期
    ,orgnltxid -- 原支付交易序号
    ,orgnlinstgpty -- 原委托方
    ,orgnlpkgbustrace -- 原所属包业务序号
    ,netgrnd -- 轧差场次
    ,netgdt -- 轧差日期/终态日期
    ,transt -- 处理状态
    ,iotype -- 往来账标识
    ,flag4 -- 借贷标志
    ,magebrn -- 处理机构
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sendbranch -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,caclrs -- 退汇原因代码
    ,processcode -- 中心返回状态
    ,rspncd -- 中心返回处理码
    ,rspninf -- 中心返回处理码处理说明
    ,rtncd -- 银行返回处理码
    ,rtninf -- 银行返回处理码处理说明
    ,rtrltd -- 回执日期
    ,diskno -- 定期业务批次号
    ,clerdt -- 清算日期
    ,bperno -- 错误代码
    ,bpermg -- 错误信息
    ,levels -- 优先级别
    ,recdes -- 支付密押
    ,chksta -- 对账状态
    ,remark -- 附言
    ,prtcnt -- 打印次数
    ,transmitdt -- 往账：发送时间、转发时间 来账：收到时间
    ,feeflag -- 收费标志
    ,inoutflag -- 行内行外标志    0行外  1行内
    ,sacact -- 挂帐帐号或维护入账帐号
    ,sacana -- 挂帐帐号或维护入账姓名
    ,clendt -- 维护入账日期
    ,clenus -- 维护入账柜员
    ,clrbrn -- 维护入账部门号
    ,edhtno -- 维护入账主机流水号/维护入账冲账主机流水号
    ,edhtdt -- 维护入账主机日期/维护入账冲账主机日期
    ,endtlr -- 维护入账冲账柜员号
    ,prdnbr -- 代理标识 0 本行业务 1 代理他行
    ,bookcd -- 凭证类型
    ,cobkdt -- 委托凭证日期
    ,booknbr -- 委托凭证号
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,transq -- 交易流水套号
    ,sdtrsq -- 发送交易流水
    ,paymod -- 支付方式
    ,opnwin -- 汇兑业务对应的窗口(交易渠道)
    ,feamt1 -- 手续费
    ,feamt2 -- 汇划费
    ,feamt3 -- 工本费
    ,calfee -- 手续费总额
    ,chngti -- 最近修改时间
    ,rcdsta -- 记录状态
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,appenddatadtltab -- 登记附加数据明细的表名
    ,hangupreason -- 挂账原因
    ,modifytlr -- 修改柜员
    ,feetype -- 计费种类
    ,areacd -- 地区代码
    ,acctchckflg -- 帐户信息检查标志
    ,servmode -- 业务类型(0-转账 1-现金)
    ,realtmcdtflg -- 实时贷记实时入账标志(0允许落地处理 1不允许)
    ,chflag -- 钞汇标志
    ,protocolnb -- 定期借贷记协议号（明细）
    ,resndflg -- 补发标识(0正常 1补发)
    ,bllind -- 票据标志
    ,blltp -- 票据种类
    ,billnb -- 票据号码
    ,channeldt -- 渠道日期
    ,tranflowno -- 渠道流水号
    ,orgnlpksqno -- 原业务包序号
    ,corprtnid -- 企业单位代码
    ,pmtitmcd -- 费项代码
    ,pmtitmnm -- 费项名称
    ,billamount -- 业务金额
    ,feeamount -- 需付款行代扣的手续费
    ,info2 -- 冲账原因
    ,od_flag -- 是否发生透支 0- 否 1- 是
    ,od_ovtranam -- 透支金额
    ,toaccountflag -- 0：不延时 1：延时2小时 2：次日到账 3：延时24小时
    ,autoflag -- 自动退汇标志 1-自动退汇
    ,autocount -- 自动退汇次数
    ,automsg -- 自动退汇信息
    ,bindacct -- 绑定账户(实体账户)
    ,bindacctnm -- 绑定账户名(实体账户名)
    ,eflag -- 1个人e 2企业e
    ,upporderid -- UPP返回订单标识
    ,intoaccounttype -- 实际收款人账号类型
    ,accttype -- 账户类型 EDME-存管+账户 QSTP-广清所
    ,bindacctopnbrn -- 虚拟账户绑定的账户开户机构
    ,branchid -- 开户机构
    ,tacctp -- 账户类别
    ,handleflag -- 后续操作标志
    ,custno -- 客户号
    ,pmtid -- 协议号
    ,chn_id -- 渠道号
    ,globseq -- 全局流水号
    ,srvcallseq -- 渠道流水号
    ,uniqueseq -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a68tszfstrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a68tszfstrx exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a68tszfstrx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a68tszfstrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a68tszfstrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a68tszfstrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);