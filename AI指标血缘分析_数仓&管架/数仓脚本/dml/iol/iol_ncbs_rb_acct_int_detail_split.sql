/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_int_detail_split
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
create table ${iol_schema}.ncbs_rb_acct_int_detail_split_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_int_detail_split
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split_op purge;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_int_detail_split_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_int_detail_split where 0=1;

create table ${iol_schema}.ncbs_rb_acct_int_detail_split_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_int_detail_split where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_int_detail_split_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,irl_seq_no -- 费率编号
            ,month_basis -- 月基准
            ,near_period -- 分段周期
            ,near_period_type -- 分段周期类型
            ,peri_seq_no -- 周期分段序号
            ,peri_split_id -- 周期分段id
            ,system_id -- 系统id
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accr_amt -- 计提金额
            ,accr_days -- 计提天数
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_int_detail_split_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,irl_seq_no -- 费率编号
            ,month_basis -- 月基准
            ,near_period -- 分段周期
            ,near_period_type -- 分段周期类型
            ,peri_seq_no -- 周期分段序号
            ,peri_split_id -- 周期分段id
            ,system_id -- 系统id
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accr_amt -- 计提金额
            ,accr_days -- 计提天数
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.agree_change_type, o.agree_change_type) as agree_change_type -- 协议变动方式
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.irl_seq_no, o.irl_seq_no) as irl_seq_no -- 费率编号
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.near_period, o.near_period) as near_period -- 分段周期
    ,nvl(n.near_period_type, o.near_period_type) as near_period_type -- 分段周期类型
    ,nvl(n.peri_seq_no, o.peri_seq_no) as peri_seq_no -- 周期分段序号
    ,nvl(n.peri_split_id, o.peri_split_id) as peri_split_id -- 周期分段id
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.accr_amt, o.accr_amt) as accr_amt -- 计提金额
    ,nvl(n.accr_days, o.accr_days) as accr_days -- 计提天数
    ,nvl(n.acct_fixed_rate, o.acct_fixed_rate) as acct_fixed_rate -- 分户级固定利率
    ,nvl(n.acct_percent_rate, o.acct_percent_rate) as acct_percent_rate -- 分户级利率浮动百分比
    ,nvl(n.acct_spread_rate, o.acct_spread_rate) as acct_spread_rate -- 分户级利率浮动百分点
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.agree_fixed_rate, o.agree_fixed_rate) as agree_fixed_rate -- 协议固定利率
    ,nvl(n.agree_percent_rate, o.agree_percent_rate) as agree_percent_rate -- 协议浮动百分比
    ,nvl(n.agree_reduce_amt, o.agree_reduce_amt) as agree_reduce_amt -- 协议优惠金额
    ,nvl(n.agree_spread_rate, o.agree_spread_rate) as agree_spread_rate -- 协议浮动百分点
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动利率
    ,nvl(n.near_amt, o.near_amt) as near_amt -- 靠档金额
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率
    ,case when
            n.irl_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.irl_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.irl_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_int_detail_split_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_int_detail_split where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.irl_seq_no = n.irl_seq_no
where (
        o.irl_seq_no is null
    )
    or (
        n.irl_seq_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.int_type <> n.int_type
        or o.internal_key <> n.internal_key
        or o.agree_change_type <> n.agree_change_type
        or o.company <> n.company
        or o.month_basis <> n.month_basis
        or o.near_period <> n.near_period
        or o.near_period_type <> n.near_period_type
        or o.peri_seq_no <> n.peri_seq_no
        or o.peri_split_id <> n.peri_split_id
        or o.system_id <> n.system_id
        or o.year_basis <> n.year_basis
        or o.int_class <> n.int_class
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.accr_amt <> n.accr_amt
        or o.accr_days <> n.accr_days
        or o.acct_fixed_rate <> n.acct_fixed_rate
        or o.acct_percent_rate <> n.acct_percent_rate
        or o.acct_spread_rate <> n.acct_spread_rate
        or o.actual_rate <> n.actual_rate
        or o.agree_fixed_rate <> n.agree_fixed_rate
        or o.agree_percent_rate <> n.agree_percent_rate
        or o.agree_reduce_amt <> n.agree_reduce_amt
        or o.agree_spread_rate <> n.agree_spread_rate
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
        into ${iol_schema}.ncbs_rb_acct_int_detail_split_cl(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,irl_seq_no -- 费率编号
            ,month_basis -- 月基准
            ,near_period -- 分段周期
            ,near_period_type -- 分段周期类型
            ,peri_seq_no -- 周期分段序号
            ,peri_split_id -- 周期分段id
            ,system_id -- 系统id
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accr_amt -- 计提金额
            ,accr_days -- 计提天数
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
            ,float_rate -- 浮动利率
            ,near_amt -- 靠档金额
            ,real_rate -- 执行利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_int_detail_split_op(
            client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,agree_change_type -- 协议变动方式
            ,company -- 法人
            ,irl_seq_no -- 费率编号
            ,month_basis -- 月基准
            ,near_period -- 分段周期
            ,near_period_type -- 分段周期类型
            ,peri_seq_no -- 周期分段序号
            ,peri_split_id -- 周期分段id
            ,system_id -- 系统id
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,accr_amt -- 计提金额
            ,accr_days -- 计提天数
            ,acct_fixed_rate -- 分户级固定利率
            ,acct_percent_rate -- 分户级利率浮动百分比
            ,acct_spread_rate -- 分户级利率浮动百分点
            ,actual_rate -- 行内利率
            ,agree_fixed_rate -- 协议固定利率
            ,agree_percent_rate -- 协议浮动百分比
            ,agree_reduce_amt -- 协议优惠金额
            ,agree_spread_rate -- 协议浮动百分点
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
    ,o.agree_change_type -- 协议变动方式
    ,o.company -- 法人
    ,o.irl_seq_no -- 费率编号
    ,o.month_basis -- 月基准
    ,o.near_period -- 分段周期
    ,o.near_period_type -- 分段周期类型
    ,o.peri_seq_no -- 周期分段序号
    ,o.peri_split_id -- 周期分段id
    ,o.system_id -- 系统id
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.accr_amt -- 计提金额
    ,o.accr_days -- 计提天数
    ,o.acct_fixed_rate -- 分户级固定利率
    ,o.acct_percent_rate -- 分户级利率浮动百分比
    ,o.acct_spread_rate -- 分户级利率浮动百分点
    ,o.actual_rate -- 行内利率
    ,o.agree_fixed_rate -- 协议固定利率
    ,o.agree_percent_rate -- 协议浮动百分比
    ,o.agree_reduce_amt -- 协议优惠金额
    ,o.agree_spread_rate -- 协议浮动百分点
    ,o.float_rate -- 浮动利率
    ,o.near_amt -- 靠档金额
    ,o.real_rate -- 执行利率
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
from ${iol_schema}.ncbs_rb_acct_int_detail_split_bk o
    left join ${iol_schema}.ncbs_rb_acct_int_detail_split_op n
        on
            o.irl_seq_no = n.irl_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_int_detail_split_cl d
        on
            o.irl_seq_no = d.irl_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_int_detail_split;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_int_detail_split') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_int_detail_split drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_int_detail_split add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_int_detail_split exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_int_detail_split_cl;
alter table ${iol_schema}.ncbs_rb_acct_int_detail_split exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_int_detail_split_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_int_detail_split to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split_op purge;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_int_detail_split',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
