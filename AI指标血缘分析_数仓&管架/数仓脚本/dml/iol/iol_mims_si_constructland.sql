/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_constructland
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
create table ${iol_schema}.mims_si_constructland_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_constructland;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_constructland_op purge;
drop table ${iol_schema}.mims_si_constructland_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_constructland_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_constructland where 0=1;

create table ${iol_schema}.mims_si_constructland_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_constructland where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_constructland_cl(
            sccode -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landusering -- 
            ,landusearea -- 
            ,landtype -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,address -- 
            ,landdec -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isattachments -- 
            ,attachmenttype -- 
            ,buildterm -- 
            ,attachmentowner -- 
            ,attachmentregion -- 
            ,overallfloorage -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_constructland_op(
            sccode -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landusering -- 
            ,landusearea -- 
            ,landtype -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,address -- 
            ,landdec -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isattachments -- 
            ,attachmenttype -- 
            ,buildterm -- 
            ,attachmentowner -- 
            ,attachmentregion -- 
            ,overallfloorage -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.landno, o.landno) as landno -- 
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 
    ,nvl(n.landusering, o.landusering) as landusering -- 
    ,nvl(n.landusearea, o.landusearea) as landusearea -- 
    ,nvl(n.landtype, o.landtype) as landtype -- 
    ,nvl(n.province, o.province) as province -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.counties, o.counties) as counties -- 
    ,nvl(n.street, o.street) as street -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.landdec, o.landdec) as landdec -- 
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 
    ,nvl(n.tradeprice, o.tradeprice) as tradeprice -- 
    ,nvl(n.isattachments, o.isattachments) as isattachments -- 
    ,nvl(n.attachmenttype, o.attachmenttype) as attachmenttype -- 
    ,nvl(n.buildterm, o.buildterm) as buildterm -- 
    ,nvl(n.attachmentowner, o.attachmentowner) as attachmentowner -- 
    ,nvl(n.attachmentregion, o.attachmentregion) as attachmentregion -- 
    ,nvl(n.overallfloorage, o.overallfloorage) as overallfloorage -- 
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
from (select * from ${iol_schema}.mims_si_constructland_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_constructland where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.landno <> n.landno
        or o.landusenature <> n.landusenature
        or o.landgainway <> n.landgainway
        or o.landstartdate <> n.landstartdate
        or o.landenddate <> n.landenddate
        or o.landusering <> n.landusering
        or o.landusearea <> n.landusearea
        or o.landtype <> n.landtype
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.address <> n.address
        or o.landdec <> n.landdec
        or o.tradedate <> n.tradedate
        or o.tradeprice <> n.tradeprice
        or o.isattachments <> n.isattachments
        or o.attachmenttype <> n.attachmenttype
        or o.buildterm <> n.buildterm
        or o.attachmentowner <> n.attachmentowner
        or o.attachmentregion <> n.attachmentregion
        or o.overallfloorage <> n.overallfloorage
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_constructland_cl(
            sccode -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landusering -- 
            ,landusearea -- 
            ,landtype -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,address -- 
            ,landdec -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isattachments -- 
            ,attachmenttype -- 
            ,buildterm -- 
            ,attachmentowner -- 
            ,attachmentregion -- 
            ,overallfloorage -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_constructland_op(
            sccode -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landusering -- 
            ,landusearea -- 
            ,landtype -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,address -- 
            ,landdec -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isattachments -- 
            ,attachmenttype -- 
            ,buildterm -- 
            ,attachmentowner -- 
            ,attachmentregion -- 
            ,overallfloorage -- 
            ,remark -- 
            ,tdcurrency -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.landno -- 
    ,o.landusenature -- 
    ,o.landgainway -- 
    ,o.landstartdate -- 
    ,o.landenddate -- 
    ,o.landusering -- 
    ,o.landusearea -- 
    ,o.landtype -- 
    ,o.province -- 
    ,o.city -- 
    ,o.counties -- 
    ,o.street -- 
    ,o.address -- 
    ,o.landdec -- 
    ,o.tradedate -- 
    ,o.tradeprice -- 
    ,o.isattachments -- 
    ,o.attachmenttype -- 
    ,o.buildterm -- 
    ,o.attachmentowner -- 
    ,o.attachmentregion -- 
    ,o.overallfloorage -- 
    ,o.remark -- 
    ,o.tdcurrency -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_constructland_bk o
    left join ${iol_schema}.mims_si_constructland_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_constructland_cl d
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
-- truncate table ${iol_schema}.mims_si_constructland;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_constructland exchange partition p_19000101 with table ${iol_schema}.mims_si_constructland_cl;
alter table ${iol_schema}.mims_si_constructland exchange partition p_20991231 with table ${iol_schema}.mims_si_constructland_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_constructland to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_constructland_op purge;
drop table ${iol_schema}.mims_si_constructland_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_constructland_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_constructland',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
