/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_irvs_ft_networth
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
create table ${iol_schema}.irvs_ft_networth_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.irvs_ft_networth
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.irvs_ft_networth_op purge;
drop table ${iol_schema}.irvs_ft_networth_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ft_networth_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.irvs_ft_networth where 0=1;

create table ${iol_schema}.irvs_ft_networth_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.irvs_ft_networth where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.irvs_ft_networth_cl(
            networth_id -- 净值id
            ,product_id -- 产品id
            ,networth_time -- 净值日期
            ,networth_cumulative -- 累计净值
            ,networth_unit -- 单位净值
            ,quotient -- 份额
            ,networth_cost -- 成本
            ,networth_marketvalue -- 市值
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.irvs_ft_networth_op(
            networth_id -- 净值id
            ,product_id -- 产品id
            ,networth_time -- 净值日期
            ,networth_cumulative -- 累计净值
            ,networth_unit -- 单位净值
            ,quotient -- 份额
            ,networth_cost -- 成本
            ,networth_marketvalue -- 市值
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.networth_id, o.networth_id) as networth_id -- 净值id
    ,nvl(n.product_id, o.product_id) as product_id -- 产品id
    ,nvl(n.networth_time, o.networth_time) as networth_time -- 净值日期
    ,nvl(n.networth_cumulative, o.networth_cumulative) as networth_cumulative -- 累计净值
    ,nvl(n.networth_unit, o.networth_unit) as networth_unit -- 单位净值
    ,nvl(n.quotient, o.quotient) as quotient -- 份额
    ,nvl(n.networth_cost, o.networth_cost) as networth_cost -- 成本
    ,nvl(n.networth_marketvalue, o.networth_marketvalue) as networth_marketvalue -- 市值
    ,nvl(n.created_by, o.created_by) as created_by -- 创建者
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,case when
            n.networth_id is null
            and n.product_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.networth_id is null
            and n.product_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.networth_id is null
            and n.product_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.irvs_ft_networth_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.irvs_ft_networth where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.networth_id = n.networth_id
            and o.product_id = n.product_id
where (
        o.networth_id is null
        and o.product_id is null
    )
    or (
        n.networth_id is null
        and n.product_id is null
    )
    or (
        o.networth_time <> n.networth_time
        or o.networth_cumulative <> n.networth_cumulative
        or o.networth_unit <> n.networth_unit
        or o.quotient <> n.quotient
        or o.networth_cost <> n.networth_cost
        or o.networth_marketvalue <> n.networth_marketvalue
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.irvs_ft_networth_cl(
            networth_id -- 净值id
            ,product_id -- 产品id
            ,networth_time -- 净值日期
            ,networth_cumulative -- 累计净值
            ,networth_unit -- 单位净值
            ,quotient -- 份额
            ,networth_cost -- 成本
            ,networth_marketvalue -- 市值
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.irvs_ft_networth_op(
            networth_id -- 净值id
            ,product_id -- 产品id
            ,networth_time -- 净值日期
            ,networth_cumulative -- 累计净值
            ,networth_unit -- 单位净值
            ,quotient -- 份额
            ,networth_cost -- 成本
            ,networth_marketvalue -- 市值
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.networth_id -- 净值id
    ,o.product_id -- 产品id
    ,o.networth_time -- 净值日期
    ,o.networth_cumulative -- 累计净值
    ,o.networth_unit -- 单位净值
    ,o.quotient -- 份额
    ,o.networth_cost -- 成本
    ,o.networth_marketvalue -- 市值
    ,o.created_by -- 创建者
    ,o.updated_by -- 修改者
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
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
from ${iol_schema}.irvs_ft_networth_bk o
    left join ${iol_schema}.irvs_ft_networth_op n
        on
            o.networth_id = n.networth_id
            and o.product_id = n.product_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.irvs_ft_networth_cl d
        on
            o.networth_id = d.networth_id
            and o.product_id = d.product_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.irvs_ft_networth;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('irvs_ft_networth') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.irvs_ft_networth drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.irvs_ft_networth add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.irvs_ft_networth exchange partition p_${batch_date} with table ${iol_schema}.irvs_ft_networth_cl;
alter table ${iol_schema}.irvs_ft_networth exchange partition p_20991231 with table ${iol_schema}.irvs_ft_networth_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.irvs_ft_networth to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.irvs_ft_networth_op purge;
drop table ${iol_schema}.irvs_ft_networth_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.irvs_ft_networth_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'irvs_ft_networth',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
