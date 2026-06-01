/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_cust_member
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
create table ${iol_schema}.pbms_tbl_cust_member_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_cust_member
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_cust_member_op purge;
drop table ${iol_schema}.pbms_tbl_cust_member_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_cust_member_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_cust_member where 0=1;

create table ${iol_schema}.pbms_tbl_cust_member_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_cust_member where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_cust_member_cl(
            id -- 主键
            ,cust_id -- 客户ID（客户号 or 潜客号）
            ,is_positive -- 客户类型 1-正式客户 0-潜客
            ,member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
            ,start_date -- 等级开始日
            ,start_time -- 等级开始时间
            ,end_date -- 等级到期日
            ,last_upgrade_time -- 最近升级时间
            ,last_downgrade_time -- 最近降级时间
            ,del_flag -- 逻辑删除
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 修改人
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_cust_member_op(
            id -- 主键
            ,cust_id -- 客户ID（客户号 or 潜客号）
            ,is_positive -- 客户类型 1-正式客户 0-潜客
            ,member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
            ,start_date -- 等级开始日
            ,start_time -- 等级开始时间
            ,end_date -- 等级到期日
            ,last_upgrade_time -- 最近升级时间
            ,last_downgrade_time -- 最近降级时间
            ,del_flag -- 逻辑删除
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 修改人
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户ID（客户号 or 潜客号）
    ,nvl(n.is_positive, o.is_positive) as is_positive -- 客户类型 1-正式客户 0-潜客
    ,nvl(n.member_code, o.member_code) as member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
    ,nvl(n.start_date, o.start_date) as start_date -- 等级开始日
    ,nvl(n.start_time, o.start_time) as start_time -- 等级开始时间
    ,nvl(n.end_date, o.end_date) as end_date -- 等级到期日
    ,nvl(n.last_upgrade_time, o.last_upgrade_time) as last_upgrade_time -- 最近升级时间
    ,nvl(n.last_downgrade_time, o.last_downgrade_time) as last_downgrade_time -- 最近降级时间
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改人
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
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
from (select * from ${iol_schema}.pbms_tbl_cust_member_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_cust_member where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.is_positive <> n.is_positive
        or o.member_code <> n.member_code
        or o.start_date <> n.start_date
        or o.start_time <> n.start_time
        or o.end_date <> n.end_date
        or o.last_upgrade_time <> n.last_upgrade_time
        or o.last_downgrade_time <> n.last_downgrade_time
        or o.del_flag <> n.del_flag
        or o.created_by <> n.created_by
        or o.create_time <> n.create_time
        or o.updated_by <> n.updated_by
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_cust_member_cl(
            id -- 主键
            ,cust_id -- 客户ID（客户号 or 潜客号）
            ,is_positive -- 客户类型 1-正式客户 0-潜客
            ,member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
            ,start_date -- 等级开始日
            ,start_time -- 等级开始时间
            ,end_date -- 等级到期日
            ,last_upgrade_time -- 最近升级时间
            ,last_downgrade_time -- 最近降级时间
            ,del_flag -- 逻辑删除
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 修改人
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_cust_member_op(
            id -- 主键
            ,cust_id -- 客户ID（客户号 or 潜客号）
            ,is_positive -- 客户类型 1-正式客户 0-潜客
            ,member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
            ,start_date -- 等级开始日
            ,start_time -- 等级开始时间
            ,end_date -- 等级到期日
            ,last_upgrade_time -- 最近升级时间
            ,last_downgrade_time -- 最近降级时间
            ,del_flag -- 逻辑删除
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 修改人
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.cust_id -- 客户ID（客户号 or 潜客号）
    ,o.is_positive -- 客户类型 1-正式客户 0-潜客
    ,o.member_code -- 等级编码，关联tbl_member_grade表必须是拿start_flag=1的
    ,o.start_date -- 等级开始日
    ,o.start_time -- 等级开始时间
    ,o.end_date -- 等级到期日
    ,o.last_upgrade_time -- 最近升级时间
    ,o.last_downgrade_time -- 最近降级时间
    ,o.del_flag -- 逻辑删除
    ,o.created_by -- 创建人
    ,o.create_time -- 创建时间
    ,o.updated_by -- 修改人
    ,o.update_time -- 修改时间
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
from ${iol_schema}.pbms_tbl_cust_member_bk o
    left join ${iol_schema}.pbms_tbl_cust_member_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_cust_member_cl d
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
--truncate table ${iol_schema}.pbms_tbl_cust_member;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_cust_member') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_cust_member drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_cust_member add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_cust_member exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_cust_member_cl;
alter table ${iol_schema}.pbms_tbl_cust_member exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_cust_member_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_cust_member to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_cust_member_op purge;
drop table ${iol_schema}.pbms_tbl_cust_member_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_cust_member_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_cust_member',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
