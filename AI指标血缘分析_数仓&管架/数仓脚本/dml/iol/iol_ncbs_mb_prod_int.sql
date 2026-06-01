/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_prod_int
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
create table ${iol_schema}.ncbs_mb_prod_int_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_prod_int
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_prod_int_op purge;
drop table ${iol_schema}.ncbs_mb_prod_int_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_int_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_prod_int where 0=1;

create table ${iol_schema}.ncbs_mb_prod_int_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_prod_int where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_prod_int_cl(
            int_type -- 利率类型
            ,prod_type -- 产品编号
            ,acct_rate_flag -- 是否使用分户利率标志
            ,company -- 法人
            ,days_gear_type -- 靠档天数计算方式
            ,effect_date_calc_method -- 计息起始日期取值方法
            ,event_type -- 事件类型
            ,gear_amt_ind -- 金额靠档方向
            ,gear_amt_method -- 金额靠档方式
            ,gear_days_ind -- 天数靠档方向
            ,gear_days_method -- 天数靠档方式
            ,group_rule_type -- 分组规则关系
            ,int_appl_type -- 利率启用方式
            ,int_calc_method -- 利息计算方法
            ,int_match_rule -- 利息明细生效规则
            ,int_recalc_method -- 利息重算方法
            ,month_basis -- 月基准
            ,rate_layer_rule -- 利率分层规则
            ,roll_freq -- 利率变更周期
            ,round_down_flag -- 是否截位标志
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,tran_timestamp -- 交易时间戳
            ,int_calc_amt_type -- 利息计算金额类型
            ,max_rate -- 最大利率
            ,min_rate -- 最小利率
            ,rate_gear_amt_type -- 利率靠档金额类型
            ,roll_day -- 利率变更日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_prod_int_op(
            int_type -- 利率类型
            ,prod_type -- 产品编号
            ,acct_rate_flag -- 是否使用分户利率标志
            ,company -- 法人
            ,days_gear_type -- 靠档天数计算方式
            ,effect_date_calc_method -- 计息起始日期取值方法
            ,event_type -- 事件类型
            ,gear_amt_ind -- 金额靠档方向
            ,gear_amt_method -- 金额靠档方式
            ,gear_days_ind -- 天数靠档方向
            ,gear_days_method -- 天数靠档方式
            ,group_rule_type -- 分组规则关系
            ,int_appl_type -- 利率启用方式
            ,int_calc_method -- 利息计算方法
            ,int_match_rule -- 利息明细生效规则
            ,int_recalc_method -- 利息重算方法
            ,month_basis -- 月基准
            ,rate_layer_rule -- 利率分层规则
            ,roll_freq -- 利率变更周期
            ,round_down_flag -- 是否截位标志
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,tran_timestamp -- 交易时间戳
            ,int_calc_amt_type -- 利息计算金额类型
            ,max_rate -- 最大利率
            ,min_rate -- 最小利率
            ,rate_gear_amt_type -- 利率靠档金额类型
            ,roll_day -- 利率变更日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.acct_rate_flag, o.acct_rate_flag) as acct_rate_flag -- 是否使用分户利率标志
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.days_gear_type, o.days_gear_type) as days_gear_type -- 靠档天数计算方式
    ,nvl(n.effect_date_calc_method, o.effect_date_calc_method) as effect_date_calc_method -- 计息起始日期取值方法
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.gear_amt_ind, o.gear_amt_ind) as gear_amt_ind -- 金额靠档方向
    ,nvl(n.gear_amt_method, o.gear_amt_method) as gear_amt_method -- 金额靠档方式
    ,nvl(n.gear_days_ind, o.gear_days_ind) as gear_days_ind -- 天数靠档方向
    ,nvl(n.gear_days_method, o.gear_days_method) as gear_days_method -- 天数靠档方式
    ,nvl(n.group_rule_type, o.group_rule_type) as group_rule_type -- 分组规则关系
    ,nvl(n.int_appl_type, o.int_appl_type) as int_appl_type -- 利率启用方式
    ,nvl(n.int_calc_method, o.int_calc_method) as int_calc_method -- 利息计算方法
    ,nvl(n.int_match_rule, o.int_match_rule) as int_match_rule -- 利息明细生效规则
    ,nvl(n.int_recalc_method, o.int_recalc_method) as int_recalc_method -- 利息重算方法
    ,nvl(n.month_basis, o.month_basis) as month_basis -- 月基准
    ,nvl(n.rate_layer_rule, o.rate_layer_rule) as rate_layer_rule -- 利率分层规则
    ,nvl(n.roll_freq, o.roll_freq) as roll_freq -- 利率变更周期
    ,nvl(n.round_down_flag, o.round_down_flag) as round_down_flag -- 是否截位标志
    ,nvl(n.tax_type, o.tax_type) as tax_type -- 税种
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.int_calc_amt_type, o.int_calc_amt_type) as int_calc_amt_type -- 利息计算金额类型
    ,nvl(n.max_rate, o.max_rate) as max_rate -- 最大利率
    ,nvl(n.min_rate, o.min_rate) as min_rate -- 最小利率
    ,nvl(n.rate_gear_amt_type, o.rate_gear_amt_type) as rate_gear_amt_type -- 利率靠档金额类型
    ,nvl(n.roll_day, o.roll_day) as roll_day -- 利率变更日
    ,case when
            n.int_type is null
            and n.prod_type is null
            and n.company is null
            and n.event_type is null
            and n.int_class is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.int_type is null
            and n.prod_type is null
            and n.company is null
            and n.event_type is null
            and n.int_class is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.int_type is null
            and n.prod_type is null
            and n.company is null
            and n.event_type is null
            and n.int_class is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_prod_int_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_prod_int where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.int_type = n.int_type
            and o.prod_type = n.prod_type
            and o.company = n.company
            and o.event_type = n.event_type
            and o.int_class = n.int_class
