/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_loan_int_default
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
create table ${iol_schema}.ncbs_cl_loan_int_default_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_loan_int_default
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_int_default_op purge;
drop table ${iol_schema}.ncbs_cl_loan_int_default_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_int_default_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan_int_default where 0=1;

create table ${iol_schema}.ncbs_cl_loan_int_default_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan_int_default where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_int_default_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,int_appl_type -- 利率启用方式
            ,int_cap_flag -- 资本化标志
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,penalty_odi_rate_type -- 罚息利率使用方式
            ,rate_effect_type -- 利率生效方式
            ,roll_freq -- 利率变更周期
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,next_cycle_date -- 下一结息日
            ,next_roll_date -- 下一个利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,max_int_rate -- 执行利率上限
            ,min_int_rate -- 执行利率下限
            ,real_rate -- 执行利率
            ,roll_day -- 利率变更日
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,int_day -- 存贷结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_int_default_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,int_appl_type -- 利率启用方式
            ,int_cap_flag -- 资本化标志
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,penalty_odi_rate_type -- 罚息利率使用方式
            ,rate_effect_type -- 利率生效方式
            ,roll_freq -- 利率变更周期
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,next_cycle_date -- 下一结息日
            ,next_roll_date -- 下一个利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,max_int_rate -- 执行利率上限
            ,min_int_rate -- 执行利率下限
            ,real_rate -- 执行利率
            ,roll_day -- 利率变更日
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,int_day -- 存贷结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.calc_by_int, o.calc_by_int) as calc_by_int -- 是否按正常利率浮动
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cycle_freq, o.cycle_freq) as cycle_freq -- 结息频率
    ,nvl(n.int_appl_type, o.int_appl_type) as int_appl_type -- 利率启用方式
    ,nvl(n.int_cap_flag, o.int_cap_flag) as int_cap_flag -- 资本化标志
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 是否计息
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.penalty_odi_rate_type, o.penalty_odi_rate_type) as penalty_odi_rate_type -- 罚息利率使用方式
    ,nvl(n.rate_effect_type, o.rate_effect_type) as rate_effect_type -- 利率生效方式
    ,nvl(n.roll_freq, o.roll_freq) as roll_freq -- 利率变更周期
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.calc_begin_date, o.calc_begin_date) as calc_begin_date -- 利息计算起始日
    ,nvl(n.calc_end_date, o.calc_end_date) as calc_end_date -- 利息计算截止日
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.next_roll_date, o.next_roll_date) as next_roll_date -- 下一个利率变更日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.max_int_rate, o.max_int_rate) as max_int_rate -- 执行利率上限
    ,nvl(n.min_int_rate, o.min_int_rate) as min_int_rate -- 执行利率下限
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,nvl(n.roll_day, o.roll_day) as roll_day -- 利率变更日
    ,nvl(n.spread_percent, o.spread_percent) as spread_percent -- 浮动百分比
    ,nvl(n.spread_rate, o.spread_rate) as spread_rate -- 浮动点数
    ,nvl(n.int_day, o.int_day) as int_day -- 存贷结息日期
    ,case when
            n.int_class is null
            and n.loan_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.int_class is null
            and n.loan_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.int_class is null
            and n.loan_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_loan_int_default_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_loan_int_default where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.int_class = n.int_class
            and o.loan_no = n.loan_no
