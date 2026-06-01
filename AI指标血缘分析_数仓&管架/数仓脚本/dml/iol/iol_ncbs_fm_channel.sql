/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_channel
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
create table ${iol_schema}.ncbs_fm_channel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_channel
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_channel_op purge;
drop table ${iol_schema}.ncbs_fm_channel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_channel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_channel where 0=1;

create table ${iol_schema}.ncbs_fm_channel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_channel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_channel_cl(
            channel_class -- 渠道分类
            ,channel_desc -- 渠道描述
            ,channel_short -- 渠道名称
            ,company -- 法人
            ,system_id -- 系统id
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,counter_flag -- 柜面标志
            ,channel_type -- 渠道细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_channel_op(
            channel_class -- 渠道分类
            ,channel_desc -- 渠道描述
            ,channel_short -- 渠道名称
            ,company -- 法人
            ,system_id -- 系统id
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,counter_flag -- 柜面标志
            ,channel_type -- 渠道细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.channel_class, o.channel_class) as channel_class -- 渠道分类
    ,nvl(n.channel_desc, o.channel_desc) as channel_desc -- 渠道描述
    ,nvl(n.channel_short, o.channel_short) as channel_short -- 渠道名称
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.counter_flag, o.counter_flag) as counter_flag -- 柜面标志
    ,nvl(n.channel_type, o.channel_type) as channel_type -- 渠道细类
    ,case when
            n.channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_channel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_channel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.channel = n.channel
where (
        o.channel is null
    )
    or (
        n.channel is null
    )
    or (
        o.channel_class <> n.channel_class
        or o.channel_desc <> n.channel_desc
        or o.channel_short <> n.channel_short
        or o.company <> n.company
        or o.system_id <> n.system_id
        or o.tran_timestamp <> n.tran_timestamp
        or o.counter_flag <> n.counter_flag
        or o.channel_type <> n.channel_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_channel_cl(
            channel_class -- 渠道分类
            ,channel_desc -- 渠道描述
            ,channel_short -- 渠道名称
            ,company -- 法人
            ,system_id -- 系统id
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,counter_flag -- 柜面标志
            ,channel_type -- 渠道细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_channel_op(
            channel_class -- 渠道分类
            ,channel_desc -- 渠道描述
            ,channel_short -- 渠道名称
            ,company -- 法人
            ,system_id -- 系统id
            ,channel -- 渠道
            ,tran_timestamp -- 交易时间戳
            ,counter_flag -- 柜面标志
            ,channel_type -- 渠道细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.channel_class -- 渠道分类
    ,o.channel_desc -- 渠道描述
    ,o.channel_short -- 渠道名称
    ,o.company -- 法人
    ,o.system_id -- 系统id
    ,o.channel -- 渠道
    ,o.tran_timestamp -- 交易时间戳
    ,o.counter_flag -- 柜面标志
    ,o.channel_type -- 渠道细类
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
from ${iol_schema}.ncbs_fm_channel_bk o
    left join ${iol_schema}.ncbs_fm_channel_op n
        on
            o.channel = n.channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_channel_cl d
        on
            o.channel = d.channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_channel;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_channel') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_channel drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_channel add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_channel exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_channel_cl;
alter table ${iol_schema}.ncbs_fm_channel exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_channel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_channel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_channel_op purge;
drop table ${iol_schema}.ncbs_fm_channel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_channel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_channel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
