/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_mb_ccy_rate_hist
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
create table ${iol_schema}.ncbs_mb_ccy_rate_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_mb_ccy_rate_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_ccy_rate_hist_op purge;
drop table ${iol_schema}.ncbs_mb_ccy_rate_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_ccy_rate_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_ccy_rate_hist where 0=1;

create table ${iol_schema}.ncbs_mb_ccy_rate_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_mb_ccy_rate_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_ccy_rate_hist_cl(
            branch -- 交易机构编号|机构代码
            ,ccy -- 币种|币种
            ,company -- 法人|法人
            ,effect_time -- 汇率牌价生效时间|汇率牌价生效时间
            ,quote_type -- 牌价类型|牌价类型|d-直接,i-间接
            ,rate_type -- 汇率类型|汇率类型
            ,effect_date -- 产品生效日期|生效日期
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,central_bank_rate -- 央行参考汇率|央行参考汇率
            ,exch_buy_rate -- 汇买价|汇买价
            ,exch_sell_rate -- 汇卖价|汇卖价
            ,max_float_rate -- 最大浮动点|最大浮动点
            ,middle_rate -- 中间价|中间价
            ,notes_buy_rate -- 钞买价|钞买价
            ,notes_sell_rate -- 钞卖价|钞卖价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_ccy_rate_hist_op(
            branch -- 交易机构编号|机构代码
            ,ccy -- 币种|币种
            ,company -- 法人|法人
            ,effect_time -- 汇率牌价生效时间|汇率牌价生效时间
            ,quote_type -- 牌价类型|牌价类型|d-直接,i-间接
            ,rate_type -- 汇率类型|汇率类型
            ,effect_date -- 产品生效日期|生效日期
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,central_bank_rate -- 央行参考汇率|央行参考汇率
            ,exch_buy_rate -- 汇买价|汇买价
            ,exch_sell_rate -- 汇卖价|汇卖价
            ,max_float_rate -- 最大浮动点|最大浮动点
            ,middle_rate -- 中间价|中间价
            ,notes_buy_rate -- 钞买价|钞买价
            ,notes_sell_rate -- 钞卖价|钞卖价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.branch, o.branch) as branch -- 交易机构编号|机构代码
    ,nvl(n.ccy, o.ccy) as ccy -- 币种|币种
    ,nvl(n.company, o.company) as company -- 法人|法人
    ,nvl(n.effect_time, o.effect_time) as effect_time -- 汇率牌价生效时间|汇率牌价生效时间
    ,nvl(n.quote_type, o.quote_type) as quote_type -- 牌价类型|牌价类型|d-直接,i-间接
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 汇率类型|汇率类型
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期|生效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳|交易时间戳
    ,nvl(n.central_bank_rate, o.central_bank_rate) as central_bank_rate -- 央行参考汇率|央行参考汇率
    ,nvl(n.exch_buy_rate, o.exch_buy_rate) as exch_buy_rate -- 汇买价|汇买价
    ,nvl(n.exch_sell_rate, o.exch_sell_rate) as exch_sell_rate -- 汇卖价|汇卖价
    ,nvl(n.max_float_rate, o.max_float_rate) as max_float_rate -- 最大浮动点|最大浮动点
    ,nvl(n.middle_rate, o.middle_rate) as middle_rate -- 中间价|中间价
    ,nvl(n.notes_buy_rate, o.notes_buy_rate) as notes_buy_rate -- 钞买价|钞买价
    ,nvl(n.notes_sell_rate, o.notes_sell_rate) as notes_sell_rate -- 钞卖价|钞卖价
    ,case when
            n.branch is null
            and n.ccy is null
            and n.effect_time is null
            and n.rate_type is null
            and n.effect_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch is null
            and n.ccy is null
            and n.effect_time is null
            and n.rate_type is null
            and n.effect_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch is null
            and n.ccy is null
            and n.effect_time is null
            and n.rate_type is null
            and n.effect_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_mb_ccy_rate_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_mb_ccy_rate_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch = n.branch
            and o.ccy = n.ccy
            and o.effect_time = n.effect_time
            and o.rate_type = n.rate_type
            and o.effect_date = n.effect_date
where (
        o.branch is null
        and o.ccy is null
        and o.effect_time is null
        and o.rate_type is null
        and o.effect_date is null
    )
    or (
        n.branch is null
        and n.ccy is null
        and n.effect_time is null
        and n.rate_type is null
        and n.effect_date is null
    )
    or (
        o.company <> n.company
        or o.quote_type <> n.quote_type
        or o.tran_timestamp <> n.tran_timestamp
        or o.central_bank_rate <> n.central_bank_rate
        or o.exch_buy_rate <> n.exch_buy_rate
        or o.exch_sell_rate <> n.exch_sell_rate
        or o.max_float_rate <> n.max_float_rate
        or o.middle_rate <> n.middle_rate
        or o.notes_buy_rate <> n.notes_buy_rate
        or o.notes_sell_rate <> n.notes_sell_rate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_mb_ccy_rate_hist_cl(
            branch -- 交易机构编号|机构代码
            ,ccy -- 币种|币种
            ,company -- 法人|法人
            ,effect_time -- 汇率牌价生效时间|汇率牌价生效时间
            ,quote_type -- 牌价类型|牌价类型|d-直接,i-间接
            ,rate_type -- 汇率类型|汇率类型
            ,effect_date -- 产品生效日期|生效日期
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,central_bank_rate -- 央行参考汇率|央行参考汇率
            ,exch_buy_rate -- 汇买价|汇买价
            ,exch_sell_rate -- 汇卖价|汇卖价
            ,max_float_rate -- 最大浮动点|最大浮动点
            ,middle_rate -- 中间价|中间价
            ,notes_buy_rate -- 钞买价|钞买价
            ,notes_sell_rate -- 钞卖价|钞卖价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_mb_ccy_rate_hist_op(
            branch -- 交易机构编号|机构代码
            ,ccy -- 币种|币种
            ,company -- 法人|法人
            ,effect_time -- 汇率牌价生效时间|汇率牌价生效时间
            ,quote_type -- 牌价类型|牌价类型|d-直接,i-间接
            ,rate_type -- 汇率类型|汇率类型
            ,effect_date -- 产品生效日期|生效日期
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,central_bank_rate -- 央行参考汇率|央行参考汇率
            ,exch_buy_rate -- 汇买价|汇买价
            ,exch_sell_rate -- 汇卖价|汇卖价
            ,max_float_rate -- 最大浮动点|最大浮动点
            ,middle_rate -- 中间价|中间价
            ,notes_buy_rate -- 钞买价|钞买价
            ,notes_sell_rate -- 钞卖价|钞卖价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.branch -- 交易机构编号|机构代码
    ,o.ccy -- 币种|币种
    ,o.company -- 法人|法人
    ,o.effect_time -- 汇率牌价生效时间|汇率牌价生效时间
    ,o.quote_type -- 牌价类型|牌价类型|d-直接,i-间接
    ,o.rate_type -- 汇率类型|汇率类型
    ,o.effect_date -- 产品生效日期|生效日期
    ,o.tran_timestamp -- 交易时间戳|交易时间戳
    ,o.central_bank_rate -- 央行参考汇率|央行参考汇率
    ,o.exch_buy_rate -- 汇买价|汇买价
    ,o.exch_sell_rate -- 汇卖价|汇卖价
    ,o.max_float_rate -- 最大浮动点|最大浮动点
    ,o.middle_rate -- 中间价|中间价
    ,o.notes_buy_rate -- 钞买价|钞买价
    ,o.notes_sell_rate -- 钞卖价|钞卖价
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
from ${iol_schema}.ncbs_mb_ccy_rate_hist_bk o
    left join ${iol_schema}.ncbs_mb_ccy_rate_hist_op n
        on
            o.branch = n.branch
            and o.ccy = n.ccy
            and o.effect_time = n.effect_time
            and o.rate_type = n.rate_type
            and o.effect_date = n.effect_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_mb_ccy_rate_hist_cl d
        on
            o.branch = d.branch
            and o.ccy = d.ccy
            and o.effect_time = d.effect_time
            and o.rate_type = d.rate_type
            and o.effect_date = d.effect_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_mb_ccy_rate_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_mb_ccy_rate_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_mb_ccy_rate_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_mb_ccy_rate_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_mb_ccy_rate_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_mb_ccy_rate_hist_cl;
alter table ${iol_schema}.ncbs_mb_ccy_rate_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_mb_ccy_rate_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_mb_ccy_rate_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_mb_ccy_rate_hist_op purge;
drop table ${iol_schema}.ncbs_mb_ccy_rate_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_mb_ccy_rate_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_mb_ccy_rate_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
