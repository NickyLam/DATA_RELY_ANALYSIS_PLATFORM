/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wbk_company_global_param
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
create table ${iol_schema}.mpcs_a1wbk_company_global_param_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wbk_company_global_param
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param_op purge;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wbk_company_global_param_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wbk_company_global_param where 0=1;

create table ${iol_schema}.mpcs_a1wbk_company_global_param_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wbk_company_global_param where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wbk_company_global_param_cl(
            param_id -- 参数id
            ,param_value -- 参数值
            ,param_name -- 参数名称
            ,param_desc -- 参数说明
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wbk_company_global_param_op(
            param_id -- 参数id
            ,param_value -- 参数值
            ,param_name -- 参数名称
            ,param_desc -- 参数说明
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.param_id, o.param_id) as param_id -- 参数id
    ,nvl(n.param_value, o.param_value) as param_value -- 参数值
    ,nvl(n.param_name, o.param_name) as param_name -- 参数名称
    ,nvl(n.param_desc, o.param_desc) as param_desc -- 参数说明
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.param_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.param_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.param_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wbk_company_global_param_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wbk_company_global_param where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.param_id = n.param_id
where (
        o.param_id is null
    )
    or (
        n.param_id is null
    )
    or (
        o.param_value <> n.param_value
        or o.param_name <> n.param_name
        or o.param_desc <> n.param_desc
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wbk_company_global_param_cl(
            param_id -- 参数id
            ,param_value -- 参数值
            ,param_name -- 参数名称
            ,param_desc -- 参数说明
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wbk_company_global_param_op(
            param_id -- 参数id
            ,param_value -- 参数值
            ,param_name -- 参数名称
            ,param_desc -- 参数说明
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.param_id -- 参数id
    ,o.param_value -- 参数值
    ,o.param_name -- 参数名称
    ,o.param_desc -- 参数说明
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.mpcs_a1wbk_company_global_param_bk o
    left join ${iol_schema}.mpcs_a1wbk_company_global_param_op n
        on
            o.param_id = n.param_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wbk_company_global_param_cl d
        on
            o.param_id = d.param_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wbk_company_global_param;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wbk_company_global_param') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wbk_company_global_param drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wbk_company_global_param add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wbk_company_global_param exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wbk_company_global_param_cl;
alter table ${iol_schema}.mpcs_a1wbk_company_global_param exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wbk_company_global_param_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wbk_company_global_param to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param_op purge;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wbk_company_global_param_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wbk_company_global_param',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
