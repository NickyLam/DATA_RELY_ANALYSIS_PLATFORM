/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_apply_switch
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
create table ${iol_schema}.ncbs_tb_apply_switch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_apply_switch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_apply_switch_op purge;
drop table ${iol_schema}.ncbs_tb_apply_switch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_apply_switch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_apply_switch where 0=1;

create table ${iol_schema}.ncbs_tb_apply_switch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_apply_switch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_apply_switch_cl(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,tb_switch_state -- 开关状态
            ,end_date -- 结束日期
            ,last_update_date -- 上次更新日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_user_id -- 上一柜员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_apply_switch_op(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,tb_switch_state -- 开关状态
            ,end_date -- 结束日期
            ,last_update_date -- 上次更新日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_user_id -- 上一柜员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 预约申请类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cv_flag, o.cv_flag) as cv_flag -- 现金/凭证标志
    ,nvl(n.tb_switch_state, o.tb_switch_state) as tb_switch_state -- 开关状态
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_update_date, o.last_update_date) as last_update_date -- 上次更新日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 上一柜员id
    ,case when
            n.branch is null
            and n.apply_type is null
            and n.cv_flag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch is null
            and n.apply_type is null
            and n.cv_flag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch is null
            and n.apply_type is null
            and n.cv_flag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_apply_switch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_apply_switch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch = n.branch
            and o.apply_type = n.apply_type
            and o.cv_flag = n.cv_flag
where (
        o.branch is null
        and o.apply_type is null
        and o.cv_flag is null
    )
    or (
        n.branch is null
        and n.apply_type is null
        and n.cv_flag is null
    )
    or (
        o.user_id <> n.user_id
        or o.company <> n.company
        or o.tb_switch_state <> n.tb_switch_state
        or o.end_date <> n.end_date
        or o.last_update_date <> n.last_update_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_user_id <> n.last_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_apply_switch_cl(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,tb_switch_state -- 开关状态
            ,end_date -- 结束日期
            ,last_update_date -- 上次更新日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_user_id -- 上一柜员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_apply_switch_op(
            branch -- 机构编号
            ,user_id -- 交易柜员编号
            ,apply_type -- 预约申请类型
            ,company -- 法人
            ,cv_flag -- 现金/凭证标志
            ,tb_switch_state -- 开关状态
            ,end_date -- 结束日期
            ,last_update_date -- 上次更新日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,last_user_id -- 上一柜员id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.user_id -- 交易柜员编号
    ,o.apply_type -- 预约申请类型
    ,o.company -- 法人
    ,o.cv_flag -- 现金/凭证标志
    ,o.tb_switch_state -- 开关状态
    ,o.end_date -- 结束日期
    ,o.last_update_date -- 上次更新日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_user_id -- 上一柜员id
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
from ${iol_schema}.ncbs_tb_apply_switch_bk o
    left join ${iol_schema}.ncbs_tb_apply_switch_op n
        on
            o.branch = n.branch
            and o.apply_type = n.apply_type
            and o.cv_flag = n.cv_flag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_apply_switch_cl d
        on
            o.branch = d.branch
            and o.apply_type = d.apply_type
            and o.cv_flag = d.cv_flag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_apply_switch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_apply_switch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_apply_switch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_apply_switch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_apply_switch exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_apply_switch_cl;
alter table ${iol_schema}.ncbs_tb_apply_switch exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_apply_switch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_apply_switch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_apply_switch_op purge;
drop table ${iol_schema}.ncbs_tb_apply_switch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_apply_switch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_apply_switch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
