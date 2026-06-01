/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_htes_buss_msg_log
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
drop table ${iol_schema}.bdms_htes_buss_msg_log_ex purge;
alter table ${iol_schema}.bdms_htes_buss_msg_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_htes_buss_msg_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_htes_buss_msg_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_htes_buss_msg_log where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_htes_buss_msg_log_ex(
    id -- ID
    ,buss_id -- 报文解析表ID
    ,txn_sender -- 交易发送方
    ,txn_rceiver -- 交易接收方
    ,msg_id -- 报文标识号
    ,msg_dt -- 交易日期
    ,msg_tm -- 交易时间
    ,msg_no -- 报文编号
    ,orgnl_msg_id -- 原始报文号
    ,orgnl_msg_dt -- 原始报文日期
    ,orgnl_msg_tm -- 原始报文时间
    ,txn_status -- 交易状态： 00 处理中 01 处理完成 02 处理失败 03 处理异常 04 自动清退 05 核对差错处理补收成功
    ,reserver1 -- 保留域1
    ,reserver2 -- 预留域2
    ,last_upd_time -- 最后修改时间
    ,last_upd_txn_id -- 最后交易ID
    ,buss_flag -- 报文方向： 01 发送 02 接收 03 通知
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,last_upd_opr -- 最后更新人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- ID
    ,buss_id -- 报文解析表ID
    ,txn_sender -- 交易发送方
    ,txn_rceiver -- 交易接收方
    ,msg_id -- 报文标识号
    ,msg_dt -- 交易日期
    ,msg_tm -- 交易时间
    ,msg_no -- 报文编号
    ,orgnl_msg_id -- 原始报文号
    ,orgnl_msg_dt -- 原始报文日期
    ,orgnl_msg_tm -- 原始报文时间
    ,txn_status -- 交易状态： 00 处理中 01 处理完成 02 处理失败 03 处理异常 04 自动清退 05 核对差错处理补收成功
    ,reserver1 -- 保留域1
    ,reserver2 -- 预留域2
    ,last_upd_time -- 最后修改时间
    ,last_upd_txn_id -- 最后交易ID
    ,buss_flag -- 报文方向： 01 发送 02 接收 03 通知
    ,create_by -- 创建人
    ,create_time -- 创建时间
    ,last_upd_opr -- 最后更新人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_htes_buss_msg_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_htes_buss_msg_log exchange partition p_${batch_date} with table ${iol_schema}.bdms_htes_buss_msg_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_htes_buss_msg_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_htes_buss_msg_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_htes_buss_msg_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);