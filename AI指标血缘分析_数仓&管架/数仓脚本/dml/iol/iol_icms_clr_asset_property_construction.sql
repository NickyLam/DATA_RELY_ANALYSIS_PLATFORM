/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_property_construction
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
create table ${iol_schema}.icms_clr_asset_property_construction_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_property_construction
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_property_construction_op purge;
drop table ${iol_schema}.icms_clr_asset_property_construction_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_construction_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_property_construction where 0=1;

create table ${iol_schema}.icms_clr_asset_property_construction_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_property_construction where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_property_construction_cl(
            clrid -- 押品编号
            ,landuseno -- 土地证/不动产证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseyear -- 土地使用年限(年)
            ,landarea -- 土地面积
            ,landleasprice -- 土地出让价值(元)
            ,landdelivery -- 土地出让金交付情况
            ,transfermoney -- 应补出让金金额（元）
            ,landusering -- 土地用途
            ,projectname -- 工程项目名称
            ,landlicenceno -- 建设用地规划许可证号
            ,projectlicenceno -- 建设工程规划许可证号
            ,licenceno -- 施工许可证号
            ,startworkdate -- 开工日期
            ,prestartdate -- 预计竣工日期
            ,pretotalprice -- 工程预计总造价（元）
            ,buildarea -- 建筑面积（平方米）
            ,buildnumber -- 建筑层数
            ,isrents -- 是否租赁
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道（村镇）
            ,roomno -- 门牌号（弄号）
            ,address -- 详细地址
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,iscompleted -- 房屋是否已竣工
            ,yearlyrental -- 租赁年收入（元）
            ,buildingno -- 楼号室号(房号)
            ,predeliver -- 预计房屋交付时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_property_construction_op(
            clrid -- 押品编号
            ,landuseno -- 土地证/不动产证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseyear -- 土地使用年限(年)
            ,landarea -- 土地面积
            ,landleasprice -- 土地出让价值(元)
            ,landdelivery -- 土地出让金交付情况
            ,transfermoney -- 应补出让金金额（元）
            ,landusering -- 土地用途
            ,projectname -- 工程项目名称
            ,landlicenceno -- 建设用地规划许可证号
            ,projectlicenceno -- 建设工程规划许可证号
            ,licenceno -- 施工许可证号
            ,startworkdate -- 开工日期
            ,prestartdate -- 预计竣工日期
            ,pretotalprice -- 工程预计总造价（元）
            ,buildarea -- 建筑面积（平方米）
            ,buildnumber -- 建筑层数
            ,isrents -- 是否租赁
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道（村镇）
            ,roomno -- 门牌号（弄号）
            ,address -- 详细地址
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,iscompleted -- 房屋是否已竣工
            ,yearlyrental -- 租赁年收入（元）
            ,buildingno -- 楼号室号(房号)
            ,predeliver -- 预计房屋交付时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.landuseno, o.landuseno) as landuseno -- 土地证/不动产证号
    ,nvl(n.landusenature, o.landusenature) as landusenature -- 土地使用权性质
    ,nvl(n.landgainway, o.landgainway) as landgainway -- 土地使用权取得方式
    ,nvl(n.landstartdate, o.landstartdate) as landstartdate -- 土地使用权起始日期
    ,nvl(n.landenddate, o.landenddate) as landenddate -- 土地使用权到期日期
    ,nvl(n.landuseyear, o.landuseyear) as landuseyear -- 土地使用年限(年)
    ,nvl(n.landarea, o.landarea) as landarea -- 土地面积
    ,nvl(n.landleasprice, o.landleasprice) as landleasprice -- 土地出让价值(元)
    ,nvl(n.landdelivery, o.landdelivery) as landdelivery -- 土地出让金交付情况
    ,nvl(n.transfermoney, o.transfermoney) as transfermoney -- 应补出让金金额（元）
    ,nvl(n.landusering, o.landusering) as landusering -- 土地用途
    ,nvl(n.projectname, o.projectname) as projectname -- 工程项目名称
    ,nvl(n.landlicenceno, o.landlicenceno) as landlicenceno -- 建设用地规划许可证号
    ,nvl(n.projectlicenceno, o.projectlicenceno) as projectlicenceno -- 建设工程规划许可证号
    ,nvl(n.licenceno, o.licenceno) as licenceno -- 施工许可证号
    ,nvl(n.startworkdate, o.startworkdate) as startworkdate -- 开工日期
    ,nvl(n.prestartdate, o.prestartdate) as prestartdate -- 预计竣工日期
    ,nvl(n.pretotalprice, o.pretotalprice) as pretotalprice -- 工程预计总造价（元）
    ,nvl(n.buildarea, o.buildarea) as buildarea -- 建筑面积（平方米）
    ,nvl(n.buildnumber, o.buildnumber) as buildnumber -- 建筑层数
    ,nvl(n.isrents, o.isrents) as isrents -- 是否租赁
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.counties, o.counties) as counties -- 所在县（区）
    ,nvl(n.street, o.street) as street -- 街道（村镇）
    ,nvl(n.roomno, o.roomno) as roomno -- 门牌号（弄号）
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.iscompleted, o.iscompleted) as iscompleted -- 房屋是否已竣工
    ,nvl(n.yearlyrental, o.yearlyrental) as yearlyrental -- 租赁年收入（元）
    ,nvl(n.buildingno, o.buildingno) as buildingno -- 楼号室号(房号)
    ,nvl(n.predeliver, o.predeliver) as predeliver -- 预计房屋交付时间
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_property_construction_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_property_construction where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
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
        or o.isrents <> n.isrents
        or o.province <> n.province
        or o.city <> n.city
        or o.counties <> n.counties
        or o.street <> n.street
        or o.roomno <> n.roomno
        or o.address <> n.address
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.iscompleted <> n.iscompleted
        or o.yearlyrental <> n.yearlyrental
        or o.buildingno <> n.buildingno
        or o.predeliver <> n.predeliver
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_property_construction_cl(
            clrid -- 押品编号
            ,landuseno -- 土地证/不动产证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseyear -- 土地使用年限(年)
            ,landarea -- 土地面积
            ,landleasprice -- 土地出让价值(元)
            ,landdelivery -- 土地出让金交付情况
            ,transfermoney -- 应补出让金金额（元）
            ,landusering -- 土地用途
            ,projectname -- 工程项目名称
            ,landlicenceno -- 建设用地规划许可证号
            ,projectlicenceno -- 建设工程规划许可证号
            ,licenceno -- 施工许可证号
            ,startworkdate -- 开工日期
            ,prestartdate -- 预计竣工日期
            ,pretotalprice -- 工程预计总造价（元）
            ,buildarea -- 建筑面积（平方米）
            ,buildnumber -- 建筑层数
            ,isrents -- 是否租赁
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道（村镇）
            ,roomno -- 门牌号（弄号）
            ,address -- 详细地址
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,iscompleted -- 房屋是否已竣工
            ,yearlyrental -- 租赁年收入（元）
            ,buildingno -- 楼号室号(房号)
            ,predeliver -- 预计房屋交付时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_property_construction_op(
            clrid -- 押品编号
            ,landuseno -- 土地证/不动产证号
            ,landusenature -- 土地使用权性质
            ,landgainway -- 土地使用权取得方式
            ,landstartdate -- 土地使用权起始日期
            ,landenddate -- 土地使用权到期日期
            ,landuseyear -- 土地使用年限(年)
            ,landarea -- 土地面积
            ,landleasprice -- 土地出让价值(元)
            ,landdelivery -- 土地出让金交付情况
            ,transfermoney -- 应补出让金金额（元）
            ,landusering -- 土地用途
            ,projectname -- 工程项目名称
            ,landlicenceno -- 建设用地规划许可证号
            ,projectlicenceno -- 建设工程规划许可证号
            ,licenceno -- 施工许可证号
            ,startworkdate -- 开工日期
            ,prestartdate -- 预计竣工日期
            ,pretotalprice -- 工程预计总造价（元）
            ,buildarea -- 建筑面积（平方米）
            ,buildnumber -- 建筑层数
            ,isrents -- 是否租赁
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,counties -- 所在县（区）
            ,street -- 街道（村镇）
            ,roomno -- 门牌号（弄号）
            ,address -- 详细地址
            ,remark -- 其他说明
            ,tdcurrency -- 币种
            ,iscompleted -- 房屋是否已竣工
            ,yearlyrental -- 租赁年收入（元）
            ,buildingno -- 楼号室号(房号)
            ,predeliver -- 预计房屋交付时间
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.landuseno -- 土地证/不动产证号
    ,o.landusenature -- 土地使用权性质
    ,o.landgainway -- 土地使用权取得方式
    ,o.landstartdate -- 土地使用权起始日期
    ,o.landenddate -- 土地使用权到期日期
    ,o.landuseyear -- 土地使用年限(年)
    ,o.landarea -- 土地面积
    ,o.landleasprice -- 土地出让价值(元)
    ,o.landdelivery -- 土地出让金交付情况
    ,o.transfermoney -- 应补出让金金额（元）
    ,o.landusering -- 土地用途
    ,o.projectname -- 工程项目名称
    ,o.landlicenceno -- 建设用地规划许可证号
    ,o.projectlicenceno -- 建设工程规划许可证号
    ,o.licenceno -- 施工许可证号
    ,o.startworkdate -- 开工日期
    ,o.prestartdate -- 预计竣工日期
    ,o.pretotalprice -- 工程预计总造价（元）
    ,o.buildarea -- 建筑面积（平方米）
    ,o.buildnumber -- 建筑层数
    ,o.isrents -- 是否租赁
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.counties -- 所在县（区）
    ,o.street -- 街道（村镇）
    ,o.roomno -- 门牌号（弄号）
    ,o.address -- 详细地址
    ,o.remark -- 其他说明
    ,o.tdcurrency -- 币种
    ,o.iscompleted -- 房屋是否已竣工
    ,o.yearlyrental -- 租赁年收入（元）
    ,o.buildingno -- 楼号室号(房号)
    ,o.predeliver -- 预计房屋交付时间
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_asset_property_construction_bk o
    left join ${iol_schema}.icms_clr_asset_property_construction_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_property_construction_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_property_construction;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_property_construction') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_property_construction drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_property_construction add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_property_construction exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_property_construction_cl;
alter table ${iol_schema}.icms_clr_asset_property_construction exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_property_construction_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_property_construction to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_property_construction_op purge;
drop table ${iol_schema}.icms_clr_asset_property_construction_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_property_construction_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_property_construction',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
