/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_responsor_table
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
create table ${iol_schema}.atms_dev_responsor_table_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_responsor_table
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_responsor_table_op purge;
drop table ${iol_schema}.atms_dev_responsor_table_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_responsor_table_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_responsor_table where 0=1;

create table ${iol_schema}.atms_dev_responsor_table_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_responsor_table where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_responsor_table_cl(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,catalog -- 责任人分类
            ,grade -- 责任人级别
            ,responser_no -- 责任人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_responsor_table_op(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,catalog -- 责任人分类
            ,grade -- 责任人级别
            ,responser_no -- 责任人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.logic_id, o.logic_id) as logic_id -- 编号
    ,nvl(n.dev_no, o.dev_no) as dev_no -- 设备号
    ,nvl(n.catalog, o.catalog) as catalog -- 责任人分类
    ,nvl(n.grade, o.grade) as grade -- 责任人级别
    ,nvl(n.responser_no, o.responser_no) as responser_no -- 责任人编号
    ,case when
            n.logic_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.logic_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.logic_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_dev_responsor_table_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_responsor_table where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.logic_id = n.logic_id
where (
        o.logic_id is null
    )
    or (
        n.logic_id is null
    )
    or (
        o.dev_no <> n.dev_no
        or o.catalog <> n.catalog
        or o.grade <> n.grade
        or o.responser_no <> n.responser_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_responsor_table_cl(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,catalog -- 责任人分类
            ,grade -- 责任人级别
            ,responser_no -- 责任人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_responsor_table_op(
            logic_id -- 编号
            ,dev_no -- 设备号
            ,catalog -- 责任人分类
            ,grade -- 责任人级别
            ,responser_no -- 责任人编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.logic_id -- 编号
    ,o.dev_no -- 设备号
    ,o.catalog -- 责任人分类
    ,o.grade -- 责任人级别
    ,o.responser_no -- 责任人编号
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
from ${iol_schema}.atms_dev_responsor_table_bk o
    left join ${iol_schema}.atms_dev_responsor_table_op n
        on
            o.logic_id = n.logic_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_responsor_table_cl d
        on
            o.logic_id = d.logic_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_dev_responsor_table;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_responsor_table') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_responsor_table drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_responsor_table add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_responsor_table exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_responsor_table_cl;
alter table ${iol_schema}.atms_dev_responsor_table exchange partition p_20991231 with table ${iol_schema}.atms_dev_responsor_table_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_responsor_table to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_responsor_table_op purge;
drop table ${iol_schema}.atms_dev_responsor_table_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_responsor_table_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_responsor_table',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
