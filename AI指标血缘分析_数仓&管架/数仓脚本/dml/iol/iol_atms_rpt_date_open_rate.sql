/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_rpt_date_open_rate
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.atms_rpt_date_open_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_rpt_date_open_rate
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_rpt_date_open_rate_op purge;
drop table ${iol_schema}.atms_rpt_date_open_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_rpt_date_open_rate_op nologging
for exchange with table
${iol_schema}.atms_rpt_date_open_rate;

create table ${iol_schema}.atms_rpt_date_open_rate_cl nologging
for exchange with table
${iol_schema}.atms_rpt_date_open_rate;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_rpt_date_open_rate_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_rpt_date_open_rate_op(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.logic_id, o.logic_id) as logic_id -- 编号
    ,nvl(n.dev_no, o.dev_no) as dev_no -- 设备号
    ,nvl(n.date_time, o.date_time) as date_time -- 日期
    ,nvl(n.full_fun_time, o.full_fun_time) as full_fun_time -- 全功能开机时间
    ,nvl(n.full_rate, o.full_rate) as full_rate -- 全功能开机率
    ,nvl(n.half_fun_time, o.half_fun_time) as half_fun_time -- 半功能开机时间
    ,nvl(n.half_rate, o.half_rate) as half_rate -- 半功能开机率
    ,nvl(n.hard_fault_time, o.hard_fault_time) as hard_fault_time -- 硬故障停机时间
    ,nvl(n.soft_fault_time, o.soft_fault_time) as soft_fault_time -- 软故障停机时间
    ,nvl(n.maintenance_time, o.maintenance_time) as maintenance_time -- 维护时间
    ,nvl(n.comm_failure_time, o.comm_failure_time) as comm_failure_time -- P通讯中断时间
    ,nvl(n.close_time, o.close_time) as close_time -- 关机时间
    ,nvl(n.other_reason_time, o.other_reason_time) as other_reason_time -- 其他原因时间
    ,nvl(n.work_time, o.work_time) as work_time -- 规定工作时间
    ,nvl(n.perfect_rate, o.perfect_rate) as perfect_rate -- 设备完好率（未使用）
    ,nvl(n.service_rate, o.service_rate) as service_rate -- 正常服务率（未使用）
    ,nvl(n.comm_rate, o.comm_rate) as comm_rate -- 通讯完好率（未使用）
    ,nvl(n.stop_time, o.stop_time) as stop_time -- 停机时间
    ,nvl(n.vcomm_failure_time, o.vcomm_failure_time) as vcomm_failure_time -- V通讯中断时间
    ,nvl(n.short_paper_time, o.short_paper_time) as short_paper_time -- 流水打印机缺纸停机时间
    ,nvl(n.cash_gate_time, o.cash_gate_time) as cash_gate_time -- 出钞门故障时间
    ,nvl(n.movement_fail_time, o.movement_fail_time) as movement_fail_time -- 机芯故障时间
    ,case when
            n.logic_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.logic_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.logic_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_rpt_date_open_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_rpt_date_open_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.logic_id = n.logic_id
where (
        o.logic_id is null
    )
    or (
        n.logic_id is null
    )
    or (
        o.dev_no <> n.dev_no
        or o.date_time <> n.date_time
        or o.full_fun_time <> n.full_fun_time
        or o.full_rate <> n.full_rate
        or o.half_fun_time <> n.half_fun_time
        or o.half_rate <> n.half_rate
        or o.hard_fault_time <> n.hard_fault_time
        or o.soft_fault_time <> n.soft_fault_time
        or o.maintenance_time <> n.maintenance_time
        or o.comm_failure_time <> n.comm_failure_time
        or o.close_time <> n.close_time
        or o.other_reason_time <> n.other_reason_time
        or o.work_time <> n.work_time
        or o.perfect_rate <> n.perfect_rate
        or o.service_rate <> n.service_rate
        or o.comm_rate <> n.comm_rate
        or o.stop_time <> n.stop_time
        or o.vcomm_failure_time <> n.vcomm_failure_time
        or o.short_paper_time <> n.short_paper_time
        or o.cash_gate_time <> n.cash_gate_time
        or o.movement_fail_time <> n.movement_fail_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_rpt_date_open_rate_cl(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_rpt_date_open_rate_op(
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
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.logic_id -- 编号
    ,o.dev_no -- 设备号
    ,o.date_time -- 日期
    ,o.full_fun_time -- 全功能开机时间
    ,o.full_rate -- 全功能开机率
    ,o.half_fun_time -- 半功能开机时间
    ,o.half_rate -- 半功能开机率
    ,o.hard_fault_time -- 硬故障停机时间
    ,o.soft_fault_time -- 软故障停机时间
    ,o.maintenance_time -- 维护时间
    ,o.comm_failure_time -- P通讯中断时间
    ,o.close_time -- 关机时间
    ,o.other_reason_time -- 其他原因时间
    ,o.work_time -- 规定工作时间
    ,o.perfect_rate -- 设备完好率（未使用）
    ,o.service_rate -- 正常服务率（未使用）
    ,o.comm_rate -- 通讯完好率（未使用）
    ,o.stop_time -- 停机时间
    ,o.vcomm_failure_time -- V通讯中断时间
    ,o.short_paper_time -- 流水打印机缺纸停机时间
    ,o.cash_gate_time -- 出钞门故障时间
    ,o.movement_fail_time -- 机芯故障时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.atms_rpt_date_open_rate_bk o
    left join ${iol_schema}.atms_rpt_date_open_rate_op n
        on
            o.logic_id = n.logic_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_rpt_date_open_rate_cl d
        on
            o.logic_id = d.logic_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_rpt_date_open_rate;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_rpt_date_open_rate') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_rpt_date_open_rate drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_rpt_date_open_rate add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_rpt_date_open_rate exchange partition p_${batch_date} with table ${iol_schema}.atms_rpt_date_open_rate_cl;
alter table ${iol_schema}.atms_rpt_date_open_rate exchange partition p_20991231 with table ${iol_schema}.atms_rpt_date_open_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_rpt_date_open_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_rpt_date_open_rate_op purge;
drop table ${iol_schema}.atms_rpt_date_open_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_rpt_date_open_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_rpt_date_open_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
