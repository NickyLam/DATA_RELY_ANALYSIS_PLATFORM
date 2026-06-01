/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_stresstestscencedetail
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
create table ${iol_schema}.mims_si_stresstestscencedetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_stresstestscencedetail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_stresstestscencedetail_op purge;
drop table ${iol_schema}.mims_si_stresstestscencedetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stresstestscencedetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_stresstestscencedetail where 0=1;

create table ${iol_schema}.mims_si_stresstestscencedetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_stresstestscencedetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_stresstestscencedetail_cl(
            scencecode -- 
            ,seqno -- 
            ,valuechangerange -- 
            ,guartype -- 
            ,deptcode -- 
            ,city -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_stresstestscencedetail_op(
            scencecode -- 
            ,seqno -- 
            ,valuechangerange -- 
            ,guartype -- 
            ,deptcode -- 
            ,city -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.scencecode, o.scencecode) as scencecode -- 
    ,nvl(n.seqno, o.seqno) as seqno -- 
    ,nvl(n.valuechangerange, o.valuechangerange) as valuechangerange -- 
    ,nvl(n.guartype, o.guartype) as guartype -- 
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 
    ,nvl(n.city, o.city) as city -- 
    ,case when
            n.scencecode is null
            and n.seqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.scencecode is null
            and n.seqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.scencecode is null
            and n.seqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_stresstestscencedetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_stresstestscencedetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.scencecode = n.scencecode
            and o.seqno = n.seqno
where (
        o.scencecode is null
        and o.seqno is null
    )
    or (
        n.scencecode is null
        and n.seqno is null
    )
    or (
        o.valuechangerange <> n.valuechangerange
        or o.guartype <> n.guartype
        or o.deptcode <> n.deptcode
        or o.city <> n.city
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_stresstestscencedetail_cl(
            scencecode -- 
            ,seqno -- 
            ,valuechangerange -- 
            ,guartype -- 
            ,deptcode -- 
            ,city -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_stresstestscencedetail_op(
            scencecode -- 
            ,seqno -- 
            ,valuechangerange -- 
            ,guartype -- 
            ,deptcode -- 
            ,city -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.scencecode -- 
    ,o.seqno -- 
    ,o.valuechangerange -- 
    ,o.guartype -- 
    ,o.deptcode -- 
    ,o.city -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_stresstestscencedetail_bk o
    left join ${iol_schema}.mims_si_stresstestscencedetail_op n
        on
            o.scencecode = n.scencecode
            and o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_stresstestscencedetail_cl d
        on
            o.scencecode = d.scencecode
            and o.seqno = d.seqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_stresstestscencedetail;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_stresstestscencedetail exchange partition p_19000101 with table ${iol_schema}.mims_si_stresstestscencedetail_cl;
alter table ${iol_schema}.mims_si_stresstestscencedetail exchange partition p_20991231 with table ${iol_schema}.mims_si_stresstestscencedetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_stresstestscencedetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_stresstestscencedetail_op purge;
drop table ${iol_schema}.mims_si_stresstestscencedetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_stresstestscencedetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_stresstestscencedetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
