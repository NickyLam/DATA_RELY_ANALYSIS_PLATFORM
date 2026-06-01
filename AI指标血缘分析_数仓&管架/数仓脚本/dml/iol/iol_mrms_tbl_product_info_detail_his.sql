/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_product_info_detail_his
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
create table ${iol_schema}.mrms_tbl_product_info_detail_his_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_product_info_detail_his;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_product_info_detail_his_op purge;
drop table ${iol_schema}.mrms_tbl_product_info_detail_his_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_product_info_detail_his_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_product_info_detail_his where 0=1;

create table ${iol_schema}.mrms_tbl_product_info_detail_his_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_product_info_detail_his where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_product_info_detail_his_cl(
            id -- 主键ID
            ,product_no -- 商品编号
            ,product_nm -- 商品名称(例如京东、苏宁易购)
            ,product_brand -- 商品品牌
            ,supplier_nm -- 供应商名称
            ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
            ,product_serial_no -- 货品编号
            ,product_quality -- 产品成色
            ,percent_gold -- 产品规格-含金量(例如50g)
            ,percent_silver -- 产品规格-含银量(例如50g)
            ,product_material -- 产品材质(材质文字描述)
            ,product_technology -- 工艺
            ,weight_unit -- 重量单位(g/kg)
            ,weight -- 重量
            ,product_size -- 尺寸
            ,product_unit_price -- 产品单价
            ,product_num -- 产品数量
            ,product_charge -- 产品手续费规则(产品单位手续费)
            ,sale_limited_num -- 销售限制数量
            ,product_status -- 产品状态(0 在售 1 停售)
            ,onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
            ,offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_product_info_detail_his_op(
            id -- 主键ID
            ,product_no -- 商品编号
            ,product_nm -- 商品名称(例如京东、苏宁易购)
            ,product_brand -- 商品品牌
            ,supplier_nm -- 供应商名称
            ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
            ,product_serial_no -- 货品编号
            ,product_quality -- 产品成色
            ,percent_gold -- 产品规格-含金量(例如50g)
            ,percent_silver -- 产品规格-含银量(例如50g)
            ,product_material -- 产品材质(材质文字描述)
            ,product_technology -- 工艺
            ,weight_unit -- 重量单位(g/kg)
            ,weight -- 重量
            ,product_size -- 尺寸
            ,product_unit_price -- 产品单价
            ,product_num -- 产品数量
            ,product_charge -- 产品手续费规则(产品单位手续费)
            ,sale_limited_num -- 销售限制数量
            ,product_status -- 产品状态(0 在售 1 停售)
            ,onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
            ,offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键ID
    ,nvl(n.product_no, o.product_no) as product_no -- 商品编号
    ,nvl(n.product_nm, o.product_nm) as product_nm -- 商品名称(例如京东、苏宁易购)
    ,nvl(n.product_brand, o.product_brand) as product_brand -- 商品品牌
    ,nvl(n.supplier_nm, o.supplier_nm) as supplier_nm -- 供应商名称
    ,nvl(n.product_type, o.product_type) as product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
    ,nvl(n.product_sort, o.product_sort) as product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
    ,nvl(n.product_serial_no, o.product_serial_no) as product_serial_no -- 货品编号
    ,nvl(n.product_quality, o.product_quality) as product_quality -- 产品成色
    ,nvl(n.percent_gold, o.percent_gold) as percent_gold -- 产品规格-含金量(例如50g)
    ,nvl(n.percent_silver, o.percent_silver) as percent_silver -- 产品规格-含银量(例如50g)
    ,nvl(n.product_material, o.product_material) as product_material -- 产品材质(材质文字描述)
    ,nvl(n.product_technology, o.product_technology) as product_technology -- 工艺
    ,nvl(n.weight_unit, o.weight_unit) as weight_unit -- 重量单位(g/kg)
    ,nvl(n.weight, o.weight) as weight -- 重量
    ,nvl(n.product_size, o.product_size) as product_size -- 尺寸
    ,nvl(n.product_unit_price, o.product_unit_price) as product_unit_price -- 产品单价
    ,nvl(n.product_num, o.product_num) as product_num -- 产品数量
    ,nvl(n.product_charge, o.product_charge) as product_charge -- 产品手续费规则(产品单位手续费)
    ,nvl(n.sale_limited_num, o.sale_limited_num) as sale_limited_num -- 销售限制数量
    ,nvl(n.product_status, o.product_status) as product_status -- 产品状态(0 在售 1 停售)
    ,nvl(n.onsale_time, o.onsale_time) as onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
    ,nvl(n.offshelves_time, o.offshelves_time) as offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.adddata1, o.adddata1) as adddata1 -- 附加数据1
    ,nvl(n.adddata2, o.adddata2) as adddata2 -- 附加数据2
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_product_info_detail_his_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_product_info_detail_his where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_no <> n.product_no
        or o.product_nm <> n.product_nm
        or o.product_brand <> n.product_brand
        or o.supplier_nm <> n.supplier_nm
        or o.product_type <> n.product_type
        or o.product_sort <> n.product_sort
        or o.product_serial_no <> n.product_serial_no
        or o.product_quality <> n.product_quality
        or o.percent_gold <> n.percent_gold
        or o.percent_silver <> n.percent_silver
        or o.product_material <> n.product_material
        or o.product_technology <> n.product_technology
        or o.weight_unit <> n.weight_unit
        or o.weight <> n.weight
        or o.product_size <> n.product_size
        or o.product_unit_price <> n.product_unit_price
        or o.product_num <> n.product_num
        or o.product_charge <> n.product_charge
        or o.sale_limited_num <> n.sale_limited_num
        or o.product_status <> n.product_status
        or o.onsale_time <> n.onsale_time
        or o.offshelves_time <> n.offshelves_time
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.adddata1 <> n.adddata1
        or o.adddata2 <> n.adddata2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_product_info_detail_his_cl(
            id -- 主键ID
            ,product_no -- 商品编号
            ,product_nm -- 商品名称(例如京东、苏宁易购)
            ,product_brand -- 商品品牌
            ,supplier_nm -- 供应商名称
            ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
            ,product_serial_no -- 货品编号
            ,product_quality -- 产品成色
            ,percent_gold -- 产品规格-含金量(例如50g)
            ,percent_silver -- 产品规格-含银量(例如50g)
            ,product_material -- 产品材质(材质文字描述)
            ,product_technology -- 工艺
            ,weight_unit -- 重量单位(g/kg)
            ,weight -- 重量
            ,product_size -- 尺寸
            ,product_unit_price -- 产品单价
            ,product_num -- 产品数量
            ,product_charge -- 产品手续费规则(产品单位手续费)
            ,sale_limited_num -- 销售限制数量
            ,product_status -- 产品状态(0 在售 1 停售)
            ,onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
            ,offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_product_info_detail_his_op(
            id -- 主键ID
            ,product_no -- 商品编号
            ,product_nm -- 商品名称(例如京东、苏宁易购)
            ,product_brand -- 商品品牌
            ,supplier_nm -- 供应商名称
            ,product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
            ,product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
            ,product_serial_no -- 货品编号
            ,product_quality -- 产品成色
            ,percent_gold -- 产品规格-含金量(例如50g)
            ,percent_silver -- 产品规格-含银量(例如50g)
            ,product_material -- 产品材质(材质文字描述)
            ,product_technology -- 工艺
            ,weight_unit -- 重量单位(g/kg)
            ,weight -- 重量
            ,product_size -- 尺寸
            ,product_unit_price -- 产品单价
            ,product_num -- 产品数量
            ,product_charge -- 产品手续费规则(产品单位手续费)
            ,sale_limited_num -- 销售限制数量
            ,product_status -- 产品状态(0 在售 1 停售)
            ,onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
            ,offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键ID
    ,o.product_no -- 商品编号
    ,o.product_nm -- 商品名称(例如京东、苏宁易购)
    ,o.product_brand -- 商品品牌
    ,o.supplier_nm -- 供应商名称
    ,o.product_type -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
    ,o.product_sort -- 商品分类(饰品类、工艺品类、投资收藏类等)
    ,o.product_serial_no -- 货品编号
    ,o.product_quality -- 产品成色
    ,o.percent_gold -- 产品规格-含金量(例如50g)
    ,o.percent_silver -- 产品规格-含银量(例如50g)
    ,o.product_material -- 产品材质(材质文字描述)
    ,o.product_technology -- 工艺
    ,o.weight_unit -- 重量单位(g/kg)
    ,o.weight -- 重量
    ,o.product_size -- 尺寸
    ,o.product_unit_price -- 产品单价
    ,o.product_num -- 产品数量
    ,o.product_charge -- 产品手续费规则(产品单位手续费)
    ,o.sale_limited_num -- 销售限制数量
    ,o.product_status -- 产品状态(0 在售 1 停售)
    ,o.onsale_time -- 上架时间(yyyyMMdd HH:mm:ss)
    ,o.offshelves_time -- 下架时间(yyyyMMdd HH:mm:ss)
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.adddata1 -- 附加数据1
    ,o.adddata2 -- 附加数据2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_product_info_detail_his_bk o
    left join ${iol_schema}.mrms_tbl_product_info_detail_his_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_product_info_detail_his_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mrms_tbl_product_info_detail_his;

-- 4.2 exchange partition
alter table ${iol_schema}.mrms_tbl_product_info_detail_his exchange partition p_19000101 with table ${iol_schema}.mrms_tbl_product_info_detail_his_cl;
alter table ${iol_schema}.mrms_tbl_product_info_detail_his exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_product_info_detail_his_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_product_info_detail_his to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_product_info_detail_his_op purge;
drop table ${iol_schema}.mrms_tbl_product_info_detail_his_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_product_info_detail_his_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_product_info_detail_his',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
