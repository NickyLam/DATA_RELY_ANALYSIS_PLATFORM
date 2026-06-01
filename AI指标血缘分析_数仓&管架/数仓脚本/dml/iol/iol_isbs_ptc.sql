/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ptc
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
create table ${iol_schema}.isbs_ptc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ptc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ptc_op purge;
drop table ${iol_schema}.isbs_ptc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ptc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ptc where 0=1;

create table ${iol_schema}.isbs_ptc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ptc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ptc_cl(
            telfax -- 
            ,gen -- 
            ,eml -- 
            ,legrep -- 
            ,etgextkey -- 
            ,telmob -- 
            ,ver -- 
            ,telfac -- 
            ,ptyinr -- 
            ,biddat -- 
            ,teloff -- 
            ,dep -- 
            ,ptainr -- 
            ,eno -- 
            ,inr -- 
            ,signup -- 
            ,nam -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ptc_op(
            telfax -- 
            ,gen -- 
            ,eml -- 
            ,legrep -- 
            ,etgextkey -- 
            ,telmob -- 
            ,ver -- 
            ,telfac -- 
            ,ptyinr -- 
            ,biddat -- 
            ,teloff -- 
            ,dep -- 
            ,ptainr -- 
            ,eno -- 
            ,inr -- 
            ,signup -- 
            ,nam -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.telfax, o.telfax) as telfax -- 
    ,nvl(n.gen, o.gen) as gen -- 
    ,nvl(n.eml, o.eml) as eml -- 
    ,nvl(n.legrep, o.legrep) as legrep -- 
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 
    ,nvl(n.telmob, o.telmob) as telmob -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.telfac, o.telfac) as telfac -- 
    ,nvl(n.ptyinr, o.ptyinr) as ptyinr -- 
    ,nvl(n.biddat, o.biddat) as biddat -- 
    ,nvl(n.teloff, o.teloff) as teloff -- 
    ,nvl(n.dep, o.dep) as dep -- 
    ,nvl(n.ptainr, o.ptainr) as ptainr -- 
    ,nvl(n.eno, o.eno) as eno -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.signup, o.signup) as signup -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_ptc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ptc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.telfax <> n.telfax
        or o.gen <> n.gen
        or o.eml <> n.eml
        or o.legrep <> n.legrep
        or o.etgextkey <> n.etgextkey
        or o.telmob <> n.telmob
        or o.ver <> n.ver
        or o.telfac <> n.telfac
        or o.ptyinr <> n.ptyinr
        or o.biddat <> n.biddat
        or o.teloff <> n.teloff
        or o.dep <> n.dep
        or o.ptainr <> n.ptainr
        or o.eno <> n.eno
        or o.signup <> n.signup
        or o.nam <> n.nam
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ptc_cl(
            telfax -- 
            ,gen -- 
            ,eml -- 
            ,legrep -- 
            ,etgextkey -- 
            ,telmob -- 
            ,ver -- 
            ,telfac -- 
            ,ptyinr -- 
            ,biddat -- 
            ,teloff -- 
            ,dep -- 
            ,ptainr -- 
            ,eno -- 
            ,inr -- 
            ,signup -- 
            ,nam -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ptc_op(
            telfax -- 
            ,gen -- 
            ,eml -- 
            ,legrep -- 
            ,etgextkey -- 
            ,telmob -- 
            ,ver -- 
            ,telfac -- 
            ,ptyinr -- 
            ,biddat -- 
            ,teloff -- 
            ,dep -- 
            ,ptainr -- 
            ,eno -- 
            ,inr -- 
            ,signup -- 
            ,nam -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.telfax -- 
    ,o.gen -- 
    ,o.eml -- 
    ,o.legrep -- 
    ,o.etgextkey -- 
    ,o.telmob -- 
    ,o.ver -- 
    ,o.telfac -- 
    ,o.ptyinr -- 
    ,o.biddat -- 
    ,o.teloff -- 
    ,o.dep -- 
    ,o.ptainr -- 
    ,o.eno -- 
    ,o.inr -- 
    ,o.signup -- 
    ,o.nam -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ptc_bk o
    left join ${iol_schema}.isbs_ptc_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ptc_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_ptc;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ptc exchange partition p_19000101 with table ${iol_schema}.isbs_ptc_cl;
alter table ${iol_schema}.isbs_ptc exchange partition p_20991231 with table ${iol_schema}.isbs_ptc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ptc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ptc_op purge;
drop table ${iol_schema}.isbs_ptc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ptc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ptc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
