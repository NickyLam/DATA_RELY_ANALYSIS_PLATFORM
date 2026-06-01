/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1stdcpstrx
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
drop table ${iol_schema}.mpcs_a1stdcpstrx_ex purge;
alter table ${iol_schema}.mpcs_a1stdcpstrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a1stdcpstrx;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1stdcpstrx_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a1stdcpstrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1stdcpstrx_ex(
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndbrnlei -- 发起机构LEI码
    ,rcvbrn -- 接收行
    ,rcvbrnlei -- 接收机构LEI码
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,batchid -- 交易批次号
    ,businesstrace -- 行内业务序号
    ,fronttrcd -- 中台交易码
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,iotype -- 往来标识:0-往，1-来
    ,cdflag -- 借贷标记:D-借，C-贷
    ,feeflag -- 手续费标志:0-无
    ,feeamt -- 手续费用金额
    ,hosttrcd -- 金融交易码
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payaccttp -- 付款人账户类型
    ,payacct -- 付款人账号钱包
    ,payname -- 付款人名称
    ,incoopenbank -- 收款人开户行行号
    ,incoopenbanknm -- 收款人开户行名称
    ,incoaccttp -- 收款人账户类型
    ,incoacct -- 收款人账号钱包
    ,inconame -- 收款人名称
    ,cdtrwltlvl -- 钱包等级
    ,cdtrwlttp -- 钱包类型
    ,cdtrwltnm -- 钱包名称
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,transaction -- 交易用途\交易资金来源
    ,sgnno -- 挂接协议号
    ,oraconsigndt -- 原委托日期
    ,oratransseq -- 原报文标识号
    ,orasndbrn -- 原发起行
    ,orapckno -- 原报文类型
    ,dsptrsncd -- 差错原因码
    ,dsptrsndesc -- 差错原因说明
    ,dsptamt -- 调账金额
    ,oprbrn -- 开户机构
    ,oprtlr -- 交易柜员
    ,info -- 附言
    ,note -- 备注
    ,opnwin -- 交易渠道
    ,msgno -- 通信级标识号
    ,refmsgno -- 通信级参考号
    ,errcode -- 行里错误码
    ,errms -- 行里错误信息
    ,rcvdt -- 回执交易日期
    ,rcvtm -- 回执交易时间
    ,msgid -- 回执报文标识号
    ,msgtp -- 回执报文类型
    ,prcsts -- 业务状态
    ,prccd -- 业务处理码
    ,processcode -- 业务回执状态
    ,rejectcode -- 业务拒绝码
    ,rejectinfo -- 业务拒绝信息
    ,transmitdt -- 业务处理时间
    ,chkprodstatus -- 业务对账状态
    ,chkhoststatus -- 金融对账状态
    ,status -- 交易状态
    ,fill -- 交易结果说明
    ,changtime -- 更新时间
    ,magebrn -- 管理机构
    ,accttp -- 账户类型
    ,globalseqno -- 全局流水号
    ,srcsysssn -- 统一支付渠道流水号
    ,returncode -- ESC接口返回码
    ,returnmsg -- ESC接口返回信息
    ,transseqno -- ESC接口交易流水号
    ,finmainseq -- 金融表中台流水
    ,fintransdt -- 金融表中台日期
    ,recnt -- 记账/冲正处理次数
    ,uniqueseqnum -- 业务流水号
    ,procflag -- 处理标志  1-处理中
    ,begintm -- 交易开始时间
    ,endtm -- 交易结束时间
    ,payresdttp -- 付款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,payctrycode -- 付款用户常驻国家/地区代码
    ,rcvresdttp -- 收款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,rcvctrycode -- 收款用户常驻国家/地区代码
    ,phnctrycode -- 钱包注册手机号所在国家/地区代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    syscd -- 系统码
    ,mainseq -- 中台流水
    ,transdt -- 中台日期
    ,transtm -- 中台时间
    ,pckno -- 报文类型
    ,sndbrn -- 发送行
    ,sndbrnlei -- 发起机构LEI码
    ,rcvbrn -- 接收行
    ,rcvbrnlei -- 接收机构LEI码
    ,consigndt -- 委托日期
    ,transseq -- 报文标识号
    ,batchid -- 交易批次号
    ,businesstrace -- 行内业务序号
    ,fronttrcd -- 中台交易码
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,iotype -- 往来标识:0-往，1-来
    ,cdflag -- 借贷标记:D-借，C-贷
    ,feeflag -- 手续费标志:0-无
    ,feeamt -- 手续费用金额
    ,hosttrcd -- 金融交易码
    ,hostdate -- 金融交易日期
    ,hostnbr -- 金融交易流水
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payaccttp -- 付款人账户类型
    ,payacct -- 付款人账号钱包
    ,payname -- 付款人名称
    ,incoopenbank -- 收款人开户行行号
    ,incoopenbanknm -- 收款人开户行名称
    ,incoaccttp -- 收款人账户类型
    ,incoacct -- 收款人账号钱包
    ,inconame -- 收款人名称
    ,cdtrwltlvl -- 钱包等级
    ,cdtrwlttp -- 钱包类型
    ,cdtrwltnm -- 钱包名称
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,transaction -- 交易用途\交易资金来源
    ,sgnno -- 挂接协议号
    ,oraconsigndt -- 原委托日期
    ,oratransseq -- 原报文标识号
    ,orasndbrn -- 原发起行
    ,orapckno -- 原报文类型
    ,dsptrsncd -- 差错原因码
    ,dsptrsndesc -- 差错原因说明
    ,dsptamt -- 调账金额
    ,oprbrn -- 开户机构
    ,oprtlr -- 交易柜员
    ,info -- 附言
    ,note -- 备注
    ,opnwin -- 交易渠道
    ,msgno -- 通信级标识号
    ,refmsgno -- 通信级参考号
    ,errcode -- 行里错误码
    ,errms -- 行里错误信息
    ,rcvdt -- 回执交易日期
    ,rcvtm -- 回执交易时间
    ,msgid -- 回执报文标识号
    ,msgtp -- 回执报文类型
    ,prcsts -- 业务状态
    ,prccd -- 业务处理码
    ,processcode -- 业务回执状态
    ,rejectcode -- 业务拒绝码
    ,rejectinfo -- 业务拒绝信息
    ,transmitdt -- 业务处理时间
    ,chkprodstatus -- 业务对账状态
    ,chkhoststatus -- 金融对账状态
    ,status -- 交易状态
    ,fill -- 交易结果说明
    ,changtime -- 更新时间
    ,magebrn -- 管理机构
    ,accttp -- 账户类型
    ,globalseqno -- 全局流水号
    ,srcsysssn -- 统一支付渠道流水号
    ,returncode -- ESC接口返回码
    ,returnmsg -- ESC接口返回信息
    ,transseqno -- ESC接口交易流水号
    ,finmainseq -- 金融表中台流水
    ,fintransdt -- 金融表中台日期
    ,recnt -- 记账/冲正处理次数
    ,uniqueseqnum -- 业务流水号
    ,procflag -- 处理标志  1-处理中
    ,begintm -- 交易开始时间
    ,endtm -- 交易结束时间
    ,payresdttp -- 付款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,payctrycode -- 付款用户常驻国家/地区代码
    ,rcvresdttp -- 收款用户居民类型  RT01/REST01: 境内居民;RT02/REST02: 境内非居民;RT03/REST03: 境外居民;RT04/REST04: 境外非居民
    ,rcvctrycode -- 收款用户常驻国家/地区代码
    ,phnctrycode -- 钱包注册手机号所在国家/地区代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1stdcpstrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1stdcpstrx exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1stdcpstrx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1stdcpstrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1stdcpstrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1stdcpstrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);