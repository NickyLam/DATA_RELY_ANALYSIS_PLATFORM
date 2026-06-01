/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_city
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
create table ${iol_schema}.ncbs_fm_city_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_city
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_city_op purge;
drop table ${iol_schema}.ncbs_fm_city_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_city_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_city where 0=1;

create table ${iol_schema}.ncbs_fm_city_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_city where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_city_cl(
            country -- 国家
            ,city -- 行政区划(城市)
            ,city_desc -- 城市描述
            ,city_tel -- 电话区号
            ,company -- 法人
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_city_op(
            country -- 国家
            ,city -- 行政区划(城市)
            ,city_desc -- 城市描述
            ,city_tel -- 电话区号
            ,company -- 法人
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.country, o.country) as country -- 国家
    ,nvl(n.city, o.city) as city -- 行政区划(城市)
    ,nvl(n.city_desc, o.city_desc) as city_desc -- 城市描述
    ,nvl(n.city_tel, o.city_tel) as city_tel -- 电话区号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.postal_code, o.postal_code) as postal_code -- 邮政编码
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.attached_to, o.attached_to) as attached_to -- 所属上级
    ,case when
            n.country is null
            and n.city is null
            and n.state is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.country is null
            and n.city is null
            and n.state is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.country is null
            and n.city is null
            and n.state is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_city_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_city where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.country = n.country
            and o.city = n.city
            and o.state = n.state
where (
        o.country is null
        and o.city is null
        and o.state is null
    )
    or (
        n.country is null
        and n.city is null
        and n.state is null
    )
    or (
        o.city_desc <> n.city_desc
        or o.city_tel <> n.city_tel
        or o.company <> n.company
        or o.postal_code <> n.postal_code
        or o.tran_timestamp <> n.tran_timestamp
        or o.attached_to <> n.attached_to
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_city_cl(
            country -- 国家
            ,city -- 行政区划(城市)
            ,city_desc -- 城市描述
            ,city_tel -- 电话区号
            ,company -- 法人
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_city_op(
            country -- 国家
            ,city -- 行政区划(城市)
            ,city_desc -- 城市描述
            ,city_tel -- 电话区号
            ,company -- 法人
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.country -- 国家
    ,o.city -- 行政区划(城市)
    ,o.city_desc -- 城市描述
    ,o.city_tel -- 电话区号
    ,o.company -- 法人
    ,o.postal_code -- 邮政编码
    ,o.state -- 行政区划(省、州)
    ,o.tran_timestamp -- 交易时间戳
    ,o.attached_to -- 所属上级
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
from ${iol_schema}.ncbs_fm_city_bk o
    left join ${iol_schema}.ncbs_fm_city_op n
        on
            o.country = n.country
            and o.city = n.city
            and o.state = n.state
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_city_cl d
        on
            o.country = d.country
            and o.city = d.city
            and o.state = d.state
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_city;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_city') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_city drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_city add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_city exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_city_cl;
alter table ${iol_schema}.ncbs_fm_city exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_city_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_city to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_city_op purge;
drop table ${iol_schema}.ncbs_fm_city_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_city_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_city',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
