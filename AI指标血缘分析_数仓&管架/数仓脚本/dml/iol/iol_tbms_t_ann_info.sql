/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_t_ann_info
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
create table ${iol_schema}.tbms_t_ann_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_t_ann_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_ann_info_op purge;
drop table ${iol_schema}.tbms_t_ann_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_ann_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_ann_info where 0=1;

create table ${iol_schema}.tbms_t_ann_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_t_ann_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_ann_info_cl(
            annid -- 
            ,uaid -- 
            ,companyid -- 
            ,title -- 
            ,background -- 
            ,summary -- 
            ,content -- 
            ,anntype -- 
            ,publishdate -- 
            ,validbegindate -- 
            ,validenddate -- 
            ,versions -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,flowid -- 
            ,status -- 
            ,clientinfo -- 存储客户端信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_ann_info_op(
            annid -- 
            ,uaid -- 
            ,companyid -- 
            ,title -- 
            ,background -- 
            ,summary -- 
            ,content -- 
            ,anntype -- 
            ,publishdate -- 
            ,validbegindate -- 
            ,validenddate -- 
            ,versions -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,flowid -- 
            ,status -- 
            ,clientinfo -- 存储客户端信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.annid, o.annid) as annid -- 
    ,nvl(n.uaid, o.uaid) as uaid -- 
    ,nvl(n.companyid, o.companyid) as companyid -- 
    ,nvl(n.title, o.title) as title -- 
    ,nvl(n.background, o.background) as background -- 
    ,nvl(n.summary, o.summary) as summary -- 
    ,nvl(n.content, o.content) as content -- 
    ,nvl(n.anntype, o.anntype) as anntype -- 
    ,nvl(n.publishdate, o.publishdate) as publishdate -- 
    ,nvl(n.validbegindate, o.validbegindate) as validbegindate -- 
    ,nvl(n.validenddate, o.validenddate) as validenddate -- 
    ,nvl(n.versions, o.versions) as versions -- 
    ,nvl(n.sys_ctime, o.sys_ctime) as sys_ctime -- 
    ,nvl(n.sys_utime, o.sys_utime) as sys_utime -- 
    ,nvl(n.sys_valid, o.sys_valid) as sys_valid -- 
    ,nvl(n.flowid, o.flowid) as flowid -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.clientinfo, o.clientinfo) as clientinfo -- 存储客户端信息
    ,case when
            n.annid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.annid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.annid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_t_ann_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_t_ann_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.annid = n.annid
where (
        o.annid is null
    )
    or (
        n.annid is null
    )
    or (
        o.uaid <> n.uaid
        or o.companyid <> n.companyid
        or o.title <> n.title
        or o.background <> n.background
        or o.summary <> n.summary
        or o.content <> n.content
        or o.anntype <> n.anntype
        or o.publishdate <> n.publishdate
        or o.validbegindate <> n.validbegindate
        or o.validenddate <> n.validenddate
        or o.versions <> n.versions
        or o.sys_ctime <> n.sys_ctime
        or o.sys_utime <> n.sys_utime
        or o.sys_valid <> n.sys_valid
        or o.flowid <> n.flowid
        or o.status <> n.status
        or o.clientinfo <> n.clientinfo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_t_ann_info_cl(
            annid -- 
            ,uaid -- 
            ,companyid -- 
            ,title -- 
            ,background -- 
            ,summary -- 
            ,content -- 
            ,anntype -- 
            ,publishdate -- 
            ,validbegindate -- 
            ,validenddate -- 
            ,versions -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,flowid -- 
            ,status -- 
            ,clientinfo -- 存储客户端信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_t_ann_info_op(
            annid -- 
            ,uaid -- 
            ,companyid -- 
            ,title -- 
            ,background -- 
            ,summary -- 
            ,content -- 
            ,anntype -- 
            ,publishdate -- 
            ,validbegindate -- 
            ,validenddate -- 
            ,versions -- 
            ,sys_ctime -- 
            ,sys_utime -- 
            ,sys_valid -- 
            ,flowid -- 
            ,status -- 
            ,clientinfo -- 存储客户端信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.annid -- 
    ,o.uaid -- 
    ,o.companyid -- 
    ,o.title -- 
    ,o.background -- 
    ,o.summary -- 
    ,o.content -- 
    ,o.anntype -- 
    ,o.publishdate -- 
    ,o.validbegindate -- 
    ,o.validenddate -- 
    ,o.versions -- 
    ,o.sys_ctime -- 
    ,o.sys_utime -- 
    ,o.sys_valid -- 
    ,o.flowid -- 
    ,o.status -- 
    ,o.clientinfo -- 存储客户端信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_t_ann_info_bk o
    left join ${iol_schema}.tbms_t_ann_info_op n
        on
            o.annid = n.annid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_t_ann_info_cl d
        on
            o.annid = d.annid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_t_ann_info;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_t_ann_info exchange partition p_19000101 with table ${iol_schema}.tbms_t_ann_info_cl;
alter table ${iol_schema}.tbms_t_ann_info exchange partition p_20991231 with table ${iol_schema}.tbms_t_ann_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_t_ann_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_t_ann_info_op purge;
drop table ${iol_schema}.tbms_t_ann_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_t_ann_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_t_ann_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
