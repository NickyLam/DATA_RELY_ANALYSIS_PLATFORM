/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_rate_result
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
create table ${iol_schema}.icms_customer_rate_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_rate_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_rate_result_op purge;
drop table ${iol_schema}.icms_customer_rate_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_rate_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_rate_result where 0=1;

create table ${iol_schema}.icms_customer_rate_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_rate_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_rate_result_cl(
            customerid -- 客户号
            ,updateuserid -- 更新人编号
            ,rateenddate -- 评级到期日
            ,inputorgid -- 登记人机构编号
            ,migtflag -- 
            ,raterisklevel -- 确认级别
            ,flag -- 标志位
            ,ratelimitlevel -- 准入级别
            ,ismerge -- 评级使用的最新财报是否合并
            ,inputuserid -- 登记人编号
            ,updateorgid -- 更新人机构编号
            ,fromflag -- 评级结果来源RateFrom
            ,inputtime -- 登记时间
            ,ratelimitamt -- 限额
            ,repperiod -- 评级使用的最新财报周期
            ,ratebegindate -- 评级核定日
            ,repno -- 评级使用的最新财报期次
            ,processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
            ,updatetime -- 更新时间
            ,isreport -- 是否有结清业务
            ,serialno -- 流水号
            ,taskno -- 内评系统任务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_rate_result_op(
            customerid -- 客户号
            ,updateuserid -- 更新人编号
            ,rateenddate -- 评级到期日
            ,inputorgid -- 登记人机构编号
            ,migtflag -- 
            ,raterisklevel -- 确认级别
            ,flag -- 标志位
            ,ratelimitlevel -- 准入级别
            ,ismerge -- 评级使用的最新财报是否合并
            ,inputuserid -- 登记人编号
            ,updateorgid -- 更新人机构编号
            ,fromflag -- 评级结果来源RateFrom
            ,inputtime -- 登记时间
            ,ratelimitamt -- 限额
            ,repperiod -- 评级使用的最新财报周期
            ,ratebegindate -- 评级核定日
            ,repno -- 评级使用的最新财报期次
            ,processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
            ,updatetime -- 更新时间
            ,isreport -- 是否有结清业务
            ,serialno -- 流水号
            ,taskno -- 内评系统任务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人编号
    ,nvl(n.rateenddate, o.rateenddate) as rateenddate -- 评级到期日
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记人机构编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.raterisklevel, o.raterisklevel) as raterisklevel -- 确认级别
    ,nvl(n.flag, o.flag) as flag -- 标志位
    ,nvl(n.ratelimitlevel, o.ratelimitlevel) as ratelimitlevel -- 准入级别
    ,nvl(n.ismerge, o.ismerge) as ismerge -- 评级使用的最新财报是否合并
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人编号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新人机构编号
    ,nvl(n.fromflag, o.fromflag) as fromflag -- 评级结果来源RateFrom
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.ratelimitamt, o.ratelimitamt) as ratelimitamt -- 限额
    ,nvl(n.repperiod, o.repperiod) as repperiod -- 评级使用的最新财报周期
    ,nvl(n.ratebegindate, o.ratebegindate) as ratebegindate -- 评级核定日
    ,nvl(n.repno, o.repno) as repno -- 评级使用的最新财报期次
    ,nvl(n.processtype, o.processtype) as processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.isreport, o.isreport) as isreport -- 是否有结清业务
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.taskno, o.taskno) as taskno -- 内评系统任务流水号
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_customer_rate_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_rate_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.updateuserid <> n.updateuserid
        or o.rateenddate <> n.rateenddate
        or o.inputorgid <> n.inputorgid
        or o.migtflag <> n.migtflag
        or o.raterisklevel <> n.raterisklevel
        or o.flag <> n.flag
        or o.ratelimitlevel <> n.ratelimitlevel
        or o.ismerge <> n.ismerge
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.fromflag <> n.fromflag
        or o.inputtime <> n.inputtime
        or o.ratelimitamt <> n.ratelimitamt
        or o.repperiod <> n.repperiod
        or o.ratebegindate <> n.ratebegindate
        or o.repno <> n.repno
        or o.processtype <> n.processtype
        or o.updatetime <> n.updatetime
        or o.isreport <> n.isreport
        or o.serialno <> n.serialno
        or o.taskno <> n.taskno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_rate_result_cl(
            customerid -- 客户号
            ,updateuserid -- 更新人编号
            ,rateenddate -- 评级到期日
            ,inputorgid -- 登记人机构编号
            ,migtflag -- 
            ,raterisklevel -- 确认级别
            ,flag -- 标志位
            ,ratelimitlevel -- 准入级别
            ,ismerge -- 评级使用的最新财报是否合并
            ,inputuserid -- 登记人编号
            ,updateorgid -- 更新人机构编号
            ,fromflag -- 评级结果来源RateFrom
            ,inputtime -- 登记时间
            ,ratelimitamt -- 限额
            ,repperiod -- 评级使用的最新财报周期
            ,ratebegindate -- 评级核定日
            ,repno -- 评级使用的最新财报期次
            ,processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
            ,updatetime -- 更新时间
            ,isreport -- 是否有结清业务
            ,serialno -- 流水号
            ,taskno -- 内评系统任务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_rate_result_op(
            customerid -- 客户号
            ,updateuserid -- 更新人编号
            ,rateenddate -- 评级到期日
            ,inputorgid -- 登记人机构编号
            ,migtflag -- 
            ,raterisklevel -- 确认级别
            ,flag -- 标志位
            ,ratelimitlevel -- 准入级别
            ,ismerge -- 评级使用的最新财报是否合并
            ,inputuserid -- 登记人编号
            ,updateorgid -- 更新人机构编号
            ,fromflag -- 评级结果来源RateFrom
            ,inputtime -- 登记时间
            ,ratelimitamt -- 限额
            ,repperiod -- 评级使用的最新财报周期
            ,ratebegindate -- 评级核定日
            ,repno -- 评级使用的最新财报期次
            ,processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
            ,updatetime -- 更新时间
            ,isreport -- 是否有结清业务
            ,serialno -- 流水号
            ,taskno -- 内评系统任务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户号
    ,o.updateuserid -- 更新人编号
    ,o.rateenddate -- 评级到期日
    ,o.inputorgid -- 登记人机构编号
    ,o.migtflag -- 
    ,o.raterisklevel -- 确认级别
    ,o.flag -- 标志位
    ,o.ratelimitlevel -- 准入级别
    ,o.ismerge -- 评级使用的最新财报是否合并
    ,o.inputuserid -- 登记人编号
    ,o.updateorgid -- 更新人机构编号
    ,o.fromflag -- 评级结果来源RateFrom
    ,o.inputtime -- 登记时间
    ,o.ratelimitamt -- 限额
    ,o.repperiod -- 评级使用的最新财报周期
    ,o.ratebegindate -- 评级核定日
    ,o.repno -- 评级使用的最新财报期次
    ,o.processtype -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
    ,o.updatetime -- 更新时间
    ,o.isreport -- 是否有结清业务
    ,o.serialno -- 流水号
    ,o.taskno -- 内评系统任务流水号
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
from ${iol_schema}.icms_customer_rate_result_bk o
    left join ${iol_schema}.icms_customer_rate_result_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_rate_result_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_customer_rate_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_rate_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_rate_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_rate_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_rate_result exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_rate_result_cl;
alter table ${iol_schema}.icms_customer_rate_result exchange partition p_20991231 with table ${iol_schema}.icms_customer_rate_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_rate_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_rate_result_op purge;
drop table ${iol_schema}.icms_customer_rate_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_rate_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_rate_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
