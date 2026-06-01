/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_state
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
create table ${iol_schema}.ncbs_fm_state_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_state
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_state_op purge;
drop table ${iol_schema}.ncbs_fm_state_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_state_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_state where 0=1;

create table ${iol_schema}.ncbs_fm_state_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_state where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_state_cl(
            country -- 国家
            ,company -- 法人
            ,state -- 行政区划(省、州)
            ,state_desc -- 省名称
            ,weekend1 -- 周末1
            ,weekend2 -- 周末2
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_state_op(
            country -- 国家
            ,company -- 法人
            ,state -- 行政区划(省、州)
            ,state_desc -- 省名称
            ,weekend1 -- 周末1
            ,weekend2 -- 周末2
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.country, o.country) as country -- 国家
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.state_desc, o.state_desc) as state_desc -- 省名称
    ,nvl(n.weekend1, o.weekend1) as weekend1 -- 周末1
    ,nvl(n.weekend2, o.weekend2) as weekend2 -- 周末2
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.country is null
            and n.state is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.country is null
            and n.state is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.country is null
            and n.state is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_state_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_state where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.country = n.country
            and o.state = n.state
where (
        o.country is null
        and o.state is null
    )
    or (
        n.country is null
        and n.state is null
    )
    or (
        o.company <> n.company
        or o.state_desc <> n.state_desc
        or o.weekend1 <> n.weekend1
        or o.weekend2 <> n.weekend2
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_state_cl(
            country -- 国家
            ,company -- 法人
            ,state -- 行政区划(省、州)
            ,state_desc -- 省名称
            ,weekend1 -- 周末1
            ,weekend2 -- 周末2
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_state_op(
            country -- 国家
            ,company -- 法人
            ,state -- 行政区划(省、州)
            ,state_desc -- 省名称
            ,weekend1 -- 周末1
            ,weekend2 -- 周末2
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.country -- 国家
    ,o.company -- 法人
    ,o.state -- 行政区划(省、州)
    ,o.state_desc -- 省名称
    ,o.weekend1 -- 周末1
    ,o.weekend2 -- 周末2
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
from ${iol_schema}.ncbs_fm_state_bk o
    left join ${iol_schema}.ncbs_fm_state_op n
        on
            o.country = n.country
            and o.state = n.state
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_state_cl d
        on
            o.country = d.country
            and o.state = d.state
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_state;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_state') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_state drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_state add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_state exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_state_cl;
alter table ${iol_schema}.ncbs_fm_state exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_state_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_state to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_state_op purge;
drop table ${iol_schema}.ncbs_fm_state_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_state_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_state',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
