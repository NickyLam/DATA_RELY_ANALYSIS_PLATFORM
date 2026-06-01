/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_close_acct_int_detail
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
create table ${iol_schema}.ncbs_rb_close_acct_int_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_close_acct_int_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail_op purge;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_close_acct_int_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_close_acct_int_detail where 0=1;

create table ${iol_schema}.ncbs_rb_close_acct_int_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_close_acct_int_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_close_acct_int_detail_cl(
            internal_key -- 账户内部键值
            ,int_class -- 利息分类
            ,accr_period_freq -- 计提周期
            ,next_accr_date -- 下一计提日期
            ,last_accrual_date -- 上一利息计提日
            ,cycle_flag -- 是否结息
            ,int_cap_flag -- 资本化标志
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,cycle_freq -- 结息频率
            ,accr_int_day -- 计提日
            ,int_day -- 存贷结息日期
            ,int_type -- 利率类型
            ,rate_effect_type -- 利率生效方式
            ,int_accrued -- 累计计提
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,adj_upd_last_date -- 上日累计调整备份日期
            ,adv_upd_last_date -- 上日累计已付备份日期
            ,int_accrued_last_prev -- 上上日累计计提利息
            ,int_adj_last_prev -- 上上日利息调整（累计）
            ,discnt_int_last_prev -- 上上日前付息
            ,month_total_amount -- 当月累计日终余额
            ,last_month_total_amount -- 上月累计日终余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_close_acct_int_detail_op(
            internal_key -- 账户内部键值
            ,int_class -- 利息分类
            ,accr_period_freq -- 计提周期
            ,next_accr_date -- 下一计提日期
            ,last_accrual_date -- 上一利息计提日
            ,cycle_flag -- 是否结息
            ,int_cap_flag -- 资本化标志
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,cycle_freq -- 结息频率
            ,accr_int_day -- 计提日
            ,int_day -- 存贷结息日期
            ,int_type -- 利率类型
            ,rate_effect_type -- 利率生效方式
            ,int_accrued -- 累计计提
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,adj_upd_last_date -- 上日累计调整备份日期
            ,adv_upd_last_date -- 上日累计已付备份日期
            ,int_accrued_last_prev -- 上上日累计计提利息
            ,int_adj_last_prev -- 上上日利息调整（累计）
            ,discnt_int_last_prev -- 上上日前付息
            ,month_total_amount -- 当月累计日终余额
            ,last_month_total_amount -- 上月累计日终余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.accr_period_freq, o.accr_period_freq) as accr_period_freq -- 计提周期
    ,nvl(n.next_accr_date, o.next_accr_date) as next_accr_date -- 下一计提日期
    ,nvl(n.last_accrual_date, o.last_accrual_date) as last_accrual_date -- 上一利息计提日
    ,nvl(n.cycle_flag, o.cycle_flag) as cycle_flag -- 是否结息
    ,nvl(n.int_cap_flag, o.int_cap_flag) as int_cap_flag -- 资本化标志
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.last_cycle_date, o.last_cycle_date) as last_cycle_date -- 上一结息日
    ,nvl(n.last_true_cycle_date, o.last_true_cycle_date) as last_true_cycle_date -- 上一真实结息日
    ,nvl(n.last_cycle_date_pre, o.last_cycle_date_pre) as last_cycle_date_pre -- 日切前上一结息日
    ,nvl(n.cycle_freq, o.cycle_freq) as cycle_freq -- 结息频率
    ,nvl(n.accr_int_day, o.accr_int_day) as accr_int_day -- 计提日
    ,nvl(n.int_day, o.int_day) as int_day -- 存贷结息日期
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.rate_effect_type, o.rate_effect_type) as rate_effect_type -- 利率生效方式
    ,nvl(n.int_accrued, o.int_accrued) as int_accrued -- 累计计提
    ,nvl(n.int_accrued_prev, o.int_accrued_prev) as int_accrued_prev -- 上日累计计提利息
    ,nvl(n.int_adj, o.int_adj) as int_adj -- 利息调增金额
    ,nvl(n.int_adj_prev, o.int_adj_prev) as int_adj_prev -- 上日利息调整(累计)
    ,nvl(n.int_posted, o.int_posted) as int_posted -- 结息金额
    ,nvl(n.calc_begin_date, o.calc_begin_date) as calc_begin_date -- 利息计算起始日
    ,nvl(n.calc_end_date, o.calc_end_date) as calc_end_date -- 利息计算截止日
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.adj_upd_last_date, o.adj_upd_last_date) as adj_upd_last_date -- 上日累计调整备份日期
    ,nvl(n.adv_upd_last_date, o.adv_upd_last_date) as adv_upd_last_date -- 上日累计已付备份日期
    ,nvl(n.int_accrued_last_prev, o.int_accrued_last_prev) as int_accrued_last_prev -- 上上日累计计提利息
    ,nvl(n.int_adj_last_prev, o.int_adj_last_prev) as int_adj_last_prev -- 上上日利息调整（累计）
    ,nvl(n.discnt_int_last_prev, o.discnt_int_last_prev) as discnt_int_last_prev -- 上上日前付息
    ,nvl(n.month_total_amount, o.month_total_amount) as month_total_amount -- 当月累计日终余额
    ,nvl(n.last_month_total_amount, o.last_month_total_amount) as last_month_total_amount -- 上月累计日终余额
    ,case when
            n.internal_key is null
            and n.int_class is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.int_class is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.int_class is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_close_acct_int_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_close_acct_int_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.int_class = n.int_class
