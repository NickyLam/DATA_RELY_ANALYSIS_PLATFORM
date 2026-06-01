/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_applydtl
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
create table ${iol_schema}.bdps_applydtl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_applydtl;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_applydtl_op purge;
drop table ${iol_schema}.bdps_applydtl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_applydtl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_applydtl where 0=1;

create table ${iol_schema}.bdps_applydtl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_applydtl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_applydtl_cl(
            id -- 
            ,transno -- 
            ,appno -- 
            ,txdate -- 
            ,brhno -- 
            ,oprno -- 
            ,tlsrno -- 
            ,txtime -- 
            ,func_code -- 
            ,buss_type -- 
            ,attitude -- 
            ,role_id -- 
            ,role_type -- 
            ,reason -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,misc -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_applydtl_op(
            id -- 
            ,transno -- 
            ,appno -- 
            ,txdate -- 
            ,brhno -- 
            ,oprno -- 
            ,tlsrno -- 
            ,txtime -- 
            ,func_code -- 
            ,buss_type -- 
            ,attitude -- 
            ,role_id -- 
            ,role_type -- 
            ,reason -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,misc -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.transno, o.transno) as transno -- 
    ,nvl(n.appno, o.appno) as appno -- 
    ,nvl(n.txdate, o.txdate) as txdate -- 
    ,nvl(n.brhno, o.brhno) as brhno -- 
    ,nvl(n.oprno, o.oprno) as oprno -- 
    ,nvl(n.tlsrno, o.tlsrno) as tlsrno -- 
    ,nvl(n.txtime, o.txtime) as txtime -- 
    ,nvl(n.func_code, o.func_code) as func_code -- 
    ,nvl(n.buss_type, o.buss_type) as buss_type -- 
    ,nvl(n.attitude, o.attitude) as attitude -- 
    ,nvl(n.role_id, o.role_id) as role_id -- 
    ,nvl(n.role_type, o.role_type) as role_type -- 
    ,nvl(n.reason, o.reason) as reason -- 
    ,nvl(n.timestamps, o.timestamps) as timestamps -- 
    ,nvl(n.miscflgs, o.miscflgs) as miscflgs -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_applydtl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_applydtl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.transno <> n.transno
        or o.appno <> n.appno
        or o.txdate <> n.txdate
        or o.brhno <> n.brhno
        or o.oprno <> n.oprno
        or o.tlsrno <> n.tlsrno
        or o.txtime <> n.txtime
        or o.func_code <> n.func_code
        or o.buss_type <> n.buss_type
        or o.attitude <> n.attitude
        or o.role_id <> n.role_id
        or o.role_type <> n.role_type
        or o.reason <> n.reason
        or o.timestamps <> n.timestamps
        or o.miscflgs <> n.miscflgs
        or o.misc <> n.misc
        or o.last_upd_time <> n.last_upd_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_applydtl_cl(
            id -- 
            ,transno -- 
            ,appno -- 
            ,txdate -- 
            ,brhno -- 
            ,oprno -- 
            ,tlsrno -- 
            ,txtime -- 
            ,func_code -- 
            ,buss_type -- 
            ,attitude -- 
            ,role_id -- 
            ,role_type -- 
            ,reason -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,misc -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_applydtl_op(
            id -- 
            ,transno -- 
            ,appno -- 
            ,txdate -- 
            ,brhno -- 
            ,oprno -- 
            ,tlsrno -- 
            ,txtime -- 
            ,func_code -- 
            ,buss_type -- 
            ,attitude -- 
            ,role_id -- 
            ,role_type -- 
            ,reason -- 
            ,timestamps -- 
            ,miscflgs -- 
            ,misc -- 
            ,last_upd_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.transno -- 
    ,o.appno -- 
    ,o.txdate -- 
    ,o.brhno -- 
    ,o.oprno -- 
    ,o.tlsrno -- 
    ,o.txtime -- 
    ,o.func_code -- 
    ,o.buss_type -- 
    ,o.attitude -- 
    ,o.role_id -- 
    ,o.role_type -- 
    ,o.reason -- 
    ,o.timestamps -- 
    ,o.miscflgs -- 
    ,o.misc -- 
    ,o.last_upd_time -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_applydtl_bk o
    left join ${iol_schema}.bdps_applydtl_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_applydtl_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_applydtl;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_applydtl exchange partition p_19000101 with table ${iol_schema}.bdps_applydtl_cl;
alter table ${iol_schema}.bdps_applydtl exchange partition p_20991231 with table ${iol_schema}.bdps_applydtl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_applydtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_applydtl_op purge;
drop table ${iol_schema}.bdps_applydtl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_applydtl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_applydtl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
