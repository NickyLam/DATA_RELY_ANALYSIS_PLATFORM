/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_other_equipment
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
create table ${iol_schema}.icms_clr_asset_other_equipment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_other_equipment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_equipment_op purge;
drop table ${iol_schema}.icms_clr_asset_other_equipment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_equipment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_equipment where 0=1;

create table ${iol_schema}.icms_clr_asset_other_equipment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_other_equipment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_equipment_cl(
            clrid -- 押品编号
            ,equipno -- 设备铭牌编号
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,equiptype -- 设备类型
            ,equipsort -- 设备分类
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,isqualify -- 是否有产品合格证
            ,invoiceno -- 发票编号
            ,invoicedate -- 发票日期
            ,invoicemoney -- 发票金额(元)
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_equipment_op(
            clrid -- 押品编号
            ,equipno -- 设备铭牌编号
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,equiptype -- 设备类型
            ,equipsort -- 设备分类
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,isqualify -- 是否有产品合格证
            ,invoiceno -- 发票编号
            ,invoicedate -- 发票日期
            ,invoicemoney -- 发票金额(元)
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.equipno, o.equipno) as equipno -- 设备铭牌编号
    ,nvl(n.isnewhouse, o.isnewhouse) as isnewhouse -- 一手/二手标识
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.equipmentbrand, o.equipmentbrand) as equipmentbrand -- 品牌/生产厂商
    ,nvl(n.specificationno, o.specificationno) as specificationno -- 型号/规格
    ,nvl(n.equiptype, o.equiptype) as equiptype -- 设备类型
    ,nvl(n.equipsort, o.equipsort) as equipsort -- 设备分类
    ,nvl(n.startdate, o.startdate) as startdate -- 出厂日期或报关日期
    ,nvl(n.enddate, o.enddate) as enddate -- 设计使用到期日期
    ,nvl(n.isqualify, o.isqualify) as isqualify -- 是否有产品合格证
    ,nvl(n.invoiceno, o.invoiceno) as invoiceno -- 发票编号
    ,nvl(n.invoicedate, o.invoicedate) as invoicedate -- 发票日期
    ,nvl(n.invoicemoney, o.invoicemoney) as invoicemoney -- 发票金额(元)
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.remark, o.remark) as remark -- 其他说明
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
from (select * from ${iol_schema}.icms_clr_asset_other_equipment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_other_equipment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.equipno <> n.equipno
        or o.isnewhouse <> n.isnewhouse
        or o.province <> n.province
        or o.city <> n.city
        or o.equipmentbrand <> n.equipmentbrand
        or o.specificationno <> n.specificationno
        or o.equiptype <> n.equiptype
        or o.equipsort <> n.equipsort
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.isqualify <> n.isqualify
        or o.invoiceno <> n.invoiceno
        or o.invoicedate <> n.invoicedate
        or o.invoicemoney <> n.invoicemoney
        or o.tdcurrency <> n.tdcurrency
        or o.remark <> n.remark
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_other_equipment_cl(
            clrid -- 押品编号
            ,equipno -- 设备铭牌编号
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,equiptype -- 设备类型
            ,equipsort -- 设备分类
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,isqualify -- 是否有产品合格证
            ,invoiceno -- 发票编号
            ,invoicedate -- 发票日期
            ,invoicemoney -- 发票金额(元)
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_other_equipment_op(
            clrid -- 押品编号
            ,equipno -- 设备铭牌编号
            ,isnewhouse -- 一手/二手标识
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,equipmentbrand -- 品牌/生产厂商
            ,specificationno -- 型号/规格
            ,equiptype -- 设备类型
            ,equipsort -- 设备分类
            ,startdate -- 出厂日期或报关日期
            ,enddate -- 设计使用到期日期
            ,isqualify -- 是否有产品合格证
            ,invoiceno -- 发票编号
            ,invoicedate -- 发票日期
            ,invoicemoney -- 发票金额(元)
            ,tdcurrency -- 币种
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.equipno -- 设备铭牌编号
    ,o.isnewhouse -- 一手/二手标识
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.equipmentbrand -- 品牌/生产厂商
    ,o.specificationno -- 型号/规格
    ,o.equiptype -- 设备类型
    ,o.equipsort -- 设备分类
    ,o.startdate -- 出厂日期或报关日期
    ,o.enddate -- 设计使用到期日期
    ,o.isqualify -- 是否有产品合格证
    ,o.invoiceno -- 发票编号
    ,o.invoicedate -- 发票日期
    ,o.invoicemoney -- 发票金额(元)
    ,o.tdcurrency -- 币种
    ,o.remark -- 其他说明
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
from ${iol_schema}.icms_clr_asset_other_equipment_bk o
    left join ${iol_schema}.icms_clr_asset_other_equipment_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_other_equipment_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_other_equipment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_other_equipment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_other_equipment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_other_equipment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_other_equipment exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_other_equipment_cl;
alter table ${iol_schema}.icms_clr_asset_other_equipment exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_other_equipment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_other_equipment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_other_equipment_op purge;
drop table ${iol_schema}.icms_clr_asset_other_equipment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_other_equipment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_other_equipment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
