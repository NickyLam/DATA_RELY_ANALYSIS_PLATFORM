/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_plan
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
create table ${iol_schema}.ncbs_cl_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_plan_op purge;
drop table ${iol_schema}.ncbs_cl_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_plan where 0=1;

create table ${iol_schema}.ncbs_cl_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_plan_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,plan_status -- 计划状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_day -- 处理日
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,use_amt -- 已使用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_plan_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,plan_status -- 计划状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_day -- 处理日
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,use_amt -- 已使用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.plan_no, o.plan_no) as plan_no -- 执行计划编号
    ,nvl(n.plan_status, o.plan_status) as plan_status -- 计划状态
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 预留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 预留字段2
    ,nvl(n.total_times, o.total_times) as total_times -- 扣划总次数
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_deal_date, o.last_deal_date) as last_deal_date -- 上一处理日
    ,nvl(n.next_deal_date, o.next_deal_date) as next_deal_date -- 下一处理日
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.deal_day, o.deal_day) as deal_day -- 处理日
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 总金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.use_amt, o.use_amt) as use_amt -- 已使用金额
    ,case when
            n.plan_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.plan_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.plan_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plan_no = n.plan_no
where (
        o.plan_no is null
    )
    or (
        n.plan_no is null
    )
    or (
        o.amount <> n.amount
        or o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.period_freq <> n.period_freq
        or o.user_id <> n.user_id
        or o.company <> n.company
        or o.event_type <> n.event_type
        or o.plan_status <> n.plan_status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.total_times <> n.total_times
        or o.end_date <> n.end_date
        or o.last_change_date <> n.last_change_date
        or o.last_deal_date <> n.last_deal_date
        or o.next_deal_date <> n.next_deal_date
        or o.start_date <> n.start_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.deal_day <> n.deal_day
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.total_amt <> n.total_amt
        or o.tran_branch <> n.tran_branch
        or o.use_amt <> n.use_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_plan_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,plan_status -- 计划状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_day -- 处理日
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,use_amt -- 已使用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_plan_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,plan_status -- 计划状态
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,deal_day -- 处理日
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,use_amt -- 已使用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amount -- 金额
    ,o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.period_freq -- 频率id
    ,o.user_id -- 交易柜员编号
    ,o.company -- 法人
    ,o.event_type -- 事件类型
    ,o.plan_no -- 执行计划编号
    ,o.plan_status -- 计划状态
    ,o.reserve1 -- 预留字段1
    ,o.reserve2 -- 预留字段2
    ,o.total_times -- 扣划总次数
    ,o.end_date -- 结束日期
    ,o.last_change_date -- 最后修改日期
    ,o.last_deal_date -- 上一处理日
    ,o.next_deal_date -- 下一处理日
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.deal_day -- 处理日
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.total_amt -- 总金额
    ,o.tran_branch -- 核心交易机构编号
    ,o.use_amt -- 已使用金额
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
from ${iol_schema}.ncbs_cl_plan_bk o
    left join ${iol_schema}.ncbs_cl_plan_op n
        on
            o.plan_no = n.plan_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_plan_cl d
        on
            o.plan_no = d.plan_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_plan exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_plan_cl;
alter table ${iol_schema}.ncbs_cl_plan exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_plan_op purge;
drop table ${iol_schema}.ncbs_cl_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
