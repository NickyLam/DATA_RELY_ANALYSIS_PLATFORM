/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_txn_batch_detail
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
drop table ${iol_schema}.ppps_t_txn_batch_detail_ex purge;
alter table ${iol_schema}.ppps_t_txn_batch_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ppps_t_txn_batch_detail;

-- 2.3 insert data to ex table
create table ${iol_schema}.ppps_t_txn_batch_detail_ex nologging
compress
as
select * from ${iol_schema}.ppps_t_txn_batch_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ppps_t_txn_batch_detail_ex(
    id -- 自增主键
    ,global_no -- 全局流水号
    ,batch_no -- 平台批次号
    ,sub_batch_no -- 平台子批次号
    ,detail_no -- 明细序号
    ,txn_no -- 平台流水号
    ,txn_date -- 平台交易日期，格式：yyyyMMdd
    ,txn_time -- 平台交易时间，格式：HHmmss
    ,corporate -- 法人标识
    ,mcht_no -- 商户/支付机构编号
    ,tran_no -- 商户交易流水号
    ,tran_date -- 商户流水日期，格式：yyyyMMdd
    ,tran_time -- 商户流水时间，格式：HHmmss
    ,product_no -- 产品编号
    ,status -- 交易处理状态，取值：StatusEnum
    ,trade_type -- 交易类别，例如：批量代付、批量代收，取值：TradeTypeEnum
    ,biz_type -- 业务类型，例如：水电气缴费
    ,host_batch_no -- 核心批次号
    ,amount -- 交易金额，默认：零元-0.00，单位：元
    ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,account_number -- 支付账号
    ,account_name -- 支付户名
    ,smrycd -- 摘要码，交易代码
    ,opp_account_number -- 对手方账号
    ,opp_account_name -- 对手方账户户名
    ,host_status -- 交易核心账务状态
    ,host_no -- 核心交易流水号
    ,pmc_code -- 请求系统编码
    ,host_req_no -- 核心请求流水号
    ,purpose -- 交易附言
    ,ret_code -- 平台返回码
    ,ret_msg -- 平台返回码描述
    ,teller_no -- 交易柜员号
    ,auth_teller_no -- 授权柜员号
    ,check_teller_no -- 复核柜员号
    ,trans_org_no -- 交易机构号
    ,summary_code -- 交易摘要码
    ,consumer_id -- 调用方系统ID
    ,route_map_id -- 明细扩展MAP编号
    ,route_map -- 明细扩展MAP的JSON串
    ,host_date -- 核心响应日期（会计日期）
    ,host_time -- 核心响应时间（会计时间）
    ,payment_method_type_id -- 支付工具
    ,depend_tran_no -- 依赖流水号
    ,real_amount -- 真实交易金额，默认：零元-0.00，单位：元
    ,book_type -- 记账类型
    ,payment_action -- 支付动作
    ,log_id -- 交易日志文件ID
    ,server_id -- 交易服务器ID
    ,sharding -- 分库参考值专用字段，无业务含义
    ,remark -- 备注信息
    ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,protocol_no -- 收款方协议号
    ,ghb_fee_amount -- 本行手续费
    ,union_fee_amount -- 银联手续费
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 自增主键
    ,global_no -- 全局流水号
    ,batch_no -- 平台批次号
    ,sub_batch_no -- 平台子批次号
    ,detail_no -- 明细序号
    ,txn_no -- 平台流水号
    ,txn_date -- 平台交易日期，格式：yyyyMMdd
    ,txn_time -- 平台交易时间，格式：HHmmss
    ,corporate -- 法人标识
    ,mcht_no -- 商户/支付机构编号
    ,tran_no -- 商户交易流水号
    ,tran_date -- 商户流水日期，格式：yyyyMMdd
    ,tran_time -- 商户流水时间，格式：HHmmss
    ,product_no -- 产品编号
    ,status -- 交易处理状态，取值：StatusEnum
    ,trade_type -- 交易类别，例如：批量代付、批量代收，取值：TradeTypeEnum
    ,biz_type -- 业务类型，例如：水电气缴费
    ,host_batch_no -- 核心批次号
    ,amount -- 交易金额，默认：零元-0.00，单位：元
    ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,account_number -- 支付账号
    ,account_name -- 支付户名
    ,smrycd -- 摘要码，交易代码
    ,opp_account_number -- 对手方账号
    ,opp_account_name -- 对手方账户户名
    ,host_status -- 交易核心账务状态
    ,host_no -- 核心交易流水号
    ,pmc_code -- 请求系统编码
    ,host_req_no -- 核心请求流水号
    ,purpose -- 交易附言
    ,ret_code -- 平台返回码
    ,ret_msg -- 平台返回码描述
    ,teller_no -- 交易柜员号
    ,auth_teller_no -- 授权柜员号
    ,check_teller_no -- 复核柜员号
    ,trans_org_no -- 交易机构号
    ,summary_code -- 交易摘要码
    ,consumer_id -- 调用方系统ID
    ,route_map_id -- 明细扩展MAP编号
    ,route_map -- 明细扩展MAP的JSON串
    ,host_date -- 核心响应日期（会计日期）
    ,host_time -- 核心响应时间（会计时间）
    ,payment_method_type_id -- 支付工具
    ,depend_tran_no -- 依赖流水号
    ,real_amount -- 真实交易金额，默认：零元-0.00，单位：元
    ,book_type -- 记账类型
    ,payment_action -- 支付动作
    ,log_id -- 交易日志文件ID
    ,server_id -- 交易服务器ID
    ,sharding -- 分库参考值专用字段，无业务含义
    ,remark -- 备注信息
    ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,protocol_no -- 收款方协议号
    ,ghb_fee_amount -- 本行手续费
    ,union_fee_amount -- 银联手续费
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ppps_t_txn_batch_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ppps_t_txn_batch_detail exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_txn_batch_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_txn_batch_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ppps_t_txn_batch_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_txn_batch_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);