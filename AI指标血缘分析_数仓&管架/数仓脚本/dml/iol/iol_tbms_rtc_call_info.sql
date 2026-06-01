/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbms_rtc_call_info
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
create table ${iol_schema}.tbms_rtc_call_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbms_rtc_call_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_rtc_call_info_op purge;
drop table ${iol_schema}.tbms_rtc_call_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_rtc_call_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_rtc_call_info where 0=1;

create table ${iol_schema}.tbms_rtc_call_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbms_rtc_call_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_rtc_call_info_cl(
            callid -- 
            ,callname -- 
            ,appid -- 
            ,calltype -- 
            ,caller -- 
            ,createtime -- 
            ,extrainfo -- 
            ,mediamode -- 
            ,chairman -- 
            ,status -- 
            ,version -- 
            ,starttime -- 
            ,finishtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_rtc_call_info_op(
            callid -- 
            ,callname -- 
            ,appid -- 
            ,calltype -- 
            ,caller -- 
            ,createtime -- 
            ,extrainfo -- 
            ,mediamode -- 
            ,chairman -- 
            ,status -- 
            ,version -- 
            ,starttime -- 
            ,finishtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.callid, o.callid) as callid -- 
    ,nvl(n.callname, o.callname) as callname -- 
    ,nvl(n.appid, o.appid) as appid -- 
    ,nvl(n.calltype, o.calltype) as calltype -- 
    ,nvl(n.caller, o.caller) as caller -- 
    ,nvl(n.createtime, o.createtime) as createtime -- 
    ,nvl(n.extrainfo, o.extrainfo) as extrainfo -- 
    ,nvl(n.mediamode, o.mediamode) as mediamode -- 
    ,nvl(n.chairman, o.chairman) as chairman -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.version, o.version) as version -- 
    ,nvl(n.starttime, o.starttime) as starttime -- 
    ,nvl(n.finishtime, o.finishtime) as finishtime -- 
    ,case when
            n.callid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.callid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.callid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbms_rtc_call_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbms_rtc_call_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.callid = n.callid
where (
        o.callid is null
    )
    or (
        n.callid is null
    )
    or (
        o.callname <> n.callname
        or o.appid <> n.appid
        or o.calltype <> n.calltype
        or o.caller <> n.caller
        or o.createtime <> n.createtime
        or o.extrainfo <> n.extrainfo
        or o.mediamode <> n.mediamode
        or o.chairman <> n.chairman
        or o.status <> n.status
        or o.version <> n.version
        or o.starttime <> n.starttime
        or o.finishtime <> n.finishtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbms_rtc_call_info_cl(
            callid -- 
            ,callname -- 
            ,appid -- 
            ,calltype -- 
            ,caller -- 
            ,createtime -- 
            ,extrainfo -- 
            ,mediamode -- 
            ,chairman -- 
            ,status -- 
            ,version -- 
            ,starttime -- 
            ,finishtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbms_rtc_call_info_op(
            callid -- 
            ,callname -- 
            ,appid -- 
            ,calltype -- 
            ,caller -- 
            ,createtime -- 
            ,extrainfo -- 
            ,mediamode -- 
            ,chairman -- 
            ,status -- 
            ,version -- 
            ,starttime -- 
            ,finishtime -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.callid -- 
    ,o.callname -- 
    ,o.appid -- 
    ,o.calltype -- 
    ,o.caller -- 
    ,o.createtime -- 
    ,o.extrainfo -- 
    ,o.mediamode -- 
    ,o.chairman -- 
    ,o.status -- 
    ,o.version -- 
    ,o.starttime -- 
    ,o.finishtime -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbms_rtc_call_info_bk o
    left join ${iol_schema}.tbms_rtc_call_info_op n
        on
            o.callid = n.callid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbms_rtc_call_info_cl d
        on
            o.callid = d.callid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbms_rtc_call_info;

-- 4.2 exchange partition
alter table ${iol_schema}.tbms_rtc_call_info exchange partition p_19000101 with table ${iol_schema}.tbms_rtc_call_info_cl;
alter table ${iol_schema}.tbms_rtc_call_info exchange partition p_20991231 with table ${iol_schema}.tbms_rtc_call_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbms_rtc_call_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbms_rtc_call_info_op purge;
drop table ${iol_schema}.tbms_rtc_call_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbms_rtc_call_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbms_rtc_call_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
