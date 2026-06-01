/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ftd
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
create table ${iol_schema}.isbs_ftd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ftd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ftd_op purge;
drop table ${iol_schema}.isbs_ftd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ftd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ftd where 0=1;

create table ${iol_schema}.isbs_ftd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ftd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ftd_cl(
            nam -- 
            ,inr -- 
            ,ownref -- 
            ,valdat -- 
            ,rat -- 
            ,cnfdat -- 
            ,branchinr -- 
            ,ver -- 
            ,fttyp -- 
            ,zjtyp -- 
            ,zjtyp1 -- 
            ,cntfra -- 
            ,usr -- 
            ,ownusr -- 
            ,clsdat -- 
            ,bchkeyinr -- 
            ,matdat -- 
            ,opndat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ftd_op(
            nam -- 
            ,inr -- 
            ,ownref -- 
            ,valdat -- 
            ,rat -- 
            ,cnfdat -- 
            ,branchinr -- 
            ,ver -- 
            ,fttyp -- 
            ,zjtyp -- 
            ,zjtyp1 -- 
            ,cntfra -- 
            ,usr -- 
            ,ownusr -- 
            ,clsdat -- 
            ,bchkeyinr -- 
            ,matdat -- 
            ,opndat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.valdat, o.valdat) as valdat -- 
    ,nvl(n.rat, o.rat) as rat -- 
    ,nvl(n.cnfdat, o.cnfdat) as cnfdat -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.fttyp, o.fttyp) as fttyp -- 
    ,nvl(n.zjtyp, o.zjtyp) as zjtyp -- 
    ,nvl(n.zjtyp1, o.zjtyp1) as zjtyp1 -- 
    ,nvl(n.cntfra, o.cntfra) as cntfra -- 
    ,nvl(n.usr, o.usr) as usr -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
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
from (select * from ${iol_schema}.isbs_ftd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ftd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.nam <> n.nam
        or o.ownref <> n.ownref
        or o.valdat <> n.valdat
        or o.rat <> n.rat
        or o.cnfdat <> n.cnfdat
        or o.branchinr <> n.branchinr
        or o.ver <> n.ver
        or o.fttyp <> n.fttyp
        or o.zjtyp <> n.zjtyp
        or o.zjtyp1 <> n.zjtyp1
        or o.cntfra <> n.cntfra
        or o.usr <> n.usr
        or o.ownusr <> n.ownusr
        or o.clsdat <> n.clsdat
        or o.bchkeyinr <> n.bchkeyinr
        or o.matdat <> n.matdat
        or o.opndat <> n.opndat
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ftd_cl(
            nam -- 
            ,inr -- 
            ,ownref -- 
            ,valdat -- 
            ,rat -- 
            ,cnfdat -- 
            ,branchinr -- 
            ,ver -- 
            ,fttyp -- 
            ,zjtyp -- 
            ,zjtyp1 -- 
            ,cntfra -- 
            ,usr -- 
            ,ownusr -- 
            ,clsdat -- 
            ,bchkeyinr -- 
            ,matdat -- 
            ,opndat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ftd_op(
            nam -- 
            ,inr -- 
            ,ownref -- 
            ,valdat -- 
            ,rat -- 
            ,cnfdat -- 
            ,branchinr -- 
            ,ver -- 
            ,fttyp -- 
            ,zjtyp -- 
            ,zjtyp1 -- 
            ,cntfra -- 
            ,usr -- 
            ,ownusr -- 
            ,clsdat -- 
            ,bchkeyinr -- 
            ,matdat -- 
            ,opndat -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.nam -- 
    ,o.inr -- 
    ,o.ownref -- 
    ,o.valdat -- 
    ,o.rat -- 
    ,o.cnfdat -- 
    ,o.branchinr -- 
    ,o.ver -- 
    ,o.fttyp -- 
    ,o.zjtyp -- 
    ,o.zjtyp1 -- 
    ,o.cntfra -- 
    ,o.usr -- 
    ,o.ownusr -- 
    ,o.clsdat -- 
    ,o.bchkeyinr -- 
    ,o.matdat -- 
    ,o.opndat -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ftd_bk o
    left join ${iol_schema}.isbs_ftd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ftd_cl d
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
-- truncate table ${iol_schema}.isbs_ftd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ftd exchange partition p_19000101 with table ${iol_schema}.isbs_ftd_cl;
alter table ${iol_schema}.isbs_ftd exchange partition p_20991231 with table ${iol_schema}.isbs_ftd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ftd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ftd_op purge;
drop table ${iol_schema}.isbs_ftd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ftd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ftd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
