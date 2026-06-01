/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t1p_pbc_ctvc
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
create table ${iol_schema}.amls_t1p_pbc_ctvc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t1p_pbc_ctvc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1p_pbc_ctvc_op purge;
drop table ${iol_schema}.amls_t1p_pbc_ctvc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1p_pbc_ctvc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1p_pbc_ctvc where 0=1;

create table ${iol_schema}.amls_t1p_pbc_ctvc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1p_pbc_ctvc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1p_pbc_ctvc_cl(
            ctvckey -- 对私客户的职业或对公客户的行业类别码
            ,ctvc_type_cd -- 分类1:个人职业 2:对公行业
            ,ctvcdesc -- 描述
            ,flag -- 是否有效
            ,create_dt -- 创建时间
            ,ctvc_lvl -- 层级
            ,upctvckey -- 上层类别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1p_pbc_ctvc_op(
            ctvckey -- 对私客户的职业或对公客户的行业类别码
            ,ctvc_type_cd -- 分类1:个人职业 2:对公行业
            ,ctvcdesc -- 描述
            ,flag -- 是否有效
            ,create_dt -- 创建时间
            ,ctvc_lvl -- 层级
            ,upctvckey -- 上层类别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ctvckey, o.ctvckey) as ctvckey -- 对私客户的职业或对公客户的行业类别码
    ,nvl(n.ctvc_type_cd, o.ctvc_type_cd) as ctvc_type_cd -- 分类1:个人职业 2:对公行业
    ,nvl(n.ctvcdesc, o.ctvcdesc) as ctvcdesc -- 描述
    ,nvl(n.flag, o.flag) as flag -- 是否有效
    ,nvl(n.create_dt, o.create_dt) as create_dt -- 创建时间
    ,nvl(n.ctvc_lvl, o.ctvc_lvl) as ctvc_lvl -- 层级
    ,nvl(n.upctvckey, o.upctvckey) as upctvckey -- 上层类别码
    ,case when
            n.ctvckey is null
            and n.ctvc_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ctvckey is null
            and n.ctvc_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ctvckey is null
            and n.ctvc_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t1p_pbc_ctvc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t1p_pbc_ctvc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ctvckey = n.ctvckey
            and o.ctvc_type_cd = n.ctvc_type_cd
where (
        o.ctvckey is null
        and o.ctvc_type_cd is null
    )
    or (
        n.ctvckey is null
        and n.ctvc_type_cd is null
    )
    or (
        o.ctvcdesc <> n.ctvcdesc
        or o.flag <> n.flag
        or o.create_dt <> n.create_dt
        or o.ctvc_lvl <> n.ctvc_lvl
        or o.upctvckey <> n.upctvckey
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1p_pbc_ctvc_cl(
            ctvckey -- 对私客户的职业或对公客户的行业类别码
            ,ctvc_type_cd -- 分类1:个人职业 2:对公行业
            ,ctvcdesc -- 描述
            ,flag -- 是否有效
            ,create_dt -- 创建时间
            ,ctvc_lvl -- 层级
            ,upctvckey -- 上层类别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1p_pbc_ctvc_op(
            ctvckey -- 对私客户的职业或对公客户的行业类别码
            ,ctvc_type_cd -- 分类1:个人职业 2:对公行业
            ,ctvcdesc -- 描述
            ,flag -- 是否有效
            ,create_dt -- 创建时间
            ,ctvc_lvl -- 层级
            ,upctvckey -- 上层类别码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ctvckey -- 对私客户的职业或对公客户的行业类别码
    ,o.ctvc_type_cd -- 分类1:个人职业 2:对公行业
    ,o.ctvcdesc -- 描述
    ,o.flag -- 是否有效
    ,o.create_dt -- 创建时间
    ,o.ctvc_lvl -- 层级
    ,o.upctvckey -- 上层类别码
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
from ${iol_schema}.amls_t1p_pbc_ctvc_bk o
    left join ${iol_schema}.amls_t1p_pbc_ctvc_op n
        on
            o.ctvckey = n.ctvckey
            and o.ctvc_type_cd = n.ctvc_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t1p_pbc_ctvc_cl d
        on
            o.ctvckey = d.ctvckey
            and o.ctvc_type_cd = d.ctvc_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t1p_pbc_ctvc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t1p_pbc_ctvc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t1p_pbc_ctvc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t1p_pbc_ctvc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t1p_pbc_ctvc exchange partition p_${batch_date} with table ${iol_schema}.amls_t1p_pbc_ctvc_cl;
alter table ${iol_schema}.amls_t1p_pbc_ctvc exchange partition p_20991231 with table ${iol_schema}.amls_t1p_pbc_ctvc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t1p_pbc_ctvc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1p_pbc_ctvc_op purge;
drop table ${iol_schema}.amls_t1p_pbc_ctvc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t1p_pbc_ctvc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t1p_pbc_ctvc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
