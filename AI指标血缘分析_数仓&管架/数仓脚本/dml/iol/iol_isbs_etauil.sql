/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_etauil
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
create table ${iol_schema}.isbs_etauil_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_etauil;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_etauil_op purge;
drop table ${iol_schema}.isbs_etauil_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_etauil_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_etauil where 0=1;

create table ${iol_schema}.isbs_etauil_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_etauil where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_etauil_cl(
            etainr -- 
            ,letstr -- 
            ,tfsstr -- 
            ,letloc -- 
            ,tfsloc -- 
            ,tfsnam -- 
            ,letbox -- 
            ,fthdet -- 
            ,letzip -- 
            ,tfsbox -- 
            ,tfszip -- 
            ,pobzip -- 
            ,brdsup -- 
            ,vatnum -- 
            ,pobloc -- 
            ,regoff -- 
            ,uil -- 
            ,brddir -- 
            ,letnam -- 
            ,etgadr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_etauil_op(
            etainr -- 
            ,letstr -- 
            ,tfsstr -- 
            ,letloc -- 
            ,tfsloc -- 
            ,tfsnam -- 
            ,letbox -- 
            ,fthdet -- 
            ,letzip -- 
            ,tfsbox -- 
            ,tfszip -- 
            ,pobzip -- 
            ,brdsup -- 
            ,vatnum -- 
            ,pobloc -- 
            ,regoff -- 
            ,uil -- 
            ,brddir -- 
            ,letnam -- 
            ,etgadr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.etainr, o.etainr) as etainr -- 
    ,nvl(n.letstr, o.letstr) as letstr -- 
    ,nvl(n.tfsstr, o.tfsstr) as tfsstr -- 
    ,nvl(n.letloc, o.letloc) as letloc -- 
    ,nvl(n.tfsloc, o.tfsloc) as tfsloc -- 
    ,nvl(n.tfsnam, o.tfsnam) as tfsnam -- 
    ,nvl(n.letbox, o.letbox) as letbox -- 
    ,nvl(n.fthdet, o.fthdet) as fthdet -- 
    ,nvl(n.letzip, o.letzip) as letzip -- 
    ,nvl(n.tfsbox, o.tfsbox) as tfsbox -- 
    ,nvl(n.tfszip, o.tfszip) as tfszip -- 
    ,nvl(n.pobzip, o.pobzip) as pobzip -- 
    ,nvl(n.brdsup, o.brdsup) as brdsup -- 
    ,nvl(n.vatnum, o.vatnum) as vatnum -- 
    ,nvl(n.pobloc, o.pobloc) as pobloc -- 
    ,nvl(n.regoff, o.regoff) as regoff -- 
    ,nvl(n.uil, o.uil) as uil -- 
    ,nvl(n.brddir, o.brddir) as brddir -- 
    ,nvl(n.letnam, o.letnam) as letnam -- 
    ,nvl(n.etgadr, o.etgadr) as etgadr -- 
    ,case when
            n.etainr is null
            and n.uil is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.etainr is null
            and n.uil is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.etainr is null
            and n.uil is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_etauil_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_etauil where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.etainr = n.etainr
            and o.uil = n.uil
where (
        o.etainr is null
        and o.uil is null
    )
    or (
        n.etainr is null
        and n.uil is null
    )
    or (
        o.letstr <> n.letstr
        or o.tfsstr <> n.tfsstr
        or o.letloc <> n.letloc
        or o.tfsloc <> n.tfsloc
        or o.tfsnam <> n.tfsnam
        or o.letbox <> n.letbox
        or o.fthdet <> n.fthdet
        or o.letzip <> n.letzip
        or o.tfsbox <> n.tfsbox
        or o.tfszip <> n.tfszip
        or o.pobzip <> n.pobzip
        or o.brdsup <> n.brdsup
        or o.vatnum <> n.vatnum
        or o.pobloc <> n.pobloc
        or o.regoff <> n.regoff
        or o.brddir <> n.brddir
        or o.letnam <> n.letnam
        or o.etgadr <> n.etgadr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_etauil_cl(
            etainr -- 
            ,letstr -- 
            ,tfsstr -- 
            ,letloc -- 
            ,tfsloc -- 
            ,tfsnam -- 
            ,letbox -- 
            ,fthdet -- 
            ,letzip -- 
            ,tfsbox -- 
            ,tfszip -- 
            ,pobzip -- 
            ,brdsup -- 
            ,vatnum -- 
            ,pobloc -- 
            ,regoff -- 
            ,uil -- 
            ,brddir -- 
            ,letnam -- 
            ,etgadr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_etauil_op(
            etainr -- 
            ,letstr -- 
            ,tfsstr -- 
            ,letloc -- 
            ,tfsloc -- 
            ,tfsnam -- 
            ,letbox -- 
            ,fthdet -- 
            ,letzip -- 
            ,tfsbox -- 
            ,tfszip -- 
            ,pobzip -- 
            ,brdsup -- 
            ,vatnum -- 
            ,pobloc -- 
            ,regoff -- 
            ,uil -- 
            ,brddir -- 
            ,letnam -- 
            ,etgadr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.etainr -- 
    ,o.letstr -- 
    ,o.tfsstr -- 
    ,o.letloc -- 
    ,o.tfsloc -- 
    ,o.tfsnam -- 
    ,o.letbox -- 
    ,o.fthdet -- 
    ,o.letzip -- 
    ,o.tfsbox -- 
    ,o.tfszip -- 
    ,o.pobzip -- 
    ,o.brdsup -- 
    ,o.vatnum -- 
    ,o.pobloc -- 
    ,o.regoff -- 
    ,o.uil -- 
    ,o.brddir -- 
    ,o.letnam -- 
    ,o.etgadr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_etauil_bk o
    left join ${iol_schema}.isbs_etauil_op n
        on
            o.etainr = n.etainr
            and o.uil = n.uil
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_etauil_cl d
        on
            o.etainr = d.etainr
            and o.uil = d.uil
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_etauil;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_etauil exchange partition p_19000101 with table ${iol_schema}.isbs_etauil_cl;
alter table ${iol_schema}.isbs_etauil exchange partition p_20991231 with table ${iol_schema}.isbs_etauil_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_etauil to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_etauil_op purge;
drop table ${iol_schema}.isbs_etauil_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_etauil_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_etauil',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
