/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_int_matrix
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
create table ${iol_schema}.ncbs_mb_int_matrix_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_int_matrix
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_int_matrix_op purge;
drop table ${iol_schema}.ncbs_mb_int_matrix_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_int_matrix_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_int_matrix where 0=1;

create table ${iol_schema}.ncbs_mb_int_matrix_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_int_matrix where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_int_matrix_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,int_type -- 利率类型
            ,period_freq -- 频率id
            ,company -- 法人
            ,int_basis -- 基准利率类型
            ,matrix_no -- 阶梯序号
            ,year_basis -- 年基准天数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,base_rate -- 基础汇率
            ,day_num -- 每期天数
            ,disc_rate -- 利率折扣
            ,matrix_amt -- 阶梯金额
            ,max_percent -- 最大上浮比例
            ,max_rate -- 最大利率
            ,min_percent -- 最小上浮百分比
            ,min_rate -- 最小利率
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,min_spread_percent -- 最小浮动比例
            ,max_spread_rate -- 最大上浮点差
            ,min_spread_rate -- 最大下浮点差
            ,max_spread_percent -- 最大下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_int_matrix_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,int_type -- 利率类型
            ,period_freq -- 频率id
            ,company -- 法人
            ,int_basis -- 基准利率类型
            ,matrix_no -- 阶梯序号
            ,year_basis -- 年基准天数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,base_rate -- 基础汇率
            ,day_num -- 每期天数
            ,disc_rate -- 利率折扣
            ,matrix_amt -- 阶梯金额
            ,max_percent -- 最大上浮比例
            ,max_rate -- 最大利率
            ,min_percent -- 最小上浮百分比
            ,min_rate -- 最小利率
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,min_spread_percent -- 最小浮动比例
            ,max_spread_rate -- 最大上浮点差
            ,min_spread_rate -- 最大下浮点差
            ,max_spread_percent -- 最大下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.int_type, o.int_type) as int_type -- 利率类型
    ,nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.int_basis, o.int_basis) as int_basis -- 基准利率类型
    ,nvl(n.matrix_no, o.matrix_no) as matrix_no -- 阶梯序号
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.actual_rate, o.actual_rate) as actual_rate -- 行内利率
    ,nvl(n.base_rate, o.base_rate) as base_rate -- 基础汇率
    ,nvl(n.day_num, o.day_num) as day_num -- 每期天数
    ,nvl(n.disc_rate, o.disc_rate) as disc_rate -- 利率折扣
    ,nvl(n.matrix_amt, o.matrix_amt) as matrix_amt -- 阶梯金额
    ,nvl(n.max_percent, o.max_percent) as max_percent -- 最大上浮比例
    ,nvl(n.max_rate, o.max_rate) as max_rate -- 最大利率
    ,nvl(n.min_percent, o.min_percent) as min_percent -- 最小上浮百分比
    ,nvl(n.min_rate, o.min_rate) as min_rate -- 最小利率
    ,nvl(n.spread_percent, o.spread_percent) as spread_percent -- 浮动百分比
    ,nvl(n.spread_rate, o.spread_rate) as spread_rate -- 浮动点数
    ,nvl(n.min_spread_percent, o.min_spread_percent) as min_spread_percent -- 最小浮动比例
    ,nvl(n.max_spread_rate, o.max_spread_rate) as max_spread_rate -- 最大上浮点差
    ,nvl(n.min_spread_rate, o.min_spread_rate) as min_spread_rate -- 最大下浮点差
    ,nvl(n.max_spread_percent, o.max_spread_percent) as max_spread_percent -- 最大下浮比例
    ,case when
            n.matrix_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.matrix_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.matrix_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_int_matrix_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_int_matrix where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.matrix_no = n.matrix_no
