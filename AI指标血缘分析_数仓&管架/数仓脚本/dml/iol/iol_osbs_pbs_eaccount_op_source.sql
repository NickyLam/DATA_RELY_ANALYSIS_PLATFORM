/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_pbs_eaccount_op_source
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
create table ${iol_schema}.osbs_pbs_eaccount_op_source_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_pbs_eaccount_op_source
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source_op purge;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_pbs_eaccount_op_source_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_eaccount_op_source where 0=1;

create table ${iol_schema}.osbs_pbs_eaccount_op_source_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_pbs_eaccount_op_source where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_eaccount_op_source_cl(
            peos_accesstoken -- 调用服务凭证
            ,peos_source -- 开户来源，MPP小程序
            ,peos_extend_one -- 备用字段1
            ,peos_extend_two -- 备用字段2
            ,peos_extend_third -- 备用字段3
            ,peos_createtime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_eaccount_op_source_op(
            peos_accesstoken -- 调用服务凭证
            ,peos_source -- 开户来源，MPP小程序
            ,peos_extend_one -- 备用字段1
            ,peos_extend_two -- 备用字段2
            ,peos_extend_third -- 备用字段3
            ,peos_createtime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.peos_accesstoken, o.peos_accesstoken) as peos_accesstoken -- 调用服务凭证
    ,nvl(n.peos_source, o.peos_source) as peos_source -- 开户来源，MPP小程序
    ,nvl(n.peos_extend_one, o.peos_extend_one) as peos_extend_one -- 备用字段1
    ,nvl(n.peos_extend_two, o.peos_extend_two) as peos_extend_two -- 备用字段2
    ,nvl(n.peos_extend_third, o.peos_extend_third) as peos_extend_third -- 备用字段3
    ,nvl(n.peos_createtime, o.peos_createtime) as peos_createtime -- 创建时间
    ,case when
            n.peos_accesstoken is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.peos_accesstoken is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.peos_accesstoken is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_pbs_eaccount_op_source_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_pbs_eaccount_op_source where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.peos_accesstoken = n.peos_accesstoken
where (
        o.peos_accesstoken is null
    )
    or (
        n.peos_accesstoken is null
    )
    or (
        o.peos_source <> n.peos_source
        or o.peos_extend_one <> n.peos_extend_one
        or o.peos_extend_two <> n.peos_extend_two
        or o.peos_extend_third <> n.peos_extend_third
        or o.peos_createtime <> n.peos_createtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_pbs_eaccount_op_source_cl(
            peos_accesstoken -- 调用服务凭证
            ,peos_source -- 开户来源，MPP小程序
            ,peos_extend_one -- 备用字段1
            ,peos_extend_two -- 备用字段2
            ,peos_extend_third -- 备用字段3
            ,peos_createtime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_pbs_eaccount_op_source_op(
            peos_accesstoken -- 调用服务凭证
            ,peos_source -- 开户来源，MPP小程序
            ,peos_extend_one -- 备用字段1
            ,peos_extend_two -- 备用字段2
            ,peos_extend_third -- 备用字段3
            ,peos_createtime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.peos_accesstoken -- 调用服务凭证
    ,o.peos_source -- 开户来源，MPP小程序
    ,o.peos_extend_one -- 备用字段1
    ,o.peos_extend_two -- 备用字段2
    ,o.peos_extend_third -- 备用字段3
    ,o.peos_createtime -- 创建时间
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
from ${iol_schema}.osbs_pbs_eaccount_op_source_bk o
    left join ${iol_schema}.osbs_pbs_eaccount_op_source_op n
        on
            o.peos_accesstoken = n.peos_accesstoken
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_pbs_eaccount_op_source_cl d
        on
            o.peos_accesstoken = d.peos_accesstoken
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_pbs_eaccount_op_source;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_pbs_eaccount_op_source') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_pbs_eaccount_op_source drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_pbs_eaccount_op_source add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_pbs_eaccount_op_source exchange partition p_${batch_date} with table ${iol_schema}.osbs_pbs_eaccount_op_source_cl;
alter table ${iol_schema}.osbs_pbs_eaccount_op_source exchange partition p_20991231 with table ${iol_schema}.osbs_pbs_eaccount_op_source_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_pbs_eaccount_op_source to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source_op purge;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_pbs_eaccount_op_source_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_pbs_eaccount_op_source',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