where (
        o.internal_key is null
        and o.int_class is null
    )
    or (
        n.internal_key is null
        and n.int_class is null
    )
    or (
        o.accr_period_freq <> n.accr_period_freq
        or o.next_accr_date <> n.next_accr_date
        or o.last_accrual_date <> n.last_accrual_date
        or o.cycle_flag <> n.cycle_flag
        or o.int_cap_flag <> n.int_cap_flag
        or o.next_cycle_date <> n.next_cycle_date
        or o.last_cycle_date <> n.last_cycle_date
        or o.last_true_cycle_date <> n.last_true_cycle_date
        or o.last_cycle_date_pre <> n.last_cycle_date_pre
        or o.cycle_freq <> n.cycle_freq
        or o.accr_int_day <> n.accr_int_day
        or o.int_day <> n.int_day
        or o.int_type <> n.int_type
        or o.rate_effect_type <> n.rate_effect_type
        or o.int_accrued <> n.int_accrued
        or o.int_accrued_prev <> n.int_accrued_prev
        or o.int_adj <> n.int_adj
        or o.int_adj_prev <> n.int_adj_prev
        or o.int_posted <> n.int_posted
        or o.calc_begin_date <> n.calc_begin_date
        or o.calc_end_date <> n.calc_end_date
        or o.last_change_date <> n.last_change_date
        or o.last_change_user_id <> n.last_change_user_id
        or o.client_no <> n.client_no
        or o.tran_timestamp <> n.tran_timestamp
        or o.company <> n.company
        or o.adj_upd_last_date <> n.adj_upd_last_date
        or o.adv_upd_last_date <> n.adv_upd_last_date
        or o.int_accrued_last_prev <> n.int_accrued_last_prev
        or o.int_adj_last_prev <> n.int_adj_last_prev
        or o.discnt_int_last_prev <> n.discnt_int_last_prev
        or o.month_total_amount <> n.month_total_amount
        or o.last_month_total_amount <> n.last_month_total_amount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_close_acct_int_detail_cl(
            internal_key -- 账户内部键值
            ,int_class -- 利息分类
            ,accr_period_freq -- 计提周期
            ,next_accr_date -- 下一计提日期
            ,last_accrual_date -- 上一利息计提日
            ,cycle_flag -- 是否结息
            ,int_cap_flag -- 资本化标志
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,cycle_freq -- 结息频率
            ,accr_int_day -- 计提日
            ,int_day -- 存贷结息日期
            ,int_type -- 利率类型
            ,rate_effect_type -- 利率生效方式
            ,int_accrued -- 累计计提
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,adj_upd_last_date -- 上日累计调整备份日期
            ,adv_upd_last_date -- 上日累计已付备份日期
            ,int_accrued_last_prev -- 上上日累计计提利息
            ,int_adj_last_prev -- 上上日利息调整（累计）
            ,discnt_int_last_prev -- 上上日前付息
            ,month_total_amount -- 当月累计日终余额
            ,last_month_total_amount -- 上月累计日终余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_close_acct_int_detail_op(
            internal_key -- 账户内部键值
            ,int_class -- 利息分类
            ,accr_period_freq -- 计提周期
            ,next_accr_date -- 下一计提日期
            ,last_accrual_date -- 上一利息计提日
            ,cycle_flag -- 是否结息
            ,int_cap_flag -- 资本化标志
            ,next_cycle_date -- 下一结息日
            ,last_cycle_date -- 上一结息日
            ,last_true_cycle_date -- 上一真实结息日
            ,last_cycle_date_pre -- 日切前上一结息日
            ,cycle_freq -- 结息频率
            ,accr_int_day -- 计提日
            ,int_day -- 存贷结息日期
            ,int_type -- 利率类型
            ,rate_effect_type -- 利率生效方式
            ,int_accrued -- 累计计提
            ,int_accrued_prev -- 上日累计计提利息
            ,int_adj -- 利息调增金额
            ,int_adj_prev -- 上日利息调整(累计)
            ,int_posted -- 结息金额
            ,calc_begin_date -- 利息计算起始日
            ,calc_end_date -- 利息计算截止日
            ,last_change_date -- 最后修改日期
            ,last_change_user_id -- 最后修改柜员
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,adj_upd_last_date -- 上日累计调整备份日期
            ,adv_upd_last_date -- 上日累计已付备份日期
            ,int_accrued_last_prev -- 上上日累计计提利息
            ,int_adj_last_prev -- 上上日利息调整（累计）
            ,discnt_int_last_prev -- 上上日前付息
            ,month_total_amount -- 当月累计日终余额
            ,last_month_total_amount -- 上月累计日终余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_key -- 账户内部键值
    ,o.int_class -- 利息分类
    ,o.accr_period_freq -- 计提周期
    ,o.next_accr_date -- 下一计提日期
    ,o.last_accrual_date -- 上一利息计提日
    ,o.cycle_flag -- 是否结息
    ,o.int_cap_flag -- 资本化标志
    ,o.next_cycle_date -- 下一结息日
    ,o.last_cycle_date -- 上一结息日
    ,o.last_true_cycle_date -- 上一真实结息日
    ,o.last_cycle_date_pre -- 日切前上一结息日
    ,o.cycle_freq -- 结息频率
    ,o.accr_int_day -- 计提日
    ,o.int_day -- 存贷结息日期
    ,o.int_type -- 利率类型
    ,o.rate_effect_type -- 利率生效方式
    ,o.int_accrued -- 累计计提
    ,o.int_accrued_prev -- 上日累计计提利息
    ,o.int_adj -- 利息调增金额
    ,o.int_adj_prev -- 上日利息调整(累计)
    ,o.int_posted -- 结息金额
    ,o.calc_begin_date -- 利息计算起始日
    ,o.calc_end_date -- 利息计算截止日
    ,o.last_change_date -- 最后修改日期
    ,o.last_change_user_id -- 最后修改柜员
    ,o.client_no -- 客户编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.company -- 法人
    ,o.adj_upd_last_date -- 上日累计调整备份日期
    ,o.adv_upd_last_date -- 上日累计已付备份日期
    ,o.int_accrued_last_prev -- 上上日累计计提利息
    ,o.int_adj_last_prev -- 上上日利息调整（累计）
    ,o.discnt_int_last_prev -- 上上日前付息
    ,o.month_total_amount -- 当月累计日终余额
    ,o.last_month_total_amount -- 上月累计日终余额
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
from ${iol_schema}.ncbs_rb_close_acct_int_detail_bk o
    left join ${iol_schema}.ncbs_rb_close_acct_int_detail_op n
        on
            o.internal_key = n.internal_key
            and o.int_class = n.int_class
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_close_acct_int_detail_cl d
        on
            o.internal_key = d.internal_key
            and o.int_class = d.int_class
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_close_acct_int_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_close_acct_int_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_close_acct_int_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_close_acct_int_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_close_acct_int_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_close_acct_int_detail_cl;
alter table ${iol_schema}.ncbs_rb_close_acct_int_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_close_acct_int_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_close_acct_int_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail_op purge;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_close_acct_int_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
