/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_int_roll
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
create table ${iol_schema}.ncbs_rb_int_roll_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_int_roll
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_roll_op purge;
drop table ${iol_schema}.ncbs_rb_int_roll_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_roll_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_roll where 0=1;

create table ${iol_schema}.ncbs_rb_int_roll_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_int_roll where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_roll_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,apply_id -- 申请预约编号
            ,appr_flag -- 复核标志
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,effect_flag -- 是否生效标志
            ,new_int_appl_type -- 新利率启用方式
            ,retry_flag -- 是否重算
            ,system_id -- 系统id
            ,tax_flag -- 是否税信息
            ,tax_resident_flag -- 税收居民标识
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,new_int_type -- 新利率类型
            ,new_rate_effect_type -- 新利率生效方式
            ,new_real_rate -- 新执行利率
            ,new_real_tax_rate -- 新执行税率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,new_spread_tax_percent -- 税率浮动百分比
            ,new_spread_tax_rate -- 税率浮动百分点
            ,past_fad_rate -- 违约利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_roll_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,apply_id -- 申请预约编号
            ,appr_flag -- 复核标志
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,effect_flag -- 是否生效标志
            ,new_int_appl_type -- 新利率启用方式
            ,retry_flag -- 是否重算
            ,system_id -- 系统id
            ,tax_flag -- 是否税信息
            ,tax_resident_flag -- 税收居民标识
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,new_int_type -- 新利率类型
            ,new_rate_effect_type -- 新利率生效方式
            ,new_real_rate -- 新执行利率
            ,new_real_tax_rate -- 新执行税率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,new_spread_tax_percent -- 税率浮动百分比
            ,new_spread_tax_rate -- 税率浮动百分点
            ,past_fad_rate -- 违约利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 申请预约编号
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.calc_by_int, o.calc_by_int) as calc_by_int -- 是否按正常利率浮动
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.effect_flag, o.effect_flag) as effect_flag -- 是否生效标志
    ,nvl(n.new_int_appl_type, o.new_int_appl_type) as new_int_appl_type -- 新利率启用方式
    ,nvl(n.retry_flag, o.retry_flag) as retry_flag -- 是否重算
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.tax_flag, o.tax_flag) as tax_flag -- 是否税信息
    ,nvl(n.tax_resident_flag, o.tax_resident_flag) as tax_resident_flag -- 税收居民标识
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.int_class, o.int_class) as int_class -- 利息分类
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.new_next_roll_date, o.new_next_roll_date) as new_next_roll_date -- 新利率变更日期
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.new_int_type, o.new_int_type) as new_int_type -- 新利率类型
    ,nvl(n.new_rate_effect_type, o.new_rate_effect_type) as new_rate_effect_type -- 新利率生效方式
    ,nvl(n.new_real_rate, o.new_real_rate) as new_real_rate -- 新执行利率
    ,nvl(n.new_real_tax_rate, o.new_real_tax_rate) as new_real_tax_rate -- 新执行税率
    ,nvl(n.new_roll_day, o.new_roll_day) as new_roll_day -- 新利率变更日
    ,nvl(n.new_roll_freq, o.new_roll_freq) as new_roll_freq -- 新利率变更周期
    ,nvl(n.new_spread_percent, o.new_spread_percent) as new_spread_percent -- 新利率浮动百分比
    ,nvl(n.new_spread_rate, o.new_spread_rate) as new_spread_rate -- 新浮动点数
    ,nvl(n.new_spread_tax_percent, o.new_spread_tax_percent) as new_spread_tax_percent -- 税率浮动百分比
    ,nvl(n.new_spread_tax_rate, o.new_spread_tax_rate) as new_spread_tax_rate -- 税率浮动百分点
    ,nvl(n.past_fad_rate, o.past_fad_rate) as past_fad_rate -- 违约利率
    ,case when
            n.internal_key is null
            and n.tax_flag is null
            and n.int_class is null
            and n.effect_date is null
            and n.tran_timestamp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.tax_flag is null
            and n.int_class is null
            and n.effect_date is null
            and n.tran_timestamp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.tax_flag is null
            and n.int_class is null
            and n.effect_date is null
            and n.tran_timestamp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_int_roll_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_int_roll where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.tax_flag = n.tax_flag
            and o.int_class = n.int_class
            and o.effect_date = n.effect_date
            and o.tran_timestamp = n.tran_timestamp
