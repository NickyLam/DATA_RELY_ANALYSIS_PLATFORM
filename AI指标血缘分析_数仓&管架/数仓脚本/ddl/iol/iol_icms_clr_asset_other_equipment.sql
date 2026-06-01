/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_equipment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_equipment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_equipment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_equipment(
    clrid varchar2(32) -- 押品编号
    ,equipno varchar2(120) -- 设备铭牌编号
    ,isnewhouse varchar2(2) -- 一手/二手标识
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,equipmentbrand varchar2(200) -- 品牌/生产厂商
    ,specificationno varchar2(60) -- 型号/规格
    ,equiptype varchar2(2) -- 设备类型
    ,equipsort varchar2(30) -- 设备分类
    ,startdate date -- 出厂日期或报关日期
    ,enddate date -- 设计使用到期日期
    ,isqualify varchar2(2) -- 是否有产品合格证
    ,invoiceno varchar2(120) -- 发票编号
    ,invoicedate date -- 发票日期
    ,invoicemoney number(24,6) -- 发票金额(元)
    ,tdcurrency varchar2(3) -- 币种
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_other_equipment to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_equipment to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_equipment to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_equipment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_equipment is '其他类之机器设备信息表';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.equipno is '设备铭牌编号';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.equipmentbrand is '品牌/生产厂商';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.specificationno is '型号/规格';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.equiptype is '设备类型';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.equipsort is '设备分类';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.startdate is '出厂日期或报关日期';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.enddate is '设计使用到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.isqualify is '是否有产品合格证';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.invoiceno is '发票编号';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.invoicedate is '发票日期';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.invoicemoney is '发票金额(元)';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_equipment.etl_timestamp is 'ETL处理时间戳';
