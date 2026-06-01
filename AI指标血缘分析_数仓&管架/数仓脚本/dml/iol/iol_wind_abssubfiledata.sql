/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_abssubfiledata
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
create table ${iol_schema}.wind_abssubfiledata_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_abssubfiledata
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_abssubfiledata_op purge;
drop table ${iol_schema}.wind_abssubfiledata_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_abssubfiledata_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_abssubfiledata where 0=1;

create table ${iol_schema}.wind_abssubfiledata_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_abssubfiledata where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_abssubfiledata_cl(
            s_info_windcode -- Wind代码
            ,yield_min -- 预期最低年收 益率(%)
            ,yield_max -- 预期最高年收 益率(%)
            ,s_info_compcode -- 资产所有方公司id
            ,b_anal_ptmyear -- 存续期
            ,basic_assets -- 基础资产
            ,mobile_places -- 流动场所
            ,product_compname -- 产品设立人
            ,start_date -- 转让起始日期
            ,end_date -- 转让截止日期
            ,product_manager -- 产品管理人
            ,bookkeeping_manager -- 薄记管理人
            ,subdivide_code -- 资产支持证券 分档代码
            ,intex_name -- Intex项目名称
            ,intex_code -- Intex分档代码
            ,intex_rate -- Intex利率基准
            ,repay_typecode -- 还本方式代码
            ,amount_ownhold -- 自持金额
            ,fix_capital_cost -- 固定资金成本
            ,sub_period_revenue_cap -- 次级期间收益 上限
            ,abs_id -- 项目ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_abssubfiledata_op(
            s_info_windcode -- Wind代码
            ,yield_min -- 预期最低年收 益率(%)
            ,yield_max -- 预期最高年收 益率(%)
            ,s_info_compcode -- 资产所有方公司id
            ,b_anal_ptmyear -- 存续期
            ,basic_assets -- 基础资产
            ,mobile_places -- 流动场所
            ,product_compname -- 产品设立人
            ,start_date -- 转让起始日期
            ,end_date -- 转让截止日期
            ,product_manager -- 产品管理人
            ,bookkeeping_manager -- 薄记管理人
            ,subdivide_code -- 资产支持证券 分档代码
            ,intex_name -- Intex项目名称
            ,intex_code -- Intex分档代码
            ,intex_rate -- Intex利率基准
            ,repay_typecode -- 还本方式代码
            ,amount_ownhold -- 自持金额
            ,fix_capital_cost -- 固定资金成本
            ,sub_period_revenue_cap -- 次级期间收益 上限
            ,abs_id -- 项目ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.s_info_windcode, o.s_info_windcode) as s_info_windcode -- Wind代码
    ,nvl(n.yield_min, o.yield_min) as yield_min -- 预期最低年收 益率(%)
    ,nvl(n.yield_max, o.yield_max) as yield_max -- 预期最高年收 益率(%)
    ,nvl(n.s_info_compcode, o.s_info_compcode) as s_info_compcode -- 资产所有方公司id
    ,nvl(n.b_anal_ptmyear, o.b_anal_ptmyear) as b_anal_ptmyear -- 存续期
    ,nvl(n.basic_assets, o.basic_assets) as basic_assets -- 基础资产
    ,nvl(n.mobile_places, o.mobile_places) as mobile_places -- 流动场所
    ,nvl(n.product_compname, o.product_compname) as product_compname -- 产品设立人
    ,nvl(n.start_date, o.start_date) as start_date -- 转让起始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 转让截止日期
    ,nvl(n.product_manager, o.product_manager) as product_manager -- 产品管理人
    ,nvl(n.bookkeeping_manager, o.bookkeeping_manager) as bookkeeping_manager -- 薄记管理人
    ,nvl(n.subdivide_code, o.subdivide_code) as subdivide_code -- 资产支持证券 分档代码
    ,nvl(n.intex_name, o.intex_name) as intex_name -- Intex项目名称
    ,nvl(n.intex_code, o.intex_code) as intex_code -- Intex分档代码
    ,nvl(n.intex_rate, o.intex_rate) as intex_rate -- Intex利率基准
    ,nvl(n.repay_typecode, o.repay_typecode) as repay_typecode -- 还本方式代码
    ,nvl(n.amount_ownhold, o.amount_ownhold) as amount_ownhold -- 自持金额
    ,nvl(n.fix_capital_cost, o.fix_capital_cost) as fix_capital_cost -- 固定资金成本
    ,nvl(n.sub_period_revenue_cap, o.sub_period_revenue_cap) as sub_period_revenue_cap -- 次级期间收益 上限
    ,nvl(n.abs_id, o.abs_id) as abs_id -- 项目ID
    ,case when
            n.s_info_windcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.s_info_windcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.s_info_windcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_abssubfiledata_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_abssubfiledata where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.s_info_windcode = n.s_info_windcode
where (
        o.s_info_windcode is null
    )
    or (
        n.s_info_windcode is null
    )
    or (
        o.yield_min <> n.yield_min
        or o.yield_max <> n.yield_max
        or o.s_info_compcode <> n.s_info_compcode
        or o.b_anal_ptmyear <> n.b_anal_ptmyear
        or o.basic_assets <> n.basic_assets
        or o.mobile_places <> n.mobile_places
        or o.product_compname <> n.product_compname
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.product_manager <> n.product_manager
        or o.bookkeeping_manager <> n.bookkeeping_manager
        or o.subdivide_code <> n.subdivide_code
        or o.intex_name <> n.intex_name
        or o.intex_code <> n.intex_code
        or o.intex_rate <> n.intex_rate
        or o.repay_typecode <> n.repay_typecode
        or o.amount_ownhold <> n.amount_ownhold
        or o.fix_capital_cost <> n.fix_capital_cost
        or o.sub_period_revenue_cap <> n.sub_period_revenue_cap
        or o.abs_id <> n.abs_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_abssubfiledata_cl(
            s_info_windcode -- Wind代码
            ,yield_min -- 预期最低年收 益率(%)
            ,yield_max -- 预期最高年收 益率(%)
            ,s_info_compcode -- 资产所有方公司id
            ,b_anal_ptmyear -- 存续期
            ,basic_assets -- 基础资产
            ,mobile_places -- 流动场所
            ,product_compname -- 产品设立人
            ,start_date -- 转让起始日期
            ,end_date -- 转让截止日期
            ,product_manager -- 产品管理人
            ,bookkeeping_manager -- 薄记管理人
            ,subdivide_code -- 资产支持证券 分档代码
            ,intex_name -- Intex项目名称
            ,intex_code -- Intex分档代码
            ,intex_rate -- Intex利率基准
            ,repay_typecode -- 还本方式代码
            ,amount_ownhold -- 自持金额
            ,fix_capital_cost -- 固定资金成本
            ,sub_period_revenue_cap -- 次级期间收益 上限
            ,abs_id -- 项目ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_abssubfiledata_op(
            s_info_windcode -- Wind代码
            ,yield_min -- 预期最低年收 益率(%)
            ,yield_max -- 预期最高年收 益率(%)
            ,s_info_compcode -- 资产所有方公司id
            ,b_anal_ptmyear -- 存续期
            ,basic_assets -- 基础资产
            ,mobile_places -- 流动场所
            ,product_compname -- 产品设立人
            ,start_date -- 转让起始日期
            ,end_date -- 转让截止日期
            ,product_manager -- 产品管理人
            ,bookkeeping_manager -- 薄记管理人
            ,subdivide_code -- 资产支持证券 分档代码
            ,intex_name -- Intex项目名称
            ,intex_code -- Intex分档代码
            ,intex_rate -- Intex利率基准
            ,repay_typecode -- 还本方式代码
            ,amount_ownhold -- 自持金额
            ,fix_capital_cost -- 固定资金成本
            ,sub_period_revenue_cap -- 次级期间收益 上限
            ,abs_id -- 项目ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.s_info_windcode -- Wind代码
    ,o.yield_min -- 预期最低年收 益率(%)
    ,o.yield_max -- 预期最高年收 益率(%)
    ,o.s_info_compcode -- 资产所有方公司id
    ,o.b_anal_ptmyear -- 存续期
    ,o.basic_assets -- 基础资产
    ,o.mobile_places -- 流动场所
    ,o.product_compname -- 产品设立人
    ,o.start_date -- 转让起始日期
    ,o.end_date -- 转让截止日期
    ,o.product_manager -- 产品管理人
    ,o.bookkeeping_manager -- 薄记管理人
    ,o.subdivide_code -- 资产支持证券 分档代码
    ,o.intex_name -- Intex项目名称
    ,o.intex_code -- Intex分档代码
    ,o.intex_rate -- Intex利率基准
    ,o.repay_typecode -- 还本方式代码
    ,o.amount_ownhold -- 自持金额
    ,o.fix_capital_cost -- 固定资金成本
    ,o.sub_period_revenue_cap -- 次级期间收益 上限
    ,o.abs_id -- 项目ID
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
from ${iol_schema}.wind_abssubfiledata_bk o
    left join ${iol_schema}.wind_abssubfiledata_op n
        on
            o.s_info_windcode = n.s_info_windcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_abssubfiledata_cl d
        on
            o.s_info_windcode = d.s_info_windcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_abssubfiledata;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_abssubfiledata') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_abssubfiledata drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_abssubfiledata add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_abssubfiledata exchange partition p_${batch_date} with table ${iol_schema}.wind_abssubfiledata_cl;
alter table ${iol_schema}.wind_abssubfiledata exchange partition p_20991231 with table ${iol_schema}.wind_abssubfiledata_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_abssubfiledata to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_abssubfiledata_op purge;
drop table ${iol_schema}.wind_abssubfiledata_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_abssubfiledata_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_abssubfiledata',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
