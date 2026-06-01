/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_p_class
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
create table ${iol_schema}.ibms_ttrd_p_class_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_p_class
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_p_class_op purge;
drop table ${iol_schema}.ibms_ttrd_p_class_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_p_class_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_p_class where 0=1;

create table ${iol_schema}.ibms_ttrd_p_class_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_p_class where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_p_class_cl(
            id -- 产品类型id
            ,a_type -- 资产类型
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,in_sys_process -- 系统流程
            ,trdtype -- 业务种类
            ,acting_type -- 会计分类
            ,p_class_code -- 产品分类码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_p_class_op(
            id -- 产品类型id
            ,a_type -- 资产类型
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,in_sys_process -- 系统流程
            ,trdtype -- 业务种类
            ,acting_type -- 会计分类
            ,p_class_code -- 产品分类码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 产品类型id
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.p_type_name, o.p_type_name) as p_type_name -- 产品类型名称
    ,nvl(n.in_sys_process, o.in_sys_process) as in_sys_process -- 系统流程
    ,nvl(n.trdtype, o.trdtype) as trdtype -- 业务种类
    ,nvl(n.acting_type, o.acting_type) as acting_type -- 会计分类
    ,nvl(n.p_class_code, o.p_class_code) as p_class_code -- 产品分类码值
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
from (select * from ${iol_schema}.ibms_ttrd_p_class_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_p_class where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.a_type <> n.a_type
        or o.p_class <> n.p_class
        or o.p_type <> n.p_type
        or o.p_type_name <> n.p_type_name
        or o.in_sys_process <> n.in_sys_process
        or o.trdtype <> n.trdtype
        or o.acting_type <> n.acting_type
        or o.p_class_code <> n.p_class_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_p_class_cl(
            id -- 产品类型id
            ,a_type -- 资产类型
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,in_sys_process -- 系统流程
            ,trdtype -- 业务种类
            ,acting_type -- 会计分类
            ,p_class_code -- 产品分类码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_p_class_op(
            id -- 产品类型id
            ,a_type -- 资产类型
            ,p_class -- 产品分类
            ,p_type -- 产品类型
            ,p_type_name -- 产品类型名称
            ,in_sys_process -- 系统流程
            ,trdtype -- 业务种类
            ,acting_type -- 会计分类
            ,p_class_code -- 产品分类码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 产品类型id
    ,o.a_type -- 资产类型
    ,o.p_class -- 产品分类
    ,o.p_type -- 产品类型
    ,o.p_type_name -- 产品类型名称
    ,o.in_sys_process -- 系统流程
    ,o.trdtype -- 业务种类
    ,o.acting_type -- 会计分类
    ,o.p_class_code -- 产品分类码值
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
from ${iol_schema}.ibms_ttrd_p_class_bk o
    left join ${iol_schema}.ibms_ttrd_p_class_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_p_class_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_p_class;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_p_class') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_p_class drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_p_class add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_p_class exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_p_class_cl;
alter table ${iol_schema}.ibms_ttrd_p_class exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_p_class_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_p_class to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_p_class_op purge;
drop table ${iol_schema}.ibms_ttrd_p_class_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_p_class_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_p_class',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
