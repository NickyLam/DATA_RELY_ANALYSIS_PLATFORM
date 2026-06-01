/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_neeqsindustriescode
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
create table ${iol_schema}.wind_neeqsindustriescode_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_neeqsindustriescode
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_neeqsindustriescode_op purge;
drop table ${iol_schema}.wind_neeqsindustriescode_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsindustriescode_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_neeqsindustriescode where 0=1;

create table ${iol_schema}.wind_neeqsindustriescode_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_neeqsindustriescode where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_neeqsindustriescode_cl(
            object_id -- 对象ID
            ,industriescode -- 板块代码
            ,industriesname -- 板块名称
            ,levelnum -- 级数
            ,used -- 是否使用
            ,industriesalias -- 板块别名
            ,sequence1 -- 展示序号
            ,memo -- [内部]备注
            ,chinesedefinition -- 板块中文定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_neeqsindustriescode_op(
            object_id -- 对象ID
            ,industriescode -- 板块代码
            ,industriesname -- 板块名称
            ,levelnum -- 级数
            ,used -- 是否使用
            ,industriesalias -- 板块别名
            ,sequence1 -- 展示序号
            ,memo -- [内部]备注
            ,chinesedefinition -- 板块中文定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.industriescode, o.industriescode) as industriescode -- 板块代码
    ,nvl(n.industriesname, o.industriesname) as industriesname -- 板块名称
    ,nvl(n.levelnum, o.levelnum) as levelnum -- 级数
    ,nvl(n.used, o.used) as used -- 是否使用
    ,nvl(n.industriesalias, o.industriesalias) as industriesalias -- 板块别名
    ,nvl(n.sequence1, o.sequence1) as sequence1 -- 展示序号
    ,nvl(n.memo, o.memo) as memo -- [内部]备注
    ,nvl(n.chinesedefinition, o.chinesedefinition) as chinesedefinition -- 板块中文定义
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_neeqsindustriescode_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_neeqsindustriescode where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.industriescode <> n.industriescode
        or o.industriesname <> n.industriesname
        or o.levelnum <> n.levelnum
        or o.used <> n.used
        or o.industriesalias <> n.industriesalias
        or o.sequence1 <> n.sequence1
        or o.memo <> n.memo
        or o.chinesedefinition <> n.chinesedefinition
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_neeqsindustriescode_cl(
            object_id -- 对象ID
            ,industriescode -- 板块代码
            ,industriesname -- 板块名称
            ,levelnum -- 级数
            ,used -- 是否使用
            ,industriesalias -- 板块别名
            ,sequence1 -- 展示序号
            ,memo -- [内部]备注
            ,chinesedefinition -- 板块中文定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_neeqsindustriescode_op(
            object_id -- 对象ID
            ,industriescode -- 板块代码
            ,industriesname -- 板块名称
            ,levelnum -- 级数
            ,used -- 是否使用
            ,industriesalias -- 板块别名
            ,sequence1 -- 展示序号
            ,memo -- [内部]备注
            ,chinesedefinition -- 板块中文定义
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.industriescode -- 板块代码
    ,o.industriesname -- 板块名称
    ,o.levelnum -- 级数
    ,o.used -- 是否使用
    ,o.industriesalias -- 板块别名
    ,o.sequence1 -- 展示序号
    ,o.memo -- [内部]备注
    ,o.chinesedefinition -- 板块中文定义
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
from ${iol_schema}.wind_neeqsindustriescode_bk o
    left join ${iol_schema}.wind_neeqsindustriescode_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_neeqsindustriescode_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_neeqsindustriescode;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_neeqsindustriescode') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_neeqsindustriescode drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_neeqsindustriescode add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_neeqsindustriescode exchange partition p_${batch_date} with table ${iol_schema}.wind_neeqsindustriescode_cl;
alter table ${iol_schema}.wind_neeqsindustriescode exchange partition p_20991231 with table ${iol_schema}.wind_neeqsindustriescode_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_neeqsindustriescode to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_neeqsindustriescode_op purge;
drop table ${iol_schema}.wind_neeqsindustriescode_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_neeqsindustriescode_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_neeqsindustriescode',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
