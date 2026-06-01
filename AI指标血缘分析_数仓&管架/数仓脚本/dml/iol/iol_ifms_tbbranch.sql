/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbbranch
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
create table ${iol_schema}.ifms_tbbranch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbbranch;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbbranch_op purge;
drop table ${iol_schema}.ifms_tbbranch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbbranch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbbranch where 0=1;

create table ${iol_schema}.ifms_tbbranch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbbranch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbbranch_cl(
            internal_branch -- 
            ,branch_no -- 
            ,branch_name -- 
            ,short_name -- 
            ,up_branch -- 
            ,branch_level -- 
            ,branch_kind -- 
            ,branch_trans -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbbranch_op(
            internal_branch -- 
            ,branch_no -- 
            ,branch_name -- 
            ,short_name -- 
            ,up_branch -- 
            ,branch_level -- 
            ,branch_kind -- 
            ,branch_trans -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_branch, o.internal_branch) as internal_branch -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 
    ,nvl(n.short_name, o.short_name) as short_name -- 
    ,nvl(n.up_branch, o.up_branch) as up_branch -- 
    ,nvl(n.branch_level, o.branch_level) as branch_level -- 
    ,nvl(n.branch_kind, o.branch_kind) as branch_kind -- 
    ,nvl(n.branch_trans, o.branch_trans) as branch_trans -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,case when
            n.branch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbbranch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbbranch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch_no = n.branch_no
where (
        o.branch_no is null
    )
    or (
        n.branch_no is null
    )
    or (
        o.internal_branch <> n.internal_branch
        or o.branch_name <> n.branch_name
        or o.short_name <> n.short_name
        or o.up_branch <> n.up_branch
        or o.branch_level <> n.branch_level
        or o.branch_kind <> n.branch_kind
        or o.branch_trans <> n.branch_trans
        or o.reserve1 <> n.reserve1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbbranch_cl(
            internal_branch -- 
            ,branch_no -- 
            ,branch_name -- 
            ,short_name -- 
            ,up_branch -- 
            ,branch_level -- 
            ,branch_kind -- 
            ,branch_trans -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbbranch_op(
            internal_branch -- 
            ,branch_no -- 
            ,branch_name -- 
            ,short_name -- 
            ,up_branch -- 
            ,branch_level -- 
            ,branch_kind -- 
            ,branch_trans -- 
            ,reserve1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_branch -- 
    ,o.branch_no -- 
    ,o.branch_name -- 
    ,o.short_name -- 
    ,o.up_branch -- 
    ,o.branch_level -- 
    ,o.branch_kind -- 
    ,o.branch_trans -- 
    ,o.reserve1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbbranch_bk o
    left join ${iol_schema}.ifms_tbbranch_op n
        on
            o.branch_no = n.branch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbbranch_cl d
        on
            o.branch_no = d.branch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbbranch;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbbranch exchange partition p_19000101 with table ${iol_schema}.ifms_tbbranch_cl;
alter table ${iol_schema}.ifms_tbbranch exchange partition p_20991231 with table ${iol_schema}.ifms_tbbranch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbbranch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbbranch_op purge;
drop table ${iol_schema}.ifms_tbbranch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbbranch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbbranch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
