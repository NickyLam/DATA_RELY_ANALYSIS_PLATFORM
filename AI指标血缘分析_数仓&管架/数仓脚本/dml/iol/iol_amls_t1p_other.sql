/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t1p_other
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
create table ${iol_schema}.amls_t1p_other_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t1p_other
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1p_other_op purge;
drop table ${iol_schema}.amls_t1p_other_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1p_other_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1p_other where 0=1;

create table ${iol_schema}.amls_t1p_other_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1p_other where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1p_other_cl(
            type_id -- 类型编号
            ,type_name -- 类型名称
            ,code_id -- 代码编号
            ,code_name -- 代码名称
            ,code_desc -- 代码描述
            ,is_valid -- 是否有效
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1p_other_op(
            type_id -- 类型编号
            ,type_name -- 类型名称
            ,code_id -- 代码编号
            ,code_name -- 代码名称
            ,code_desc -- 代码描述
            ,is_valid -- 是否有效
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.type_id, o.type_id) as type_id -- 类型编号
    ,nvl(n.type_name, o.type_name) as type_name -- 类型名称
    ,nvl(n.code_id, o.code_id) as code_id -- 代码编号
    ,nvl(n.code_name, o.code_name) as code_name -- 代码名称
    ,nvl(n.code_desc, o.code_desc) as code_desc -- 代码描述
    ,nvl(n.is_valid, o.is_valid) as is_valid -- 是否有效
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.modify_tm, o.modify_tm) as modify_tm -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,case when
            n.type_id is null
            and n.code_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.type_id is null
            and n.code_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.type_id is null
            and n.code_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t1p_other_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t1p_other where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.type_id = n.type_id
            and o.code_id = n.code_id
where (
        o.type_id is null
        and o.code_id is null
    )
    or (
        n.type_id is null
        and n.code_id is null
    )
    or (
        o.type_name <> n.type_name
        or o.code_name <> n.code_name
        or o.code_desc <> n.code_desc
        or o.is_valid <> n.is_valid
        or o.create_tm <> n.create_tm
        or o.creator <> n.creator
        or o.modify_tm <> n.modify_tm
        or o.modifier <> n.modifier
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1p_other_cl(
            type_id -- 类型编号
            ,type_name -- 类型名称
            ,code_id -- 代码编号
            ,code_name -- 代码名称
            ,code_desc -- 代码描述
            ,is_valid -- 是否有效
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1p_other_op(
            type_id -- 类型编号
            ,type_name -- 类型名称
            ,code_id -- 代码编号
            ,code_name -- 代码名称
            ,code_desc -- 代码描述
            ,is_valid -- 是否有效
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.type_id -- 类型编号
    ,o.type_name -- 类型名称
    ,o.code_id -- 代码编号
    ,o.code_name -- 代码名称
    ,o.code_desc -- 代码描述
    ,o.is_valid -- 是否有效
    ,o.create_tm -- 创建时间
    ,o.creator -- 创建人
    ,o.modify_tm -- 修改时间
    ,o.modifier -- 修改人
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
from ${iol_schema}.amls_t1p_other_bk o
    left join ${iol_schema}.amls_t1p_other_op n
        on
            o.type_id = n.type_id
            and o.code_id = n.code_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t1p_other_cl d
        on
            o.type_id = d.type_id
            and o.code_id = d.code_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t1p_other;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t1p_other') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t1p_other drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t1p_other add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t1p_other exchange partition p_${batch_date} with table ${iol_schema}.amls_t1p_other_cl;
alter table ${iol_schema}.amls_t1p_other exchange partition p_20991231 with table ${iol_schema}.amls_t1p_other_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t1p_other to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1p_other_op purge;
drop table ${iol_schema}.amls_t1p_other_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t1p_other_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t1p_other',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
