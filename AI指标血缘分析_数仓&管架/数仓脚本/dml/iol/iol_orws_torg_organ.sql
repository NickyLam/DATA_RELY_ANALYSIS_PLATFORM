/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_torg_organ
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
create table ${iol_schema}.orws_torg_organ_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_torg_organ;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_torg_organ_op purge;
drop table ${iol_schema}.orws_torg_organ_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_torg_organ_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_torg_organ where 0=1;

create table ${iol_schema}.orws_torg_organ_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_torg_organ where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_torg_organ_cl(
            organid -- 
            ,ownerorganid -- 
            ,organcode -- 
            ,organnum -- 
            ,organname -- 
            ,invoicename -- 
            ,shortname -- 
            ,organtype -- 
            ,isbuildaccunt -- 
            ,address -- 
            ,builddate -- 
            ,invaliddate -- 
            ,corporation -- 
            ,master -- 
            ,postcode -- 
            ,linkphone -- 
            ,fax -- 
            ,email -- 
            ,taxno -- 
            ,personnelnum -- 
            ,isused -- 
            ,remark -- 
            ,ext1 -- 
            ,ext2 -- 
            ,ext3 -- 
            ,officedate -- 
            ,managermaster -- 
            ,mofficedate -- 
            ,status -- 
            ,source_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_torg_organ_op(
            organid -- 
            ,ownerorganid -- 
            ,organcode -- 
            ,organnum -- 
            ,organname -- 
            ,invoicename -- 
            ,shortname -- 
            ,organtype -- 
            ,isbuildaccunt -- 
            ,address -- 
            ,builddate -- 
            ,invaliddate -- 
            ,corporation -- 
            ,master -- 
            ,postcode -- 
            ,linkphone -- 
            ,fax -- 
            ,email -- 
            ,taxno -- 
            ,personnelnum -- 
            ,isused -- 
            ,remark -- 
            ,ext1 -- 
            ,ext2 -- 
            ,ext3 -- 
            ,officedate -- 
            ,managermaster -- 
            ,mofficedate -- 
            ,status -- 
            ,source_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.organid, o.organid) as organid -- 
    ,nvl(n.ownerorganid, o.ownerorganid) as ownerorganid -- 
    ,nvl(n.organcode, o.organcode) as organcode -- 
    ,nvl(n.organnum, o.organnum) as organnum -- 
    ,nvl(n.organname, o.organname) as organname -- 
    ,nvl(n.invoicename, o.invoicename) as invoicename -- 
    ,nvl(n.shortname, o.shortname) as shortname -- 
    ,nvl(n.organtype, o.organtype) as organtype -- 
    ,nvl(n.isbuildaccunt, o.isbuildaccunt) as isbuildaccunt -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.builddate, o.builddate) as builddate -- 
    ,nvl(n.invaliddate, o.invaliddate) as invaliddate -- 
    ,nvl(n.corporation, o.corporation) as corporation -- 
    ,nvl(n.master, o.master) as master -- 
    ,nvl(n.postcode, o.postcode) as postcode -- 
    ,nvl(n.linkphone, o.linkphone) as linkphone -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.taxno, o.taxno) as taxno -- 
    ,nvl(n.personnelnum, o.personnelnum) as personnelnum -- 
    ,nvl(n.isused, o.isused) as isused -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.ext1, o.ext1) as ext1 -- 
    ,nvl(n.ext2, o.ext2) as ext2 -- 
    ,nvl(n.ext3, o.ext3) as ext3 -- 
    ,nvl(n.officedate, o.officedate) as officedate -- 
    ,nvl(n.managermaster, o.managermaster) as managermaster -- 
    ,nvl(n.mofficedate, o.mofficedate) as mofficedate -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.source_type, o.source_type) as source_type -- 
    ,case when
            n.organid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.organid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.organid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orws_torg_organ_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_torg_organ where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.organid = n.organid
