/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_role_type
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
create table ${iol_schema}.noas_role_type_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_role_type;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_role_type_op purge;
drop table ${iol_schema}.noas_role_type_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_role_type_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_role_type where 0=1;

create table ${iol_schema}.noas_role_type_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_role_type where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_role_type_cl(
            role_type_id -- 主键
            ,description -- 角色名
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_role_type_op(
            role_type_id -- 主键
            ,description -- 角色名
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.role_type_id, o.role_type_id) as role_type_id -- 主键
    ,nvl(n.description, o.description) as description -- 角色名
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- bosent自带最后修改时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- bosent自带最后修改时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- bosent自带创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- bosent自带创建时间
    ,nvl(n.role_attribute, o.role_attribute) as role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
    ,case when
            n.role_type_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.role_type_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.role_type_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_role_type_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_role_type where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.role_type_id = n.role_type_id
where (
        o.role_type_id is null
    )
    or (
        n.role_type_id is null
    )
    or (
        o.description <> n.description
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.role_attribute <> n.role_attribute
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_role_type_cl(
            role_type_id -- 主键
            ,description -- 角色名
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_role_type_op(
            role_type_id -- 主键
            ,description -- 角色名
            ,last_updated_stamp -- bosent自带最后修改时间
            ,last_updated_tx_stamp -- bosent自带最后修改时间
            ,created_stamp -- bosent自带创建时间
            ,created_tx_stamp -- bosent自带创建时间
            ,role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.role_type_id -- 主键
    ,o.description -- 角色名
    ,o.last_updated_stamp -- bosent自带最后修改时间
    ,o.last_updated_tx_stamp -- bosent自带最后修改时间
    ,o.created_stamp -- bosent自带创建时间
    ,o.created_tx_stamp -- bosent自带创建时间
    ,o.role_attribute -- 角色归属(枚举值: 1-总行 2-分行 3-总分行)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.noas_role_type_bk o
    left join ${iol_schema}.noas_role_type_op n
        on
            o.role_type_id = n.role_type_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_role_type_cl d
        on
            o.role_type_id = d.role_type_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.noas_role_type;

-- 4.2 exchange partition
alter table ${iol_schema}.noas_role_type exchange partition p_19000101 with table ${iol_schema}.noas_role_type_cl;
alter table ${iol_schema}.noas_role_type exchange partition p_20991231 with table ${iol_schema}.noas_role_type_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_role_type to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_role_type_op purge;
drop table ${iol_schema}.noas_role_type_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_role_type_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_role_type',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
