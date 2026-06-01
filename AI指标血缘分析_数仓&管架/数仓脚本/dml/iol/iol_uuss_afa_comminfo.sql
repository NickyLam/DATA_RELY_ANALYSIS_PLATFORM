/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uuss_afa_comminfo
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
create table ${iol_schema}.uuss_afa_comminfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uuss_afa_comminfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_afa_comminfo_op purge;
drop table ${iol_schema}.uuss_afa_comminfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_afa_comminfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_afa_comminfo where 0=1;

create table ${iol_schema}.uuss_afa_comminfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uuss_afa_comminfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_afa_comminfo_cl(
            sendersysid -- 发起方系统标识
            ,recversysid -- 接收方系统标识
            ,itemname -- 通讯配置项名称
            ,serverip -- 服务器IP
            ,serverport -- 服务器端口
            ,conntimeout -- 连接超时
            ,transtimeout -- 传输超时
            ,encoding -- 编码
            ,remark -- 备注
            ,status -- 配置状态 0:正常 1:失效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_afa_comminfo_op(
            sendersysid -- 发起方系统标识
            ,recversysid -- 接收方系统标识
            ,itemname -- 通讯配置项名称
            ,serverip -- 服务器IP
            ,serverport -- 服务器端口
            ,conntimeout -- 连接超时
            ,transtimeout -- 传输超时
            ,encoding -- 编码
            ,remark -- 备注
            ,status -- 配置状态 0:正常 1:失效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sendersysid, o.sendersysid) as sendersysid -- 发起方系统标识
    ,nvl(n.recversysid, o.recversysid) as recversysid -- 接收方系统标识
    ,nvl(n.itemname, o.itemname) as itemname -- 通讯配置项名称
    ,nvl(n.serverip, o.serverip) as serverip -- 服务器IP
    ,nvl(n.serverport, o.serverport) as serverport -- 服务器端口
    ,nvl(n.conntimeout, o.conntimeout) as conntimeout -- 连接超时
    ,nvl(n.transtimeout, o.transtimeout) as transtimeout -- 传输超时
    ,nvl(n.encoding, o.encoding) as encoding -- 编码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.status, o.status) as status -- 配置状态 0:正常 1:失效
    ,case when
            n.sendersysid is null
            and n.recversysid is null
            and n.itemname is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sendersysid is null
            and n.recversysid is null
            and n.itemname is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sendersysid is null
            and n.recversysid is null
            and n.itemname is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uuss_afa_comminfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uuss_afa_comminfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sendersysid = n.sendersysid
            and o.recversysid = n.recversysid
            and o.itemname = n.itemname
where (
        o.sendersysid is null
        and o.recversysid is null
        and o.itemname is null
    )
    or (
        n.sendersysid is null
        and n.recversysid is null
        and n.itemname is null
    )
    or (
        o.serverip <> n.serverip
        or o.serverport <> n.serverport
        or o.conntimeout <> n.conntimeout
        or o.transtimeout <> n.transtimeout
        or o.encoding <> n.encoding
        or o.remark <> n.remark
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uuss_afa_comminfo_cl(
            sendersysid -- 发起方系统标识
            ,recversysid -- 接收方系统标识
            ,itemname -- 通讯配置项名称
            ,serverip -- 服务器IP
            ,serverport -- 服务器端口
            ,conntimeout -- 连接超时
            ,transtimeout -- 传输超时
            ,encoding -- 编码
            ,remark -- 备注
            ,status -- 配置状态 0:正常 1:失效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uuss_afa_comminfo_op(
            sendersysid -- 发起方系统标识
            ,recversysid -- 接收方系统标识
            ,itemname -- 通讯配置项名称
            ,serverip -- 服务器IP
            ,serverport -- 服务器端口
            ,conntimeout -- 连接超时
            ,transtimeout -- 传输超时
            ,encoding -- 编码
            ,remark -- 备注
            ,status -- 配置状态 0:正常 1:失效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sendersysid -- 发起方系统标识
    ,o.recversysid -- 接收方系统标识
    ,o.itemname -- 通讯配置项名称
    ,o.serverip -- 服务器IP
    ,o.serverport -- 服务器端口
    ,o.conntimeout -- 连接超时
    ,o.transtimeout -- 传输超时
    ,o.encoding -- 编码
    ,o.remark -- 备注
    ,o.status -- 配置状态 0:正常 1:失效
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.uuss_afa_comminfo_bk o
    left join ${iol_schema}.uuss_afa_comminfo_op n
        on
            o.sendersysid = n.sendersysid
            and o.recversysid = n.recversysid
            and o.itemname = n.itemname
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uuss_afa_comminfo_cl d
        on
            o.sendersysid = d.sendersysid
            and o.recversysid = d.recversysid
            and o.itemname = d.itemname
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.uuss_afa_comminfo;

-- 4.2 exchange partition
alter table ${iol_schema}.uuss_afa_comminfo exchange partition p_19000101 with table ${iol_schema}.uuss_afa_comminfo_cl;
alter table ${iol_schema}.uuss_afa_comminfo exchange partition p_20991231 with table ${iol_schema}.uuss_afa_comminfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uuss_afa_comminfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uuss_afa_comminfo_op purge;
drop table ${iol_schema}.uuss_afa_comminfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uuss_afa_comminfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uuss_afa_comminfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
