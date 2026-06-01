/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_other_motor
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
create table ${iol_schema}.icms_clr_asset_other_motor_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_other_motor
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_motor_op purge;
drop table ${iol_schema}.icms_clr_asset_other_motor_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_motor_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_motor where 0=1;

create table ${iol_schema}.icms_clr_asset_other_motor_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_motor where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_motor_cl(
            clrid -- 押品编号
            ,registno -- 机动车登记证书编号
            ,drivelicense -- 行驶证编号
            ,vehicleno -- 车架号
            ,engineno -- 发动机号
            ,plateno -- 牌照号码
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,capacity -- 排量（L）
            ,speedtype -- 变速类型
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,rangesum -- 行驶里程数(公里)
            ,invoiceno -- 发票编号
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vehiclesubtype -- 车辆细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_motor_op(
            clrid -- 押品编号
            ,registno -- 机动车登记证书编号
            ,drivelicense -- 行驶证编号
            ,vehicleno -- 车架号
            ,engineno -- 发动机号
            ,plateno -- 牌照号码
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,capacity -- 排量（L）
            ,speedtype -- 变速类型
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,rangesum -- 行驶里程数(公里)
            ,invoiceno -- 发票编号
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vehiclesubtype -- 车辆细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.registno, o.registno) as registno -- 机动车登记证书编号
    ,nvl(n.drivelicense, o.drivelicense) as drivelicense -- 行驶证编号
    ,nvl(n.vehicleno, o.vehicleno) as vehicleno -- 车架号
    ,nvl(n.engineno, o.engineno) as engineno -- 发动机号
    ,nvl(n.plateno, o.plateno) as plateno -- 牌照号码
    ,nvl(n.isnewhouse, o.isnewhouse) as isnewhouse -- 一手/二手标识
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.equipmentbrand, o.equipmentbrand) as equipmentbrand -- 品牌/生产厂商
    ,nvl(n.specificationno, o.specificationno) as specificationno -- 型号/规格
    ,nvl(n.capacity, o.capacity) as capacity -- 排量（L）
    ,nvl(n.speedtype, o.speedtype) as speedtype -- 变速类型
    ,nvl(n.startdate, o.startdate) as startdate -- 出厂日期或报关日期
    ,nvl(n.enddate, o.enddate) as enddate -- 设计使用到期日期
    ,nvl(n.rangesum, o.rangesum) as rangesum -- 行驶里程数(公里)
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 发票编号
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.vehiclesubtype, o.vehiclesubtype) as vehiclesubtype -- 车辆细类
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
from (select * from ${iol_schema}.icms_clr_asset_other_motor_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_other_motor where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.registno <> n.registno
        or o.drivelicense <> n.drivelicense
        or o.vehicleno <> n.vehicleno
        or o.engineno <> n.engineno
        or o.plateno <> n.plateno
        or o.isnewhouse <> n.isnewhouse
        or o.province <> n.province
        or o.city <> n.city
        or o.equipmentbrand <> n.equipmentbrand
        or o.specificationno <> n.specificationno
        or o.capacity <> n.capacity
        or o.speedtype <> n.speedtype
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.rangesum <> n.rangesum
        or o.invoiceno <> n.invoiceno
        or o.remark <> n.remark
        or o.migtflag <> n.migtflag
        or o.vehiclesubtype <> n.vehiclesubtype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_motor_cl(
            clrid -- 押品编号
            ,registno -- 机动车登记证书编号
            ,drivelicense -- 行驶证编号
            ,vehicleno -- 车架号
            ,engineno -- 发动机号
            ,plateno -- 牌照号码
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,capacity -- 排量（L）
            ,speedtype -- 变速类型
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,rangesum -- 行驶里程数(公里)
            ,invoiceno -- 发票编号
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vehiclesubtype -- 车辆细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_motor_op(
            clrid -- 押品编号
            ,registno -- 机动车登记证书编号
            ,drivelicense -- 行驶证编号
            ,vehicleno -- 车架号
            ,engineno -- 发动机号
            ,plateno -- 牌照号码
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,capacity -- 排量（L）
            ,speedtype -- 变速类型
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,rangesum -- 行驶里程数(公里)
            ,invoiceno -- 发票编号
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vehiclesubtype -- 车辆细类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.registno -- 机动车登记证书编号
    ,o.drivelicense -- 行驶证编号
    ,o.vehicleno -- 车架号
    ,o.engineno -- 发动机号
    ,o.plateno -- 牌照号码
    ,o.isnewhouse -- 一手/二手标识
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.equipmentbrand -- 品牌/生产厂商
    ,o.specificationno -- 型号/规格
    ,o.capacity -- 排量（L）
    ,o.speedtype -- 变速类型
    ,o.startdate -- 出厂日期或报关日期
    ,o.enddate -- 设计使用到期日期
    ,o.rangesum -- 行驶里程数(公里)
    ,o.invoiceno -- 发票编号
    ,o.remark -- 其他说明
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.vehiclesubtype -- 车辆细类
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
from ${iol_schema}.icms_clr_asset_other_motor_bk o
    left join ${iol_schema}.icms_clr_asset_other_motor_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_other_motor_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_other_motor;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_other_motor') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_other_motor drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_other_motor add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_other_motor exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_other_motor_cl;
alter table ${iol_schema}.icms_clr_asset_other_motor exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_other_motor_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_other_motor to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_motor_op purge;
drop table ${iol_schema}.icms_clr_asset_other_motor_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_other_motor_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_other_motor',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
