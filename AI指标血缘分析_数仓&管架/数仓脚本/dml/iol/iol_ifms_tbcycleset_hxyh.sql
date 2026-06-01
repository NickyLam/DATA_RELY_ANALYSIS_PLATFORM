/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbcycleset_hxyh
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
create table ${iol_schema}.ifms_tbcycleset_hxyh_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbcycleset_hxyh
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbcycleset_hxyh_op purge;
drop table ${iol_schema}.ifms_tbcycleset_hxyh_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcycleset_hxyh_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbcycleset_hxyh where 0=1;

create table ${iol_schema}.ifms_tbcycleset_hxyh_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbcycleset_hxyh where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbcycleset_hxyh_cl(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,date_type -- 开放日类型a-产品申购日9-产品赎回日
            ,cycle_start_date -- 开放开始日期
            ,cycle_end_date -- 开放结束日期
            ,cycle_cfm_date -- 开放确认日
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbcycleset_hxyh_op(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,date_type -- 开放日类型a-产品申购日9-产品赎回日
            ,cycle_start_date -- 开放开始日期
            ,cycle_end_date -- 开放结束日期
            ,cycle_cfm_date -- 开放确认日
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- ta代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.date_type, o.date_type) as date_type -- 开放日类型a-产品申购日9-产品赎回日
    ,nvl(n.cycle_start_date, o.cycle_start_date) as cycle_start_date -- 开放开始日期
    ,nvl(n.cycle_end_date, o.cycle_end_date) as cycle_end_date -- 开放结束日期
    ,nvl(n.cycle_cfm_date, o.cycle_cfm_date) as cycle_cfm_date -- 开放确认日
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.date_type is null
            and n.cycle_cfm_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.date_type is null
            and n.cycle_cfm_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.date_type is null
            and n.cycle_cfm_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbcycleset_hxyh_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbcycleset_hxyh where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.date_type = n.date_type
            and o.cycle_cfm_date = n.cycle_cfm_date
where (
        o.ta_code is null
        and o.prd_code is null
        and o.date_type is null
        and o.cycle_cfm_date is null
    )
    or (
        n.ta_code is null
        and n.prd_code is null
        and n.date_type is null
        and n.cycle_cfm_date is null
    )
    or (
        o.cycle_start_date <> n.cycle_start_date
        or o.cycle_end_date <> n.cycle_end_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbcycleset_hxyh_cl(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,date_type -- 开放日类型a-产品申购日9-产品赎回日
            ,cycle_start_date -- 开放开始日期
            ,cycle_end_date -- 开放结束日期
            ,cycle_cfm_date -- 开放确认日
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbcycleset_hxyh_op(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,date_type -- 开放日类型a-产品申购日9-产品赎回日
            ,cycle_start_date -- 开放开始日期
            ,cycle_end_date -- 开放结束日期
            ,cycle_cfm_date -- 开放确认日
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- ta代码
    ,o.prd_code -- 产品代码
    ,o.date_type -- 开放日类型a-产品申购日9-产品赎回日
    ,o.cycle_start_date -- 开放开始日期
    ,o.cycle_end_date -- 开放结束日期
    ,o.cycle_cfm_date -- 开放确认日
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
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
from ${iol_schema}.ifms_tbcycleset_hxyh_bk o
    left join ${iol_schema}.ifms_tbcycleset_hxyh_op n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.date_type = n.date_type
            and o.cycle_cfm_date = n.cycle_cfm_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbcycleset_hxyh_cl d
        on
            o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
            and o.date_type = d.date_type
            and o.cycle_cfm_date = d.cycle_cfm_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbcycleset_hxyh;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbcycleset_hxyh') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbcycleset_hxyh drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbcycleset_hxyh add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbcycleset_hxyh exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbcycleset_hxyh_cl;
alter table ${iol_schema}.ifms_tbcycleset_hxyh exchange partition p_20991231 with table ${iol_schema}.ifms_tbcycleset_hxyh_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbcycleset_hxyh to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbcycleset_hxyh_op purge;
drop table ${iol_schema}.ifms_tbcycleset_hxyh_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbcycleset_hxyh_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbcycleset_hxyh',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
