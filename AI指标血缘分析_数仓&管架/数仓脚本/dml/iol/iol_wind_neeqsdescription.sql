/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_neeqsdescription
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
create table ${iol_schema}.wind_neeqsdescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_neeqsdescription;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_neeqsdescription_op purge;
drop table ${iol_schema}.wind_neeqsdescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsdescription_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_neeqsdescription where 0=1;

create table ${iol_schema}.wind_neeqsdescription_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_neeqsdescription where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_neeqsdescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_name -- 证券简称
            ,s_info_pinyin -- 简称拼音
            ,s_info_exchmarket -- 交易所代码
            ,s_info_listboard -- 上市板代码
            ,s_info_listdate -- 上市时间
            ,s_info_delistdate -- 摘牌日期
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_neeqsdescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_name -- 证券简称
            ,s_info_pinyin -- 简称拼音
            ,s_info_exchmarket -- 交易所代码
            ,s_info_listboard -- 上市板代码
            ,s_info_listdate -- 上市时间
            ,s_info_delistdate -- 摘牌日期
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
    ,nvl(n.s_info_code, o.s_info_code) as s_info_code -- 交易代码
    ,nvl(n.s_info_name, o.s_info_name) as s_info_name -- 证券简称
    ,nvl(n.s_info_pinyin, o.s_info_pinyin) as s_info_pinyin -- 简称拼音
    ,nvl(n.s_info_exchmarket, o.s_info_exchmarket) as s_info_exchmarket -- 交易所代码
    ,nvl(n.s_info_listboard, o.s_info_listboard) as s_info_listboard -- 上市板代码
    ,nvl(n.s_info_listdate, o.s_info_listdate) as s_info_listdate -- 上市时间
    ,nvl(n.s_info_delistdate, o.s_info_delistdate) as s_info_delistdate -- 摘牌日期
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
from (select * from ${iol_schema}.wind_neeqsdescription_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_neeqsdescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.s_info_code <> n.s_info_code
        or o.s_info_name <> n.s_info_name
        or o.s_info_pinyin <> n.s_info_pinyin
        or o.s_info_exchmarket <> n.s_info_exchmarket
        or o.s_info_listboard <> n.s_info_listboard
        or o.s_info_listdate <> n.s_info_listdate
        or o.s_info_delistdate <> n.s_info_delistdate
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_neeqsdescription_cl(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_name -- 证券简称
            ,s_info_pinyin -- 简称拼音
            ,s_info_exchmarket -- 交易所代码
            ,s_info_listboard -- 上市板代码
            ,s_info_listdate -- 上市时间
            ,s_info_delistdate -- 摘牌日期
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_neeqsdescription_op(
            object_id -- 对象ID
            ,s_info_windcode -- Wind代码
            ,s_info_code -- 交易代码
            ,s_info_name -- 证券简称
            ,s_info_pinyin -- 简称拼音
            ,s_info_exchmarket -- 交易所代码
            ,s_info_listboard -- 上市板代码
            ,s_info_listdate -- 上市时间
            ,s_info_delistdate -- 摘牌日期
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
    ,o.s_info_code -- 交易代码
    ,o.s_info_name -- 证券简称
    ,o.s_info_pinyin -- 简称拼音
    ,o.s_info_exchmarket -- 交易所代码
    ,o.s_info_listboard -- 上市板代码
    ,o.s_info_listdate -- 上市时间
    ,o.s_info_delistdate -- 摘牌日期
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_neeqsdescription_bk o
    left join ${iol_schema}.wind_neeqsdescription_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_neeqsdescription_cl d
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
-- truncate table ${iol_schema}.wind_neeqsdescription;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_neeqsdescription exchange partition p_19000101 with table ${iol_schema}.wind_neeqsdescription_cl;
alter table ${iol_schema}.wind_neeqsdescription exchange partition p_20991231 with table ${iol_schema}.wind_neeqsdescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_neeqsdescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_neeqsdescription_op purge;
drop table ${iol_schema}.wind_neeqsdescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_neeqsdescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_neeqsdescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
