/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_product_info_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_product_info_detail
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_product_info_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_product_info_detail(
    id varchar2(96) -- 主键id
    ,product_no varchar2(150) -- 商品编号
    ,product_nm varchar2(383) -- 商品名称(例如京东、苏宁易购)
    ,product_brand varchar2(383) -- 商品品牌
    ,supplier_nm varchar2(383) -- 供应商名称
    ,product_type varchar2(383) -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
    ,product_sort varchar2(383) -- 商品分类(饰品类、工艺品类、投资收藏类等)
    ,product_serial_no varchar2(300) -- 货品编号
    ,product_quality varchar2(300) -- 产品成色
    ,percent_gold varchar2(383) -- 产品规格-含金量(例如50g)
    ,percent_silver varchar2(383) -- 产品规格-含银量(例如50g)
    ,product_material varchar2(383) -- 产品材质(材质文字描述)
    ,product_technology varchar2(383) -- 工艺
    ,weight_unit varchar2(30) -- 重量单位(g/kg)
    ,weight varchar2(90) -- 重量
    ,product_size varchar2(150) -- 尺寸
    ,product_unit_price varchar2(21) -- 产品单价
    ,product_num varchar2(24) -- 产品数量
    ,product_charge varchar2(24) -- 产品手续费规则(产品单位手续费)
    ,sale_limited_num varchar2(15) -- 销售限制数量
    ,product_status varchar2(30) -- 产品状态(0 在售 1 停售)
    ,onsale_time varchar2(45) -- 上架时间(yyyymmdd hh:mm:ss)
    ,offshelves_time varchar2(45) -- 下架时间(yyyymmdd hh:mm:ss)
    ,create_time varchar2(30) -- 创建时间
    ,update_time varchar2(30) -- 更新时间
    ,adddata1 varchar2(150) -- 附加数据1
    ,adddata2 varchar2(150) -- 附加数据2
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_tbl_product_info_detail to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_product_info_detail to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_product_info_detail to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_product_info_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_product_info_detail is '贵金属产品明细表';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.id is '主键id';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_no is '商品编号';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_nm is '商品名称(例如京东、苏宁易购)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_brand is '商品品牌';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.supplier_nm is '供应商名称';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_type is '商品类型(1、实体商品2、虚拟商品3、实物贵金属)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_sort is '商品分类(饰品类、工艺品类、投资收藏类等)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_serial_no is '货品编号';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_quality is '产品成色';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.percent_gold is '产品规格-含金量(例如50g)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.percent_silver is '产品规格-含银量(例如50g)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_material is '产品材质(材质文字描述)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_technology is '工艺';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.weight_unit is '重量单位(g/kg)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.weight is '重量';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_size is '尺寸';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_unit_price is '产品单价';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_num is '产品数量';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_charge is '产品手续费规则(产品单位手续费)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.sale_limited_num is '销售限制数量';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.product_status is '产品状态(0 在售 1 停售)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.onsale_time is '上架时间(yyyymmdd hh:mm:ss)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.offshelves_time is '下架时间(yyyymmdd hh:mm:ss)';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.create_time is '创建时间';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.update_time is '更新时间';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.adddata1 is '附加数据1';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.adddata2 is '附加数据2';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_product_info_detail.etl_timestamp is 'ETL处理时间戳';
