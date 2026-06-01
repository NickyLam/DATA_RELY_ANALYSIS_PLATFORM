/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_trade_record_order
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
drop table ${iol_schema}.bdms_bms_trade_record_order_ex purge;
alter table ${iol_schema}.bdms_bms_trade_record_order add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_bms_trade_record_order;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_bms_trade_record_order_ex nologging
compress
as
select * from ${iol_schema}.bdms_bms_trade_record_order where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_bms_trade_record_order_ex(
    order_id -- 记账交易订单记录表ID
    ,order_no -- 订单号
    ,request_no -- 交易请求号
    ,trade_seq_no -- 交易流水号
    ,top_branch_no -- 所属总行机构号
    ,trans_branch_no -- 交易机构号
    ,trade_no -- 记账交易号
    ,trade_attr_str -- 交易属性字符串
    ,product_no -- 产品号
    ,contract_id -- 协议ID
    ,protocol_no -- 协议号
    ,detail_id -- 明细ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_amount -- 票面金额
    ,amount_reserve1 -- 扩展金额1
    ,amount_reserve2 -- 扩展金额2
    ,amount_reserve3 -- 扩展金额3
    ,recode -- 接口返回码
    ,restatus -- 接口返回类型
    ,remessage -- 接口消息
    ,trade_date -- 交易时间
    ,is_batch_acct -- 是否批次记账  1:是 0:否
    ,status -- 订单请求状态 -- 0:记账失败 1:记账成功 2-记账处理中 3:冲正处理中 4:冲正成功 5:冲正失败
    ,create_time -- 创建时间
    ,update_time -- 创建时间
    ,last_upd_oper_no -- 最后修改操作员号
    ,acct_date -- 记账日期
    ,acct_scene -- 记账扩展场景
    ,extension -- 参与方扩展
    ,reserve1 -- 备注1
    ,reserve2 -- 备注2
    ,reserve3 -- 备注3
    ,reserve4 -- 备注4
    ,acct_branch_no -- 账务机构号
    ,bank_seq_no -- 银行核心记账流水号
    ,sys_code -- 系统编码  BMS:票据4.0  CPES:票交所
    ,bms_draft_id -- 传统票据登记表ID
    ,acct_timestamp -- 记账时间戳
    ,cd_range -- 子票区间
    ,cd_split -- 是否允许分包流转:0-否,1-是
    ,org_draft_id -- 原始票据ID
    ,split_draft_id -- 实际拆前票据ID
    ,src_type -- 票据来源
    ,is_busi_interface -- 是否业务类核心接口：0 否 1 是
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    order_id -- 记账交易订单记录表ID
    ,order_no -- 订单号
    ,request_no -- 交易请求号
    ,trade_seq_no -- 交易流水号
    ,top_branch_no -- 所属总行机构号
    ,trans_branch_no -- 交易机构号
    ,trade_no -- 记账交易号
    ,trade_attr_str -- 交易属性字符串
    ,product_no -- 产品号
    ,contract_id -- 协议ID
    ,protocol_no -- 协议号
    ,detail_id -- 明细ID
    ,draft_id -- 票据ID
    ,draft_number -- 票据号
    ,draft_amount -- 票面金额
    ,amount_reserve1 -- 扩展金额1
    ,amount_reserve2 -- 扩展金额2
    ,amount_reserve3 -- 扩展金额3
    ,recode -- 接口返回码
    ,restatus -- 接口返回类型
    ,remessage -- 接口消息
    ,trade_date -- 交易时间
    ,is_batch_acct -- 是否批次记账  1:是 0:否
    ,status -- 订单请求状态 -- 0:记账失败 1:记账成功 2-记账处理中 3:冲正处理中 4:冲正成功 5:冲正失败
    ,create_time -- 创建时间
    ,update_time -- 创建时间
    ,last_upd_oper_no -- 最后修改操作员号
    ,acct_date -- 记账日期
    ,acct_scene -- 记账扩展场景
    ,extension -- 参与方扩展
    ,reserve1 -- 备注1
    ,reserve2 -- 备注2
    ,reserve3 -- 备注3
    ,reserve4 -- 备注4
    ,acct_branch_no -- 账务机构号
    ,bank_seq_no -- 银行核心记账流水号
    ,sys_code -- 系统编码  BMS:票据4.0  CPES:票交所
    ,bms_draft_id -- 传统票据登记表ID
    ,acct_timestamp -- 记账时间戳
    ,cd_range -- 子票区间
    ,cd_split -- 是否允许分包流转:0-否,1-是
    ,org_draft_id -- 原始票据ID
    ,split_draft_id -- 实际拆前票据ID
    ,src_type -- 票据来源
    ,is_busi_interface -- 是否业务类核心接口：0 否 1 是
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_bms_trade_record_order
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_bms_trade_record_order exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_trade_record_order_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_trade_record_order to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_bms_trade_record_order_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_trade_record_order',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);