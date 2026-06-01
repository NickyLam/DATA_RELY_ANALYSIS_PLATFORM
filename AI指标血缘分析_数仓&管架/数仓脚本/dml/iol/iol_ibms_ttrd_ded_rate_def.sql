/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ded_rate_def
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
create table ${iol_schema}.ibms_ttrd_ded_rate_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_ded_rate_def;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def_op purge;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ded_rate_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ded_rate_def where 0=1;

create table ${iol_schema}.ibms_ttrd_ded_rate_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ded_rate_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ded_rate_def_cl(
            id -- 序号
            ,name -- 名称
            ,update_time -- 更新时间
            ,update_user -- 更新者
            ,create_time -- 创建时间
            ,create_user -- 创建者
            ,type -- 类型
            ,i_id -- 金融机构id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ded_rate_def_op(
            id -- 序号
            ,name -- 名称
            ,update_time -- 更新时间
            ,update_user -- 更新者
            ,create_time -- 创建时间
            ,create_user -- 创建者
            ,type -- 类型
            ,i_id -- 金融机构id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 序号
    ,nvl(n.name, o.name) as name -- 名称
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建者
    ,nvl(n.type, o.type) as type -- 类型
    ,nvl(n.i_id, o.i_id) as i_id -- 金融机构id
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
from (select * from ${iol_schema}.ibms_ttrd_ded_rate_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_ded_rate_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.name <> n.name
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.create_time <> n.create_time
        or o.create_user <> n.create_user
        or o.type <> n.type
        or o.i_id <> n.i_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ded_rate_def_cl(
            id -- 序号
            ,name -- 名称
            ,update_time -- 更新时间
            ,update_user -- 更新者
            ,create_time -- 创建时间
            ,create_user -- 创建者
            ,type -- 类型
            ,i_id -- 金融机构id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ded_rate_def_op(
            id -- 序号
            ,name -- 名称
            ,update_time -- 更新时间
            ,update_user -- 更新者
            ,create_time -- 创建时间
            ,create_user -- 创建者
            ,type -- 类型
            ,i_id -- 金融机构id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 序号
    ,o.name -- 名称
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新者
    ,o.create_time -- 创建时间
    ,o.create_user -- 创建者
    ,o.type -- 类型
    ,o.i_id -- 金融机构id
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_ded_rate_def_bk o
    left join ${iol_schema}.ibms_ttrd_ded_rate_def_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_ded_rate_def_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_ded_rate_def;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_ded_rate_def exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_ded_rate_def_cl;
alter table ${iol_schema}.ibms_ttrd_ded_rate_def exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_ded_rate_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ded_rate_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def_op purge;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_ded_rate_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ded_rate_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
