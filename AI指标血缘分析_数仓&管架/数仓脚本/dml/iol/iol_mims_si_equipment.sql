/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_equipment
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
create table ${iol_schema}.mims_si_equipment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_equipment;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_equipment_op purge;
drop table ${iol_schema}.mims_si_equipment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_equipment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_equipment where 0=1;

create table ${iol_schema}.mims_si_equipment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_equipment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_equipment_cl(
            sccode -- 
            ,equipno -- 
            ,isnewhouse -- 
            ,province -- 
            ,city -- 
            ,equiptype -- 
            ,equipsort -- 
            ,specificationno -- 
            ,equipmentbrand -- 
            ,startdate -- 
            ,enddate -- 
            ,isqualify -- 
            ,invoiceno -- 
            ,invoicedate -- 
            ,invoicemoney -- 
            ,tdcurrency -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_equipment_op(
            sccode -- 
            ,equipno -- 
            ,isnewhouse -- 
            ,province -- 
            ,city -- 
            ,equiptype -- 
            ,equipsort -- 
            ,specificationno -- 
            ,equipmentbrand -- 
            ,startdate -- 
            ,enddate -- 
            ,isqualify -- 
            ,invoiceno -- 
            ,invoicedate -- 
            ,invoicemoney -- 
            ,tdcurrency -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.equipno, o.equipno) as equipno -- 
    ,nvl(n.isnewhouse, o.isnewhouse) as isnewhouse -- 
    ,nvl(n.province, o.province) as province -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.equiptype, o.equiptype) as equiptype -- 
    ,nvl(n.equipsort, o.equipsort) as equipsort -- 
    ,nvl(n.specificationno, o.specificationno) as specificationno -- 
    ,nvl(n.equipmentbrand, o.equipmentbrand) as equipmentbrand -- 
    ,nvl(n.startdate, o.startdate) as startdate -- 
    ,nvl(n.enddate, o.enddate) as enddate -- 
    ,nvl(n.isqualify, o.isqualify) as isqualify -- 
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 
    ,nvl(n.invoicedate, o.invoicedate) as invoicedate -- 
    ,nvl(n.invoicemoney, o.invoicemoney) as invoicemoney -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,nvl(n.remark, o.remark) as remark -- 
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
from (select * from ${iol_schema}.mims_si_equipment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_equipment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.equipno <> n.equipno
        or o.isnewhouse <> n.isnewhouse
        or o.province <> n.province
        or o.city <> n.city
        or o.equiptype <> n.equiptype
        or o.equipsort <> n.equipsort
        or o.specificationno <> n.specificationno
        or o.equipmentbrand <> n.equipmentbrand
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.isqualify <> n.isqualify
        or o.invoiceno <> n.invoiceno
        or o.invoicedate <> n.invoicedate
        or o.invoicemoney <> n.invoicemoney
        or o.tdcurrency <> n.tdcurrency
        or o.remark <> n.remark
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_equipment_cl(
            sccode -- 
            ,equipno -- 
            ,isnewhouse -- 
            ,province -- 
            ,city -- 
            ,equiptype -- 
            ,equipsort -- 
            ,specificationno -- 
            ,equipmentbrand -- 
            ,startdate -- 
            ,enddate -- 
            ,isqualify -- 
            ,invoiceno -- 
            ,invoicedate -- 
            ,invoicemoney -- 
            ,tdcurrency -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_equipment_op(
            sccode -- 
            ,equipno -- 
            ,isnewhouse -- 
            ,province -- 
            ,city -- 
            ,equiptype -- 
            ,equipsort -- 
            ,specificationno -- 
            ,equipmentbrand -- 
            ,startdate -- 
            ,enddate -- 
            ,isqualify -- 
            ,invoiceno -- 
            ,invoicedate -- 
            ,invoicemoney -- 
            ,tdcurrency -- 
            ,remark -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.equipno -- 
    ,o.isnewhouse -- 
    ,o.province -- 
    ,o.city -- 
    ,o.equiptype -- 
    ,o.equipsort -- 
    ,o.specificationno -- 
    ,o.equipmentbrand -- 
    ,o.startdate -- 
    ,o.enddate -- 
    ,o.isqualify -- 
    ,o.invoiceno -- 
    ,o.invoicedate -- 
    ,o.invoicemoney -- 
    ,o.tdcurrency -- 
    ,o.remark -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_equipment_bk o
    left join ${iol_schema}.mims_si_equipment_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_equipment_cl d
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
-- truncate table ${iol_schema}.mims_si_equipment;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_equipment exchange partition p_19000101 with table ${iol_schema}.mims_si_equipment_cl;
alter table ${iol_schema}.mims_si_equipment exchange partition p_20991231 with table ${iol_schema}.mims_si_equipment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_equipment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_equipment_op purge;
drop table ${iol_schema}.mims_si_equipment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_equipment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_equipment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
