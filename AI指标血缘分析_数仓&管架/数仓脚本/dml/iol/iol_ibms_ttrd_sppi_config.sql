/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_sppi_config
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
create table ${iol_schema}.ibms_ttrd_sppi_config_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_sppi_config;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_sppi_config_op purge;
drop table ${iol_schema}.ibms_ttrd_sppi_config_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_sppi_config_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_sppi_config where 0=1;

create table ${iol_schema}.ibms_ttrd_sppi_config_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_sppi_config where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_sppi_config_cl(
            tradeclass -- 业务模式
            ,tradeclassname -- 业务模式名称
            ,testresult -- 测试结果
            ,testresultname -- 测试结果名称
            ,i9class -- i9分类
            ,i9classname -- i9分类名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_sppi_config_op(
            tradeclass -- 业务模式
            ,tradeclassname -- 业务模式名称
            ,testresult -- 测试结果
            ,testresultname -- 测试结果名称
            ,i9class -- i9分类
            ,i9classname -- i9分类名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tradeclass, o.tradeclass) as tradeclass -- 业务模式
    ,nvl(n.tradeclassname, o.tradeclassname) as tradeclassname -- 业务模式名称
    ,nvl(n.testresult, o.testresult) as testresult -- 测试结果
    ,nvl(n.testresultname, o.testresultname) as testresultname -- 测试结果名称
    ,nvl(n.i9class, o.i9class) as i9class -- i9分类
    ,nvl(n.i9classname, o.i9classname) as i9classname -- i9分类名称
    ,case when
            n.tradeclass is null
            and n.testresult is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tradeclass is null
            and n.testresult is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tradeclass is null
            and n.testresult is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_sppi_config_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_sppi_config where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tradeclass = n.tradeclass
            and o.testresult = n.testresult
where (
        o.tradeclass is null
        and o.testresult is null
    )
    or (
        n.tradeclass is null
        and n.testresult is null
    )
    or (
        o.tradeclassname <> n.tradeclassname
        or o.testresultname <> n.testresultname
        or o.i9class <> n.i9class
        or o.i9classname <> n.i9classname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_sppi_config_cl(
            tradeclass -- 业务模式
            ,tradeclassname -- 业务模式名称
            ,testresult -- 测试结果
            ,testresultname -- 测试结果名称
            ,i9class -- i9分类
            ,i9classname -- i9分类名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_sppi_config_op(
            tradeclass -- 业务模式
            ,tradeclassname -- 业务模式名称
            ,testresult -- 测试结果
            ,testresultname -- 测试结果名称
            ,i9class -- i9分类
            ,i9classname -- i9分类名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tradeclass -- 业务模式
    ,o.tradeclassname -- 业务模式名称
    ,o.testresult -- 测试结果
    ,o.testresultname -- 测试结果名称
    ,o.i9class -- i9分类
    ,o.i9classname -- i9分类名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_sppi_config_bk o
    left join ${iol_schema}.ibms_ttrd_sppi_config_op n
        on
            o.tradeclass = n.tradeclass
            and o.testresult = n.testresult
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_sppi_config_cl d
        on
            o.tradeclass = d.tradeclass
            and o.testresult = d.testresult
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_sppi_config;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_sppi_config exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_sppi_config_cl;
alter table ${iol_schema}.ibms_ttrd_sppi_config exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_sppi_config_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_sppi_config to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_sppi_config_op purge;
drop table ${iol_schema}.ibms_ttrd_sppi_config_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_sppi_config_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_sppi_config',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
