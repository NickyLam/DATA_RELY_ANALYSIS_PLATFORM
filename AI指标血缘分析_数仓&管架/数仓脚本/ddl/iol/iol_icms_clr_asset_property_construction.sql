/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_property_construction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_property_construction
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_property_construction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_construction(
    clrid varchar2(32) -- 押品编号
    ,landuseno varchar2(200) -- 土地证/不动产证号
    ,landusenature varchar2(2) -- 土地使用权性质
    ,landgainway varchar2(2) -- 土地使用权取得方式
    ,landstartdate date -- 土地使用权起始日期
    ,landenddate date -- 土地使用权到期日期
    ,landuseyear number(38,0) -- 土地使用年限(年)
    ,landarea number(20,2) -- 土地面积
    ,landleasprice number(20,2) -- 土地出让价值(元)
    ,landdelivery varchar2(2) -- 土地出让金交付情况
    ,transfermoney number(20,2) -- 应补出让金金额（元）
    ,landusering varchar2(2) -- 土地用途
    ,projectname varchar2(100) -- 工程项目名称
    ,landlicenceno varchar2(120) -- 建设用地规划许可证号
    ,projectlicenceno varchar2(120) -- 建设工程规划许可证号
    ,licenceno varchar2(120) -- 施工许可证号
    ,startworkdate date -- 开工日期
    ,prestartdate date -- 预计竣工日期
    ,pretotalprice number(20,2) -- 工程预计总造价（元）
    ,buildarea number(20,2) -- 建筑面积（平方米）
    ,buildnumber number(38,0) -- 建筑层数
    ,isrents varchar2(2) -- 是否租赁
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,counties varchar2(60) -- 所在县（区）
    ,street varchar2(120) -- 街道（村镇）
    ,roomno varchar2(120) -- 门牌号（弄号）
    ,address varchar2(400) -- 详细地址
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,iscompleted varchar2(2) -- 房屋是否已竣工
    ,yearlyrental number(20,2) -- 租赁年收入（元）
    ,buildingno varchar2(60) -- 楼号室号(房号)
    ,predeliver date -- 预计房屋交付时间
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
grant select on ${iol_schema}.icms_clr_asset_property_construction to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_property_construction to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_construction to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_construction to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_property_construction is '房地产类之在建工程信息表';
comment on column ${iol_schema}.icms_clr_asset_property_construction.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landuseno is '土地证/不动产证号';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landusenature is '土地使用权性质';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landgainway is '土地使用权取得方式';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landstartdate is '土地使用权起始日期';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landenddate is '土地使用权到期日期';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landuseyear is '土地使用年限(年)';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landarea is '土地面积';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landleasprice is '土地出让价值(元)';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landdelivery is '土地出让金交付情况';
comment on column ${iol_schema}.icms_clr_asset_property_construction.transfermoney is '应补出让金金额（元）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landusering is '土地用途';
comment on column ${iol_schema}.icms_clr_asset_property_construction.projectname is '工程项目名称';
comment on column ${iol_schema}.icms_clr_asset_property_construction.landlicenceno is '建设用地规划许可证号';
comment on column ${iol_schema}.icms_clr_asset_property_construction.projectlicenceno is '建设工程规划许可证号';
comment on column ${iol_schema}.icms_clr_asset_property_construction.licenceno is '施工许可证号';
comment on column ${iol_schema}.icms_clr_asset_property_construction.startworkdate is '开工日期';
comment on column ${iol_schema}.icms_clr_asset_property_construction.prestartdate is '预计竣工日期';
comment on column ${iol_schema}.icms_clr_asset_property_construction.pretotalprice is '工程预计总造价（元）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.buildarea is '建筑面积（平方米）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.buildnumber is '建筑层数';
comment on column ${iol_schema}.icms_clr_asset_property_construction.isrents is '是否租赁';
comment on column ${iol_schema}.icms_clr_asset_property_construction.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_property_construction.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_property_construction.counties is '所在县（区）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.street is '街道（村镇）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.roomno is '门牌号（弄号）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.address is '详细地址';
comment on column ${iol_schema}.icms_clr_asset_property_construction.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_property_construction.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_property_construction.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.icms_clr_asset_property_construction.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.icms_clr_asset_property_construction.buildingno is '楼号室号(房号)';
comment on column ${iol_schema}.icms_clr_asset_property_construction.predeliver is '预计房屋交付时间';
comment on column ${iol_schema}.icms_clr_asset_property_construction.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_property_construction.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_property_construction.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_property_construction.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_property_construction.etl_timestamp is 'ETL处理时间戳';
