/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1xdztransjour
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
drop table ${iol_schema}.mpcs_a1xdztransjour_ex purge;
alter table ${iol_schema}.mpcs_a1xdztransjour add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a1xdztransjour truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1xdztransjour_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1xdztransjour where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1xdztransjour_ex(
    transdate -- 清算日期
    ,keyid -- 流水唯一KEY
    ,acqinstid -- 代理银行标识码
    ,fwdinstid -- 发送银行标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,priacct -- 主账号
    ,transamt -- 交易金额
    ,acceptamt -- 部分代收时的承兑金额
    ,handfee -- 持卡人交易手续费
    ,msgtype -- 报文类型
    ,procecode -- 交易类型码
    ,mchnttype -- 商户类型
    ,acptermnlid -- 受卡机终端标识码
    ,accptrid -- 受卡方标识码
    ,accttrnameloc -- 受卡方名称地址
    ,retrivarefnum -- 检索参考号
    ,servicecode -- 服务点条件码
    ,authridresp -- 授权应答码
    ,rcvinstid -- 接收银行标识码
    ,oldsystrace -- 原始交易的系统跟踪
    ,respcode -- 交易返回码
    ,tranccy -- 交易货币
    ,posentrymode -- 服务点输入方式
    ,settccy -- 清算货币
    ,settamt -- 清算金额
    ,rate -- 清算汇率
    ,settdate -- 清算日期
    ,ratedate -- 兑换日期
    ,cardholdccy -- 持卡人账户货币
    ,cardholdamt -- 持卡人扣账金额
    ,cardholdrate -- 持卡人扣账汇率
    ,rcvtranfee -- 应收手续费（交易币种）
    ,paytranfee -- 应付手续费（交易币种）
    ,rcvsettfee -- 应收手续费（清算币种）
    ,paysettfee -- 应付手续费（清算币种）
    ,covfee -- 转接服务费
    ,backfee -- 退款交易手续费
    ,sindouchflg -- 单双转换标志
    ,cardseq -- 卡片序列号
    ,termable -- 终端读取能力
    ,iccode -- IC卡条件代码
    ,oldtranstime -- 原始系统日期时间
    ,issurinstid -- 发卡银行标识码
    ,transarea -- 交易地域标志
    ,termtype -- 终端类型
    ,instflg -- 国际信用卡公司/外资银行标识
    ,ectflg -- ECI标志
    ,addfee -- 分期付款附加手续费
    ,reserve -- 保留使用
    ,orderid -- 外部订单号
    ,status -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transdate -- 清算日期
    ,keyid -- 流水唯一KEY
    ,acqinstid -- 代理银行标识码
    ,fwdinstid -- 发送银行标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易传输时间
    ,priacct -- 主账号
    ,transamt -- 交易金额
    ,acceptamt -- 部分代收时的承兑金额
    ,handfee -- 持卡人交易手续费
    ,msgtype -- 报文类型
    ,procecode -- 交易类型码
    ,mchnttype -- 商户类型
    ,acptermnlid -- 受卡机终端标识码
    ,accptrid -- 受卡方标识码
    ,accttrnameloc -- 受卡方名称地址
    ,retrivarefnum -- 检索参考号
    ,servicecode -- 服务点条件码
    ,authridresp -- 授权应答码
    ,rcvinstid -- 接收银行标识码
    ,oldsystrace -- 原始交易的系统跟踪
    ,respcode -- 交易返回码
    ,tranccy -- 交易货币
    ,posentrymode -- 服务点输入方式
    ,settccy -- 清算货币
    ,settamt -- 清算金额
    ,rate -- 清算汇率
    ,settdate -- 清算日期
    ,ratedate -- 兑换日期
    ,cardholdccy -- 持卡人账户货币
    ,cardholdamt -- 持卡人扣账金额
    ,cardholdrate -- 持卡人扣账汇率
    ,rcvtranfee -- 应收手续费（交易币种）
    ,paytranfee -- 应付手续费（交易币种）
    ,rcvsettfee -- 应收手续费（清算币种）
    ,paysettfee -- 应付手续费（清算币种）
    ,covfee -- 转接服务费
    ,backfee -- 退款交易手续费
    ,sindouchflg -- 单双转换标志
    ,cardseq -- 卡片序列号
    ,termable -- 终端读取能力
    ,iccode -- IC卡条件代码
    ,oldtranstime -- 原始系统日期时间
    ,issurinstid -- 发卡银行标识码
    ,transarea -- 交易地域标志
    ,termtype -- 终端类型
    ,instflg -- 国际信用卡公司/外资银行标识
    ,ectflg -- ECI标志
    ,addfee -- 分期付款附加手续费
    ,reserve -- 保留使用
    ,orderid -- 外部订单号
    ,status -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1xdztransjour
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1xdztransjour exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1xdztransjour_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1xdztransjour to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1xdztransjour_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1xdztransjour',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);