/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wmanage_batch_summary
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
create table ${iol_schema}.mpcs_a1wmanage_batch_summary_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wmanage_batch_summary
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary_op purge;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wmanage_batch_summary_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wmanage_batch_summary where 0=1;

create table ${iol_schema}.mpcs_a1wmanage_batch_summary_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wmanage_batch_summary where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wmanage_batch_summary_cl(
            branch_no -- 机构编号不带_
            ,branch_id -- 机构id带_的多级结构
            ,company_count -- 入驻公司总数
            ,employee_count -- 员工总数
            ,total_amount -- 发放工资总金额
            ,batch_count -- 发放工资总次数
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,redis_update_time -- redis更新同步的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wmanage_batch_summary_op(
            branch_no -- 机构编号不带_
            ,branch_id -- 机构id带_的多级结构
            ,company_count -- 入驻公司总数
            ,employee_count -- 员工总数
            ,total_amount -- 发放工资总金额
            ,batch_count -- 发放工资总次数
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,redis_update_time -- redis更新同步的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch_no, o.branch_no) as branch_no -- 机构编号不带_
    ,nvl(n.branch_id, o.branch_id) as branch_id -- 机构id带_的多级结构
    ,nvl(n.company_count, o.company_count) as company_count -- 入驻公司总数
    ,nvl(n.employee_count, o.employee_count) as employee_count -- 员工总数
    ,nvl(n.total_amount, o.total_amount) as total_amount -- 发放工资总金额
    ,nvl(n.batch_count, o.batch_count) as batch_count -- 发放工资总次数
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,nvl(n.redis_update_time, o.redis_update_time) as redis_update_time -- redis更新同步的时间
    ,case when
            n.branch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wmanage_batch_summary_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wmanage_batch_summary where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch_no = n.branch_no
where (
        o.branch_no is null
    )
    or (
        n.branch_no is null
    )
    or (
        o.branch_id <> n.branch_id
        or o.company_count <> n.company_count
        or o.employee_count <> n.employee_count
        or o.total_amount <> n.total_amount
        or o.batch_count <> n.batch_count
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
        or o.redis_update_time <> n.redis_update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wmanage_batch_summary_cl(
            branch_no -- 机构编号不带_
            ,branch_id -- 机构id带_的多级结构
            ,company_count -- 入驻公司总数
            ,employee_count -- 员工总数
            ,total_amount -- 发放工资总金额
            ,batch_count -- 发放工资总次数
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,redis_update_time -- redis更新同步的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wmanage_batch_summary_op(
            branch_no -- 机构编号不带_
            ,branch_id -- 机构id带_的多级结构
            ,company_count -- 入驻公司总数
            ,employee_count -- 员工总数
            ,total_amount -- 发放工资总金额
            ,batch_count -- 发放工资总次数
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,redis_update_time -- redis更新同步的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch_no -- 机构编号不带_
    ,o.branch_id -- 机构id带_的多级结构
    ,o.company_count -- 入驻公司总数
    ,o.employee_count -- 员工总数
    ,o.total_amount -- 发放工资总金额
    ,o.batch_count -- 发放工资总次数
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.redis_update_time -- redis更新同步的时间
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
from ${iol_schema}.mpcs_a1wmanage_batch_summary_bk o
    left join ${iol_schema}.mpcs_a1wmanage_batch_summary_op n
        on
            o.branch_no = n.branch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wmanage_batch_summary_cl d
        on
            o.branch_no = d.branch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wmanage_batch_summary;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wmanage_batch_summary') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wmanage_batch_summary drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wmanage_batch_summary add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wmanage_batch_summary exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wmanage_batch_summary_cl;
alter table ${iol_schema}.mpcs_a1wmanage_batch_summary exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wmanage_batch_summary_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wmanage_batch_summary to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary_op purge;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wmanage_batch_summary_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wmanage_batch_summary',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
