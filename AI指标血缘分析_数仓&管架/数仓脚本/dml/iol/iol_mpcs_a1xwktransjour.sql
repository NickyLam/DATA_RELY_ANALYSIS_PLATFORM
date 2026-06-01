/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1xwktransjour
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
drop table ${iol_schema}.mpcs_a1xwktransjour_ex purge;
alter table ${iol_schema}.mpcs_a1xwktransjour add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a1xwktransjour;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1xwktransjour_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a1xwktransjour where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1xwktransjour_ex(
    fntdt -- 渠道日期
    ,globalseq -- 全局流水号
    ,transcode -- 交易类型 01-充值 02-退卡 03-3DS 99-外卡异步回调
    ,oldtranscode -- 原交易类型 01-充值 02-退卡 03-3DS
    ,txnno -- 银联交易流水号
    ,messageid -- 外卡收单消息ID
    ,orderid -- 外卡收单订单号
    ,reforderid -- 外卡收单关联订单号
    ,txnamt -- 交易金额
    ,txnwkamt -- 外卡交易金额
    ,feeamt -- 外卡手续费
    ,txnccy -- 币种
    ,acctno -- 外卡账号
    ,acctprd -- 外卡账号卡有效期
    ,acctcvn -- 外卡账号卡CVN
    ,phoneno -- 手机号
    ,customid -- 客户ID
    ,baseacctno -- 旅行通账号
    ,custno -- 客户号
    ,acctna -- 账号户名
    ,issinscode -- 机构代码
    ,merchantid -- 商户号
    ,frncurcode -- 币种
    ,frntxnamt -- 外币金额
    ,callbackurl -- 回调地址
    ,authurl -- 3ds认证Url
    ,modetp -- 商户的3DS策略 NEEDED-需要去进行3DS，NONEED-不需要进行3DS
    ,synctype -- 同步方式
    ,code -- 应答码 00-成功 05-超时 08-失败
    ,rspdesc -- 应答信息
    ,authcode -- 授权码
    ,retrievalnumber -- 检索参考号
    ,settldate -- 清算日期
    ,brand -- 卡品牌 VIS, MCC, JCB, AME, CUP, DNC
    ,status -- 状态 0-初始状态 1-成功 2-冲正 4-已发送到第三方支付 5-已发送核心 6-第三方成功 7-核心成功 8-失败 9-第三方异步回调处理中
    ,degree -- 账户等级 1-不记名 2-记名普通 3-记名高级
    ,busiseq -- 业务流水号
    ,transeq -- 交易流水号
    ,hostnbr -- 核心流水
    ,destrnseq -- 3DES认证交易流水号
    ,rtitraceseqno -- 实时智能跟踪流水号
    ,inserttm -- 入库时间
    ,updatetm -- 最新维护时间
    ,callbacktm -- 异步回调时间
    ,hostchkflg -- 核心对账状态 0-未对账 1-成功 2-已冲正 N-不涉及
    ,eci -- 电子商务标识
    ,av -- 身份认证值
    ,dstransactionid -- DS交易标识符
    ,transstatus -- 交易状态标识 Y-平滑模式验证成功 C-挑战模式验证成功 A-尝试验证成功 N-验证未完成，交易失败 U-验证无法进行，交易失败 R-验证被拒绝，交易失败
    ,settleamt -- 清算金额
    ,settlecurrencycode -- 币种
    ,exchangedate -- 兑换日期
    ,exchangerate -- 清算汇率
    ,traceno -- 系统跟踪号
    ,tracetime -- 交易传输时间
    ,hostdate -- 核心日期
    ,queryid -- 交易查询流水号
    ,txntime -- 订单发送时间
    ,bkstatus -- 退款状态 0-未退款 1-已发起退款 2-退款失败 3-退款成功
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,remark6 -- 备注6
    ,remark7 -- 备注7
    ,remark8 -- 备注8
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    fntdt -- 渠道日期
    ,globalseq -- 全局流水号
    ,transcode -- 交易类型 01-充值 02-退卡 03-3DS 99-外卡异步回调
    ,oldtranscode -- 原交易类型 01-充值 02-退卡 03-3DS
    ,txnno -- 银联交易流水号
    ,messageid -- 外卡收单消息ID
    ,orderid -- 外卡收单订单号
    ,reforderid -- 外卡收单关联订单号
    ,txnamt -- 交易金额
    ,txnwkamt -- 外卡交易金额
    ,feeamt -- 外卡手续费
    ,txnccy -- 币种
    ,acctno -- 外卡账号
    ,acctprd -- 外卡账号卡有效期
    ,acctcvn -- 外卡账号卡CVN
    ,phoneno -- 手机号
    ,customid -- 客户ID
    ,baseacctno -- 旅行通账号
    ,custno -- 客户号
    ,acctna -- 账号户名
    ,issinscode -- 机构代码
    ,merchantid -- 商户号
    ,frncurcode -- 币种
    ,frntxnamt -- 外币金额
    ,callbackurl -- 回调地址
    ,authurl -- 3ds认证Url
    ,modetp -- 商户的3DS策略 NEEDED-需要去进行3DS，NONEED-不需要进行3DS
    ,synctype -- 同步方式
    ,code -- 应答码 00-成功 05-超时 08-失败
    ,rspdesc -- 应答信息
    ,authcode -- 授权码
    ,retrievalnumber -- 检索参考号
    ,settldate -- 清算日期
    ,brand -- 卡品牌 VIS, MCC, JCB, AME, CUP, DNC
    ,status -- 状态 0-初始状态 1-成功 2-冲正 4-已发送到第三方支付 5-已发送核心 6-第三方成功 7-核心成功 8-失败 9-第三方异步回调处理中
    ,degree -- 账户等级 1-不记名 2-记名普通 3-记名高级
    ,busiseq -- 业务流水号
    ,transeq -- 交易流水号
    ,hostnbr -- 核心流水
    ,destrnseq -- 3DES认证交易流水号
    ,rtitraceseqno -- 实时智能跟踪流水号
    ,inserttm -- 入库时间
    ,updatetm -- 最新维护时间
    ,callbacktm -- 异步回调时间
    ,hostchkflg -- 核心对账状态 0-未对账 1-成功 2-已冲正 N-不涉及
    ,eci -- 电子商务标识
    ,av -- 身份认证值
    ,dstransactionid -- DS交易标识符
    ,transstatus -- 交易状态标识 Y-平滑模式验证成功 C-挑战模式验证成功 A-尝试验证成功 N-验证未完成，交易失败 U-验证无法进行，交易失败 R-验证被拒绝，交易失败
    ,settleamt -- 清算金额
    ,settlecurrencycode -- 币种
    ,exchangedate -- 兑换日期
    ,exchangerate -- 清算汇率
    ,traceno -- 系统跟踪号
    ,tracetime -- 交易传输时间
    ,hostdate -- 核心日期
    ,queryid -- 交易查询流水号
    ,txntime -- 订单发送时间
    ,bkstatus -- 退款状态 0-未退款 1-已发起退款 2-退款失败 3-退款成功
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,remark6 -- 备注6
    ,remark7 -- 备注7
    ,remark8 -- 备注8
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1xwktransjour
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1xwktransjour exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1xwktransjour_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1xwktransjour to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1xwktransjour_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1xwktransjour',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);