/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_conship
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
create table ${iol_schema}.mims_si_conship_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_conship;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_conship_op purge;
drop table ${iol_schema}.mims_si_conship_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_conship_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_conship where 0=1;

create table ${iol_schema}.mims_si_conship_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_conship where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_conship_cl(
            sccode -- 
            ,equipmentbrand -- 
            ,specificationno -- 
            ,shiptype -- 
            ,fullcapacity -- 
            ,netcapacity -- 
            ,predate -- 
            ,issign -- 
            ,contdate -- 
            ,contno -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_conship_op(
            sccode -- 
            ,equipmentbrand -- 
            ,specificationno -- 
            ,shiptype -- 
            ,fullcapacity -- 
            ,netcapacity -- 
            ,predate -- 
            ,issign -- 
            ,contdate -- 
            ,contno -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.equipmentbrand, o.equipmentbrand) as equipmentbrand -- 
    ,nvl(n.specificationno, o.specificationno) as specificationno -- 
    ,nvl(n.shiptype, o.shiptype) as shiptype -- 
    ,nvl(n.fullcapacity, o.fullcapacity) as fullcapacity -- 
    ,nvl(n.netcapacity, o.netcapacity) as netcapacity -- 
    ,nvl(n.predate, o.predate) as predate -- 
    ,nvl(n.issign, o.issign) as issign -- 
    ,nvl(n.contdate, o.contdate) as contdate -- 
    ,nvl(n.contno, o.contno) as contno -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,case when
            n.sccode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_conship_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_conship where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.equipmentbrand <> n.equipmentbrand
        or o.specificationno <> n.specificationno
        or o.shiptype <> n.shiptype
        or o.fullcapacity <> n.fullcapacity
        or o.netcapacity <> n.netcapacity
        or o.predate <> n.predate
        or o.issign <> n.issign
        or o.contdate <> n.contdate
        or o.contno <> n.contno
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_conship_cl(
            sccode -- 
            ,equipmentbrand -- 
            ,specificationno -- 
            ,shiptype -- 
            ,fullcapacity -- 
            ,netcapacity -- 
            ,predate -- 
            ,issign -- 
            ,contdate -- 
            ,contno -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_conship_op(
            sccode -- 
            ,equipmentbrand -- 
            ,specificationno -- 
            ,shiptype -- 
            ,fullcapacity -- 
            ,netcapacity -- 
            ,predate -- 
            ,issign -- 
            ,contdate -- 
            ,contno -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.equipmentbrand -- 
    ,o.specificationno -- 
    ,o.shiptype -- 
    ,o.fullcapacity -- 
    ,o.netcapacity -- 
    ,o.predate -- 
    ,o.issign -- 
    ,o.contdate -- 
    ,o.contno -- 
    ,o.remark -- 
    ,o.tdcurrency -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_conship_bk o
    left join ${iol_schema}.mims_si_conship_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_conship_cl d
        on
            o.sccode = d.sccode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_conship;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_conship exchange partition p_19000101 with table ${iol_schema}.mims_si_conship_cl;
alter table ${iol_schema}.mims_si_conship exchange partition p_20991231 with table ${iol_schema}.mims_si_conship_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_conship to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_conship_op purge;
drop table ${iol_schema}.mims_si_conship_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_conship_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_conship',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
