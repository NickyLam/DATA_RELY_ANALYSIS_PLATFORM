/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_handmade_balance_contract
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
drop table ${iol_schema}.bdms_handmade_balance_contract_ex purge;
alter table ${iol_schema}.bdms_handmade_balance_contract add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.bdms_handmade_balance_contract;

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_handmade_balance_contract_ex nologging
compress
as
select * from ${iol_schema}.bdms_handmade_balance_contract where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_handmade_balance_contract_ex(
    id -- 主键ID
    ,systid -- 系统代号
    ,brchcd -- 财务机构编号
    ,prodcd -- 解析产品
    ,bsnssq -- 全局流水
    ,transq -- 交易流水
    ,trprcd -- 金额类型
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,trade_direct -- 交易方向
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,channel -- 渠道
    ,acct_status -- 记账状态
    ,atfid -- 冲抹原交易流水
    ,trandt -- 交易日期
    ,datex0 -- 交易时间
    ,tfid -- 原交易流水ID
    ,custcd -- 客户号
    ,prcscd -- 交易码
    ,balance_flag -- 余额统计标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,systid -- 系统代号
    ,brchcd -- 财务机构编号
    ,prodcd -- 解析产品
    ,bsnssq -- 全局流水
    ,transq -- 交易流水
    ,trprcd -- 金额类型
    ,crcycd -- 币种
    ,tranam -- 交易金额
    ,trade_direct -- 交易方向
    ,assis1 -- 可售产品
    ,assis2 -- 辅助核算2
    ,channel -- 渠道
    ,acct_status -- 记账状态
    ,atfid -- 冲抹原交易流水
    ,trandt -- 交易日期
    ,datex0 -- 交易时间
    ,tfid -- 原交易流水ID
    ,custcd -- 客户号
    ,prcscd -- 交易码
    ,balance_flag -- 余额统计标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_handmade_balance_contract
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_handmade_balance_contract exchange partition p_${batch_date} with table ${iol_schema}.bdms_handmade_balance_contract_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_handmade_balance_contract to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_handmade_balance_contract_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_handmade_balance_contract',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);