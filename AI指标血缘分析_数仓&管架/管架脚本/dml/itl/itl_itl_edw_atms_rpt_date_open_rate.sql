/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_atms_rpt_date_open_rate
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_atms_rpt_date_open_rate drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_atms_rpt_date_open_rate drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_atms_rpt_date_open_rate add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_atms_rpt_date_open_rate partition for (to_date('${batch_date}','yyyymmdd')) (
    logic_id -- 编号
    ,dev_no -- 设备号
    ,date_time -- 日期
    ,full_fun_time -- 全功能开机时间
    ,full_rate -- 全功能开机率
    ,half_fun_time -- 半功能开机时间
    ,half_rate -- 半功能开机率
    ,hard_fault_time -- 硬故障停机时间
    ,soft_fault_time -- 软故障停机时间
    ,maintenance_time -- 维护时间
    ,comm_failure_time -- P通讯中断时间
    ,close_time -- 关机时间
    ,other_reason_time -- 其他原因时间
    ,work_time -- 规定工作时间
    ,perfect_rate -- 设备完好率（未使用）
    ,service_rate -- 正常服务率（未使用）
    ,comm_rate -- 通讯完好率（未使用）
    ,stop_time -- 停机时间
    ,vcomm_failure_time -- V通讯中断时间
    ,short_paper_time -- 流水打印机缺纸停机时间
    ,cash_gate_time -- 出钞门故障时间
    ,movement_fail_time -- 机芯故障时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(logic_id), ' ') as logic_id -- 编号
    ,nvl(trim(dev_no), ' ') as dev_no -- 设备号
    ,nvl(trim(date_time), ' ') as date_time -- 日期
    ,nvl(trim(full_fun_time), 0) as full_fun_time -- 全功能开机时间
    ,nvl(trim(full_rate), 0) as full_rate -- 全功能开机率
    ,nvl(trim(half_fun_time), 0) as half_fun_time -- 半功能开机时间
    ,nvl(trim(half_rate), 0) as half_rate -- 半功能开机率
    ,nvl(trim(hard_fault_time), 0) as hard_fault_time -- 硬故障停机时间
    ,nvl(trim(soft_fault_time), 0) as soft_fault_time -- 软故障停机时间
    ,nvl(trim(maintenance_time), 0) as maintenance_time -- 维护时间
    ,nvl(trim(comm_failure_time), 0) as comm_failure_time -- P通讯中断时间
    ,nvl(trim(close_time), 0) as close_time -- 关机时间
    ,nvl(trim(other_reason_time), 0) as other_reason_time -- 其他原因时间
    ,nvl(trim(work_time), 0) as work_time -- 规定工作时间
    ,nvl(trim(perfect_rate), 0) as perfect_rate -- 设备完好率（未使用）
    ,nvl(trim(service_rate), 0) as service_rate -- 正常服务率（未使用）
    ,nvl(trim(comm_rate), 0) as comm_rate -- 通讯完好率（未使用）
    ,nvl(trim(stop_time), 0) as stop_time -- 停机时间
    ,nvl(trim(vcomm_failure_time), 0) as vcomm_failure_time -- V通讯中断时间
    ,nvl(trim(short_paper_time), 0) as short_paper_time -- 流水打印机缺纸停机时间
    ,nvl(trim(cash_gate_time), 0) as cash_gate_time -- 出钞门故障时间
    ,nvl(trim(movement_fail_time), 0) as movement_fail_time -- 机芯故障时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_atms_rpt_date_open_rate
 where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
 
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_atms_rpt_date_open_rate to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_atms_rpt_date_open_rate',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);