/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_bonus_plan
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
create table ${iol_schema}.pbms_tbl_bonus_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_bonus_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_bonus_plan_op purge;
drop table ${iol_schema}.pbms_tbl_bonus_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_bonus_plan where 0=1;

create table ${iol_schema}.pbms_tbl_bonus_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_bonus_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_bonus_plan_cl(
            pk_bonus_plan -- 主键
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分类型
            ,total_bonus -- 总积分
            ,valid_bonus -- 可用积分
            ,apply_bonus -- 已用积分
            ,expire_bonus -- 过期积分
            ,freeze_bonus -- 冻结积分
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 更新人
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_bonus_plan_op(
            pk_bonus_plan -- 主键
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分类型
            ,total_bonus -- 总积分
            ,valid_bonus -- 可用积分
            ,apply_bonus -- 已用积分
            ,expire_bonus -- 过期积分
            ,freeze_bonus -- 冻结积分
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 更新人
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_bonus_plan, o.pk_bonus_plan) as pk_bonus_plan -- 主键
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.bonus_plan_type, o.bonus_plan_type) as bonus_plan_type -- 积分类型
    ,nvl(n.total_bonus, o.total_bonus) as total_bonus -- 总积分
    ,nvl(n.valid_bonus, o.valid_bonus) as valid_bonus -- 可用积分
    ,nvl(n.apply_bonus, o.apply_bonus) as apply_bonus -- 已用积分
    ,nvl(n.expire_bonus, o.expire_bonus) as expire_bonus -- 过期积分
    ,nvl(n.freeze_bonus, o.freeze_bonus) as freeze_bonus -- 冻结积分
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除标志（0-正常，1-删除）
    ,case when
            n.pk_bonus_plan is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_bonus_plan is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_bonus_plan is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_bonus_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_bonus_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_bonus_plan = n.pk_bonus_plan
where (
        o.pk_bonus_plan is null
    )
    or (
        n.pk_bonus_plan is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.bonus_plan_type <> n.bonus_plan_type
        or o.total_bonus <> n.total_bonus
        or o.valid_bonus <> n.valid_bonus
        or o.apply_bonus <> n.apply_bonus
        or o.expire_bonus <> n.expire_bonus
        or o.freeze_bonus <> n.freeze_bonus
        or o.created_by <> n.created_by
        or o.create_time <> n.create_time
        or o.updated_by <> n.updated_by
        or o.update_time <> n.update_time
        or o.del_flag <> n.del_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_bonus_plan_cl(
            pk_bonus_plan -- 主键
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分类型
            ,total_bonus -- 总积分
            ,valid_bonus -- 可用积分
            ,apply_bonus -- 已用积分
            ,expire_bonus -- 过期积分
            ,freeze_bonus -- 冻结积分
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 更新人
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_bonus_plan_op(
            pk_bonus_plan -- 主键
            ,cust_id -- 客户号
            ,bonus_plan_type -- 积分类型
            ,total_bonus -- 总积分
            ,valid_bonus -- 可用积分
            ,apply_bonus -- 已用积分
            ,expire_bonus -- 过期积分
            ,freeze_bonus -- 冻结积分
            ,created_by -- 创建人
            ,create_time -- 创建时间
            ,updated_by -- 更新人
            ,update_time -- 更新时间
            ,del_flag -- 逻辑删除标志（0-正常，1-删除）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_bonus_plan -- 主键
    ,o.cust_id -- 客户号
    ,o.bonus_plan_type -- 积分类型
    ,o.total_bonus -- 总积分
    ,o.valid_bonus -- 可用积分
    ,o.apply_bonus -- 已用积分
    ,o.expire_bonus -- 过期积分
    ,o.freeze_bonus -- 冻结积分
    ,o.created_by -- 创建人
    ,o.create_time -- 创建时间
    ,o.updated_by -- 更新人
    ,o.update_time -- 更新时间
    ,o.del_flag -- 逻辑删除标志（0-正常，1-删除）
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
from ${iol_schema}.pbms_tbl_bonus_plan_bk o
    left join ${iol_schema}.pbms_tbl_bonus_plan_op n
        on
            o.pk_bonus_plan = n.pk_bonus_plan
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_bonus_plan_cl d
        on
            o.pk_bonus_plan = d.pk_bonus_plan
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_bonus_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_bonus_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_bonus_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_bonus_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_bonus_plan exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_bonus_plan_cl;
alter table ${iol_schema}.pbms_tbl_bonus_plan exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_bonus_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_bonus_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_bonus_plan_op purge;
drop table ${iol_schema}.pbms_tbl_bonus_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_bonus_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_bonus_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
