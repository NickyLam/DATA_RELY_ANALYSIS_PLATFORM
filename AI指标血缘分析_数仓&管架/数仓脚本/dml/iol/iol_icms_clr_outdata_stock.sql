/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_outdata_stock
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
create table ${iol_schema}.icms_clr_outdata_stock_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_outdata_stock
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_outdata_stock_op purge;
drop table ${iol_schema}.icms_clr_outdata_stock_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_outdata_stock_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_outdata_stock where 0=1;

create table ${iol_schema}.icms_clr_outdata_stock_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_outdata_stock where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_outdata_stock_cl(
            dateno -- 期次
            ,interestno -- 股票代码
            ,interestname -- 股票名称
            ,newprice -- 最新发行价（元）
            ,volatility -- 涨跌幅（百分比）
            ,lastdayprice -- 昨日收盘价（元）
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_outdata_stock_op(
            dateno -- 期次
            ,interestno -- 股票代码
            ,interestname -- 股票名称
            ,newprice -- 最新发行价（元）
            ,volatility -- 涨跌幅（百分比）
            ,lastdayprice -- 昨日收盘价（元）
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dateno, o.dateno) as dateno -- 期次
    ,nvl(n.interestno, o.interestno) as interestno -- 股票代码
    ,nvl(n.interestname, o.interestname) as interestname -- 股票名称
    ,nvl(n.newprice, o.newprice) as newprice -- 最新发行价（元）
    ,nvl(n.volatility, o.volatility) as volatility -- 涨跌幅（百分比）
    ,nvl(n.lastdayprice, o.lastdayprice) as lastdayprice -- 昨日收盘价（元）
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.dateno is null
            and n.interestno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dateno is null
            and n.interestno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dateno is null
            and n.interestno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_outdata_stock_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_outdata_stock where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dateno = n.dateno
            and o.interestno = n.interestno
where (
        o.dateno is null
        and o.interestno is null
    )
    or (
        n.dateno is null
        and n.interestno is null
    )
    or (
        o.interestname <> n.interestname
        or o.newprice <> n.newprice
        or o.volatility <> n.volatility
        or o.lastdayprice <> n.lastdayprice
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_outdata_stock_cl(
            dateno -- 期次
            ,interestno -- 股票代码
            ,interestname -- 股票名称
            ,newprice -- 最新发行价（元）
            ,volatility -- 涨跌幅（百分比）
            ,lastdayprice -- 昨日收盘价（元）
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_outdata_stock_op(
            dateno -- 期次
            ,interestno -- 股票代码
            ,interestname -- 股票名称
            ,newprice -- 最新发行价（元）
            ,volatility -- 涨跌幅（百分比）
            ,lastdayprice -- 昨日收盘价（元）
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dateno -- 期次
    ,o.interestno -- 股票代码
    ,o.interestname -- 股票名称
    ,o.newprice -- 最新发行价（元）
    ,o.volatility -- 涨跌幅（百分比）
    ,o.lastdayprice -- 昨日收盘价（元）
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_outdata_stock_bk o
    left join ${iol_schema}.icms_clr_outdata_stock_op n
        on
            o.dateno = n.dateno
            and o.interestno = n.interestno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_outdata_stock_cl d
        on
            o.dateno = d.dateno
            and o.interestno = d.interestno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_outdata_stock;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_outdata_stock') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_outdata_stock drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_outdata_stock add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_outdata_stock exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_outdata_stock_cl;
alter table ${iol_schema}.icms_clr_outdata_stock exchange partition p_20991231 with table ${iol_schema}.icms_clr_outdata_stock_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_outdata_stock to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_outdata_stock_op purge;
drop table ${iol_schema}.icms_clr_outdata_stock_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_outdata_stock_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_outdata_stock',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
