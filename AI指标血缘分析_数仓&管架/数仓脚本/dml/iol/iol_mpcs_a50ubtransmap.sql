/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ubtransmap
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
create table ${iol_schema}.mpcs_a50ubtransmap_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a50ubtransmap;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubtransmap_op purge;
drop table ${iol_schema}.mpcs_a50ubtransmap_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubtransmap_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubtransmap where 0=1;

create table ${iol_schema}.mpcs_a50ubtransmap_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubtransmap where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubtransmap_cl(
            paraid -- 
            ,msgtype -- 消息类型
            ,procecode -- 银联交易处理码
            ,exprocode -- 服务点条件码
            ,transcode -- 交易码
            ,transname -- 交易名称
            ,addrflag -- 
            ,revflag -- 
            ,timeout -- 超时时间
            ,resflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubtransmap_op(
            paraid -- 
            ,msgtype -- 消息类型
            ,procecode -- 银联交易处理码
            ,exprocode -- 服务点条件码
            ,transcode -- 交易码
            ,transname -- 交易名称
            ,addrflag -- 
            ,revflag -- 
            ,timeout -- 超时时间
            ,resflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.paraid, o.paraid) as paraid -- 
    ,nvl(n.msgtype, o.msgtype) as msgtype -- 消息类型
    ,nvl(n.procecode, o.procecode) as procecode -- 银联交易处理码
    ,nvl(n.exprocode, o.exprocode) as exprocode -- 服务点条件码
    ,nvl(n.transcode, o.transcode) as transcode -- 交易码
    ,nvl(n.transname, o.transname) as transname -- 交易名称
    ,nvl(n.addrflag, o.addrflag) as addrflag -- 
    ,nvl(n.revflag, o.revflag) as revflag -- 
    ,nvl(n.timeout, o.timeout) as timeout -- 超时时间
    ,nvl(n.resflag, o.resflag) as resflag -- 
    ,case when
            n.msgtype is null
            and n.procecode is null
            and n.exprocode is null
            and n.transcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.msgtype is null
            and n.procecode is null
            and n.exprocode is null
            and n.transcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.msgtype is null
            and n.procecode is null
            and n.exprocode is null
            and n.transcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a50ubtransmap_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a50ubtransmap where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.msgtype = n.msgtype
            and o.procecode = n.procecode
            and o.exprocode = n.exprocode
            and o.transcode = n.transcode
where (
        o.msgtype is null
        and o.procecode is null
        and o.exprocode is null
        and o.transcode is null
    )
    or (
        n.msgtype is null
        and n.procecode is null
        and n.exprocode is null
        and n.transcode is null
    )
    or (
        o.paraid <> n.paraid
        or o.transname <> n.transname
        or o.addrflag <> n.addrflag
        or o.revflag <> n.revflag
        or o.timeout <> n.timeout
        or o.resflag <> n.resflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a50ubtransmap_cl(
            paraid -- 
            ,msgtype -- 消息类型
            ,procecode -- 银联交易处理码
            ,exprocode -- 服务点条件码
            ,transcode -- 交易码
            ,transname -- 交易名称
            ,addrflag -- 
            ,revflag -- 
            ,timeout -- 超时时间
            ,resflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a50ubtransmap_op(
            paraid -- 
            ,msgtype -- 消息类型
            ,procecode -- 银联交易处理码
            ,exprocode -- 服务点条件码
            ,transcode -- 交易码
            ,transname -- 交易名称
            ,addrflag -- 
            ,revflag -- 
            ,timeout -- 超时时间
            ,resflag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.paraid -- 
    ,o.msgtype -- 消息类型
    ,o.procecode -- 银联交易处理码
    ,o.exprocode -- 服务点条件码
    ,o.transcode -- 交易码
    ,o.transname -- 交易名称
    ,o.addrflag -- 
    ,o.revflag -- 
    ,o.timeout -- 超时时间
    ,o.resflag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a50ubtransmap_bk o
    left join ${iol_schema}.mpcs_a50ubtransmap_op n
        on
            o.msgtype = n.msgtype
            and o.procecode = n.procecode
            and o.exprocode = n.exprocode
            and o.transcode = n.transcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a50ubtransmap_cl d
        on
            o.msgtype = d.msgtype
            and o.procecode = d.procecode
            and o.exprocode = d.exprocode
            and o.transcode = d.transcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a50ubtransmap;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a50ubtransmap exchange partition p_19000101 with table ${iol_schema}.mpcs_a50ubtransmap_cl;
alter table ${iol_schema}.mpcs_a50ubtransmap exchange partition p_20991231 with table ${iol_schema}.mpcs_a50ubtransmap_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ubtransmap to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a50ubtransmap_op purge;
drop table ${iol_schema}.mpcs_a50ubtransmap_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a50ubtransmap_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ubtransmap',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
