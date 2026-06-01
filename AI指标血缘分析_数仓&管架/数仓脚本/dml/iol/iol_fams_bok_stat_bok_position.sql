/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_stat_bok_position
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
create table ${iol_schema}.fams_bok_stat_bok_position_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_stat_bok_position;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_stat_bok_position_op purge;
drop table ${iol_schema}.fams_bok_stat_bok_position_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_stat_bok_position_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_stat_bok_position where 0=1;

create table ${iol_schema}.fams_bok_stat_bok_position_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_stat_bok_position where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_stat_bok_position_cl(
            bookset_id -- 账套代码
            ,finprod_id -- 金融产品代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,profit_type -- 收益类型
            ,capital -- 实收资本
            ,profit_amt -- 当日应付利润
            ,tot_profit_amt -- 累计应付利润
            ,int_rate -- 计提利率
            ,net_asset_value_bef -- 费前资产净值
            ,net_asset_value -- 资产净值
            ,net_unit_value_bef -- 费前单位净值
            ,net_unit_value -- 单位净值
            ,p_yield_bef -- 万份收益_费前
            ,p_yield -- 万份收益
            ,tdy_yield_bef -- 当日年化收益率_费前
            ,tdy_yield -- 当日年化收益率
            ,yield_term_bef -- 周期年化收益率_费前
            ,yield_term -- 周期年化收益率
            ,yield_7_bef -- 当日7日年化收益率_费前
            ,yield_7 -- 当日7日年化收益率
            ,tot_bouns_amt -- 累计分红金额
            ,tdy_bouns_amt -- 当日分红金额
            ,tot_bouns_net -- 累计分红净值
            ,tdy_bouns_net -- 当日分红净值
            ,is_sub_prd -- 是否子产品
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_stat_bok_position_op(
            bookset_id -- 账套代码
            ,finprod_id -- 金融产品代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,profit_type -- 收益类型
            ,capital -- 实收资本
            ,profit_amt -- 当日应付利润
            ,tot_profit_amt -- 累计应付利润
            ,int_rate -- 计提利率
            ,net_asset_value_bef -- 费前资产净值
            ,net_asset_value -- 资产净值
            ,net_unit_value_bef -- 费前单位净值
            ,net_unit_value -- 单位净值
            ,p_yield_bef -- 万份收益_费前
            ,p_yield -- 万份收益
            ,tdy_yield_bef -- 当日年化收益率_费前
            ,tdy_yield -- 当日年化收益率
            ,yield_term_bef -- 周期年化收益率_费前
            ,yield_term -- 周期年化收益率
            ,yield_7_bef -- 当日7日年化收益率_费前
            ,yield_7 -- 当日7日年化收益率
            ,tot_bouns_amt -- 累计分红金额
            ,tdy_bouns_amt -- 当日分红金额
            ,tot_bouns_net -- 累计分红净值
            ,tdy_bouns_net -- 当日分红净值
            ,is_sub_prd -- 是否子产品
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.happen_date, o.happen_date) as happen_date -- 发生日期
    ,nvl(n.book_date, o.book_date) as book_date -- 入账日期
    ,nvl(n.bookset_date, o.bookset_date) as bookset_date -- 账套日期
    ,nvl(n.profit_type, o.profit_type) as profit_type -- 收益类型
    ,nvl(n.capital, o.capital) as capital -- 实收资本
    ,nvl(n.profit_amt, o.profit_amt) as profit_amt -- 当日应付利润
    ,nvl(n.tot_profit_amt, o.tot_profit_amt) as tot_profit_amt -- 累计应付利润
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 计提利率
    ,nvl(n.net_asset_value_bef, o.net_asset_value_bef) as net_asset_value_bef -- 费前资产净值
    ,nvl(n.net_asset_value, o.net_asset_value) as net_asset_value -- 资产净值
    ,nvl(n.net_unit_value_bef, o.net_unit_value_bef) as net_unit_value_bef -- 费前单位净值
    ,nvl(n.net_unit_value, o.net_unit_value) as net_unit_value -- 单位净值
    ,nvl(n.p_yield_bef, o.p_yield_bef) as p_yield_bef -- 万份收益_费前
    ,nvl(n.p_yield, o.p_yield) as p_yield -- 万份收益
    ,nvl(n.tdy_yield_bef, o.tdy_yield_bef) as tdy_yield_bef -- 当日年化收益率_费前
    ,nvl(n.tdy_yield, o.tdy_yield) as tdy_yield -- 当日年化收益率
    ,nvl(n.yield_term_bef, o.yield_term_bef) as yield_term_bef -- 周期年化收益率_费前
    ,nvl(n.yield_term, o.yield_term) as yield_term -- 周期年化收益率
    ,nvl(n.yield_7_bef, o.yield_7_bef) as yield_7_bef -- 当日7日年化收益率_费前
    ,nvl(n.yield_7, o.yield_7) as yield_7 -- 当日7日年化收益率
    ,nvl(n.tot_bouns_amt, o.tot_bouns_amt) as tot_bouns_amt -- 累计分红金额
    ,nvl(n.tdy_bouns_amt, o.tdy_bouns_amt) as tdy_bouns_amt -- 当日分红金额
    ,nvl(n.tot_bouns_net, o.tot_bouns_net) as tot_bouns_net -- 累计分红净值
    ,nvl(n.tdy_bouns_net, o.tdy_bouns_net) as tdy_bouns_net -- 当日分红净值
    ,nvl(n.is_sub_prd, o.is_sub_prd) as is_sub_prd -- 是否子产品
    ,nvl(n.layering_id, o.layering_id) as layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.layering_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.layering_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.happen_date is null
            and n.book_date is null
            and n.layering_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_stat_bok_position_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_stat_bok_position where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.layering_id = n.layering_id
where (
        o.bookset_id is null
        and o.happen_date is null
        and o.book_date is null
        and o.layering_id is null
    )
    or (
        n.bookset_id is null
        and n.happen_date is null
        and n.book_date is null
        and n.layering_id is null
    )
    or (
        o.finprod_id <> n.finprod_id
        or o.bookset_date <> n.bookset_date
        or o.profit_type <> n.profit_type
        or o.capital <> n.capital
        or o.profit_amt <> n.profit_amt
        or o.tot_profit_amt <> n.tot_profit_amt
        or o.int_rate <> n.int_rate
        or o.net_asset_value_bef <> n.net_asset_value_bef
        or o.net_asset_value <> n.net_asset_value
        or o.net_unit_value_bef <> n.net_unit_value_bef
        or o.net_unit_value <> n.net_unit_value
        or o.p_yield_bef <> n.p_yield_bef
        or o.p_yield <> n.p_yield
        or o.tdy_yield_bef <> n.tdy_yield_bef
        or o.tdy_yield <> n.tdy_yield
        or o.yield_term_bef <> n.yield_term_bef
        or o.yield_term <> n.yield_term
        or o.yield_7_bef <> n.yield_7_bef
        or o.yield_7 <> n.yield_7
        or o.tot_bouns_amt <> n.tot_bouns_amt
        or o.tdy_bouns_amt <> n.tdy_bouns_amt
        or o.tot_bouns_net <> n.tot_bouns_net
        or o.tdy_bouns_net <> n.tdy_bouns_net
        or o.is_sub_prd <> n.is_sub_prd
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_stat_bok_position_cl(
            bookset_id -- 账套代码
            ,finprod_id -- 金融产品代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,profit_type -- 收益类型
            ,capital -- 实收资本
            ,profit_amt -- 当日应付利润
            ,tot_profit_amt -- 累计应付利润
            ,int_rate -- 计提利率
            ,net_asset_value_bef -- 费前资产净值
            ,net_asset_value -- 资产净值
            ,net_unit_value_bef -- 费前单位净值
            ,net_unit_value -- 单位净值
            ,p_yield_bef -- 万份收益_费前
            ,p_yield -- 万份收益
            ,tdy_yield_bef -- 当日年化收益率_费前
            ,tdy_yield -- 当日年化收益率
            ,yield_term_bef -- 周期年化收益率_费前
            ,yield_term -- 周期年化收益率
            ,yield_7_bef -- 当日7日年化收益率_费前
            ,yield_7 -- 当日7日年化收益率
            ,tot_bouns_amt -- 累计分红金额
            ,tdy_bouns_amt -- 当日分红金额
            ,tot_bouns_net -- 累计分红净值
            ,tdy_bouns_net -- 当日分红净值
            ,is_sub_prd -- 是否子产品
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_stat_bok_position_op(
            bookset_id -- 账套代码
            ,finprod_id -- 金融产品代码
            ,happen_date -- 发生日期
            ,book_date -- 入账日期
            ,bookset_date -- 账套日期
            ,profit_type -- 收益类型
            ,capital -- 实收资本
            ,profit_amt -- 当日应付利润
            ,tot_profit_amt -- 累计应付利润
            ,int_rate -- 计提利率
            ,net_asset_value_bef -- 费前资产净值
            ,net_asset_value -- 资产净值
            ,net_unit_value_bef -- 费前单位净值
            ,net_unit_value -- 单位净值
            ,p_yield_bef -- 万份收益_费前
            ,p_yield -- 万份收益
            ,tdy_yield_bef -- 当日年化收益率_费前
            ,tdy_yield -- 当日年化收益率
            ,yield_term_bef -- 周期年化收益率_费前
            ,yield_term -- 周期年化收益率
            ,yield_7_bef -- 当日7日年化收益率_费前
            ,yield_7 -- 当日7日年化收益率
            ,tot_bouns_amt -- 累计分红金额
            ,tdy_bouns_amt -- 当日分红金额
            ,tot_bouns_net -- 累计分红净值
            ,tdy_bouns_net -- 当日分红净值
            ,is_sub_prd -- 是否子产品
            ,layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bookset_id -- 账套代码
    ,o.finprod_id -- 金融产品代码
    ,o.happen_date -- 发生日期
    ,o.book_date -- 入账日期
    ,o.bookset_date -- 账套日期
    ,o.profit_type -- 收益类型
    ,o.capital -- 实收资本
    ,o.profit_amt -- 当日应付利润
    ,o.tot_profit_amt -- 累计应付利润
    ,o.int_rate -- 计提利率
    ,o.net_asset_value_bef -- 费前资产净值
    ,o.net_asset_value -- 资产净值
    ,o.net_unit_value_bef -- 费前单位净值
    ,o.net_unit_value -- 单位净值
    ,o.p_yield_bef -- 万份收益_费前
    ,o.p_yield -- 万份收益
    ,o.tdy_yield_bef -- 当日年化收益率_费前
    ,o.tdy_yield -- 当日年化收益率
    ,o.yield_term_bef -- 周期年化收益率_费前
    ,o.yield_term -- 周期年化收益率
    ,o.yield_7_bef -- 当日7日年化收益率_费前
    ,o.yield_7 -- 当日7日年化收益率
    ,o.tot_bouns_amt -- 累计分红金额
    ,o.tdy_bouns_amt -- 当日分红金额
    ,o.tot_bouns_net -- 累计分红净值
    ,o.tdy_bouns_net -- 当日分红净值
    ,o.is_sub_prd -- 是否子产品
    ,o.layering_id -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_stat_bok_position_bk o
    left join ${iol_schema}.fams_bok_stat_bok_position_op n
        on
            o.bookset_id = n.bookset_id
            and o.happen_date = n.happen_date
            and o.book_date = n.book_date
            and o.layering_id = n.layering_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_stat_bok_position_cl d
        on
            o.bookset_id = d.bookset_id
            and o.happen_date = d.happen_date
            and o.book_date = d.book_date
            and o.layering_id = d.layering_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_bok_stat_bok_position;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_bok_stat_bok_position exchange partition p_19000101 with table ${iol_schema}.fams_bok_stat_bok_position_cl;
alter table ${iol_schema}.fams_bok_stat_bok_position exchange partition p_20991231 with table ${iol_schema}.fams_bok_stat_bok_position_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_stat_bok_position to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_stat_bok_position_op purge;
drop table ${iol_schema}.fams_bok_stat_bok_position_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_stat_bok_position_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_stat_bok_position',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
