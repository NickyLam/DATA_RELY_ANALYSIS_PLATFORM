/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ats_login_control
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
create table ${iol_schema}.osbs_ats_login_control_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.osbs_ats_login_control
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_login_control_op purge;
drop table ${iol_schema}.osbs_ats_login_control_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_login_control_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_login_control where 0=1;

create table ${iol_schema}.osbs_ats_login_control_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_login_control where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_login_control_cl(
            alc_cstno -- 登录客户号
            ,alc_userno -- 登录用户号
            ,alc_sessionid -- 登录时记录下的sessionId
            ,alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
            ,alc_serveraddress -- 存储会话数据的服务器(ip:port)
            ,alc_clientip -- 客户登陆IP
            ,alc_channel -- 客户登录渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_login_control_op(
            alc_cstno -- 登录客户号
            ,alc_userno -- 登录用户号
            ,alc_sessionid -- 登录时记录下的sessionId
            ,alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
            ,alc_serveraddress -- 存储会话数据的服务器(ip:port)
            ,alc_clientip -- 客户登陆IP
            ,alc_channel -- 客户登录渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.alc_cstno, o.alc_cstno) as alc_cstno -- 登录客户号
    ,nvl(n.alc_userno, o.alc_userno) as alc_userno -- 登录用户号
    ,nvl(n.alc_sessionid, o.alc_sessionid) as alc_sessionid -- 登录时记录下的sessionId
    ,nvl(n.alc_create_time, o.alc_create_time) as alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
    ,nvl(n.alc_serveraddress, o.alc_serveraddress) as alc_serveraddress -- 存储会话数据的服务器(ip:port)
    ,nvl(n.alc_clientip, o.alc_clientip) as alc_clientip -- 客户登陆IP
    ,nvl(n.alc_channel, o.alc_channel) as alc_channel -- 客户登录渠道
    ,case when
            n.alc_cstno is null
            and n.alc_channel is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.alc_cstno is null
            and n.alc_channel is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.alc_cstno is null
            and n.alc_channel is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.osbs_ats_login_control_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.osbs_ats_login_control where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.alc_cstno = n.alc_cstno
            and o.alc_channel = n.alc_channel
where (
        o.alc_cstno is null
        and o.alc_channel is null
    )
    or (
        n.alc_cstno is null
        and n.alc_channel is null
    )
    or (
        o.alc_userno <> n.alc_userno
        or o.alc_sessionid <> n.alc_sessionid
        or o.alc_create_time <> n.alc_create_time
        or o.alc_serveraddress <> n.alc_serveraddress
        or o.alc_clientip <> n.alc_clientip
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.osbs_ats_login_control_cl(
            alc_cstno -- 登录客户号
            ,alc_userno -- 登录用户号
            ,alc_sessionid -- 登录时记录下的sessionId
            ,alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
            ,alc_serveraddress -- 存储会话数据的服务器(ip:port)
            ,alc_clientip -- 客户登陆IP
            ,alc_channel -- 客户登录渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.osbs_ats_login_control_op(
            alc_cstno -- 登录客户号
            ,alc_userno -- 登录用户号
            ,alc_sessionid -- 登录时记录下的sessionId
            ,alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
            ,alc_serveraddress -- 存储会话数据的服务器(ip:port)
            ,alc_clientip -- 客户登陆IP
            ,alc_channel -- 客户登录渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.alc_cstno -- 登录客户号
    ,o.alc_userno -- 登录用户号
    ,o.alc_sessionid -- 登录时记录下的sessionId
    ,o.alc_create_time -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
    ,o.alc_serveraddress -- 存储会话数据的服务器(ip:port)
    ,o.alc_clientip -- 客户登陆IP
    ,o.alc_channel -- 客户登录渠道
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
from ${iol_schema}.osbs_ats_login_control_bk o
    left join ${iol_schema}.osbs_ats_login_control_op n
        on
            o.alc_cstno = n.alc_cstno
            and o.alc_channel = n.alc_channel
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.osbs_ats_login_control_cl d
        on
            o.alc_cstno = d.alc_cstno
            and o.alc_channel = d.alc_channel
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.osbs_ats_login_control;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('osbs_ats_login_control') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.osbs_ats_login_control drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.osbs_ats_login_control add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.osbs_ats_login_control exchange partition p_${batch_date} with table ${iol_schema}.osbs_ats_login_control_cl;
alter table ${iol_schema}.osbs_ats_login_control exchange partition p_20991231 with table ${iol_schema}.osbs_ats_login_control_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ats_login_control to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.osbs_ats_login_control_op purge;
drop table ${iol_schema}.osbs_ats_login_control_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.osbs_ats_login_control_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ats_login_control',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
