/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_sched_mode
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
create table ${iol_schema}.ncbs_cl_sched_mode_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_sched_mode
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_sched_mode_op purge;
drop table ${iol_schema}.ncbs_cl_sched_mode_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_sched_mode_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_sched_mode where 0=1;

create table ${iol_schema}.ncbs_cl_sched_mode_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_sched_mode where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_sched_mode_cl(
            calc_formula -- 计算公式
            ,company -- 法人
            ,first_break_flag -- 首期破期
            ,pay_rec -- 收付标志
            ,pri_repay_type -- 本金还款方式
            ,process_type -- 本息处理方式
            ,sched_mode -- 还款方式
            ,sched_mode_desc -- 还款方式描述
            ,tran_timestamp -- 交易时间戳
            ,last_merge_period -- 末期合并天数
            ,last_merge_type -- 末期合并类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_sched_mode_op(
            calc_formula -- 计算公式
            ,company -- 法人
            ,first_break_flag -- 首期破期
            ,pay_rec -- 收付标志
            ,pri_repay_type -- 本金还款方式
            ,process_type -- 本息处理方式
            ,sched_mode -- 还款方式
            ,sched_mode_desc -- 还款方式描述
            ,tran_timestamp -- 交易时间戳
            ,last_merge_period -- 末期合并天数
            ,last_merge_type -- 末期合并类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.calc_formula, o.calc_formula) as calc_formula -- 计算公式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.first_break_flag, o.first_break_flag) as first_break_flag -- 首期破期
    ,nvl(n.pay_rec, o.pay_rec) as pay_rec -- 收付标志
    ,nvl(n.pri_repay_type, o.pri_repay_type) as pri_repay_type -- 本金还款方式
    ,nvl(n.process_type, o.process_type) as process_type -- 本息处理方式
    ,nvl(n.sched_mode, o.sched_mode) as sched_mode -- 还款方式
    ,nvl(n.sched_mode_desc, o.sched_mode_desc) as sched_mode_desc -- 还款方式描述
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.last_merge_period, o.last_merge_period) as last_merge_period -- 末期合并天数
    ,nvl(n.last_merge_type, o.last_merge_type) as last_merge_type -- 末期合并类型
    ,case when
            n.sched_mode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sched_mode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sched_mode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_sched_mode_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_sched_mode where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sched_mode = n.sched_mode
where (
        o.sched_mode is null
    )
    or (
        n.sched_mode is null
    )
    or (
        o.calc_formula <> n.calc_formula
        or o.company <> n.company
        or o.first_break_flag <> n.first_break_flag
        or o.pay_rec <> n.pay_rec
        or o.pri_repay_type <> n.pri_repay_type
        or o.process_type <> n.process_type
        or o.sched_mode_desc <> n.sched_mode_desc
        or o.tran_timestamp <> n.tran_timestamp
        or o.last_merge_period <> n.last_merge_period
        or o.last_merge_type <> n.last_merge_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_sched_mode_cl(
            calc_formula -- 计算公式
            ,company -- 法人
            ,first_break_flag -- 首期破期
            ,pay_rec -- 收付标志
            ,pri_repay_type -- 本金还款方式
            ,process_type -- 本息处理方式
            ,sched_mode -- 还款方式
            ,sched_mode_desc -- 还款方式描述
            ,tran_timestamp -- 交易时间戳
            ,last_merge_period -- 末期合并天数
            ,last_merge_type -- 末期合并类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_sched_mode_op(
            calc_formula -- 计算公式
            ,company -- 法人
            ,first_break_flag -- 首期破期
            ,pay_rec -- 收付标志
            ,pri_repay_type -- 本金还款方式
            ,process_type -- 本息处理方式
            ,sched_mode -- 还款方式
            ,sched_mode_desc -- 还款方式描述
            ,tran_timestamp -- 交易时间戳
            ,last_merge_period -- 末期合并天数
            ,last_merge_type -- 末期合并类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.calc_formula -- 计算公式
    ,o.company -- 法人
    ,o.first_break_flag -- 首期破期
    ,o.pay_rec -- 收付标志
    ,o.pri_repay_type -- 本金还款方式
    ,o.process_type -- 本息处理方式
    ,o.sched_mode -- 还款方式
    ,o.sched_mode_desc -- 还款方式描述
    ,o.tran_timestamp -- 交易时间戳
    ,o.last_merge_period -- 末期合并天数
    ,o.last_merge_type -- 末期合并类型
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
from ${iol_schema}.ncbs_cl_sched_mode_bk o
    left join ${iol_schema}.ncbs_cl_sched_mode_op n
        on
            o.sched_mode = n.sched_mode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_sched_mode_cl d
        on
            o.sched_mode = d.sched_mode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_sched_mode;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_sched_mode') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_sched_mode drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_sched_mode add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_sched_mode exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_sched_mode_cl;
alter table ${iol_schema}.ncbs_cl_sched_mode exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_sched_mode_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_sched_mode to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_sched_mode_op purge;
drop table ${iol_schema}.ncbs_cl_sched_mode_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_sched_mode_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_sched_mode',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
