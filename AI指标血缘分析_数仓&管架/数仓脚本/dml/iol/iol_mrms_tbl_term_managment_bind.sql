/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_term_managment_bind
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
create table ${iol_schema}.mrms_tbl_term_managment_bind_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_term_managment_bind;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_term_managment_bind_op purge;
drop table ${iol_schema}.mrms_tbl_term_managment_bind_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_term_managment_bind_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_term_managment_bind where 0=1;

create table ${iol_schema}.mrms_tbl_term_managment_bind_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_term_managment_bind where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_term_managment_bind_cl(
            term_id -- 
            ,term_id_id -- 
            ,pin_term -- 
            ,pad_id_id -- 
            ,pin_pad -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,crt_opr_id -- 
            ,upd_opr_id -- 
            ,reserved1 -- 
            ,reserved2 -- 
            ,pad_factory -- 
            ,pad_mach_tp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_term_managment_bind_op(
            term_id -- 
            ,term_id_id -- 
            ,pin_term -- 
            ,pad_id_id -- 
            ,pin_pad -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,crt_opr_id -- 
            ,upd_opr_id -- 
            ,reserved1 -- 
            ,reserved2 -- 
            ,pad_factory -- 
            ,pad_mach_tp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.term_id, o.term_id) as term_id -- 
    ,nvl(n.term_id_id, o.term_id_id) as term_id_id -- 
    ,nvl(n.pin_term, o.pin_term) as pin_term -- 
    ,nvl(n.pad_id_id, o.pad_id_id) as pad_id_id -- 
    ,nvl(n.pin_pad, o.pin_pad) as pin_pad -- 
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 
    ,nvl(n.crt_opr_id, o.crt_opr_id) as crt_opr_id -- 
    ,nvl(n.upd_opr_id, o.upd_opr_id) as upd_opr_id -- 
    ,nvl(n.reserved1, o.reserved1) as reserved1 -- 
    ,nvl(n.reserved2, o.reserved2) as reserved2 -- 
    ,nvl(n.pad_factory, o.pad_factory) as pad_factory -- 
    ,nvl(n.pad_mach_tp, o.pad_mach_tp) as pad_mach_tp -- 
    ,case when
            n.term_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.term_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.term_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_term_managment_bind_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_term_managment_bind where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.term_id = n.term_id
where (
        o.term_id is null
    )
    or (
        n.term_id is null
    )
    or (
        o.term_id_id <> n.term_id_id
        or o.pin_term <> n.pin_term
        or o.pad_id_id <> n.pad_id_id
        or o.pin_pad <> n.pin_pad
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.crt_opr_id <> n.crt_opr_id
        or o.upd_opr_id <> n.upd_opr_id
        or o.reserved1 <> n.reserved1
        or o.reserved2 <> n.reserved2
        or o.pad_factory <> n.pad_factory
        or o.pad_mach_tp <> n.pad_mach_tp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_term_managment_bind_cl(
            term_id -- 
            ,term_id_id -- 
            ,pin_term -- 
            ,pad_id_id -- 
            ,pin_pad -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,crt_opr_id -- 
            ,upd_opr_id -- 
            ,reserved1 -- 
            ,reserved2 -- 
            ,pad_factory -- 
            ,pad_mach_tp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_term_managment_bind_op(
            term_id -- 
            ,term_id_id -- 
            ,pin_term -- 
            ,pad_id_id -- 
            ,pin_pad -- 
            ,rec_crt_ts -- 
            ,rec_upd_ts -- 
            ,crt_opr_id -- 
            ,upd_opr_id -- 
            ,reserved1 -- 
            ,reserved2 -- 
            ,pad_factory -- 
            ,pad_mach_tp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.term_id -- 
    ,o.term_id_id -- 
    ,o.pin_term -- 
    ,o.pad_id_id -- 
    ,o.pin_pad -- 
    ,o.rec_crt_ts -- 
    ,o.rec_upd_ts -- 
    ,o.crt_opr_id -- 
    ,o.upd_opr_id -- 
    ,o.reserved1 -- 
    ,o.reserved2 -- 
    ,o.pad_factory -- 
    ,o.pad_mach_tp -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_term_managment_bind_bk o
    left join ${iol_schema}.mrms_tbl_term_managment_bind_op n
        on
            o.term_id = n.term_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_term_managment_bind_cl d
        on
            o.term_id = d.term_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mrms_tbl_term_managment_bind;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_term_managment_bind exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_term_managment_bind_cl;
alter table ${iol_schema}.mrms_tbl_term_managment_bind exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_term_managment_bind_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_term_managment_bind to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_term_managment_bind_op purge;
drop table ${iol_schema}.mrms_tbl_term_managment_bind_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_term_managment_bind_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_term_managment_bind',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