where (
        o.matrix_no is null
    )
    or (
        n.matrix_no is null
    )
    or (
        o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.int_type <> n.int_type
        or o.period_freq <> n.period_freq
        or o.company <> n.company
        or o.int_basis <> n.int_basis
        or o.year_basis <> n.year_basis
        or o.effect_date <> n.effect_date
        or o.end_date <> n.end_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.actual_rate <> n.actual_rate
        or o.base_rate <> n.base_rate
        or o.day_num <> n.day_num
        or o.disc_rate <> n.disc_rate
        or o.matrix_amt <> n.matrix_amt
        or o.max_percent <> n.max_percent
        or o.max_rate <> n.max_rate
        or o.min_percent <> n.min_percent
        or o.min_rate <> n.min_rate
        or o.spread_percent <> n.spread_percent
        or o.spread_rate <> n.spread_rate
        or o.min_spread_percent <> n.min_spread_percent
        or o.max_spread_rate <> n.max_spread_rate
        or o.min_spread_rate <> n.min_spread_rate
        or o.max_spread_percent <> n.max_spread_percent
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_int_matrix_cl(
            branch -- 机构编号
            ,ccy -- 币种
            ,int_type -- 利率类型
            ,period_freq -- 频率id
            ,company -- 法人
            ,int_basis -- 基准利率类型
            ,matrix_no -- 阶梯序号
            ,year_basis -- 年基准天数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,base_rate -- 基础汇率
            ,day_num -- 每期天数
            ,disc_rate -- 利率折扣
            ,matrix_amt -- 阶梯金额
            ,max_percent -- 最大上浮比例
            ,max_rate -- 最大利率
            ,min_percent -- 最小上浮百分比
            ,min_rate -- 最小利率
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,min_spread_percent -- 最小浮动比例
            ,max_spread_rate -- 最大上浮点差
            ,min_spread_rate -- 最大下浮点差
            ,max_spread_percent -- 最大下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_int_matrix_op(
            branch -- 机构编号
            ,ccy -- 币种
            ,int_type -- 利率类型
            ,period_freq -- 频率id
            ,company -- 法人
            ,int_basis -- 基准利率类型
            ,matrix_no -- 阶梯序号
            ,year_basis -- 年基准天数
            ,effect_date -- 产品生效日期
            ,end_date -- 结束日期
            ,tran_timestamp -- 交易时间戳
            ,actual_rate -- 行内利率
            ,base_rate -- 基础汇率
            ,day_num -- 每期天数
            ,disc_rate -- 利率折扣
            ,matrix_amt -- 阶梯金额
            ,max_percent -- 最大上浮比例
            ,max_rate -- 最大利率
            ,min_percent -- 最小上浮百分比
            ,min_rate -- 最小利率
            ,spread_percent -- 浮动百分比
            ,spread_rate -- 浮动点数
            ,min_spread_percent -- 最小浮动比例
            ,max_spread_rate -- 最大上浮点差
            ,min_spread_rate -- 最大下浮点差
            ,max_spread_percent -- 最大下浮比例
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.int_type -- 利率类型
    ,o.period_freq -- 频率id
    ,o.company -- 法人
    ,o.int_basis -- 基准利率类型
    ,o.matrix_no -- 阶梯序号
    ,o.year_basis -- 年基准天数
    ,o.effect_date -- 产品生效日期
    ,o.end_date -- 结束日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.actual_rate -- 行内利率
    ,o.base_rate -- 基础汇率
    ,o.day_num -- 每期天数
    ,o.disc_rate -- 利率折扣
    ,o.matrix_amt -- 阶梯金额
    ,o.max_percent -- 最大上浮比例
    ,o.max_rate -- 最大利率
    ,o.min_percent -- 最小上浮百分比
    ,o.min_rate -- 最小利率
    ,o.spread_percent -- 浮动百分比
    ,o.spread_rate -- 浮动点数
    ,o.min_spread_percent -- 最小浮动比例
    ,o.max_spread_rate -- 最大上浮点差
    ,o.min_spread_rate -- 最大下浮点差
    ,o.max_spread_percent -- 最大下浮比例
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
from ${iol_schema}.ncbs_mb_int_matrix_bk o
    left join ${iol_schema}.ncbs_mb_int_matrix_op n
        on
            o.matrix_no = n.matrix_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_int_matrix_cl d
        on
            o.matrix_no = d.matrix_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_int_matrix;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_int_matrix') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_int_matrix drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_int_matrix add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_int_matrix exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_int_matrix_cl;
alter table ${iol_schema}.ncbs_mb_int_matrix exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_int_matrix_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_int_matrix to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_int_matrix_op purge;
drop table ${iol_schema}.ncbs_mb_int_matrix_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_int_matrix_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_int_matrix',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
