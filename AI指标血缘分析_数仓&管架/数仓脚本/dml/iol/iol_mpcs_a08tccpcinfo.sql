/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tccpcinfo
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
create table ${iol_schema}.mpcs_a08tccpcinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08tccpcinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tccpcinfo_op purge;
drop table ${iol_schema}.mpcs_a08tccpcinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tccpcinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tccpcinfo where 0=1;

create table ${iol_schema}.mpcs_a08tccpcinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tccpcinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tccpcinfo_cl(
            ccpccd -- 
            ,ccpcrunsts -- 
            ,ccpcnm -- 
            ,ccpctp -- 
            ,ccpccitycd -- 
            ,chngnb -- 
            ,syscd -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tccpcinfo_op(
            ccpccd -- 
            ,ccpcrunsts -- 
            ,ccpcnm -- 
            ,ccpctp -- 
            ,ccpccitycd -- 
            ,chngnb -- 
            ,syscd -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccpccd, o.ccpccd) as ccpccd -- 
    ,nvl(n.ccpcrunsts, o.ccpcrunsts) as ccpcrunsts -- 
    ,nvl(n.ccpcnm, o.ccpcnm) as ccpcnm -- 
    ,nvl(n.ccpctp, o.ccpctp) as ccpctp -- 
    ,nvl(n.ccpccitycd, o.ccpccitycd) as ccpccitycd -- 
    ,nvl(n.chngnb, o.chngnb) as chngnb -- 
    ,nvl(n.syscd, o.syscd) as syscd -- 
    ,case when
            n.ccpccd is null
            and n.syscd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ccpccd is null
            and n.syscd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ccpccd is null
            and n.syscd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08tccpcinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08tccpcinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ccpccd = n.ccpccd
            and o.syscd = n.syscd
where (
        o.ccpccd is null
        and o.syscd is null
    )
    or (
        n.ccpccd is null
        and n.syscd is null
    )
    or (
        o.ccpcrunsts <> n.ccpcrunsts
        or o.ccpcnm <> n.ccpcnm
        or o.ccpctp <> n.ccpctp
        or o.ccpccitycd <> n.ccpccitycd
        or o.chngnb <> n.chngnb
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tccpcinfo_cl(
            ccpccd -- 
            ,ccpcrunsts -- 
            ,ccpcnm -- 
            ,ccpctp -- 
            ,ccpccitycd -- 
            ,chngnb -- 
            ,syscd -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tccpcinfo_op(
            ccpccd -- 
            ,ccpcrunsts -- 
            ,ccpcnm -- 
            ,ccpctp -- 
            ,ccpccitycd -- 
            ,chngnb -- 
            ,syscd -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccpccd -- 
    ,o.ccpcrunsts -- 
    ,o.ccpcnm -- 
    ,o.ccpctp -- 
    ,o.ccpccitycd -- 
    ,o.chngnb -- 
    ,o.syscd -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a08tccpcinfo_bk o
    left join ${iol_schema}.mpcs_a08tccpcinfo_op n
        on
            o.ccpccd = n.ccpccd
            and o.syscd = n.syscd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08tccpcinfo_cl d
        on
            o.ccpccd = d.ccpccd
            and o.syscd = d.syscd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a08tccpcinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a08tccpcinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a08tccpcinfo_cl;
alter table ${iol_schema}.mpcs_a08tccpcinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a08tccpcinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tccpcinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tccpcinfo_op purge;
drop table ${iol_schema}.mpcs_a08tccpcinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08tccpcinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tccpcinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
