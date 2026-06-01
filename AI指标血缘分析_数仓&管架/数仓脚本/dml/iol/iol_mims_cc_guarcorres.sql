/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_cc_guarcorres
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
create table ${iol_schema}.mims_cc_guarcorres_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_cc_guarcorres
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_guarcorres_op purge;
drop table ${iol_schema}.mims_cc_guarcorres_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_cc_guarcorres_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_guarcorres where 0=1;

create table ${iol_schema}.mims_cc_guarcorres_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_cc_guarcorres where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_guarcorres_cl(
            guarno -- 
            ,bussno -- 
            ,assconttype -- 
            ,period -- 
            ,useassamt -- 
            ,useasscurrency -- 
            ,state -- 
            ,state2 -- 
            ,guarrate -- 
            ,adguarrate -- 
            ,mainguartype -- 
            ,isimp -- 
            ,guarorder -- 
            ,guardate -- 
            ,guarvalue -- 
            ,datasourceflag -- 
            ,startdate -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_guarcorres_op(
            guarno -- 
            ,bussno -- 
            ,assconttype -- 
            ,period -- 
            ,useassamt -- 
            ,useasscurrency -- 
            ,state -- 
            ,state2 -- 
            ,guarrate -- 
            ,adguarrate -- 
            ,mainguartype -- 
            ,isimp -- 
            ,guarorder -- 
            ,guardate -- 
            ,guarvalue -- 
            ,datasourceflag -- 
            ,startdate -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.guarno, o.guarno) as guarno -- 
    ,nvl(n.bussno, o.bussno) as bussno -- 
    ,nvl(n.assconttype, o.assconttype) as assconttype -- 
    ,nvl(n.period, o.period) as period -- 
    ,nvl(n.useassamt, o.useassamt) as useassamt -- 
    ,nvl(n.useasscurrency, o.useasscurrency) as useasscurrency -- 
    ,nvl(n.state, o.state) as state -- 
    ,nvl(n.state2, o.state2) as state2 -- 
    ,nvl(n.guarrate, o.guarrate) as guarrate -- 
    ,nvl(n.adguarrate, o.adguarrate) as adguarrate -- 
    ,nvl(n.mainguartype, o.mainguartype) as mainguartype -- 
    ,nvl(n.isimp, o.isimp) as isimp -- 
    ,nvl(n.guarorder, o.guarorder) as guarorder -- 
    ,nvl(n.guardate, o.guardate) as guardate -- 
    ,nvl(n.guarvalue, o.guarvalue) as guarvalue -- 
    ,nvl(n.datasourceflag, o.datasourceflag) as datasourceflag -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.barsign, o.barsign) as barsign -- 
    ,case when
            n.guarno is null
            and n.bussno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.guarno is null
            and n.bussno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.guarno is null
            and n.bussno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_cc_guarcorres_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_cc_guarcorres where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.guarno = n.guarno
            and o.bussno = n.bussno
where (
        o.guarno is null
        and o.bussno is null
    )
    or (
        n.guarno is null
        and n.bussno is null
    )
    or (
        o.assconttype <> n.assconttype
        or o.period <> n.period
        or o.useassamt <> n.useassamt
        or o.useasscurrency <> n.useasscurrency
        or o.state <> n.state
        or o.state2 <> n.state2
        or o.guarrate <> n.guarrate
        or o.adguarrate <> n.adguarrate
        or o.mainguartype <> n.mainguartype
        or o.isimp <> n.isimp
        or o.guarorder <> n.guarorder
        or o.guardate <> n.guardate
        or o.guarvalue <> n.guarvalue
        or o.datasourceflag <> n.datasourceflag
        or o.startdate <> n.startdate
        or o.barsign <> n.barsign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_cc_guarcorres_cl(
            guarno -- 
            ,bussno -- 
            ,assconttype -- 
            ,period -- 
            ,useassamt -- 
            ,useasscurrency -- 
            ,state -- 
            ,state2 -- 
            ,guarrate -- 
            ,adguarrate -- 
            ,mainguartype -- 
            ,isimp -- 
            ,guarorder -- 
            ,guardate -- 
            ,guarvalue -- 
            ,datasourceflag -- 
            ,startdate -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_cc_guarcorres_op(
            guarno -- 
            ,bussno -- 
            ,assconttype -- 
            ,period -- 
            ,useassamt -- 
            ,useasscurrency -- 
            ,state -- 
            ,state2 -- 
            ,guarrate -- 
            ,adguarrate -- 
            ,mainguartype -- 
            ,isimp -- 
            ,guarorder -- 
            ,guardate -- 
            ,guarvalue -- 
            ,datasourceflag -- 
            ,startdate -- 
            ,barsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.guarno -- 
    ,o.bussno -- 
    ,o.assconttype -- 
    ,o.period -- 
    ,o.useassamt -- 
    ,o.useasscurrency -- 
    ,o.state -- 
    ,o.state2 -- 
    ,o.guarrate -- 
    ,o.adguarrate -- 
    ,o.mainguartype -- 
    ,o.isimp -- 
    ,o.guarorder -- 
    ,o.guardate -- 
    ,o.guarvalue -- 
    ,o.datasourceflag -- 
    ,o.startdate -- 
    ,o.barsign -- 
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
from ${iol_schema}.mims_cc_guarcorres_bk o
    left join ${iol_schema}.mims_cc_guarcorres_op n
        on
            o.guarno = n.guarno
            and o.bussno = n.bussno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_cc_guarcorres_cl d
        on
            o.guarno = d.guarno
            and o.bussno = d.bussno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_cc_guarcorres;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_cc_guarcorres') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_cc_guarcorres drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_cc_guarcorres add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_cc_guarcorres exchange partition p_${batch_date} with table ${iol_schema}.mims_cc_guarcorres_cl;
alter table ${iol_schema}.mims_cc_guarcorres exchange partition p_20991231 with table ${iol_schema}.mims_cc_guarcorres_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_cc_guarcorres to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_cc_guarcorres_op purge;
drop table ${iol_schema}.mims_cc_guarcorres_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_cc_guarcorres_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_cc_guarcorres',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