where (
        o.int_class is null
        and o.loan_no is null
    )
    or (
        n.int_class is null
        and n.loan_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.calc_by_int <> n.calc_by_int
        or o.company <> n.company
        or o.cycle_freq <> n.cycle_freq
        or o.int_appl_type <> n.int_appl_type
        or o.int_cap_flag <> n.int_cap_flag
        or o.int_ind_flag <> n.int_ind_flag
        or o.month_basis <> n.month_basis
        or o.penalty_odi_rate_type <> n.penalty_odi_rate_type
        or o.rate_effect_type <> n.rate_effect_type
        or o.roll_freq <> n.roll_freq
        or o.year_basis <> n.year_basis
        or o.calc_begin_date <> n.calc_begin_date
        or o.calc_end_date <> n.calc_end_date
        or o.last_change_date <> n.last_change_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.next_roll_date <> n.next_roll_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.float_rate <> n.float_rate
        or o.last_change_user_id <> n.last_change_user_id
        or o.max_int_rate <> n.max_int_rate
        or o.min_int_rate <> n.min_int_rate
        or o.real_rate <> n.real_rate
        or o.roll_day <> n.roll_day
        or o.spread_percent <> n.spread_percent
        or o.spread_rate <> n.spread_rate
        or o.int_day <> n.int_day
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_int_default_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,int_appl_type -- 利率启用方式
            ,int_cap_flag -- 资本化标志
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,penalty_odi_rate_type -- 罚息利率使用方式
            ,rate_effect_type -- 利率生效方式
            ,roll_freq -- 利率变更周期
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,next_cycle_date -- 下一结息日
            ,next_roll_date -- 下一个利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,max_int_rate -- 执行利率上限
            ,min_int_rate -- 执行利率下限
            ,real_rate -- 执行利率
            ,roll_day -- 利率变更日
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,int_day -- 存贷结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_int_default_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,int_appl_type -- 利率启用方式
            ,int_cap_flag -- 资本化标志
            ,int_ind_flag -- 是否计息
            ,month_basis -- 月基准
            ,penalty_odi_rate_type -- 罚息利率使用方式
            ,rate_effect_type -- 利率生效方式
            ,roll_freq -- 利率变更周期
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,next_cycle_date -- 下一结息日
            ,next_roll_date -- 下一个利率变更日期
            ,tran_timestamp -- 交易时间戳
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,float_rate -- 浮动利率
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,max_int_rate -- 执行利率上限
            ,min_int_rate -- 执行利率下限
            ,real_rate -- 执行利率
            ,roll_day -- 利率变更日
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,int_day -- 存贷结息日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.calc_by_int -- 是否按正常利率浮动
    ,o.company -- 法人
    ,o.cycle_freq -- 结息频率
    ,o.int_appl_type -- 利率启用方式
    ,o.int_cap_flag -- 资本化标志
    ,o.int_ind_flag -- 是否计息
    ,o.month_basis -- 月基准
    ,o.penalty_odi_rate_type -- 罚息利率使用方式
    ,o.rate_effect_type -- 利率生效方式
    ,o.roll_freq -- 利率变更周期
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.calc_begin_date -- 利息计算起始日
    ,o.calc_end_date -- 利息计算截止日
    ,o.last_change_date -- 最后修改日期
    ,o.next_cycle_date -- 下一结息日
    ,o.next_roll_date -- 下一个利率变更日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.float_rate -- 浮动利率
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.max_int_rate -- 执行利率上限
    ,o.min_int_rate -- 执行利率下限
    ,o.real_rate -- 执行利率
    ,o.roll_day -- 利率变更日
    ,o.spread_percent -- 浮动百分比
    ,o.spread_rate -- 浮动点数
    ,o.int_day -- 存贷结息日期
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
from ${iol_schema}.ncbs_cl_loan_int_default_bk o
    left join ${iol_schema}.ncbs_cl_loan_int_default_op n
        on
            o.int_class = n.int_class
            and o.loan_no = n.loan_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_loan_int_default_cl d
        on
            o.int_class = d.int_class
            and o.loan_no = d.loan_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_loan_int_default;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_loan_int_default') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_loan_int_default drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_loan_int_default add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_loan_int_default exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_loan_int_default_cl;
alter table ${iol_schema}.ncbs_cl_loan_int_default exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_loan_int_default_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_loan_int_default to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_int_default_op purge;
drop table ${iol_schema}.ncbs_cl_loan_int_default_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_loan_int_default_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_loan_int_default',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
