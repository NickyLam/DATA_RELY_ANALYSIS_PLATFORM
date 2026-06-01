/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92ym_asset_view
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
create table ${iol_schema}.mpcs_a92ym_asset_view_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92ym_asset_view
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92ym_asset_view_op purge;
drop table ${iol_schema}.mpcs_a92ym_asset_view_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92ym_asset_view_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92ym_asset_view where 0=1;

create table ${iol_schema}.mpcs_a92ym_asset_view_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92ym_asset_view where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92ym_asset_view_cl(
            custno -- 客户号
            ,cardno -- 账号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型
            ,totalshare -- 份额
            ,totalsharedt -- 份额日期
            ,nav -- 净值
            ,navdt -- 净值日期
            ,divamt -- 净值日期对应的分红金额
            ,oldtotalshare -- 上日份额
            ,oldtotalsharedt -- 上日份额日期
            ,oldnav -- 上日净值
            ,oldnavtdt -- 上日净值日期
            ,olddivamt -- 上日净值日期对应的分红金额
            ,total_cosr -- 投入资金
            ,total_income -- 收益资金（不含分红）
            ,total_div -- 分红收益
            ,old_total_cosr -- 上日投入资金
            ,old_total_income -- 上日收益资金（不含分红）
            ,old_total_div -- 上日分行收益
            ,income -- 最新收益（基金净值差计算）
            ,accprofit -- 净值日期对应的浮动盈亏
            ,lastaccprofit -- 上日净值日期对应的浮动盈亏
            ,fund_income -- 最新收益（浮动盈亏相差计算）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92ym_asset_view_op(
            custno -- 客户号
            ,cardno -- 账号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型
            ,totalshare -- 份额
            ,totalsharedt -- 份额日期
            ,nav -- 净值
            ,navdt -- 净值日期
            ,divamt -- 净值日期对应的分红金额
            ,oldtotalshare -- 上日份额
            ,oldtotalsharedt -- 上日份额日期
            ,oldnav -- 上日净值
            ,oldnavtdt -- 上日净值日期
            ,olddivamt -- 上日净值日期对应的分红金额
            ,total_cosr -- 投入资金
            ,total_income -- 收益资金（不含分红）
            ,total_div -- 分红收益
            ,old_total_cosr -- 上日投入资金
            ,old_total_income -- 上日收益资金（不含分红）
            ,old_total_div -- 上日分行收益
            ,income -- 最新收益（基金净值差计算）
            ,accprofit -- 净值日期对应的浮动盈亏
            ,lastaccprofit -- 上日净值日期对应的浮动盈亏
            ,fund_income -- 最新收益（浮动盈亏相差计算）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custno, o.custno) as custno -- 客户号
    ,nvl(n.cardno, o.cardno) as cardno -- 账号
    ,nvl(n.fundcode, o.fundcode) as fundcode -- 基金代码
    ,nvl(n.fundfullname, o.fundfullname) as fundfullname -- 基金全称
    ,nvl(n.fundname, o.fundname) as fundname -- 基金简称
    ,nvl(n.fundtype, o.fundtype) as fundtype -- 基金类型
    ,nvl(n.totalshare, o.totalshare) as totalshare -- 份额
    ,nvl(n.totalsharedt, o.totalsharedt) as totalsharedt -- 份额日期
    ,nvl(n.nav, o.nav) as nav -- 净值
    ,nvl(n.navdt, o.navdt) as navdt -- 净值日期
    ,nvl(n.divamt, o.divamt) as divamt -- 净值日期对应的分红金额
    ,nvl(n.oldtotalshare, o.oldtotalshare) as oldtotalshare -- 上日份额
    ,nvl(n.oldtotalsharedt, o.oldtotalsharedt) as oldtotalsharedt -- 上日份额日期
    ,nvl(n.oldnav, o.oldnav) as oldnav -- 上日净值
    ,nvl(n.oldnavtdt, o.oldnavtdt) as oldnavtdt -- 上日净值日期
    ,nvl(n.olddivamt, o.olddivamt) as olddivamt -- 上日净值日期对应的分红金额
    ,nvl(n.total_cosr, o.total_cosr) as total_cosr -- 投入资金
    ,nvl(n.total_income, o.total_income) as total_income -- 收益资金（不含分红）
    ,nvl(n.total_div, o.total_div) as total_div -- 分红收益
    ,nvl(n.old_total_cosr, o.old_total_cosr) as old_total_cosr -- 上日投入资金
    ,nvl(n.old_total_income, o.old_total_income) as old_total_income -- 上日收益资金（不含分红）
    ,nvl(n.old_total_div, o.old_total_div) as old_total_div -- 上日分行收益
    ,nvl(n.income, o.income) as income -- 最新收益（基金净值差计算）
    ,nvl(n.accprofit, o.accprofit) as accprofit -- 净值日期对应的浮动盈亏
    ,nvl(n.lastaccprofit, o.lastaccprofit) as lastaccprofit -- 上日净值日期对应的浮动盈亏
    ,nvl(n.fund_income, o.fund_income) as fund_income -- 最新收益（浮动盈亏相差计算）
    ,case when
            n.custno is null
            and n.fundcode is null
            and n.navdt is null
            and n.oldnavtdt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custno is null
            and n.fundcode is null
            and n.navdt is null
            and n.oldnavtdt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custno is null
            and n.fundcode is null
            and n.navdt is null
            and n.oldnavtdt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92ym_asset_view_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92ym_asset_view where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custno = n.custno
            and o.fundcode = n.fundcode
            and o.navdt = n.navdt
            and o.oldnavtdt = n.oldnavtdt
where (
        o.custno is null
        and o.fundcode is null
        and o.navdt is null
        and o.oldnavtdt is null
    )
    or (
        n.custno is null
        and n.fundcode is null
        and n.navdt is null
        and n.oldnavtdt is null
    )
    or (
        o.cardno <> n.cardno
        or o.fundfullname <> n.fundfullname
        or o.fundname <> n.fundname
        or o.fundtype <> n.fundtype
        or o.totalshare <> n.totalshare
        or o.totalsharedt <> n.totalsharedt
        or o.nav <> n.nav
        or o.divamt <> n.divamt
        or o.oldtotalshare <> n.oldtotalshare
        or o.oldtotalsharedt <> n.oldtotalsharedt
        or o.oldnav <> n.oldnav
        or o.olddivamt <> n.olddivamt
        or o.total_cosr <> n.total_cosr
        or o.total_income <> n.total_income
        or o.total_div <> n.total_div
        or o.old_total_cosr <> n.old_total_cosr
        or o.old_total_income <> n.old_total_income
        or o.old_total_div <> n.old_total_div
        or o.income <> n.income
        or o.accprofit <> n.accprofit
        or o.lastaccprofit <> n.lastaccprofit
        or o.fund_income <> n.fund_income
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92ym_asset_view_cl(
            custno -- 客户号
            ,cardno -- 账号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型
            ,totalshare -- 份额
            ,totalsharedt -- 份额日期
            ,nav -- 净值
            ,navdt -- 净值日期
            ,divamt -- 净值日期对应的分红金额
            ,oldtotalshare -- 上日份额
            ,oldtotalsharedt -- 上日份额日期
            ,oldnav -- 上日净值
            ,oldnavtdt -- 上日净值日期
            ,olddivamt -- 上日净值日期对应的分红金额
            ,total_cosr -- 投入资金
            ,total_income -- 收益资金（不含分红）
            ,total_div -- 分红收益
            ,old_total_cosr -- 上日投入资金
            ,old_total_income -- 上日收益资金（不含分红）
            ,old_total_div -- 上日分行收益
            ,income -- 最新收益（基金净值差计算）
            ,accprofit -- 净值日期对应的浮动盈亏
            ,lastaccprofit -- 上日净值日期对应的浮动盈亏
            ,fund_income -- 最新收益（浮动盈亏相差计算）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92ym_asset_view_op(
            custno -- 客户号
            ,cardno -- 账号
            ,fundcode -- 基金代码
            ,fundfullname -- 基金全称
            ,fundname -- 基金简称
            ,fundtype -- 基金类型
            ,totalshare -- 份额
            ,totalsharedt -- 份额日期
            ,nav -- 净值
            ,navdt -- 净值日期
            ,divamt -- 净值日期对应的分红金额
            ,oldtotalshare -- 上日份额
            ,oldtotalsharedt -- 上日份额日期
            ,oldnav -- 上日净值
            ,oldnavtdt -- 上日净值日期
            ,olddivamt -- 上日净值日期对应的分红金额
            ,total_cosr -- 投入资金
            ,total_income -- 收益资金（不含分红）
            ,total_div -- 分红收益
            ,old_total_cosr -- 上日投入资金
            ,old_total_income -- 上日收益资金（不含分红）
            ,old_total_div -- 上日分行收益
            ,income -- 最新收益（基金净值差计算）
            ,accprofit -- 净值日期对应的浮动盈亏
            ,lastaccprofit -- 上日净值日期对应的浮动盈亏
            ,fund_income -- 最新收益（浮动盈亏相差计算）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custno -- 客户号
    ,o.cardno -- 账号
    ,o.fundcode -- 基金代码
    ,o.fundfullname -- 基金全称
    ,o.fundname -- 基金简称
    ,o.fundtype -- 基金类型
    ,o.totalshare -- 份额
    ,o.totalsharedt -- 份额日期
    ,o.nav -- 净值
    ,o.navdt -- 净值日期
    ,o.divamt -- 净值日期对应的分红金额
    ,o.oldtotalshare -- 上日份额
    ,o.oldtotalsharedt -- 上日份额日期
    ,o.oldnav -- 上日净值
    ,o.oldnavtdt -- 上日净值日期
    ,o.olddivamt -- 上日净值日期对应的分红金额
    ,o.total_cosr -- 投入资金
    ,o.total_income -- 收益资金（不含分红）
    ,o.total_div -- 分红收益
    ,o.old_total_cosr -- 上日投入资金
    ,o.old_total_income -- 上日收益资金（不含分红）
    ,o.old_total_div -- 上日分行收益
    ,o.income -- 最新收益（基金净值差计算）
    ,o.accprofit -- 净值日期对应的浮动盈亏
    ,o.lastaccprofit -- 上日净值日期对应的浮动盈亏
    ,o.fund_income -- 最新收益（浮动盈亏相差计算）
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
from ${iol_schema}.mpcs_a92ym_asset_view_bk o
    left join ${iol_schema}.mpcs_a92ym_asset_view_op n
        on
            o.custno = n.custno
            and o.fundcode = n.fundcode
            and o.navdt = n.navdt
            and o.oldnavtdt = n.oldnavtdt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92ym_asset_view_cl d
        on
            o.custno = d.custno
            and o.fundcode = d.fundcode
            and o.navdt = d.navdt
            and o.oldnavtdt = d.oldnavtdt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a92ym_asset_view;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a92ym_asset_view') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a92ym_asset_view drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a92ym_asset_view add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a92ym_asset_view exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a92ym_asset_view_cl;
alter table ${iol_schema}.mpcs_a92ym_asset_view exchange partition p_20991231 with table ${iol_schema}.mpcs_a92ym_asset_view_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92ym_asset_view to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92ym_asset_view_op purge;
drop table ${iol_schema}.mpcs_a92ym_asset_view_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92ym_asset_view_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92ym_asset_view',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