where (
        o.internal_key is null
        and o.tax_flag is null
        and o.int_class is null
        and o.effect_date is null
        and o.tran_timestamp is null
    )
    or (
        n.internal_key is null
        and n.tax_flag is null
        and n.int_class is null
        and n.effect_date is null
        and n.tran_timestamp is null
    )
    or (
        o.client_no <> n.client_no
        or o.user_id <> n.user_id
        or o.apply_id <> n.apply_id
        or o.appr_flag <> n.appr_flag
        or o.calc_by_int <> n.calc_by_int
        or o.company <> n.company
        or o.effect_flag <> n.effect_flag
        or o.new_int_appl_type <> n.new_int_appl_type
        or o.retry_flag <> n.retry_flag
        or o.system_id <> n.system_id
        or o.tax_resident_flag <> n.tax_resident_flag
        or o.year_basis <> n.year_basis
        or o.new_next_roll_date <> n.new_next_roll_date
        or o.tran_date <> n.tran_date
        or o.appr_user_id <> n.appr_user_id
        or o.new_int_type <> n.new_int_type
        or o.new_rate_effect_type <> n.new_rate_effect_type
        or o.new_real_rate <> n.new_real_rate
        or o.new_real_tax_rate <> n.new_real_tax_rate
        or o.new_roll_day <> n.new_roll_day
        or o.new_roll_freq <> n.new_roll_freq
        or o.new_spread_percent <> n.new_spread_percent
        or o.new_spread_rate <> n.new_spread_rate
        or o.new_spread_tax_percent <> n.new_spread_tax_percent
        or o.new_spread_tax_rate <> n.new_spread_tax_rate
        or o.past_fad_rate <> n.past_fad_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_int_roll_cl(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,apply_id -- 申请预约编号
            ,appr_flag -- 复核标志
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,effect_flag -- 是否生效标志
            ,new_int_appl_type -- 新利率启用方式
            ,retry_flag -- 是否重算
            ,system_id -- 系统id
            ,tax_flag -- 是否税信息
            ,tax_resident_flag -- 税收居民标识
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,new_int_type -- 新利率类型
            ,new_rate_effect_type -- 新利率生效方式
            ,new_real_rate -- 新执行利率
            ,new_real_tax_rate -- 新执行税率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,new_spread_tax_percent -- 税率浮动百分比
            ,new_spread_tax_rate -- 税率浮动百分点
            ,past_fad_rate -- 违约利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_int_roll_op(
            client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,apply_id -- 申请预约编号
            ,appr_flag -- 复核标志
            ,calc_by_int -- 是否按正常利率浮动
            ,company -- 法人
            ,effect_flag -- 是否生效标志
            ,new_int_appl_type -- 新利率启用方式
            ,retry_flag -- 是否重算
            ,system_id -- 系统id
            ,tax_flag -- 是否税信息
            ,tax_resident_flag -- 税收居民标识
            ,year_basis -- 年基准天数
            ,int_class -- 利息分类
            ,effect_date -- 产品生效日期
            ,new_next_roll_date -- 新利率变更日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,appr_user_id -- 复核柜员
            ,new_int_type -- 新利率类型
            ,new_rate_effect_type -- 新利率生效方式
            ,new_real_rate -- 新执行利率
            ,new_real_tax_rate -- 新执行税率
            ,new_roll_day -- 新利率变更日
            ,new_roll_freq -- 新利率变更周期
            ,new_spread_percent -- 新利率浮动百分比
            ,new_spread_rate -- 新浮动点数
            ,new_spread_tax_percent -- 税率浮动百分比
            ,new_spread_tax_rate -- 税率浮动百分点
            ,past_fad_rate -- 违约利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.user_id -- 交易柜员编号
    ,o.apply_id -- 申请预约编号
    ,o.appr_flag -- 复核标志
    ,o.calc_by_int -- 是否按正常利率浮动
    ,o.company -- 法人
    ,o.effect_flag -- 是否生效标志
    ,o.new_int_appl_type -- 新利率启用方式
    ,o.retry_flag -- 是否重算
    ,o.system_id -- 系统id
    ,o.tax_flag -- 是否税信息
    ,o.tax_resident_flag -- 税收居民标识
    ,o.year_basis -- 年基准天数
    ,o.int_class -- 利息分类
    ,o.effect_date -- 产品生效日期
    ,o.new_next_roll_date -- 新利率变更日期
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.appr_user_id -- 复核柜员
    ,o.new_int_type -- 新利率类型
    ,o.new_rate_effect_type -- 新利率生效方式
    ,o.new_real_rate -- 新执行利率
    ,o.new_real_tax_rate -- 新执行税率
    ,o.new_roll_day -- 新利率变更日
    ,o.new_roll_freq -- 新利率变更周期
    ,o.new_spread_percent -- 新利率浮动百分比
    ,o.new_spread_rate -- 新浮动点数
    ,o.new_spread_tax_percent -- 税率浮动百分比
    ,o.new_spread_tax_rate -- 税率浮动百分点
    ,o.past_fad_rate -- 违约利率
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
from ${iol_schema}.ncbs_rb_int_roll_bk o
    left join ${iol_schema}.ncbs_rb_int_roll_op n
        on
            o.internal_key = n.internal_key
            and o.tax_flag = n.tax_flag
            and o.int_class = n.int_class
            and o.effect_date = n.effect_date
            and o.tran_timestamp = n.tran_timestamp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_int_roll_cl d
        on
            o.internal_key = d.internal_key
            and o.tax_flag = d.tax_flag
            and o.int_class = d.int_class
            and o.effect_date = d.effect_date
            and o.tran_timestamp = d.tran_timestamp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_int_roll;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_int_roll') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_int_roll drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_int_roll add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_int_roll exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_int_roll_cl;
alter table ${iol_schema}.ncbs_rb_int_roll exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_int_roll_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_int_roll to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_int_roll_op purge;
drop table ${iol_schema}.ncbs_rb_int_roll_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_int_roll_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_int_roll',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
