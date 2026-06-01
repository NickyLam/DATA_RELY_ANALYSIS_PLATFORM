/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_irsrateyield
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
create table ${iol_schema}.wind_irsrateyield_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_irsrateyield;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_irsrateyield_op purge;
drop table ${iol_schema}.wind_irsrateyield_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_irsrateyield_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_irsrateyield where 0=1;

create table ${iol_schema}.wind_irsrateyield_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_irsrateyield where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_irsrateyield_cl(
            object_id -- OBJECT_ID
            ,trade_dt -- 交易日期
            ,b_anal_curvetype -- 曲线类型
            ,b_anal_curvetypecode -- 曲线类型代码
            ,b_anal_curveterm -- 期限(年)
            ,b_anal_ytm -- 到期收益率(%)
            ,b_tbf_sytm -- 即期利率(%)
            ,b_tbf_fytm -- 远期利率(%)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_irsrateyield_op(
            object_id -- OBJECT_ID
            ,trade_dt -- 交易日期
            ,b_anal_curvetype -- 曲线类型
            ,b_anal_curvetypecode -- 曲线类型代码
            ,b_anal_curveterm -- 期限(年)
            ,b_anal_ytm -- 到期收益率(%)
            ,b_tbf_sytm -- 即期利率(%)
            ,b_tbf_fytm -- 远期利率(%)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.object_id, o.object_id) as object_id -- OBJECT_ID
    ,nvl(n.trade_dt, o.trade_dt) as trade_dt -- 交易日期
    ,nvl(n.b_anal_curvetype, o.b_anal_curvetype) as b_anal_curvetype -- 曲线类型
    ,nvl(n.b_anal_curvetypecode, o.b_anal_curvetypecode) as b_anal_curvetypecode -- 曲线类型代码
    ,nvl(n.b_anal_curveterm, o.b_anal_curveterm) as b_anal_curveterm -- 期限(年)
    ,nvl(n.b_anal_ytm, o.b_anal_ytm) as b_anal_ytm -- 到期收益率(%)
    ,nvl(n.b_tbf_sytm, o.b_tbf_sytm) as b_tbf_sytm -- 即期利率(%)
    ,nvl(n.b_tbf_fytm, o.b_tbf_fytm) as b_tbf_fytm -- 远期利率(%)
    ,nvl(n.opdate, o.opdate) as opdate -- 
    ,nvl(n.opmode, o.opmode) as opmode -- 
    ,case when
            n.object_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.object_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.object_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_irsrateyield_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.wind_irsrateyield where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        n.object_id is null
    )
    or (
        o.trade_dt <> n.trade_dt
        or o.b_anal_curvetype <> n.b_anal_curvetype
        or o.b_anal_curvetypecode <> n.b_anal_curvetypecode
        or o.b_anal_curveterm <> n.b_anal_curveterm
        or o.b_anal_ytm <> n.b_anal_ytm
        or o.b_tbf_sytm <> n.b_tbf_sytm
        or o.b_tbf_fytm <> n.b_tbf_fytm
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_irsrateyield_cl(
            object_id -- OBJECT_ID
            ,trade_dt -- 交易日期
            ,b_anal_curvetype -- 曲线类型
            ,b_anal_curvetypecode -- 曲线类型代码
            ,b_anal_curveterm -- 期限(年)
            ,b_anal_ytm -- 到期收益率(%)
            ,b_tbf_sytm -- 即期利率(%)
            ,b_tbf_fytm -- 远期利率(%)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_irsrateyield_op(
            object_id -- OBJECT_ID
            ,trade_dt -- 交易日期
            ,b_anal_curvetype -- 曲线类型
            ,b_anal_curvetypecode -- 曲线类型代码
            ,b_anal_curveterm -- 期限(年)
            ,b_anal_ytm -- 到期收益率(%)
            ,b_tbf_sytm -- 即期利率(%)
            ,b_tbf_fytm -- 远期利率(%)
            ,opdate -- 
            ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- OBJECT_ID
    ,o.trade_dt -- 交易日期
    ,o.b_anal_curvetype -- 曲线类型
    ,o.b_anal_curvetypecode -- 曲线类型代码
    ,o.b_anal_curveterm -- 期限(年)
    ,o.b_anal_ytm -- 到期收益率(%)
    ,o.b_tbf_sytm -- 即期利率(%)
    ,o.b_tbf_fytm -- 远期利率(%)
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_irsrateyield_bk o
    left join ${iol_schema}.wind_irsrateyield_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.wind_irsrateyield_cl d
        on
            o.object_id = d.object_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.wind_irsrateyield;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_irsrateyield exchange partition p_19000101 with table ${iol_schema}.wind_irsrateyield_cl;
alter table ${iol_schema}.wind_irsrateyield exchange partition p_20991231 with table ${iol_schema}.wind_irsrateyield_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_irsrateyield to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_irsrateyield_op purge;
drop table ${iol_schema}.wind_irsrateyield_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_irsrateyield_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_irsrateyield',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
