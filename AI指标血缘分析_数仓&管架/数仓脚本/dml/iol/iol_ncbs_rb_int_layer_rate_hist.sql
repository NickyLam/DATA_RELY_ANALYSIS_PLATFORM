/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_layer_rate_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_int_layer_rate_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_int_layer_rate_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist_op purge;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_layer_rate_hist_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_int_layer_rate_hist where 0=1;

create table ${iol_schema}.ncbs_rb_int_layer_rate_hist_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.ncbs_rb_int_layer_rate_hist where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.ncbs_rb_int_layer_rate_hist_op(
        client_no -- 客户编号
        ,int_type -- 利率类型
        ,internal_key -- 账户内部键值
        ,company -- 法人
        ,irl_seq_no -- 费率编号
        ,month_basis -- 月基准
        ,near_period -- 分段周期
        ,near_period_type -- 分段周期类型
        ,system_id -- 系统id
        ,year_basis -- 年基准天数
        ,int_class -- 利息分类
        ,end_date -- 结束日期
        ,split_date -- 分段时计算开始日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,accr_amt -- 计提金额
        ,accr_days -- 计提天数
        ,acct_fixed_rate -- 分户级固定利率
        ,acct_percent_rate -- 分户级利率浮动百分比
        ,acct_spread_rate -- 分户级利率浮动百分点
        ,actual_rate -- 行内利率
        ,float_rate -- 浮动利率
        ,near_amt -- 靠档金额
        ,real_rate -- 执行利率
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.client_no -- 客户编号
    ,n.int_type -- 利率类型
    ,n.internal_key -- 账户内部键值
    ,n.company -- 法人
    ,n.irl_seq_no -- 费率编号
    ,n.month_basis -- 月基准
    ,n.near_period -- 分段周期
    ,n.near_period_type -- 分段周期类型
    ,n.system_id -- 系统id
    ,n.year_basis -- 年基准天数
    ,n.int_class -- 利息分类
    ,n.end_date -- 结束日期
    ,n.split_date -- 分段时计算开始日期
    ,n.start_date -- 开始日期
    ,n.tran_date -- 交易日期
    ,n.tran_timestamp -- 交易时间戳
    ,n.accr_amt -- 计提金额
    ,n.accr_days -- 计提天数
    ,n.acct_fixed_rate -- 分户级固定利率
    ,n.acct_percent_rate -- 分户级利率浮动百分比
    ,n.acct_spread_rate -- 分户级利率浮动百分点
    ,n.actual_rate -- 行内利率
    ,n.float_rate -- 浮动利率
    ,n.near_amt -- 靠档金额
    ,n.real_rate -- 执行利率
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_int_layer_rate_hist_bk o
    right join (select * from ${itl_schema}.ncbs_rb_int_layer_rate_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.irl_seq_no = n.irl_seq_no
where (
        o.irl_seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.company <> n.company
        or o.month_basis <> n.month_basis
        or o.near_period <> n.near_period
        or o.near_period_type <> n.near_period_type
        or o.system_id <> n.system_id
        or o.year_basis <> n.year_basis
        or o.int_class <> n.int_class
        or o.end_date <> n.end_date
        or o.split_date <> n.split_date
        or o.start_date <> n.start_date
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.accr_amt <> n.accr_amt
        or o.accr_days <> n.accr_days
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.float_rate <> n.float_rate
        or o.near_amt <> n.near_amt
        or o.real_rate <> n.real_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_layer_rate_hist_cl(
            client_no -- 客户编号
        ,int_type -- 利率类型
        ,internal_key -- 账户内部键值
        ,company -- 法人
        ,irl_seq_no -- 费率编号
        ,month_basis -- 月基准
        ,near_period -- 分段周期
        ,near_period_type -- 分段周期类型
        ,system_id -- 系统id
        ,year_basis -- 年基准天数
        ,int_class -- 利息分类
        ,end_date -- 结束日期
        ,split_date -- 分段时计算开始日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,accr_amt -- 计提金额
        ,accr_days -- 计提天数
        ,acct_fixed_rate -- 分户级固定利率
        ,acct_percent_rate -- 分户级利率浮动百分比
        ,acct_spread_rate -- 分户级利率浮动百分点
        ,actual_rate -- 行内利率
        ,float_rate -- 浮动利率
        ,near_amt -- 靠档金额
        ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_layer_rate_hist_op(
            client_no -- 客户编号
        ,int_type -- 利率类型
        ,internal_key -- 账户内部键值
        ,company -- 法人
        ,irl_seq_no -- 费率编号
        ,month_basis -- 月基准
        ,near_period -- 分段周期
        ,near_period_type -- 分段周期类型
        ,system_id -- 系统id
        ,year_basis -- 年基准天数
        ,int_class -- 利息分类
        ,end_date -- 结束日期
        ,split_date -- 分段时计算开始日期
        ,start_date -- 开始日期
        ,tran_date -- 交易日期
        ,tran_timestamp -- 交易时间戳
        ,accr_amt -- 计提金额
        ,accr_days -- 计提天数
        ,acct_fixed_rate -- 分户级固定利率
        ,acct_percent_rate -- 分户级利率浮动百分比
        ,acct_spread_rate -- 分户级利率浮动百分点
        ,actual_rate -- 行内利率
        ,float_rate -- 浮动利率
        ,near_amt -- 靠档金额
        ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.int_type -- 利率类型
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.irl_seq_no -- 费率编号
    ,o.month_basis -- 月基准
    ,o.near_period -- 分段周期
    ,o.near_period_type -- 分段周期类型
    ,o.system_id -- 系统id
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.end_date -- 结束日期
    ,o.split_date -- 分段时计算开始日期
    ,o.start_date -- 开始日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.accr_amt -- 计提金额
    ,o.accr_days -- 计提天数
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.float_rate -- 浮动利率
    ,o.near_amt -- 靠档金额
    ,o.real_rate -- 执行利率
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_int_layer_rate_hist_bk o
    left join ${iol_schema}.ncbs_rb_int_layer_rate_hist_op n
        on
            o.irl_seq_no = n.irl_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_int_layer_rate_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_int_layer_rate_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_int_layer_rate_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_int_layer_rate_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_int_layer_rate_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_int_layer_rate_hist_cl;
alter table ${iol_schema}.ncbs_rb_int_layer_rate_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_int_layer_rate_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_int_layer_rate_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist_op purge;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_int_layer_rate_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
