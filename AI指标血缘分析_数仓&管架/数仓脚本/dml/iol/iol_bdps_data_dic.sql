/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_data_dic
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
create table ${iol_schema}.bdps_data_dic_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_data_dic;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_data_dic_op purge;
drop table ${iol_schema}.bdps_data_dic_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_data_dic_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_data_dic where 0=1;

create table ${iol_schema}.bdps_data_dic_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_data_dic where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_data_dic_cl(
            id -- 
            ,data_type_no -- 
            ,data_no -- 
            ,data_type_name -- 
            ,data_no_len -- 
            ,data_name -- 
            ,limit_flag -- 
            ,high_limit -- 
            ,low_limit -- 
            ,effect_date -- 
            ,expire_date -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_data_dic_op(
            id -- 
            ,data_type_no -- 
            ,data_no -- 
            ,data_type_name -- 
            ,data_no_len -- 
            ,data_name -- 
            ,limit_flag -- 
            ,high_limit -- 
            ,low_limit -- 
            ,effect_date -- 
            ,expire_date -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.data_type_no, o.data_type_no) as data_type_no -- 
    ,nvl(n.data_no, o.data_no) as data_no -- 
    ,nvl(n.data_type_name, o.data_type_name) as data_type_name -- 
    ,nvl(n.data_no_len, o.data_no_len) as data_no_len -- 
    ,nvl(n.data_name, o.data_name) as data_name -- 
    ,nvl(n.limit_flag, o.limit_flag) as limit_flag -- 
    ,nvl(n.high_limit, o.high_limit) as high_limit -- 
    ,nvl(n.low_limit, o.low_limit) as low_limit -- 
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 
    ,nvl(n.timestamps, o.timestamps) as timestamps -- 
    ,nvl(n.miscflgs, o.miscflgs) as miscflgs -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_data_dic_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_data_dic where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.data_type_no <> n.data_type_no
        or o.data_no <> n.data_no
        or o.data_type_name <> n.data_type_name
        or o.data_no_len <> n.data_no_len
        or o.data_name <> n.data_name
        or o.limit_flag <> n.limit_flag
        or o.high_limit <> n.high_limit
        or o.low_limit <> n.low_limit
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.timestamps <> n.timestamps
        or o.miscflgs <> n.miscflgs
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_data_dic_cl(
            id -- 
            ,data_type_no -- 
            ,data_no -- 
            ,data_type_name -- 
            ,data_no_len -- 
            ,data_name -- 
            ,limit_flag -- 
            ,high_limit -- 
            ,low_limit -- 
            ,effect_date -- 
            ,expire_date -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_data_dic_op(
            id -- 
            ,data_type_no -- 
            ,data_no -- 
            ,data_type_name -- 
            ,data_no_len -- 
            ,data_name -- 
            ,limit_flag -- 
            ,high_limit -- 
            ,low_limit -- 
            ,effect_date -- 
            ,expire_date -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.data_type_no -- 
    ,o.data_no -- 
    ,o.data_type_name -- 
    ,o.data_no_len -- 
    ,o.data_name -- 
    ,o.limit_flag -- 
    ,o.high_limit -- 
    ,o.low_limit -- 
    ,o.effect_date -- 
    ,o.expire_date -- 
    ,o.timestamps -- 
    ,o.miscflgs -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_data_dic_bk o
    left join ${iol_schema}.bdps_data_dic_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_data_dic_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_data_dic;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_data_dic exchange partition p_19000101 with table ${iol_schema}.bdps_data_dic_cl;
alter table ${iol_schema}.bdps_data_dic exchange partition p_20991231 with table ${iol_schema}.bdps_data_dic_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_data_dic to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_data_dic_op purge;
drop table ${iol_schema}.bdps_data_dic_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_data_dic_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_data_dic',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
