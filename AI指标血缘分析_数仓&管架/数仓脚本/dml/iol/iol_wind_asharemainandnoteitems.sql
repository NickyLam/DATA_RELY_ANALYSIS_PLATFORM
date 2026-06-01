/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharemainandnoteitems
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_asharemainandnoteitems_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_asharemainandnoteitems;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharemainandnoteitems_op purge;
drop table ${iol_schema}.wind_asharemainandnoteitems_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharemainandnoteitems_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_asharemainandnoteitems where 0=1;

create table ${iol_schema}.wind_asharemainandnoteitems_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_asharemainandnoteitems where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_asharemainandnoteitems_op(
        object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,sequence1 -- 顺序编号
        ,accounts_id -- 科目ID
        ,is_not_null -- 是否非空
        ,is_show -- 是否展示
        ,s_info_typecode -- 报表品种代码
        ,subject_chinese_name -- 科目中文名
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.s_info_windcode -- Wind代码
    ,n.sequence1 -- 顺序编号
    ,n.accounts_id -- 科目ID
    ,n.is_not_null -- 是否非空
    ,n.is_show -- 是否展示
    ,n.s_info_typecode -- 报表品种代码
    ,n.subject_chinese_name -- 科目中文名
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_asharemainandnoteitems_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_asharemainandnoteitems where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
            and o.s_info_windcode = n.s_info_windcode
            and o.accounts_id = n.accounts_id
            and o.s_info_typecode = n.s_info_typecode
where (
        o.object_id is null
        and o.s_info_windcode is null
        and o.accounts_id is null
        and o.s_info_typecode is null
    )
    or (
        o.sequence1 <> n.sequence1
        or o.is_not_null <> n.is_not_null
        or o.is_show <> n.is_show
        or o.subject_chinese_name <> n.subject_chinese_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharemainandnoteitems_cl(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,sequence1 -- 顺序编号
        ,accounts_id -- 科目ID
        ,is_not_null -- 是否非空
        ,is_show -- 是否展示
        ,s_info_typecode -- 报表品种代码
        ,subject_chinese_name -- 科目中文名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharemainandnoteitems_op(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,sequence1 -- 顺序编号
        ,accounts_id -- 科目ID
        ,is_not_null -- 是否非空
        ,is_show -- 是否展示
        ,s_info_typecode -- 报表品种代码
        ,subject_chinese_name -- 科目中文名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_windcode -- Wind代码
    ,o.sequence1 -- 顺序编号
    ,o.accounts_id -- 科目ID
    ,o.is_not_null -- 是否非空
    ,o.is_show -- 是否展示
    ,o.s_info_typecode -- 报表品种代码
    ,o.subject_chinese_name -- 科目中文名
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_asharemainandnoteitems_bk o
    left join ${iol_schema}.wind_asharemainandnoteitems_op n
        on
            o.object_id = n.object_id
            and o.s_info_windcode = n.s_info_windcode
            and o.accounts_id = n.accounts_id
            and o.s_info_typecode = n.s_info_typecode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_asharemainandnoteitems;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_asharemainandnoteitems exchange partition p_19000101 with table ${iol_schema}.wind_asharemainandnoteitems_cl;
alter table ${iol_schema}.wind_asharemainandnoteitems exchange partition p_20991231 with table ${iol_schema}.wind_asharemainandnoteitems_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharemainandnoteitems to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharemainandnoteitems_op purge;
drop table ${iol_schema}.wind_asharemainandnoteitems_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_asharemainandnoteitems_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharemainandnoteitems',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
