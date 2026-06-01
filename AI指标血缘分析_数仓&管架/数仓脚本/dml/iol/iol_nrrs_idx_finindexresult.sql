/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_idx_finindexresult
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
create table ${iol_schema}.nrrs_idx_finindexresult_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_idx_finindexresult
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_idx_finindexresult_op purge;
drop table ${iol_schema}.nrrs_idx_finindexresult_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_idx_finindexresult_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_idx_finindexresult where 0=1;

create table ${iol_schema}.nrrs_idx_finindexresult_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_idx_finindexresult where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_idx_finindexresult_cl(
            clientcode -- 客户编号
            ,regioncode -- 地区号
            ,reporttime -- 报表期数
            ,indexcode -- 指标编码
            ,indexresult -- 指标结果
            ,intime -- 录入时间
            ,indexname -- 指标名称
            ,reporttime_bj -- 比较期财务报表
            ,flag -- 计算方法标示
            ,indus_rank -- 行业排名
            ,indus_avg -- 指标行业均值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_idx_finindexresult_op(
            clientcode -- 客户编号
            ,regioncode -- 地区号
            ,reporttime -- 报表期数
            ,indexcode -- 指标编码
            ,indexresult -- 指标结果
            ,intime -- 录入时间
            ,indexname -- 指标名称
            ,reporttime_bj -- 比较期财务报表
            ,flag -- 计算方法标示
            ,indus_rank -- 行业排名
            ,indus_avg -- 指标行业均值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clientcode, o.clientcode) as clientcode -- 客户编号
    ,nvl(n.regioncode, o.regioncode) as regioncode -- 地区号
    ,nvl(n.reporttime, o.reporttime) as reporttime -- 报表期数
    ,nvl(n.indexcode, o.indexcode) as indexcode -- 指标编码
    ,nvl(n.indexresult, o.indexresult) as indexresult -- 指标结果
    ,nvl(n.intime, o.intime) as intime -- 录入时间
    ,nvl(n.indexname, o.indexname) as indexname -- 指标名称
    ,nvl(n.reporttime_bj, o.reporttime_bj) as reporttime_bj -- 比较期财务报表
    ,nvl(n.flag, o.flag) as flag -- 计算方法标示
    ,nvl(n.indus_rank, o.indus_rank) as indus_rank -- 行业排名
    ,nvl(n.indus_avg, o.indus_avg) as indus_avg -- 指标行业均值
    ,case when
            n.clientcode is null
            and n.reporttime is null
            and n.indexcode is null
            and n.flag is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clientcode is null
            and n.reporttime is null
            and n.indexcode is null
            and n.flag is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clientcode is null
            and n.reporttime is null
            and n.indexcode is null
            and n.flag is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_idx_finindexresult_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_idx_finindexresult where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clientcode = n.clientcode
            and o.reporttime = n.reporttime
            and o.indexcode = n.indexcode
            and o.flag = n.flag
where (
        o.clientcode is null
        and o.reporttime is null
        and o.indexcode is null
        and o.flag is null
    )
    or (
        n.clientcode is null
        and n.reporttime is null
        and n.indexcode is null
        and n.flag is null
    )
    or (
        o.regioncode <> n.regioncode
        or o.indexresult <> n.indexresult
        or o.intime <> n.intime
        or o.indexname <> n.indexname
        or o.reporttime_bj <> n.reporttime_bj
        or o.indus_rank <> n.indus_rank
        or o.indus_avg <> n.indus_avg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_idx_finindexresult_cl(
            clientcode -- 客户编号
            ,regioncode -- 地区号
            ,reporttime -- 报表期数
            ,indexcode -- 指标编码
            ,indexresult -- 指标结果
            ,intime -- 录入时间
            ,indexname -- 指标名称
            ,reporttime_bj -- 比较期财务报表
            ,flag -- 计算方法标示
            ,indus_rank -- 行业排名
            ,indus_avg -- 指标行业均值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_idx_finindexresult_op(
            clientcode -- 客户编号
            ,regioncode -- 地区号
            ,reporttime -- 报表期数
            ,indexcode -- 指标编码
            ,indexresult -- 指标结果
            ,intime -- 录入时间
            ,indexname -- 指标名称
            ,reporttime_bj -- 比较期财务报表
            ,flag -- 计算方法标示
            ,indus_rank -- 行业排名
            ,indus_avg -- 指标行业均值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clientcode -- 客户编号
    ,o.regioncode -- 地区号
    ,o.reporttime -- 报表期数
    ,o.indexcode -- 指标编码
    ,o.indexresult -- 指标结果
    ,o.intime -- 录入时间
    ,o.indexname -- 指标名称
    ,o.reporttime_bj -- 比较期财务报表
    ,o.flag -- 计算方法标示
    ,o.indus_rank -- 行业排名
    ,o.indus_avg -- 指标行业均值
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
from ${iol_schema}.nrrs_idx_finindexresult_bk o
    left join ${iol_schema}.nrrs_idx_finindexresult_op n
        on
            o.clientcode = n.clientcode
            and o.reporttime = n.reporttime
            and o.indexcode = n.indexcode
            and o.flag = n.flag
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_idx_finindexresult_cl d
        on
            o.clientcode = d.clientcode
            and o.reporttime = d.reporttime
            and o.indexcode = d.indexcode
            and o.flag = d.flag
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nrrs_idx_finindexresult;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nrrs_idx_finindexresult') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nrrs_idx_finindexresult drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nrrs_idx_finindexresult add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nrrs_idx_finindexresult exchange partition p_${batch_date} with table ${iol_schema}.nrrs_idx_finindexresult_cl;
alter table ${iol_schema}.nrrs_idx_finindexresult exchange partition p_20991231 with table ${iol_schema}.nrrs_idx_finindexresult_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_idx_finindexresult to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_idx_finindexresult_op purge;
drop table ${iol_schema}.nrrs_idx_finindexresult_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_idx_finindexresult_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_idx_finindexresult',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
