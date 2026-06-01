/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_credit_pool
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
create table ${iol_schema}.bdps_credit_pool_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_credit_pool;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_credit_pool_op purge;
drop table ${iol_schema}.bdps_credit_pool_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_credit_pool_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_credit_pool where 0=1;

create table ${iol_schema}.bdps_credit_pool_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_credit_pool where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_credit_pool_cl(
            id -- 
            ,cust_id -- 
            ,manager_id -- 
            ,depart_id -- 
            ,collztn_credit_no -- 
            ,valid_flag -- 
            ,branch_id_opt -- 
            ,credit_start_date -- 
            ,credit_end_date -- 
            ,max_impawn_amount -- 
            ,max_impawn_rate -- 
            ,is_use_group -- 
            ,max_group_amount -- 
            ,use_group_type -- 
            ,is_allow_collect -- 
            ,is_auto_collect -- 
            ,collect_to_group -- 
            ,collect_plan -- 
            ,keep_exposure -- 
            ,allow_subcom_use -- 
            ,max_subcom_amount -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,lock_flag -- 
            ,lock_id -- 
            ,group_flag -- 
            ,collect_time -- 
            ,fixed_time -- 
            ,is_allow_nocollztn -- 
            ,is_allow_ele_nocollztn -- 
            ,warn_amount -- 额度预警阀值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_credit_pool_op(
            id -- 
            ,cust_id -- 
            ,manager_id -- 
            ,depart_id -- 
            ,collztn_credit_no -- 
            ,valid_flag -- 
            ,branch_id_opt -- 
            ,credit_start_date -- 
            ,credit_end_date -- 
            ,max_impawn_amount -- 
            ,max_impawn_rate -- 
            ,is_use_group -- 
            ,max_group_amount -- 
            ,use_group_type -- 
            ,is_allow_collect -- 
            ,is_auto_collect -- 
            ,collect_to_group -- 
            ,collect_plan -- 
            ,keep_exposure -- 
            ,allow_subcom_use -- 
            ,max_subcom_amount -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,lock_flag -- 
            ,lock_id -- 
            ,group_flag -- 
            ,collect_time -- 
            ,fixed_time -- 
            ,is_allow_nocollztn -- 
            ,is_allow_ele_nocollztn -- 
            ,warn_amount -- 额度预警阀值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 
    ,nvl(n.depart_id, o.depart_id) as depart_id -- 
    ,nvl(n.collztn_credit_no, o.collztn_credit_no) as collztn_credit_no -- 
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 
    ,nvl(n.branch_id_opt, o.branch_id_opt) as branch_id_opt -- 
    ,nvl(n.credit_start_date, o.credit_start_date) as credit_start_date -- 
    ,nvl(n.credit_end_date, o.credit_end_date) as credit_end_date -- 
    ,nvl(n.max_impawn_amount, o.max_impawn_amount) as max_impawn_amount -- 
    ,nvl(n.max_impawn_rate, o.max_impawn_rate) as max_impawn_rate -- 
    ,nvl(n.is_use_group, o.is_use_group) as is_use_group -- 
    ,nvl(n.max_group_amount, o.max_group_amount) as max_group_amount -- 
    ,nvl(n.use_group_type, o.use_group_type) as use_group_type -- 
    ,nvl(n.is_allow_collect, o.is_allow_collect) as is_allow_collect -- 
    ,nvl(n.is_auto_collect, o.is_auto_collect) as is_auto_collect -- 
    ,nvl(n.collect_to_group, o.collect_to_group) as collect_to_group -- 
    ,nvl(n.collect_plan, o.collect_plan) as collect_plan -- 
    ,nvl(n.keep_exposure, o.keep_exposure) as keep_exposure -- 
    ,nvl(n.allow_subcom_use, o.allow_subcom_use) as allow_subcom_use -- 
    ,nvl(n.max_subcom_amount, o.max_subcom_amount) as max_subcom_amount -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 
    ,nvl(n.lock_id, o.lock_id) as lock_id -- 
    ,nvl(n.group_flag, o.group_flag) as group_flag -- 
    ,nvl(n.collect_time, o.collect_time) as collect_time -- 
    ,nvl(n.fixed_time, o.fixed_time) as fixed_time -- 
    ,nvl(n.is_allow_nocollztn, o.is_allow_nocollztn) as is_allow_nocollztn -- 
    ,nvl(n.is_allow_ele_nocollztn, o.is_allow_ele_nocollztn) as is_allow_ele_nocollztn -- 
    ,nvl(n.warn_amount, o.warn_amount) as warn_amount -- 额度预警阀值
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
from (select * from ${iol_schema}.bdps_credit_pool_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_credit_pool where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.manager_id <> n.manager_id
        or o.depart_id <> n.depart_id
        or o.collztn_credit_no <> n.collztn_credit_no
        or o.valid_flag <> n.valid_flag
        or o.branch_id_opt <> n.branch_id_opt
        or o.credit_start_date <> n.credit_start_date
        or o.credit_end_date <> n.credit_end_date
        or o.max_impawn_amount <> n.max_impawn_amount
        or o.max_impawn_rate <> n.max_impawn_rate
        or o.is_use_group <> n.is_use_group
        or o.max_group_amount <> n.max_group_amount
        or o.use_group_type <> n.use_group_type
        or o.is_allow_collect <> n.is_allow_collect
        or o.is_auto_collect <> n.is_auto_collect
        or o.collect_to_group <> n.collect_to_group
        or o.collect_plan <> n.collect_plan
        or o.keep_exposure <> n.keep_exposure
        or o.allow_subcom_use <> n.allow_subcom_use
        or o.max_subcom_amount <> n.max_subcom_amount
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.lock_flag <> n.lock_flag
        or o.lock_id <> n.lock_id
        or o.group_flag <> n.group_flag
        or o.collect_time <> n.collect_time
        or o.fixed_time <> n.fixed_time
        or o.is_allow_nocollztn <> n.is_allow_nocollztn
        or o.is_allow_ele_nocollztn <> n.is_allow_ele_nocollztn
        or o.warn_amount <> n.warn_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_credit_pool_cl(
            id -- 
            ,cust_id -- 
            ,manager_id -- 
            ,depart_id -- 
            ,collztn_credit_no -- 
            ,valid_flag -- 
            ,branch_id_opt -- 
            ,credit_start_date -- 
            ,credit_end_date -- 
            ,max_impawn_amount -- 
            ,max_impawn_rate -- 
            ,is_use_group -- 
            ,max_group_amount -- 
            ,use_group_type -- 
            ,is_allow_collect -- 
            ,is_auto_collect -- 
            ,collect_to_group -- 
            ,collect_plan -- 
            ,keep_exposure -- 
            ,allow_subcom_use -- 
            ,max_subcom_amount -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,lock_flag -- 
            ,lock_id -- 
            ,group_flag -- 
            ,collect_time -- 
            ,fixed_time -- 
            ,is_allow_nocollztn -- 
            ,is_allow_ele_nocollztn -- 
            ,warn_amount -- 额度预警阀值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_credit_pool_op(
            id -- 
            ,cust_id -- 
            ,manager_id -- 
            ,depart_id -- 
            ,collztn_credit_no -- 
            ,valid_flag -- 
            ,branch_id_opt -- 
            ,credit_start_date -- 
            ,credit_end_date -- 
            ,max_impawn_amount -- 
            ,max_impawn_rate -- 
            ,is_use_group -- 
            ,max_group_amount -- 
            ,use_group_type -- 
            ,is_allow_collect -- 
            ,is_auto_collect -- 
            ,collect_to_group -- 
            ,collect_plan -- 
            ,keep_exposure -- 
            ,allow_subcom_use -- 
            ,max_subcom_amount -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,lock_flag -- 
            ,lock_id -- 
            ,group_flag -- 
            ,collect_time -- 
            ,fixed_time -- 
            ,is_allow_nocollztn -- 
            ,is_allow_ele_nocollztn -- 
            ,warn_amount -- 额度预警阀值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.cust_id -- 
    ,o.manager_id -- 
    ,o.depart_id -- 
    ,o.collztn_credit_no -- 
    ,o.valid_flag -- 
    ,o.branch_id_opt -- 
    ,o.credit_start_date -- 
    ,o.credit_end_date -- 
    ,o.max_impawn_amount -- 
    ,o.max_impawn_rate -- 
    ,o.is_use_group -- 
    ,o.max_group_amount -- 
    ,o.use_group_type -- 
    ,o.is_allow_collect -- 
    ,o.is_auto_collect -- 
    ,o.collect_to_group -- 
    ,o.collect_plan -- 
    ,o.keep_exposure -- 
    ,o.allow_subcom_use -- 
    ,o.max_subcom_amount -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.lock_flag -- 
    ,o.lock_id -- 
    ,o.group_flag -- 
    ,o.collect_time -- 
    ,o.fixed_time -- 
    ,o.is_allow_nocollztn -- 
    ,o.is_allow_ele_nocollztn -- 
    ,o.warn_amount -- 额度预警阀值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_credit_pool_bk o
    left join ${iol_schema}.bdps_credit_pool_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_credit_pool_cl d
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
-- truncate table ${iol_schema}.bdps_credit_pool;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_credit_pool exchange partition p_19000101 with table ${iol_schema}.bdps_credit_pool_cl;
alter table ${iol_schema}.bdps_credit_pool exchange partition p_20991231 with table ${iol_schema}.bdps_credit_pool_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_credit_pool to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_credit_pool_op purge;
drop table ${iol_schema}.bdps_credit_pool_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_credit_pool_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_credit_pool',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