where (
        o.int_type is null
        and o.prod_type is null
        and o.company is null
        and o.event_type is null
        and o.int_class is null
    )
    or (
        n.int_type is null
        and n.prod_type is null
        and n.company is null
        and n.event_type is null
        and n.int_class is null
    )
    or (
        o.acct_rate_flag <> n.acct_rate_flag
        or o.days_gear_type <> n.days_gear_type
        or o.effect_date_calc_method <> n.effect_date_calc_method
        or o.gear_amt_ind <> n.gear_amt_ind
        or o.gear_amt_method <> n.gear_amt_method
        or o.gear_days_ind <> n.gear_days_ind
        or o.gear_days_method <> n.gear_days_method
        or o.group_rule_type <> n.group_rule_type
        or o.int_appl_type <> n.int_appl_type
        or o.int_calc_method <> n.int_calc_method
        or o.int_match_rule <> n.int_match_rule
        or o.int_recalc_method <> n.int_recalc_method
        or o.month_basis <> n.month_basis
        or o.rate_layer_rule <> n.rate_layer_rule
        or o.roll_freq <> n.roll_freq
        or o.round_down_flag <> n.round_down_flag
        or o.tax_type <> n.tax_type
        or o.tran_timestamp <> n.tran_timestamp
        or o.int_calc_amt_type <> n.int_calc_amt_type
        or o.max_rate <> n.max_rate
        or o.min_rate <> n.min_rate
        or o.rate_gear_amt_type <> n.rate_gear_amt_type
        or o.roll_day <> n.roll_day
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_prod_int_cl(
            int_type -- 利率类型
            ,prod_type -- 产品编号
            ,acct_rate_flag -- 是否使用分户利率标志
            ,company -- 法人
            ,days_gear_type -- 靠档天数计算方式
            ,effect_date_calc_method -- 计息起始日期取值方法
            ,event_type -- 事件类型
            ,gear_amt_ind -- 金额靠档方向
            ,gear_amt_method -- 金额靠档方式
            ,gear_days_ind -- 天数靠档方向
            ,gear_days_method -- 天数靠档方式
            ,group_rule_type -- 分组规则关系
            ,int_appl_type -- 利率启用方式
            ,int_calc_method -- 利息计算方法
            ,int_match_rule -- 利息明细生效规则
            ,int_recalc_method -- 利息重算方法
            ,month_basis -- 月基准
            ,rate_layer_rule -- 利率分层规则
            ,roll_freq -- 利率变更周期
            ,round_down_flag -- 是否截位标志
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,tran_timestamp -- 交易时间戳
            ,int_calc_amt_type -- 利息计算金额类型
            ,max_rate -- 最大利率
            ,min_rate -- 最小利率
            ,rate_gear_amt_type -- 利率靠档金额类型
            ,roll_day -- 利率变更日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_prod_int_op(
            int_type -- 利率类型
            ,prod_type -- 产品编号
            ,acct_rate_flag -- 是否使用分户利率标志
            ,company -- 法人
            ,days_gear_type -- 靠档天数计算方式
            ,effect_date_calc_method -- 计息起始日期取值方法
            ,event_type -- 事件类型
            ,gear_amt_ind -- 金额靠档方向
            ,gear_amt_method -- 金额靠档方式
            ,gear_days_ind -- 天数靠档方向
            ,gear_days_method -- 天数靠档方式
            ,group_rule_type -- 分组规则关系
            ,int_appl_type -- 利率启用方式
            ,int_calc_method -- 利息计算方法
            ,int_match_rule -- 利息明细生效规则
            ,int_recalc_method -- 利息重算方法
            ,month_basis -- 月基准
            ,rate_layer_rule -- 利率分层规则
            ,roll_freq -- 利率变更周期
            ,round_down_flag -- 是否截位标志
            ,tax_type -- 税种
            ,int_class -- 利息分类
            ,tran_timestamp -- 交易时间戳
            ,int_calc_amt_type -- 利息计算金额类型
            ,max_rate -- 最大利率
            ,min_rate -- 最小利率
            ,rate_gear_amt_type -- 利率靠档金额类型
            ,roll_day -- 利率变更日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.int_type -- 利率类型
    ,o.prod_type -- 产品编号
    ,o.acct_rate_flag -- 是否使用分户利率标志
    ,o.company -- 法人
    ,o.days_gear_type -- 靠档天数计算方式
    ,o.effect_date_calc_method -- 计息起始日期取值方法
    ,o.event_type -- 事件类型
    ,o.gear_amt_ind -- 金额靠档方向
    ,o.gear_amt_method -- 金额靠档方式
    ,o.gear_days_ind -- 天数靠档方向
    ,o.gear_days_method -- 天数靠档方式
    ,o.group_rule_type -- 分组规则关系
    ,o.int_appl_type -- 利率启用方式
    ,o.int_calc_method -- 利息计算方法
    ,o.int_match_rule -- 利息明细生效规则
    ,o.int_recalc_method -- 利息重算方法
    ,o.month_basis -- 月基准
    ,o.rate_layer_rule -- 利率分层规则
    ,o.roll_freq -- 利率变更周期
    ,o.round_down_flag -- 是否截位标志
    ,o.tax_type -- 税种
    ,o.int_class -- 利息分类
    ,o.tran_timestamp -- 交易时间戳
    ,o.int_calc_amt_type -- 利息计算金额类型
    ,o.max_rate -- 最大利率
    ,o.min_rate -- 最小利率
    ,o.rate_gear_amt_type -- 利率靠档金额类型
    ,o.roll_day -- 利率变更日
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
from ${iol_schema}.ncbs_mb_prod_int_bk o
    left join ${iol_schema}.ncbs_mb_prod_int_op n
        on
            o.int_type = n.int_type
            and o.prod_type = n.prod_type
            and o.company = n.company
            and o.event_type = n.event_type
            and o.int_class = n.int_class
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_prod_int_cl d
        on
            o.int_type = d.int_type
            and o.prod_type = d.prod_type
            and o.company = d.company
            and o.event_type = d.event_type
            and o.int_class = d.int_class
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_prod_int;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_prod_int') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_prod_int drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_prod_int add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_prod_int exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_prod_int_cl;
alter table ${iol_schema}.ncbs_mb_prod_int exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_prod_int_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_prod_int to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_prod_int_op purge;
drop table ${iol_schema}.ncbs_mb_prod_int_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_prod_int_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_prod_int',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
