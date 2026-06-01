/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_gwd
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
create table ${iol_schema}.isbs_gwd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_gwd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gwd_op purge;
drop table ${iol_schema}.isbs_gwd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gwd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gwd where 0=1;

create table ${iol_schema}.isbs_gwd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_gwd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gwd_cl(
            opndat -- 
            ,ver -- 
            ,credat -- 
            ,valdat -- 
            ,nam -- 
            ,inr -- 
            ,wrkgrp -- 
            ,rpflg -- 
            ,clsdat -- 
            ,checkflg -- 
            ,bustyp -- 
            ,rptyp -- 
            ,ownusr -- 
            ,cdflg -- 
            ,etyextkey -- 
            ,ownref -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gwd_op(
            opndat -- 
            ,ver -- 
            ,credat -- 
            ,valdat -- 
            ,nam -- 
            ,inr -- 
            ,wrkgrp -- 
            ,rpflg -- 
            ,clsdat -- 
            ,checkflg -- 
            ,bustyp -- 
            ,rptyp -- 
            ,ownusr -- 
            ,cdflg -- 
            ,etyextkey -- 
            ,ownref -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.valdat, o.valdat) as valdat -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.wrkgrp, o.wrkgrp) as wrkgrp -- 
    ,nvl(n.rpflg, o.rpflg) as rpflg -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.checkflg, o.checkflg) as checkflg -- 
    ,nvl(n.bustyp, o.bustyp) as bustyp -- 
    ,nvl(n.rptyp, o.rptyp) as rptyp -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.cdflg, o.cdflg) as cdflg -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
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
from (select * from ${iol_schema}.isbs_gwd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_gwd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.opndat <> n.opndat
        or o.ver <> n.ver
        or o.credat <> n.credat
        or o.valdat <> n.valdat
        or o.nam <> n.nam
        or o.wrkgrp <> n.wrkgrp
        or o.rpflg <> n.rpflg
        or o.clsdat <> n.clsdat
        or o.checkflg <> n.checkflg
        or o.bustyp <> n.bustyp
        or o.rptyp <> n.rptyp
        or o.ownusr <> n.ownusr
        or o.cdflg <> n.cdflg
        or o.etyextkey <> n.etyextkey
        or o.ownref <> n.ownref
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_gwd_cl(
            opndat -- 
            ,ver -- 
            ,credat -- 
            ,valdat -- 
            ,nam -- 
            ,inr -- 
            ,wrkgrp -- 
            ,rpflg -- 
            ,clsdat -- 
            ,checkflg -- 
            ,bustyp -- 
            ,rptyp -- 
            ,ownusr -- 
            ,cdflg -- 
            ,etyextkey -- 
            ,ownref -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_gwd_op(
            opndat -- 
            ,ver -- 
            ,credat -- 
            ,valdat -- 
            ,nam -- 
            ,inr -- 
            ,wrkgrp -- 
            ,rpflg -- 
            ,clsdat -- 
            ,checkflg -- 
            ,bustyp -- 
            ,rptyp -- 
            ,ownusr -- 
            ,cdflg -- 
            ,etyextkey -- 
            ,ownref -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.opndat -- 
    ,o.ver -- 
    ,o.credat -- 
    ,o.valdat -- 
    ,o.nam -- 
    ,o.inr -- 
    ,o.wrkgrp -- 
    ,o.rpflg -- 
    ,o.clsdat -- 
    ,o.checkflg -- 
    ,o.bustyp -- 
    ,o.rptyp -- 
    ,o.ownusr -- 
    ,o.cdflg -- 
    ,o.etyextkey -- 
    ,o.ownref -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_gwd_bk o
    left join ${iol_schema}.isbs_gwd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_gwd_cl d
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
-- truncate table ${iol_schema}.isbs_gwd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_gwd exchange partition p_19000101 with table ${iol_schema}.isbs_gwd_cl;
alter table ${iol_schema}.isbs_gwd exchange partition p_20991231 with table ${iol_schema}.isbs_gwd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_gwd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_gwd_op purge;
drop table ${iol_schema}.isbs_gwd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_gwd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_gwd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
