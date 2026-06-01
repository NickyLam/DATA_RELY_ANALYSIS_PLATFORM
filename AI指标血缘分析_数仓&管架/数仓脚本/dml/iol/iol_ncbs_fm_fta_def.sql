/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_fta_def
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
create table ${iol_schema}.ncbs_fm_fta_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_fta_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_fta_def_op purge;
drop table ${iol_schema}.ncbs_fm_fta_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_fta_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_fta_def where 0=1;

create table ${iol_schema}.ncbs_fm_fta_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_fta_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_fta_def_cl(
            country -- 国家
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,fta_code -- 自贸区代码
            ,fta_desc -- 自贸区名称
            ,fta_nature -- 自贸区属性
            ,fta_type -- 自贸区类型
            ,fte_flag -- 本岸企业客户前缀
            ,ftf_flag -- 个人非居民标志
            ,fti_flag -- 区内个人居民账户标志
            ,ftn_flag -- 离岸企业客户标志
            ,ftu_flag -- 同业客户账户前缀
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_fta_def_op(
            country -- 国家
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,fta_code -- 自贸区代码
            ,fta_desc -- 自贸区名称
            ,fta_nature -- 自贸区属性
            ,fta_type -- 自贸区类型
            ,fte_flag -- 本岸企业客户前缀
            ,ftf_flag -- 个人非居民标志
            ,fti_flag -- 区内个人居民账户标志
            ,ftn_flag -- 离岸企业客户标志
            ,ftu_flag -- 同业客户账户前缀
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.country, o.country) as country -- 国家
    ,nvl(n.city, o.city) as city -- 行政区划(城市)
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fta_code, o.fta_code) as fta_code -- 自贸区代码
    ,nvl(n.fta_desc, o.fta_desc) as fta_desc -- 自贸区名称
    ,nvl(n.fta_nature, o.fta_nature) as fta_nature -- 自贸区属性
    ,nvl(n.fta_type, o.fta_type) as fta_type -- 自贸区类型
    ,nvl(n.fte_flag, o.fte_flag) as fte_flag -- 本岸企业客户前缀
    ,nvl(n.ftf_flag, o.ftf_flag) as ftf_flag -- 个人非居民标志
    ,nvl(n.fti_flag, o.fti_flag) as fti_flag -- 区内个人居民账户标志
    ,nvl(n.ftn_flag, o.ftn_flag) as ftn_flag -- 离岸企业客户标志
    ,nvl(n.ftu_flag, o.ftu_flag) as ftu_flag -- 同业客户账户前缀
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.fta_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fta_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fta_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_fta_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_fta_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fta_code = n.fta_code
where (
        o.fta_code is null
    )
    or (
        n.fta_code is null
    )
    or (
        o.country <> n.country
        or o.city <> n.city
        or o.company <> n.company
        or o.fta_desc <> n.fta_desc
        or o.fta_nature <> n.fta_nature
        or o.fta_type <> n.fta_type
        or o.fte_flag <> n.fte_flag
        or o.ftf_flag <> n.ftf_flag
        or o.fti_flag <> n.fti_flag
        or o.ftn_flag <> n.ftn_flag
        or o.ftu_flag <> n.ftu_flag
        or o.state <> n.state
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_fta_def_cl(
            country -- 国家
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,fta_code -- 自贸区代码
            ,fta_desc -- 自贸区名称
            ,fta_nature -- 自贸区属性
            ,fta_type -- 自贸区类型
            ,fte_flag -- 本岸企业客户前缀
            ,ftf_flag -- 个人非居民标志
            ,fti_flag -- 区内个人居民账户标志
            ,ftn_flag -- 离岸企业客户标志
            ,ftu_flag -- 同业客户账户前缀
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_fta_def_op(
            country -- 国家
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,fta_code -- 自贸区代码
            ,fta_desc -- 自贸区名称
            ,fta_nature -- 自贸区属性
            ,fta_type -- 自贸区类型
            ,fte_flag -- 本岸企业客户前缀
            ,ftf_flag -- 个人非居民标志
            ,fti_flag -- 区内个人居民账户标志
            ,ftn_flag -- 离岸企业客户标志
            ,ftu_flag -- 同业客户账户前缀
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.country -- 国家
    ,o.city -- 行政区划(城市)
    ,o.company -- 法人
    ,o.fta_code -- 自贸区代码
    ,o.fta_desc -- 自贸区名称
    ,o.fta_nature -- 自贸区属性
    ,o.fta_type -- 自贸区类型
    ,o.fte_flag -- 本岸企业客户前缀
    ,o.ftf_flag -- 个人非居民标志
    ,o.fti_flag -- 区内个人居民账户标志
    ,o.ftn_flag -- 离岸企业客户标志
    ,o.ftu_flag -- 同业客户账户前缀
    ,o.state -- 行政区划(省、州)
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_fm_fta_def_bk o
    left join ${iol_schema}.ncbs_fm_fta_def_op n
        on
            o.fta_code = n.fta_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_fta_def_cl d
        on
            o.fta_code = d.fta_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_fta_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_fta_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_fta_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_fta_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_fta_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_fta_def_cl;
alter table ${iol_schema}.ncbs_fm_fta_def exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_fta_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_fta_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_fta_def_op purge;
drop table ${iol_schema}.ncbs_fm_fta_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_fta_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_fta_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
