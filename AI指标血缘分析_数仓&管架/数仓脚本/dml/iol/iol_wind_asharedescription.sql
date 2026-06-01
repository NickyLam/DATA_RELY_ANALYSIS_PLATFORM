/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharedescription
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_asharedescription_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_asharedescription
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharedescription_op purge;
drop table ${iol_schema}.wind_asharedescription_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharedescription_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_asharedescription where 0=1;

create table ${iol_schema}.wind_asharedescription_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_asharedescription where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_asharedescription_op(
        object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券简称
        ,s_info_compname -- 公司中文名称
        ,s_info_compnameeng -- 公司英文名称
        ,s_info_isincode -- ISIN代码
        ,s_info_exchmarket -- 交易所
        ,s_info_listboard -- 上市板类型
        ,s_info_listdate -- 上市日期
        ,s_info_delistdate -- 退市日期
        ,s_info_sedolcode -- 
        ,crncy_code -- 货币代码
        ,s_info_pinyin -- 简称拼音
        ,s_info_listboardname -- 上市板
        ,is_shsc -- 是否在沪股通或深港通范围内
        ,s_info_compcode -- 公司ID
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.s_info_windcode -- Wind代码
    ,n.s_info_code -- 交易代码
    ,n.s_info_name -- 证券简称
    ,n.s_info_compname -- 公司中文名称
    ,n.s_info_compnameeng -- 公司英文名称
    ,n.s_info_isincode -- ISIN代码
    ,n.s_info_exchmarket -- 交易所
    ,n.s_info_listboard -- 上市板类型
    ,n.s_info_listdate -- 上市日期
    ,n.s_info_delistdate -- 退市日期
    ,n.s_info_sedolcode -- 
    ,n.crncy_code -- 货币代码
    ,n.s_info_pinyin -- 简称拼音
    ,n.s_info_listboardname -- 上市板
    ,n.is_shsc -- 是否在沪股通或深港通范围内
    ,n.s_info_compcode -- 公司ID
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_asharedescription_bk o
    right join (select * from ${itl_schema}.wind_asharedescription where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.s_info_windcode = n.s_info_windcode
where (
        o.s_info_windcode is null
    )
    or (
        o.object_id <> n.object_id
        or o.s_info_code <> n.s_info_code
        or o.s_info_name <> n.s_info_name
        or o.s_info_compname <> n.s_info_compname
        or o.s_info_compnameeng <> n.s_info_compnameeng
        or o.s_info_isincode <> n.s_info_isincode
        or o.s_info_exchmarket <> n.s_info_exchmarket
        or o.s_info_listboard <> n.s_info_listboard
        or o.s_info_listdate <> n.s_info_listdate
        or o.s_info_delistdate <> n.s_info_delistdate
        or o.s_info_sedolcode <> n.s_info_sedolcode
        or o.crncy_code <> n.crncy_code
        or o.s_info_pinyin <> n.s_info_pinyin
        or o.s_info_listboardname <> n.s_info_listboardname
        or o.is_shsc <> n.is_shsc
        or o.s_info_compcode <> n.s_info_compcode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_asharedescription_cl(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券简称
        ,s_info_compname -- 公司中文名称
        ,s_info_compnameeng -- 公司英文名称
        ,s_info_isincode -- ISIN代码
        ,s_info_exchmarket -- 交易所
        ,s_info_listboard -- 上市板类型
        ,s_info_listdate -- 上市日期
        ,s_info_delistdate -- 退市日期
        ,s_info_sedolcode -- 
        ,crncy_code -- 货币代码
        ,s_info_pinyin -- 简称拼音
        ,s_info_listboardname -- 上市板
        ,is_shsc -- 是否在沪股通或深港通范围内
        ,s_info_compcode -- 公司ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_asharedescription_op(
            object_id -- 对象ID
        ,s_info_windcode -- Wind代码
        ,s_info_code -- 交易代码
        ,s_info_name -- 证券简称
        ,s_info_compname -- 公司中文名称
        ,s_info_compnameeng -- 公司英文名称
        ,s_info_isincode -- ISIN代码
        ,s_info_exchmarket -- 交易所
        ,s_info_listboard -- 上市板类型
        ,s_info_listdate -- 上市日期
        ,s_info_delistdate -- 退市日期
        ,s_info_sedolcode -- 
        ,crncy_code -- 货币代码
        ,s_info_pinyin -- 简称拼音
        ,s_info_listboardname -- 上市板
        ,is_shsc -- 是否在沪股通或深港通范围内
        ,s_info_compcode -- 公司ID
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
    ,o.s_info_compname -- 公司中文名称
    ,o.s_info_compnameeng -- 公司英文名称
    ,o.s_info_isincode -- ISIN代码
    ,o.s_info_exchmarket -- 交易所
    ,o.s_info_listboard -- 上市板类型
    ,o.s_info_listdate -- 上市日期
    ,o.s_info_delistdate -- 退市日期
    ,o.s_info_sedolcode -- 
    ,o.crncy_code -- 货币代码
    ,o.s_info_pinyin -- 简称拼音
    ,o.s_info_listboardname -- 上市板
    ,o.is_shsc -- 是否在沪股通或深港通范围内
    ,o.s_info_compcode -- 公司ID
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_asharedescription_bk o
    left join ${iol_schema}.wind_asharedescription_op n
        on
            o.s_info_windcode = n.s_info_windcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_asharedescription;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_asharedescription') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_asharedescription drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_asharedescription add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_asharedescription exchange partition p_${batch_date} with table ${iol_schema}.wind_asharedescription_cl;
alter table ${iol_schema}.wind_asharedescription exchange partition p_20991231 with table ${iol_schema}.wind_asharedescription_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharedescription to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_asharedescription_op purge;
drop table ${iol_schema}.wind_asharedescription_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_asharedescription_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharedescription',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
