/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_othertraffic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_othertraffic
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_othertraffic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_othertraffic(
    clrid varchar2(32) -- 押品编号
    ,identyno varchar2(100) -- 其他交通运输设备识别号
    ,registno varchar2(60) -- 其他交通运输设备登记号
    ,shipcerno varchar2(60) -- 车架号
    ,engineno varchar2(60) -- 发动机号
    ,plateno varchar2(60) -- 牌照号码
    ,isnewhouse varchar2(2) -- 一手/二手标识
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,equipmentbrand varchar2(100) -- 品牌/生产厂商
    ,specificationno varchar2(60) -- 型号/规格
    ,startdate date -- 出厂日期或报关日期（其他交通运输设备）/预计出厂日期（其他在建运输工具）
    ,enddate date -- 设计使用到期日期
    ,invoiceno varchar2(60) -- 发票编号
    ,issign varchar2(2) -- 是否已经签订销售合同
    ,confirmdate date -- 发票日期（其他交通运输设备）/合同日期（其他在建运输工具）
    ,confirmmoney number(24,6) -- 发票金额(元)（其他交通运输设备）/合同金额(元)（其他在建运输工具）
    ,tdcurrency varchar2(3) -- 币种
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,registrationno varchar2(60) -- 抵押登记编号
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
grant select on ${iol_schema}.icms_clr_asset_other_othertraffic to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_othertraffic to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_othertraffic to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_othertraffic to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_othertraffic is '其他类之其他交通工具信息表';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.identyno is '其他交通运输设备识别号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.registno is '其他交通运输设备登记号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.shipcerno is '车架号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.engineno is '发动机号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.plateno is '牌照号码';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.equipmentbrand is '品牌/生产厂商';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.specificationno is '型号/规格';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.startdate is '出厂日期或报关日期（其他交通运输设备）/预计出厂日期（其他在建运输工具）';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.enddate is '设计使用到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.invoiceno is '发票编号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.issign is '是否已经签订销售合同';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.confirmdate is '发票日期（其他交通运输设备）/合同日期（其他在建运输工具）';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.confirmmoney is '发票金额(元)（其他交通运输设备）/合同金额(元)（其他在建运输工具）';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.registrationno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_othertraffic.etl_timestamp is 'ETL处理时间戳';