where (
        o.organid is null
    )
    or (
        n.organid is null
    )
    or (
        o.ownerorganid <> n.ownerorganid
        or o.organcode <> n.organcode
        or o.organnum <> n.organnum
        or o.organname <> n.organname
        or o.invoicename <> n.invoicename
        or o.shortname <> n.shortname
        or o.organtype <> n.organtype
        or o.isbuildaccunt <> n.isbuildaccunt
        or o.address <> n.address
        or o.builddate <> n.builddate
        or o.invaliddate <> n.invaliddate
        or o.corporation <> n.corporation
        or o.master <> n.master
        or o.postcode <> n.postcode
        or o.linkphone <> n.linkphone
        or o.fax <> n.fax
        or o.email <> n.email
        or o.taxno <> n.taxno
        or o.personnelnum <> n.personnelnum
        or o.isused <> n.isused
        or o.remark <> n.remark
        or o.ext1 <> n.ext1
        or o.ext2 <> n.ext2
        or o.ext3 <> n.ext3
        or o.officedate <> n.officedate
        or o.managermaster <> n.managermaster
        or o.mofficedate <> n.mofficedate
        or o.status <> n.status
        or o.source_type <> n.source_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_torg_organ_cl(
            organid -- 
            ,ownerorganid -- 
            ,organcode -- 
            ,organnum -- 
            ,organname -- 
            ,invoicename -- 
            ,shortname -- 
            ,organtype -- 
            ,isbuildaccunt -- 
            ,address -- 
            ,builddate -- 
            ,invaliddate -- 
            ,corporation -- 
            ,master -- 
            ,postcode -- 
            ,linkphone -- 
            ,fax -- 
            ,email -- 
            ,taxno -- 
            ,personnelnum -- 
            ,isused -- 
            ,remark -- 
            ,ext1 -- 
            ,ext2 -- 
            ,ext3 -- 
            ,officedate -- 
            ,managermaster -- 
            ,mofficedate -- 
            ,status -- 
            ,source_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_torg_organ_op(
            organid -- 
            ,ownerorganid -- 
            ,organcode -- 
            ,organnum -- 
            ,organname -- 
            ,invoicename -- 
            ,shortname -- 
            ,organtype -- 
            ,isbuildaccunt -- 
            ,address -- 
            ,builddate -- 
            ,invaliddate -- 
            ,corporation -- 
            ,master -- 
            ,postcode -- 
            ,linkphone -- 
            ,fax -- 
            ,email -- 
            ,taxno -- 
            ,personnelnum -- 
            ,isused -- 
            ,remark -- 
            ,ext1 -- 
            ,ext2 -- 
            ,ext3 -- 
            ,officedate -- 
            ,managermaster -- 
            ,mofficedate -- 
            ,status -- 
            ,source_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.organid -- 
    ,o.ownerorganid -- 
    ,o.organcode -- 
    ,o.organnum -- 
    ,o.organname -- 
    ,o.invoicename -- 
    ,o.shortname -- 
    ,o.organtype -- 
    ,o.isbuildaccunt -- 
    ,o.address -- 
    ,o.builddate -- 
    ,o.invaliddate -- 
    ,o.corporation -- 
    ,o.master -- 
    ,o.postcode -- 
    ,o.linkphone -- 
    ,o.fax -- 
    ,o.email -- 
    ,o.taxno -- 
    ,o.personnelnum -- 
    ,o.isused -- 
    ,o.remark -- 
    ,o.ext1 -- 
    ,o.ext2 -- 
    ,o.ext3 -- 
    ,o.officedate -- 
    ,o.managermaster -- 
    ,o.mofficedate -- 
    ,o.status -- 
    ,o.source_type -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orws_torg_organ_bk o
    left join ${iol_schema}.orws_torg_organ_op n
        on
            o.organid = n.organid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_torg_organ_cl d
        on
            o.organid = d.organid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.orws_torg_organ;

-- 4.2 exchange partition
alter table ${iol_schema}.orws_torg_organ exchange partition p_19000101 with table ${iol_schema}.orws_torg_organ_cl;
alter table ${iol_schema}.orws_torg_organ exchange partition p_20991231 with table ${iol_schema}.orws_torg_organ_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_torg_organ to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_torg_organ_op purge;
drop table ${iol_schema}.orws_torg_organ_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_torg_organ_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_torg_organ',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
