/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_dist_code
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
create table ${iol_schema}.ncbs_fm_dist_code_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_dist_code
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_dist_code_op purge;
drop table ${iol_schema}.ncbs_fm_dist_code_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_dist_code_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_dist_code where 0=1;

create table ${iol_schema}.ncbs_fm_dist_code_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_dist_code where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_dist_code_cl(
            city -- 行政区划(城市)
            ,company -- 法人
            ,dist_code -- 发证机关地区代码
            ,dist_grade -- 地区代码级别
            ,province -- 省
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,dist_name -- 地区名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_dist_code_op(
            city -- 行政区划(城市)
            ,company -- 法人
            ,dist_code -- 发证机关地区代码
            ,dist_grade -- 地区代码级别
            ,province -- 省
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,dist_name -- 地区名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.city, o.city) as city -- 行政区划(城市)
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.dist_code, o.dist_code) as dist_code -- 发证机关地区代码
    ,nvl(n.dist_grade, o.dist_grade) as dist_grade -- 地区代码级别
    ,nvl(n.province, o.province) as province -- 省
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.dist_name, o.dist_name) as dist_name -- 地区名称
    ,case when
            n.city is null
            and n.dist_code is null
            and n.province is null
            and n.dist_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.city is null
            and n.dist_code is null
            and n.province is null
            and n.dist_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.city is null
            and n.dist_code is null
            and n.province is null
            and n.dist_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_dist_code_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_dist_code where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.city = n.city
            and o.dist_code = n.dist_code
            and o.province = n.province
            and o.dist_name = n.dist_name
where (
        o.city is null
        and o.dist_code is null
        and o.province is null
        and o.dist_name is null
    )
    or (
        n.city is null
        and n.dist_code is null
        and n.province is null
        and n.dist_name is null
    )
    or (
        o.company <> n.company
        or o.dist_grade <> n.dist_grade
        or o.state <> n.state
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_dist_code_cl(
            city -- 行政区划(城市)
            ,company -- 法人
            ,dist_code -- 发证机关地区代码
            ,dist_grade -- 地区代码级别
            ,province -- 省
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,dist_name -- 地区名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_dist_code_op(
            city -- 行政区划(城市)
            ,company -- 法人
            ,dist_code -- 发证机关地区代码
            ,dist_grade -- 地区代码级别
            ,province -- 省
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,dist_name -- 地区名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.city -- 行政区划(城市)
    ,o.company -- 法人
    ,o.dist_code -- 发证机关地区代码
    ,o.dist_grade -- 地区代码级别
    ,o.province -- 省
    ,o.state -- 行政区划(省、州)
    ,o.tran_timestamp -- 交易时间戳
    ,o.dist_name -- 地区名称
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
from ${iol_schema}.ncbs_fm_dist_code_bk o
    left join ${iol_schema}.ncbs_fm_dist_code_op n
        on
            o.city = n.city
            and o.dist_code = n.dist_code
            and o.province = n.province
            and o.dist_name = n.dist_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_dist_code_cl d
        on
            o.city = d.city
            and o.dist_code = d.dist_code
            and o.province = d.province
            and o.dist_name = d.dist_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_dist_code;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_dist_code') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_dist_code drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_dist_code add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_dist_code exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_dist_code_cl;
alter table ${iol_schema}.ncbs_fm_dist_code exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_dist_code_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_dist_code to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_dist_code_op purge;
drop table ${iol_schema}.ncbs_fm_dist_code_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_dist_code_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_dist_code',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
