/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_oss_ope_lot_num
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
create table ${iol_schema}.osbs_oss_ope_lot_num_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_oss_ope_lot_num
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_oss_ope_lot_num_op purge;
drop table ${iol_schema}.osbs_oss_ope_lot_num_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_oss_ope_lot_num_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_oss_ope_lot_num where 0=1;

create table ${iol_schema}.osbs_oss_ope_lot_num_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_oss_ope_lot_num where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_oss_ope_lot_num_cl(
            id -- 主键序号
            ,ecif_no -- 客户号
            ,act_no -- 关联活动序号
            ,tas_no -- 任务序号
            ,pro_no -- 产品序号
            ,safe_no -- 补送维护序号
            ,lot_num -- 抽奖次数
            ,get_time -- 获取时间
            ,get_channel -- 获取渠道 0 通过任务形式 1 补送维护
            ,is_use -- 是否使用 0 未使用 1 已使用
            ,oss_efetimestart -- 生效开始时间
            ,oss_efetimeend -- 生效结束时间
            ,oss_createtime -- 创建时间
            ,oss_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_oss_ope_lot_num_op(
            id -- 主键序号
            ,ecif_no -- 客户号
            ,act_no -- 关联活动序号
            ,tas_no -- 任务序号
            ,pro_no -- 产品序号
            ,safe_no -- 补送维护序号
            ,lot_num -- 抽奖次数
            ,get_time -- 获取时间
            ,get_channel -- 获取渠道 0 通过任务形式 1 补送维护
            ,is_use -- 是否使用 0 未使用 1 已使用
            ,oss_efetimestart -- 生效开始时间
            ,oss_efetimeend -- 生效结束时间
            ,oss_createtime -- 创建时间
            ,oss_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键序号
    ,nvl(n.ecif_no, o.ecif_no) as ecif_no -- 客户号
    ,nvl(n.act_no, o.act_no) as act_no -- 关联活动序号
    ,nvl(n.tas_no, o.tas_no) as tas_no -- 任务序号
    ,nvl(n.pro_no, o.pro_no) as pro_no -- 产品序号
    ,nvl(n.safe_no, o.safe_no) as safe_no -- 补送维护序号
    ,nvl(n.lot_num, o.lot_num) as lot_num -- 抽奖次数
    ,nvl(n.get_time, o.get_time) as get_time -- 获取时间
    ,nvl(n.get_channel, o.get_channel) as get_channel -- 获取渠道 0 通过任务形式 1 补送维护
    ,nvl(n.is_use, o.is_use) as is_use -- 是否使用 0 未使用 1 已使用
    ,nvl(n.oss_efetimestart, o.oss_efetimestart) as oss_efetimestart -- 生效开始时间
    ,nvl(n.oss_efetimeend, o.oss_efetimeend) as oss_efetimeend -- 生效结束时间
    ,nvl(n.oss_createtime, o.oss_createtime) as oss_createtime -- 创建时间
    ,nvl(n.oss_updatetime, o.oss_updatetime) as oss_updatetime -- 修改时间
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
from (select * from ${iol_schema}.osbs_oss_ope_lot_num_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_oss_ope_lot_num where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.ecif_no <> n.ecif_no
        or o.act_no <> n.act_no
        or o.tas_no <> n.tas_no
        or o.pro_no <> n.pro_no
        or o.safe_no <> n.safe_no
        or o.lot_num <> n.lot_num
        or o.get_time <> n.get_time
        or o.get_channel <> n.get_channel
        or o.is_use <> n.is_use
        or o.oss_efetimestart <> n.oss_efetimestart
        or o.oss_efetimeend <> n.oss_efetimeend
        or o.oss_createtime <> n.oss_createtime
        or o.oss_updatetime <> n.oss_updatetime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_oss_ope_lot_num_cl(
            id -- 主键序号
            ,ecif_no -- 客户号
            ,act_no -- 关联活动序号
            ,tas_no -- 任务序号
            ,pro_no -- 产品序号
            ,safe_no -- 补送维护序号
            ,lot_num -- 抽奖次数
            ,get_time -- 获取时间
            ,get_channel -- 获取渠道 0 通过任务形式 1 补送维护
            ,is_use -- 是否使用 0 未使用 1 已使用
            ,oss_efetimestart -- 生效开始时间
            ,oss_efetimeend -- 生效结束时间
            ,oss_createtime -- 创建时间
            ,oss_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_oss_ope_lot_num_op(
            id -- 主键序号
            ,ecif_no -- 客户号
            ,act_no -- 关联活动序号
            ,tas_no -- 任务序号
            ,pro_no -- 产品序号
            ,safe_no -- 补送维护序号
            ,lot_num -- 抽奖次数
            ,get_time -- 获取时间
            ,get_channel -- 获取渠道 0 通过任务形式 1 补送维护
            ,is_use -- 是否使用 0 未使用 1 已使用
            ,oss_efetimestart -- 生效开始时间
            ,oss_efetimeend -- 生效结束时间
            ,oss_createtime -- 创建时间
            ,oss_updatetime -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键序号
    ,o.ecif_no -- 客户号
    ,o.act_no -- 关联活动序号
    ,o.tas_no -- 任务序号
    ,o.pro_no -- 产品序号
    ,o.safe_no -- 补送维护序号
    ,o.lot_num -- 抽奖次数
    ,o.get_time -- 获取时间
    ,o.get_channel -- 获取渠道 0 通过任务形式 1 补送维护
    ,o.is_use -- 是否使用 0 未使用 1 已使用
    ,o.oss_efetimestart -- 生效开始时间
    ,o.oss_efetimeend -- 生效结束时间
    ,o.oss_createtime -- 创建时间
    ,o.oss_updatetime -- 修改时间
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
from ${iol_schema}.osbs_oss_ope_lot_num_bk o
    left join ${iol_schema}.osbs_oss_ope_lot_num_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_oss_ope_lot_num_cl d
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
--truncate table ${iol_schema}.osbs_oss_ope_lot_num;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_oss_ope_lot_num') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_oss_ope_lot_num drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_oss_ope_lot_num add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_oss_ope_lot_num exchange partition p_${batch_date} with table ${iol_schema}.osbs_oss_ope_lot_num_cl;
alter table ${iol_schema}.osbs_oss_ope_lot_num exchange partition p_20991231 with table ${iol_schema}.osbs_oss_ope_lot_num_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_oss_ope_lot_num to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_oss_ope_lot_num_op purge;
drop table ${iol_schema}.osbs_oss_ope_lot_num_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_oss_ope_lot_num_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_oss_ope_lot_num',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
