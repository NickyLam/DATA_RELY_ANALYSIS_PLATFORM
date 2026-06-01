/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_online_flow_task_lhdk
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
create table ${iol_schema}.icms_online_flow_task_lhdk_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_online_flow_task_lhdk
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_flow_task_lhdk_op purge;
drop table ${iol_schema}.icms_online_flow_task_lhdk_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_flow_task_lhdk_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_flow_task_lhdk where 0=1;

create table ${iol_schema}.icms_online_flow_task_lhdk_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_online_flow_task_lhdk where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_flow_task_lhdk_cl(
            serialno -- 流程节点编号
            ,objectno -- 流程对象编号
            ,uniqueid -- 唯一标识
            ,stage -- 产品阶段
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,flowname -- 流程模型名称
            ,phaseno -- 当前阶段编号
            ,phasename -- 当前阶段名称
            ,phasestatus -- 当前阶段状态
            ,endtime -- 结束时间
            ,msg -- 报错详情
            ,productid -- 产品编号
            ,otherparam -- 其他参数
            ,applydate -- 授信时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_flow_task_lhdk_op(
            serialno -- 流程节点编号
            ,objectno -- 流程对象编号
            ,uniqueid -- 唯一标识
            ,stage -- 产品阶段
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,flowname -- 流程模型名称
            ,phaseno -- 当前阶段编号
            ,phasename -- 当前阶段名称
            ,phasestatus -- 当前阶段状态
            ,endtime -- 结束时间
            ,msg -- 报错详情
            ,productid -- 产品编号
            ,otherparam -- 其他参数
            ,applydate -- 授信时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流程节点编号
    ,nvl(n.objectno, o.objectno) as objectno -- 流程对象编号
    ,nvl(n.uniqueid, o.uniqueid) as uniqueid -- 唯一标识
    ,nvl(n.stage, o.stage) as stage -- 产品阶段
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 上一流水号字段
    ,nvl(n.flowno, o.flowno) as flowno -- 流程模型编号
    ,nvl(n.flowname, o.flowname) as flowname -- 流程模型名称
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 当前阶段编号
    ,nvl(n.phasename, o.phasename) as phasename -- 当前阶段名称
    ,nvl(n.phasestatus, o.phasestatus) as phasestatus -- 当前阶段状态
    ,nvl(n.endtime, o.endtime) as endtime -- 结束时间
    ,nvl(n.msg, o.msg) as msg -- 报错详情
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.otherparam, o.otherparam) as otherparam -- 其他参数
    ,nvl(n.applydate, o.applydate) as applydate -- 授信时间
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_online_flow_task_lhdk_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_online_flow_task_lhdk where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objectno <> n.objectno
        or o.uniqueid <> n.uniqueid
        or o.stage <> n.stage
        or o.relativeserialno <> n.relativeserialno
        or o.flowno <> n.flowno
        or o.flowname <> n.flowname
        or o.phaseno <> n.phaseno
        or o.phasename <> n.phasename
        or o.phasestatus <> n.phasestatus
        or o.endtime <> n.endtime
        or o.msg <> n.msg
        or o.productid <> n.productid
        or o.otherparam <> n.otherparam
        or o.applydate <> n.applydate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_online_flow_task_lhdk_cl(
            serialno -- 流程节点编号
            ,objectno -- 流程对象编号
            ,uniqueid -- 唯一标识
            ,stage -- 产品阶段
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,flowname -- 流程模型名称
            ,phaseno -- 当前阶段编号
            ,phasename -- 当前阶段名称
            ,phasestatus -- 当前阶段状态
            ,endtime -- 结束时间
            ,msg -- 报错详情
            ,productid -- 产品编号
            ,otherparam -- 其他参数
            ,applydate -- 授信时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_online_flow_task_lhdk_op(
            serialno -- 流程节点编号
            ,objectno -- 流程对象编号
            ,uniqueid -- 唯一标识
            ,stage -- 产品阶段
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,flowname -- 流程模型名称
            ,phaseno -- 当前阶段编号
            ,phasename -- 当前阶段名称
            ,phasestatus -- 当前阶段状态
            ,endtime -- 结束时间
            ,msg -- 报错详情
            ,productid -- 产品编号
            ,otherparam -- 其他参数
            ,applydate -- 授信时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流程节点编号
    ,o.objectno -- 流程对象编号
    ,o.uniqueid -- 唯一标识
    ,o.stage -- 产品阶段
    ,o.relativeserialno -- 上一流水号字段
    ,o.flowno -- 流程模型编号
    ,o.flowname -- 流程模型名称
    ,o.phaseno -- 当前阶段编号
    ,o.phasename -- 当前阶段名称
    ,o.phasestatus -- 当前阶段状态
    ,o.endtime -- 结束时间
    ,o.msg -- 报错详情
    ,o.productid -- 产品编号
    ,o.otherparam -- 其他参数
    ,o.applydate -- 授信时间
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
from ${iol_schema}.icms_online_flow_task_lhdk_bk o
    left join ${iol_schema}.icms_online_flow_task_lhdk_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_online_flow_task_lhdk_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_online_flow_task_lhdk;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_online_flow_task_lhdk') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_online_flow_task_lhdk drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_online_flow_task_lhdk add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_online_flow_task_lhdk exchange partition p_${batch_date} with table ${iol_schema}.icms_online_flow_task_lhdk_cl;
alter table ${iol_schema}.icms_online_flow_task_lhdk exchange partition p_20991231 with table ${iol_schema}.icms_online_flow_task_lhdk_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_online_flow_task_lhdk to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_online_flow_task_lhdk_op purge;
drop table ${iol_schema}.icms_online_flow_task_lhdk_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_online_flow_task_lhdk_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_online_flow_task_lhdk',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
