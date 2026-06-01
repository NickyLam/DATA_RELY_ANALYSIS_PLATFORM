/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondratingdefinition
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_cbondratingdefinition_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_cbondratingdefinition;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondratingdefinition_op purge;
drop table ${iol_schema}.wind_cbondratingdefinition_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondratingdefinition_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_cbondratingdefinition where 0=1;

create table ${iol_schema}.wind_cbondratingdefinition_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_cbondratingdefinition where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_cbondratingdefinition_op(
        object_id -- 对象ID
        ,b_info_creditratingagency -- 评估机构代码
        ,b_info_creditrating_name -- 评估机构名称
        ,s_info_compcode -- 公司ID
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.b_info_creditratingagency -- 评估机构代码
    ,n.b_info_creditrating_name -- 评估机构名称
    ,n.s_info_compcode -- 公司ID
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_cbondratingdefinition_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_cbondratingdefinition where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.b_info_creditratingagency = n.b_info_creditratingagency
            and o.s_info_compcode = n.s_info_compcode
where (
        o.b_info_creditratingagency is null
        and o.s_info_compcode is null
    )
    or (
        o.object_id <> n.object_id
        or o.b_info_creditrating_name <> n.b_info_creditrating_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbondratingdefinition_cl(
            object_id -- 对象ID
        ,b_info_creditratingagency -- 评估机构代码
        ,b_info_creditrating_name -- 评估机构名称
        ,s_info_compcode -- 公司ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbondratingdefinition_op(
            object_id -- 对象ID
        ,b_info_creditratingagency -- 评估机构代码
        ,b_info_creditrating_name -- 评估机构名称
        ,s_info_compcode -- 公司ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.b_info_creditratingagency -- 评估机构代码
    ,o.b_info_creditrating_name -- 评估机构名称
    ,o.s_info_compcode -- 公司ID
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_cbondratingdefinition_bk o
    left join ${iol_schema}.wind_cbondratingdefinition_op n
        on
            o.b_info_creditratingagency = n.b_info_creditratingagency
            and o.s_info_compcode = n.s_info_compcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_cbondratingdefinition;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_cbondratingdefinition exchange partition p_19000101 with table ${iol_schema}.wind_cbondratingdefinition_cl;
alter table ${iol_schema}.wind_cbondratingdefinition exchange partition p_20991231 with table ${iol_schema}.wind_cbondratingdefinition_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondratingdefinition to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondratingdefinition_op purge;
drop table ${iol_schema}.wind_cbondratingdefinition_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_cbondratingdefinition_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondratingdefinition',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
