/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_airplane
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_airplane
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_airplane purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_airplane(
    clrid varchar2(32) -- 押品编号
    ,identyno varchar2(60) -- 民航飞机注册号
    ,engineno varchar2(60) -- 发动机号
    ,isnewhouse varchar2(2) -- 一手/二手标识
    ,country varchar2(60) -- 所在国家或地区
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,equipmentbrand varchar2(100) -- 品牌/生产厂商
    ,specificationno varchar2(60) -- 型号/规格
    ,load number(20,2) -- 载重(吨)
    ,airplanetype varchar2(2) -- 飞行器类型
    ,enginenum number(38,0) -- 发动机数量
    ,startdate date -- 出厂日期或报关日期（飞行设备）/预计出厂日期（在建飞行设备）
    ,enddate date -- 设计使用到期日期
    ,invoiceno varchar2(60) -- 发票编号
    ,issign varchar2(2) -- 是否已经签订销售合同
    ,confirmdate date -- 发票日期（飞行设备）/合同日期（在建飞行设备）
    ,confirmmoney number(24,6) -- 发票金额(元)（飞行设备）/合同金额(元)（在建飞行设备）
    ,travelleddistance number(20,2) -- 累计航程(公里)
    ,tdcurrency varchar2(3) -- 币种
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,registno varchar2(60) -- 抵押登记编号
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
grant select on ${iol_schema}.icms_clr_asset_other_airplane to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_airplane to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_airplane to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_airplane to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_airplane is '其他类之飞行设备信息表';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.identyno is '民航飞机注册号';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.engineno is '发动机号';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.country is '所在国家或地区';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.equipmentbrand is '品牌/生产厂商';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.specificationno is '型号/规格';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.load is '载重(吨)';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.airplanetype is '飞行器类型';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.enginenum is '发动机数量';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.startdate is '出厂日期或报关日期（飞行设备）/预计出厂日期（在建飞行设备）';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.enddate is '设计使用到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.invoiceno is '发票编号';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.issign is '是否已经签订销售合同';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.confirmdate is '发票日期（飞行设备）/合同日期（在建飞行设备）';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.confirmmoney is '发票金额(元)（飞行设备）/合同金额(元)（在建飞行设备）';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.travelleddistance is '累计航程(公里)';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.registno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_airplane.etl_timestamp is 'ETL处理时间戳';
