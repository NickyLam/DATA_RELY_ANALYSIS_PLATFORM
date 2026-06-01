/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_institution_rating_inner
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
create table ${iol_schema}.ibms_ttrd_institution_rating_inner_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_institution_rating_inner;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_rating_inner_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_rating_inner where 0=1;

create table ${iol_schema}.ibms_ttrd_institution_rating_inner_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_rating_inner where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_rating_inner_cl(
            i_id -- 机构ID
            ,i_name -- 公司名称
            ,grade -- 评级
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,imp_date -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_rating_inner_op(
            i_id -- 机构ID
            ,i_name -- 公司名称
            ,grade -- 评级
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,imp_date -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_id, o.i_id) as i_id -- 机构ID
    ,nvl(n.i_name, o.i_name) as i_name -- 公司名称
    ,nvl(n.grade, o.grade) as grade -- 评级
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 生效日期
    ,nvl(n.end_date, o.end_date) as end_date -- 失效日期
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入时间
    ,case when
            n.i_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_institution_rating_inner_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_institution_rating_inner where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_id = n.i_id
where (
        o.i_id is null
    )
    or (
        n.i_id is null
    )
    or (
        o.i_name <> n.i_name
        or o.grade <> n.grade
        or o.beg_date <> n.beg_date
        or o.end_date <> n.end_date
        or o.imp_date <> n.imp_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_rating_inner_cl(
            i_id -- 机构ID
            ,i_name -- 公司名称
            ,grade -- 评级
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,imp_date -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_rating_inner_op(
            i_id -- 机构ID
            ,i_name -- 公司名称
            ,grade -- 评级
            ,beg_date -- 生效日期
            ,end_date -- 失效日期
            ,imp_date -- 导入时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_id -- 机构ID
    ,o.i_name -- 公司名称
    ,o.grade -- 评级
    ,o.beg_date -- 生效日期
    ,o.end_date -- 失效日期
    ,o.imp_date -- 导入时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_institution_rating_inner_bk o
    left join ${iol_schema}.ibms_ttrd_institution_rating_inner_op n
        on
            o.i_id = n.i_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_institution_rating_inner_cl d
        on
            o.i_id = d.i_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_institution_rating_inner;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_institution_rating_inner exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_institution_rating_inner_cl;
alter table ${iol_schema}.ibms_ttrd_institution_rating_inner exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_institution_rating_inner_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_institution_rating_inner to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_institution_rating_inner_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_institution_rating_inner',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
