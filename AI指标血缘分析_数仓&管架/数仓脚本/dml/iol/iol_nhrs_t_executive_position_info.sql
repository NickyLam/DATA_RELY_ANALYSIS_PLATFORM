/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_t_executive_position_info
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
create table ${iol_schema}.nhrs_t_executive_position_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_t_executive_position_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_t_executive_position_info_op purge;
drop table ${iol_schema}.nhrs_t_executive_position_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_t_executive_position_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_t_executive_position_info where 0=1;

create table ${iol_schema}.nhrs_t_executive_position_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_t_executive_position_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_t_executive_position_info_cl(
            id -- 主键ID
            ,user_id -- 员工号
            ,login_name -- 域名
            ,user_name -- 姓名
            ,approval_date -- 批复日期
            ,position_date -- 任职日期
            ,is_effective -- 是否有效（Y：有效，N：无效）
            ,create_user_id -- 创建人ID
            ,create_user_name -- 创建人姓名
            ,create_time -- 创建时间
            ,update_user_id -- 修改人ID
            ,update_user_name -- 修改人姓名
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_t_executive_position_info_op(
            id -- 主键ID
            ,user_id -- 员工号
            ,login_name -- 域名
            ,user_name -- 姓名
            ,approval_date -- 批复日期
            ,position_date -- 任职日期
            ,is_effective -- 是否有效（Y：有效，N：无效）
            ,create_user_id -- 创建人ID
            ,create_user_name -- 创建人姓名
            ,create_time -- 创建时间
            ,update_user_id -- 修改人ID
            ,update_user_name -- 修改人姓名
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.user_id, o.user_id) as user_id -- 员工号
    ,nvl(n.login_name, o.login_name) as login_name -- 域名
    ,nvl(n.user_name, o.user_name) as user_name -- 姓名
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 批复日期
    ,nvl(n.position_date, o.position_date) as position_date -- 任职日期
    ,nvl(n.is_effective, o.is_effective) as is_effective -- 是否有效（Y：有效，N：无效）
    ,nvl(n.create_user_id, o.create_user_id) as create_user_id -- 创建人ID
    ,nvl(n.create_user_name, o.create_user_name) as create_user_name -- 创建人姓名
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 修改人ID
    ,nvl(n.update_user_name, o.update_user_name) as update_user_name -- 修改人姓名
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
from (select * from ${iol_schema}.nhrs_t_executive_position_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_t_executive_position_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.user_id <> n.user_id
        or o.login_name <> n.login_name
        or o.user_name <> n.user_name
        or o.approval_date <> n.approval_date
        or o.position_date <> n.position_date
        or o.is_effective <> n.is_effective
        or o.create_user_id <> n.create_user_id
        or o.create_user_name <> n.create_user_name
        or o.create_time <> n.create_time
        or o.update_user_id <> n.update_user_id
        or o.update_user_name <> n.update_user_name
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_t_executive_position_info_cl(
            id -- 主键ID
            ,user_id -- 员工号
            ,login_name -- 域名
            ,user_name -- 姓名
            ,approval_date -- 批复日期
            ,position_date -- 任职日期
            ,is_effective -- 是否有效（Y：有效，N：无效）
            ,create_user_id -- 创建人ID
            ,create_user_name -- 创建人姓名
            ,create_time -- 创建时间
            ,update_user_id -- 修改人ID
            ,update_user_name -- 修改人姓名
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_t_executive_position_info_op(
            id -- 主键ID
            ,user_id -- 员工号
            ,login_name -- 域名
            ,user_name -- 姓名
            ,approval_date -- 批复日期
            ,position_date -- 任职日期
            ,is_effective -- 是否有效（Y：有效，N：无效）
            ,create_user_id -- 创建人ID
            ,create_user_name -- 创建人姓名
            ,create_time -- 创建时间
            ,update_user_id -- 修改人ID
            ,update_user_name -- 修改人姓名
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.user_id -- 员工号
    ,o.login_name -- 域名
    ,o.user_name -- 姓名
    ,o.approval_date -- 批复日期
    ,o.position_date -- 任职日期
    ,o.is_effective -- 是否有效（Y：有效，N：无效）
    ,o.create_user_id -- 创建人ID
    ,o.create_user_name -- 创建人姓名
    ,o.create_time -- 创建时间
    ,o.update_user_id -- 修改人ID
    ,o.update_user_name -- 修改人姓名
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
from ${iol_schema}.nhrs_t_executive_position_info_bk o
    left join ${iol_schema}.nhrs_t_executive_position_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_t_executive_position_info_cl d
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
--truncate table ${iol_schema}.nhrs_t_executive_position_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_t_executive_position_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_t_executive_position_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_t_executive_position_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_t_executive_position_info exchange partition p_${batch_date} with table ${iol_schema}.nhrs_t_executive_position_info_cl;
alter table ${iol_schema}.nhrs_t_executive_position_info exchange partition p_20991231 with table ${iol_schema}.nhrs_t_executive_position_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_t_executive_position_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_t_executive_position_info_op purge;
drop table ${iol_schema}.nhrs_t_executive_position_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_t_executive_position_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_t_executive_position_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
