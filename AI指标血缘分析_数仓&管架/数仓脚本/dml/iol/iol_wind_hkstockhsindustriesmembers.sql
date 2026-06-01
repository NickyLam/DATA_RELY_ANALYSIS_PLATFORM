/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkstockhsindustriesmembers
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
create table ${iol_schema}.wind_hkstockhsindustriesmembers_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hkstockhsindustriesmembers;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers_op purge;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkstockhsindustriesmembers_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkstockhsindustriesmembers where 0=1;

create table ${iol_schema}.wind_hkstockhsindustriesmembers_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkstockhsindustriesmembers where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hkstockhsindustriesmembers_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,hs_ind_code -- 恒生行业代码
            ,entry_dt -- 纳入日期
            ,remove_dt -- 剔除日期
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hkstockhsindustriesmembers_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,hs_ind_code -- 恒生行业代码
            ,entry_dt -- 纳入日期
            ,remove_dt -- 剔除日期
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- 对象ID
    ,nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.hs_ind_code, o.hs_ind_code) as hs_ind_code -- 恒生行业代码
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 纳入日期
    ,nvl(n.remove_dt, o.remove_dt) as remove_dt -- 剔除日期
    ,nvl(n.cur_sign, o.cur_sign) as cur_sign -- 最新标志
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
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
from (select * from ${iol_schema}.wind_hkstockhsindustriesmembers_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_hkstockhsindustriesmembers where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.hs_ind_code <> n.hs_ind_code
        or o.entry_dt <> n.entry_dt
        or o.remove_dt <> n.remove_dt
        or o.cur_sign <> n.cur_sign
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hkstockhsindustriesmembers_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,hs_ind_code -- 恒生行业代码
            ,entry_dt -- 纳入日期
            ,remove_dt -- 剔除日期
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hkstockhsindustriesmembers_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,hs_ind_code -- 恒生行业代码
            ,entry_dt -- 纳入日期
            ,remove_dt -- 剔除日期
            ,cur_sign -- 最新标志
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.hs_ind_code -- 恒生行业代码
    ,o.entry_dt -- 纳入日期
    ,o.remove_dt -- 剔除日期
    ,o.cur_sign -- 最新标志
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hkstockhsindustriesmembers_bk o
    left join ${iol_schema}.wind_hkstockhsindustriesmembers_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_hkstockhsindustriesmembers_cl d
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
-- truncate table ${iol_schema}.wind_hkstockhsindustriesmembers;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_hkstockhsindustriesmembers exchange partition p_19000101 with table ${iol_schema}.wind_hkstockhsindustriesmembers_cl;
alter table ${iol_schema}.wind_hkstockhsindustriesmembers exchange partition p_20991231 with table ${iol_schema}.wind_hkstockhsindustriesmembers_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkstockhsindustriesmembers to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers_op purge;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkstockhsindustriesmembers',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
