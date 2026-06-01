/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_motor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_motor
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_motor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_motor(
    clrid varchar2(32) -- 押品编号
    ,registno varchar2(60) -- 机动车登记证书编号
    ,drivelicense varchar2(100) -- 行驶证编号
    ,vehicleno varchar2(100) -- 车架号
    ,engineno varchar2(100) -- 发动机号
    ,plateno varchar2(30) -- 牌照号码
    ,isnewhouse varchar2(2) -- 一手/二手标识
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,equipmentbrand varchar2(200) -- 品牌/生产厂商
    ,specificationno varchar2(60) -- 型号/规格
    ,capacity number(20,2) -- 排量（L）
    ,speedtype varchar2(2) -- 变速类型
    ,startdate date -- 出厂日期或报关日期
    ,enddate date -- 设计使用到期日期
    ,rangesum number(20,2) -- 行驶里程数(公里)
    ,invoiceno varchar2(60) -- 发票编号
    ,remark varchar2(4000) -- 其他说明
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,vehiclesubtype varchar2(10) -- 车辆细类
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
grant select on ${iol_schema}.icms_clr_asset_other_motor to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_motor to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_motor to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_motor to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_motor is '其他类之机器车辆信息表';
comment on column ${iol_schema}.icms_clr_asset_other_motor.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.registno is '机动车登记证书编号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.drivelicense is '行驶证编号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.vehicleno is '车架号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.engineno is '发动机号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.plateno is '牌照号码';
comment on column ${iol_schema}.icms_clr_asset_other_motor.isnewhouse is '一手/二手标识';
comment on column ${iol_schema}.icms_clr_asset_other_motor.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_motor.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_motor.equipmentbrand is '品牌/生产厂商';
comment on column ${iol_schema}.icms_clr_asset_other_motor.specificationno is '型号/规格';
comment on column ${iol_schema}.icms_clr_asset_other_motor.capacity is '排量（L）';
comment on column ${iol_schema}.icms_clr_asset_other_motor.speedtype is '变速类型';
comment on column ${iol_schema}.icms_clr_asset_other_motor.startdate is '出厂日期或报关日期';
comment on column ${iol_schema}.icms_clr_asset_other_motor.enddate is '设计使用到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_motor.rangesum is '行驶里程数(公里)';
comment on column ${iol_schema}.icms_clr_asset_other_motor.invoiceno is '发票编号';
comment on column ${iol_schema}.icms_clr_asset_other_motor.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_motor.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_motor.vehiclesubtype is '车辆细类';
comment on column ${iol_schema}.icms_clr_asset_other_motor.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_motor.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_motor.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_motor.etl_timestamp is 'ETL处理时间戳';
