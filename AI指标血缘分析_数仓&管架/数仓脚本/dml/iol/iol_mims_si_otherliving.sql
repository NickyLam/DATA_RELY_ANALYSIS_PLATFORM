/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_otherliving
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
create table ${iol_schema}.mims_si_otherliving_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_otherliving
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_otherliving_op purge;
drop table ${iol_schema}.mims_si_otherliving_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_otherliving_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_otherliving where 0=1;

create table ${iol_schema}.mims_si_otherliving_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_otherliving where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_otherliving_cl(
            sccode -- 
            ,houseflag -- 
            ,preregistnos -- 
            ,preroyno -- 
            ,prevalidity -- 
            ,predeliver -- 
            ,isnewhouse -- 
            ,istwotogether -- 
            ,warrantsno -- 
            ,licenceno -- 
            ,istotal -- 
            ,otherremark -- 
            ,contno -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isapply -- 
            ,isonlyhouse -- 
            ,buildingarea -- 
            ,usearea -- 
            ,createyear -- 
            ,limitinfo -- 
            ,buildage -- 
            ,orientations -- 
            ,roomstructe -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,buildingno -- 
            ,address -- 
            ,buildingname -- 
            ,storeyno -- 
            ,totalstoreyno -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseryear -- 
            ,landusering -- 
            ,isotherright -- 
            ,remark -- 
            ,isrents -- 
            ,hpaddr -- 
            ,hiresdate -- 
            ,hireedate -- 
            ,hireremark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_otherliving_op(
            sccode -- 
            ,houseflag -- 
            ,preregistnos -- 
            ,preroyno -- 
            ,prevalidity -- 
            ,predeliver -- 
            ,isnewhouse -- 
            ,istwotogether -- 
            ,warrantsno -- 
            ,licenceno -- 
            ,istotal -- 
            ,otherremark -- 
            ,contno -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isapply -- 
            ,isonlyhouse -- 
            ,buildingarea -- 
            ,usearea -- 
            ,createyear -- 
            ,limitinfo -- 
            ,buildage -- 
            ,orientations -- 
            ,roomstructe -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,buildingno -- 
            ,address -- 
            ,buildingname -- 
            ,storeyno -- 
            ,totalstoreyno -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseryear -- 
            ,landusering -- 
            ,isotherright -- 
            ,remark -- 
            ,isrents -- 
            ,hpaddr -- 
            ,hiresdate -- 
            ,hireedate -- 
            ,hireremark -- 
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
    ,nvl(n.houseflag, o.houseflag) as houseflag -- 
    ,nvl(n.preregistnos, o.preregistnos) as preregistnos -- 
    ,nvl(n.preroyno, o.preroyno) as preroyno -- 
    ,nvl(n.prevalidity, o.prevalidity) as prevalidity -- 
    ,nvl(n.predeliver, o.predeliver) as predeliver -- 
    ,nvl(n.isnewhouse, o.isnewhouse) as isnewhouse -- 
    ,nvl(n.istwotogether, o.istwotogether) as istwotogether -- 
    ,nvl(n.warrantsno, o.warrantsno) as warrantsno -- 
    ,nvl(n.licenceno, o.licenceno) as licenceno -- 
    ,nvl(n.istotal, o.istotal) as istotal -- 
    ,nvl(n.otherremark, o.otherremark) as otherremark -- 
    ,nvl(n.contno, o.contno) as contno -- 
    ,nvl(n.tradedate, o.tradedate) as tradedate -- 
    ,nvl(n.tradeprice, o.tradeprice) as tradeprice -- 
    ,nvl(n.isapply, o.isapply) as isapply -- 
    ,nvl(n.isonlyhouse, o.isonlyhouse) as isonlyhouse -- 
    ,nvl(n.buildingarea, o.buildingarea) as buildingarea -- 
    ,nvl(n.usearea, o.usearea) as usearea -- 
    ,nvl(n.createyear, o.createyear) as createyear -- 
    ,nvl(n.limitinfo, o.limitinfo) as limitinfo -- 
    ,nvl(n.buildage, o.buildage) as buildage -- 
    ,nvl(n.orientations, o.orientations) as orientations -- 
    ,nvl(n.roomstructe, o.roomstructe) as roomstructe -- 
    ,nvl(n.province, o.province) as province -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.counties, o.counties) as counties -- 
    ,nvl(n.street, o.street) as street -- 
    ,nvl(n.roomno, o.roomno) as roomno -- 
    ,nvl(n.buildingno, o.buildingno) as buildingno -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.buildingname, o.buildingname) as buildingname -- 
    ,nvl(n.storeyno, o.storeyno) as storeyno -- 
    ,nvl(n.totalstoreyno, o.totalstoreyno) as totalstoreyno -- 
    ,nvl(n.landno, o.landno) as landno -- 
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 
    ,nvl(n.landuseryear, o.landuseryear) as landuseryear -- 
    ,nvl(n.landusering, o.landusering) as landusering -- 
    ,nvl(n.isotherright, o.isotherright) as isotherright -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.isrents, o.isrents) as isrents -- 
    ,nvl(n.hpaddr, o.hpaddr) as hpaddr -- 
    ,nvl(n.hiresdate, o.hiresdate) as hiresdate -- 
    ,nvl(n.hireedate, o.hireedate) as hireedate -- 
    ,nvl(n.hireremark, o.hireremark) as hireremark -- 
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
from (select * from ${iol_schema}.mims_si_otherliving_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_otherliving where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
where (
        o.sccode is null
    )
    or (
        n.sccode is null
    )
    or (
        o.houseflag <> n.houseflag
        or o.preregistnos <> n.preregistnos
        or o.preroyno <> n.preroyno
        or o.prevalidity <> n.prevalidity
        or o.predeliver <> n.predeliver
        or o.isnewhouse <> n.isnewhouse
        or o.istwotogether <> n.istwotogether
        or o.warrantsno <> n.warrantsno
        or o.licenceno <> n.licenceno
        or o.istotal <> n.istotal
        or o.otherremark <> n.otherremark
        or o.contno <> n.contno
        or o.tradedate <> n.tradedate
        or o.tradeprice <> n.tradeprice
        or o.isapply <> n.isapply
        or o.isonlyhouse <> n.isonlyhouse
        or o.buildingarea <> n.buildingarea
        or o.usearea <> n.usearea
        or o.createyear <> n.createyear
        or o.limitinfo <> n.limitinfo
        or o.buildage <> n.buildage
        or o.orientations <> n.orientations
        or o.roomstructe <> n.roomstructe
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.roomno <> n.roomno
        or o.buildingno <> n.buildingno
        or o.address <> n.address
        or o.buildingname <> n.buildingname
        or o.storeyno <> n.storeyno
        or o.totalstoreyno <> n.totalstoreyno
        or o.landno <> n.landno
        or o.landusenature <> n.landusenature
        or o.landgainway <> n.landgainway
        or o.landstartdate <> n.landstartdate
        or o.landenddate <> n.landenddate
        or o.landuseryear <> n.landuseryear
        or o.landusering <> n.landusering
        or o.isotherright <> n.isotherright
        or o.remark <> n.remark
        or o.isrents <> n.isrents
        or o.hpaddr <> n.hpaddr
        or o.hiresdate <> n.hiresdate
        or o.hireedate <> n.hireedate
        or o.hireremark <> n.hireremark
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
        into ${iol_schema}.mims_si_otherliving_cl(
            sccode -- 
            ,houseflag -- 
            ,preregistnos -- 
            ,preroyno -- 
            ,prevalidity -- 
            ,predeliver -- 
            ,isnewhouse -- 
            ,istwotogether -- 
            ,warrantsno -- 
            ,licenceno -- 
            ,istotal -- 
            ,otherremark -- 
            ,contno -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isapply -- 
            ,isonlyhouse -- 
            ,buildingarea -- 
            ,usearea -- 
            ,createyear -- 
            ,limitinfo -- 
            ,buildage -- 
            ,orientations -- 
            ,roomstructe -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,buildingno -- 
            ,address -- 
            ,buildingname -- 
            ,storeyno -- 
            ,totalstoreyno -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseryear -- 
            ,landusering -- 
            ,isotherright -- 
            ,remark -- 
            ,isrents -- 
            ,hpaddr -- 
            ,hiresdate -- 
            ,hireedate -- 
            ,hireremark -- 
            ,tdcurrency -- 
            ,yearlyrental -- 租赁年收入（元）
            ,iscompleted -- 房屋是否已竣工
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_otherliving_op(
            sccode -- 
            ,houseflag -- 
            ,preregistnos -- 
            ,preroyno -- 
            ,prevalidity -- 
            ,predeliver -- 
            ,isnewhouse -- 
            ,istwotogether -- 
            ,warrantsno -- 
            ,licenceno -- 
            ,istotal -- 
            ,otherremark -- 
            ,contno -- 
            ,tradedate -- 
            ,tradeprice -- 
            ,isapply -- 
            ,isonlyhouse -- 
            ,buildingarea -- 
            ,usearea -- 
            ,createyear -- 
            ,limitinfo -- 
            ,buildage -- 
            ,orientations -- 
            ,roomstructe -- 
            ,province -- 
            ,city -- 
            ,counties -- 
            ,street -- 
            ,roomno -- 
            ,buildingno -- 
            ,address -- 
            ,buildingname -- 
            ,storeyno -- 
            ,totalstoreyno -- 
            ,landno -- 
            ,landusenature -- 
            ,landgainway -- 
            ,landstartdate -- 
            ,landenddate -- 
            ,landuseryear -- 
            ,landusering -- 
            ,isotherright -- 
            ,remark -- 
            ,isrents -- 
            ,hpaddr -- 
            ,hiresdate -- 
            ,hireedate -- 
            ,hireremark -- 
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
    ,o.houseflag -- 
    ,o.preregistnos -- 
    ,o.preroyno -- 
    ,o.prevalidity -- 
    ,o.predeliver -- 
    ,o.isnewhouse -- 
    ,o.istwotogether -- 
    ,o.warrantsno -- 
    ,o.licenceno -- 
    ,o.istotal -- 
    ,o.otherremark -- 
    ,o.contno -- 
    ,o.tradedate -- 
    ,o.tradeprice -- 
    ,o.isapply -- 
    ,o.isonlyhouse -- 
    ,o.buildingarea -- 
    ,o.usearea -- 
    ,o.createyear -- 
    ,o.limitinfo -- 
    ,o.buildage -- 
    ,o.orientations -- 
    ,o.roomstructe -- 
    ,o.province -- 
    ,o.city -- 
    ,o.counties -- 
    ,o.street -- 
    ,o.roomno -- 
    ,o.buildingno -- 
    ,o.address -- 
    ,o.buildingname -- 
    ,o.storeyno -- 
    ,o.totalstoreyno -- 
    ,o.landno -- 
    ,o.landusenature -- 
    ,o.landgainway -- 
    ,o.landstartdate -- 
    ,o.landenddate -- 
    ,o.landuseryear -- 
    ,o.landusering -- 
    ,o.isotherright -- 
    ,o.remark -- 
    ,o.isrents -- 
    ,o.hpaddr -- 
    ,o.hiresdate -- 
    ,o.hireedate -- 
    ,o.hireremark -- 
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
from ${iol_schema}.mims_si_otherliving_bk o
    left join ${iol_schema}.mims_si_otherliving_op n
        on
            o.sccode = n.sccode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_otherliving_cl d
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
--truncate table ${iol_schema}.mims_si_otherliving;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_otherliving') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_otherliving drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_otherliving add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_otherliving exchange partition p_${batch_date} with table ${iol_schema}.mims_si_otherliving_cl;
alter table ${iol_schema}.mims_si_otherliving exchange partition p_20991231 with table ${iol_schema}.mims_si_otherliving_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_otherliving to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_otherliving_op purge;
drop table ${iol_schema}.mims_si_otherliving_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_otherliving_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_otherliving',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
