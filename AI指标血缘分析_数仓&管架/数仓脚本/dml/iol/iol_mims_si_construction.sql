/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_construction
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
create table ${iol_schema}.mims_si_construction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_construction
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_construction_op purge;
drop table ${iol_schema}.mims_si_construction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_construction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_construction where 0=1;

create table ${iol_schema}.mims_si_construction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_construction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_construction_cl(
            sccode -- 
            ,landuseno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseyear -- 
            ,landarea -- 
            ,landleasprice -- 
            ,landdelivery -- 
            ,transfermoney -- 
            ,landusering -- 
            ,projectname -- 
            ,landlicenceno -- 
            ,projectlicenceno -- 
            ,licenceno -- 
            ,startworkdate -- 
            ,prestartdate -- 
            ,pretotalprice -- 
            ,buildarea -- 
            ,buildnumber -- 
            ,isrent -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,address -- 
            ,remark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_construction_op(
            sccode -- 
            ,landuseno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseyear -- 
            ,landarea -- 
            ,landleasprice -- 
            ,landdelivery -- 
            ,transfermoney -- 
            ,landusering -- 
            ,projectname -- 
            ,landlicenceno -- 
            ,projectlicenceno -- 
            ,licenceno -- 
            ,startworkdate -- 
            ,prestartdate -- 
            ,pretotalprice -- 
            ,buildarea -- 
            ,buildnumber -- 
            ,isrent -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,address -- 
            ,remark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 
    ,nvl(n.landuseno, o.landuseno) as landuseno -- 
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 
    ,nvl(n.landuseyear, o.landuseyear) as landuseyear -- 
    ,nvl(n.landarea, o.landarea) as landarea -- 
    ,nvl(n.landleasprice, o.landleasprice) as landleasprice -- 
    ,nvl(n.landdelivery, o.landdelivery) as landdelivery -- 
    ,nvl(n.transfermoney, o.transfermoney) as transfermoney -- 
    ,nvl(n.landusering, o.landusering) as landusering -- 
    ,nvl(n.projectname, o.projectname) as projectname -- 
    ,nvl(n.landlicenceno, o.landlicenceno) as landlicenceno -- 
    ,nvl(n.projectlicenceno, o.projectlicenceno) as projectlicenceno -- 
    ,nvl(n.licenceno, o.licenceno) as licenceno -- 
    ,nvl(n.startworkdate, o.startworkdate) as startworkdate -- 
    ,nvl(n.prestartdate, o.prestartdate) as prestartdate -- 
    ,nvl(n.pretotalprice, o.pretotalprice) as pretotalprice -- 
    ,nvl(n.buildarea, o.buildarea) as buildarea -- 
    ,nvl(n.buildnumber, o.buildnumber) as buildnumber -- 
    ,nvl(n.isrent, o.isrent) as isrent -- 
    ,nvl(n.province, o.province) as province -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.counties, o.counties) as counties -- 
    ,nvl(n.street, o.street) as street -- 
    ,nvl(n.roomno, o.roomno) as roomno -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 
    ,nvl(n.yearlyrental, o.yearlyrental) as yearlyrental -- 租赁年收入（元）
    ,nvl(n.iscompleted, o.iscompleted) as iscompleted -- 房屋是否已竣工
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
from (select * from ${iol_schema}.mims_si_construction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_construction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.landuseno <> n.landuseno
        or o.landusenature <> n.landusenature
        or o.landgainway <> n.landgainway
        or o.landstartdate <> n.landstartdate
        or o.landenddate <> n.landenddate
        or o.landuseyear <> n.landuseyear
        or o.landarea <> n.landarea
        or o.landleasprice <> n.landleasprice
        or o.landdelivery <> n.landdelivery
        or o.transfermoney <> n.transfermoney
        or o.landusering <> n.landusering
        or o.projectname <> n.projectname
        or o.landlicenceno <> n.landlicenceno
        or o.projectlicenceno <> n.projectlicenceno
        or o.licenceno <> n.licenceno
        or o.startworkdate <> n.startworkdate
        or o.prestartdate <> n.prestartdate
        or o.pretotalprice <> n.pretotalprice
        or o.buildarea <> n.buildarea
        or o.buildnumber <> n.buildnumber
        or o.isrent <> n.isrent
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.roomno <> n.roomno
        or o.address <> n.address
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.yearlyrental <> n.yearlyrental
        or o.iscompleted <> n.iscompleted
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_construction_cl(
            sccode -- 
            ,landuseno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseyear -- 
            ,landarea -- 
            ,landleasprice -- 
            ,landdelivery -- 
            ,transfermoney -- 
            ,landusering -- 
            ,projectname -- 
            ,landlicenceno -- 
            ,projectlicenceno -- 
            ,licenceno -- 
            ,startworkdate -- 
            ,prestartdate -- 
            ,pretotalprice -- 
            ,buildarea -- 
            ,buildnumber -- 
            ,isrent -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,address -- 
            ,remark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_construction_op(
            sccode -- 
            ,landuseno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseyear -- 
            ,landarea -- 
            ,landleasprice -- 
            ,landdelivery -- 
            ,transfermoney -- 
            ,landusering -- 
            ,projectname -- 
            ,landlicenceno -- 
            ,projectlicenceno -- 
            ,licenceno -- 
            ,startworkdate -- 
            ,prestartdate -- 
            ,pretotalprice -- 
            ,buildarea -- 
            ,buildnumber -- 
            ,isrent -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,address -- 
            ,remark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 
    ,o.landuseno -- 
    ,o.landusenature -- 
    ,o.landgainway -- 
    ,o.landstartdate -- 
    ,o.landenddate -- 
    ,o.landuseyear -- 
    ,o.landarea -- 
    ,o.landleasprice -- 
    ,o.landdelivery -- 
    ,o.transfermoney -- 
    ,o.landusering -- 
    ,o.projectname -- 
    ,o.landlicenceno -- 
    ,o.projectlicenceno -- 
    ,o.licenceno -- 
    ,o.startworkdate -- 
    ,o.prestartdate -- 
    ,o.pretotalprice -- 
    ,o.buildarea -- 
    ,o.buildnumber -- 
    ,o.isrent -- 
    ,o.province -- 
    ,o.city -- 
    ,o.counties -- 
    ,o.street -- 
    ,o.roomno -- 
    ,o.address -- 
    ,o.remark -- 
    ,o.tdcurrency -- 
    ,o.yearlyrental -- 租赁年收入（元）
    ,o.iscompleted -- 房屋是否已竣工
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
from ${iol_schema}.mims_si_construction_bk o
    left join ${iol_schema}.mims_si_construction_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_construction_cl d
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
--truncate table ${iol_schema}.mims_si_construction;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_construction') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_construction drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_construction add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_construction exchange partition p_${batch_date} with table ${iol_schema}.mims_si_construction_cl;
alter table ${iol_schema}.mims_si_construction exchange partition p_20991231 with table ${iol_schema}.mims_si_construction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_construction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_construction_op purge;
drop table ${iol_schema}.mims_si_construction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_construction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_construction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
