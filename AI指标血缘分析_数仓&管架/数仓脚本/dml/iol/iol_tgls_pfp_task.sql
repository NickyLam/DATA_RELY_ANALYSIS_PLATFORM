/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_pfp_task
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
create table ${iol_schema}.tgls_pfp_task_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_pfp_task
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pfp_task_op purge;
drop table ${iol_schema}.tgls_pfp_task_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pfp_task_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pfp_task where 0=1;

create table ${iol_schema}.tgls_pfp_task_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_pfp_task where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pfp_task_cl(
            stacid -- 账套
            ,acptyr -- 年份
            ,brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
            ,middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
            ,resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
            ,orderi -- 分配顺序号
            ,pfrtvl -- 利润分配比例百分数
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pfp_task_op(
            stacid -- 账套
            ,acptyr -- 年份
            ,brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
            ,middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
            ,resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
            ,orderi -- 分配顺序号
            ,pfrtvl -- 利润分配比例百分数
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.acptyr, o.acptyr) as acptyr -- 年份
    ,nvl(n.brchcd, o.brchcd) as brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
    ,nvl(n.middit, o.middit) as middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
    ,nvl(n.resuit, o.resuit) as resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
    ,nvl(n.orderi, o.orderi) as orderi -- 分配顺序号
    ,nvl(n.pfrtvl, o.pfrtvl) as pfrtvl -- 利润分配比例百分数
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,case when
            n.stacid is null
            and n.acptyr is null
            and n.brchcd is null
            and n.middit is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.acptyr is null
            and n.brchcd is null
            and n.middit is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.acptyr is null
            and n.brchcd is null
            and n.middit is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_pfp_task_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_pfp_task where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.acptyr = n.acptyr
            and o.brchcd = n.brchcd
            and o.middit = n.middit
where (
        o.stacid is null
        and o.acptyr is null
        and o.brchcd is null
        and o.middit is null
    )
    or (
        n.stacid is null
        and n.acptyr is null
        and n.brchcd is null
        and n.middit is null
    )
    or (
        o.resuit <> n.resuit
        or o.orderi <> n.orderi
        or o.pfrtvl <> n.pfrtvl
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_pfp_task_cl(
            stacid -- 账套
            ,acptyr -- 年份
            ,brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
            ,middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
            ,resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
            ,orderi -- 分配顺序号
            ,pfrtvl -- 利润分配比例百分数
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_pfp_task_op(
            stacid -- 账套
            ,acptyr -- 年份
            ,brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
            ,middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
            ,resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
            ,orderi -- 分配顺序号
            ,pfrtvl -- 利润分配比例百分数
            ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.acptyr -- 年份
    ,o.brchcd -- 机构编号(从pfp_brch中取，为损益结转的后未分配归属机构)
    ,o.middit -- 利润分配的中间科目编号,如利润分配-提取盈余公积
    ,o.resuit -- 利润分配的最终科目编号,如盈余公积-一般盈余公积
    ,o.orderi -- 分配顺序号
    ,o.pfrtvl -- 利润分配比例百分数
    ,o.remark -- 备注
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
from ${iol_schema}.tgls_pfp_task_bk o
    left join ${iol_schema}.tgls_pfp_task_op n
        on
            o.stacid = n.stacid
            and o.acptyr = n.acptyr
            and o.brchcd = n.brchcd
            and o.middit = n.middit
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_pfp_task_cl d
        on
            o.stacid = d.stacid
            and o.acptyr = d.acptyr
            and o.brchcd = d.brchcd
            and o.middit = d.middit
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_pfp_task;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_pfp_task') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_pfp_task drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_pfp_task add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_pfp_task exchange partition p_${batch_date} with table ${iol_schema}.tgls_pfp_task_cl;
alter table ${iol_schema}.tgls_pfp_task exchange partition p_20991231 with table ${iol_schema}.tgls_pfp_task_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_pfp_task to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_pfp_task_op purge;
drop table ${iol_schema}.tgls_pfp_task_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_pfp_task_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_pfp_task',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
