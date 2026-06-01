/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orms_t21_disclosure
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
create table ${iol_schema}.orms_t21_disclosure_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orms_t21_disclosure
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_disclosure_op purge;
drop table ${iol_schema}.orms_t21_disclosure_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_disclosure_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_disclosure where 0=1;

create table ${iol_schema}.orms_t21_disclosure_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_disclosure where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_disclosure_cl(
            id -- id，主键
            ,name -- 统计事件名称
            ,flag -- 是否有效(0:否，1:是）
            ,pid -- 上级id
            ,seq -- 序号
            ,type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
            ,model -- 关联查询字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_disclosure_op(
            id -- id，主键
            ,name -- 统计事件名称
            ,flag -- 是否有效(0:否，1:是）
            ,pid -- 上级id
            ,seq -- 序号
            ,type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
            ,model -- 关联查询字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- id，主键
    ,nvl(n.name, o.name) as name -- 统计事件名称
    ,nvl(n.flag, o.flag) as flag -- 是否有效(0:否，1:是）
    ,nvl(n.pid, o.pid) as pid -- 上级id
    ,nvl(n.seq, o.seq) as seq -- 序号
    ,nvl(n.type, o.type) as type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
    ,nvl(n.model, o.model) as model -- 关联查询字段
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orms_t21_disclosure_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orms_t21_disclosure where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.name <> n.name
        or o.flag <> n.flag
        or o.pid <> n.pid
        or o.seq <> n.seq
        or o.type <> n.type
        or o.model <> n.model
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_disclosure_cl(
            id -- id，主键
            ,name -- 统计事件名称
            ,flag -- 是否有效(0:否，1:是）
            ,pid -- 上级id
            ,seq -- 序号
            ,type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
            ,model -- 关联查询字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_disclosure_op(
            id -- id，主键
            ,name -- 统计事件名称
            ,flag -- 是否有效(0:否，1:是）
            ,pid -- 上级id
            ,seq -- 序号
            ,type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
            ,model -- 关联查询字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- id，主键
    ,o.name -- 统计事件名称
    ,o.flag -- 是否有效(0:否，1:是）
    ,o.pid -- 上级id
    ,o.seq -- 序号
    ,o.type -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
    ,o.model -- 关联查询字段
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
from ${iol_schema}.orms_t21_disclosure_bk o
    left join ${iol_schema}.orms_t21_disclosure_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orms_t21_disclosure_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.orms_t21_disclosure;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orms_t21_disclosure') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orms_t21_disclosure drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orms_t21_disclosure add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orms_t21_disclosure exchange partition p_${batch_date} with table ${iol_schema}.orms_t21_disclosure_cl;
alter table ${iol_schema}.orms_t21_disclosure exchange partition p_20991231 with table ${iol_schema}.orms_t21_disclosure_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orms_t21_disclosure to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_disclosure_op purge;
drop table ${iol_schema}.orms_t21_disclosure_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orms_t21_disclosure_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orms_t21_disclosure',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
