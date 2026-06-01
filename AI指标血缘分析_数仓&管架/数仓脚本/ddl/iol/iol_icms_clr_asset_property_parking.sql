/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_property_parking
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_property_parking
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_property_parking purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_parking(
    clrid varchar2(32) -- 押品编号
    ,isindepcard varchar2(60) -- 是否有独立产权证
    ,parktype varchar2(2) -- 车库/车位类型
    ,contno varchar2(60) -- 房地产买卖合同编号
    ,tradedate date -- 购买日期
    ,tradeprice number(20,2) -- 购买总价
    ,buildingarea number(20,2) -- 建筑面积
    ,usearea number(20,2) -- 实用面积
    ,createyear varchar2(10) -- 建成年份
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,counties varchar2(60) -- 所在县（区）
    ,street varchar2(120) -- 街道/村镇/路名
    ,roomno varchar2(120) -- 门牌号/弄号
    ,buildingno varchar2(120) -- 楼号室号
    ,address varchar2(200) -- 房产证或不动产证地址
    ,buildingname varchar2(100) -- 楼盘（社区）名称
    ,buildrightinfo varchar2(100) -- 房屋产权期限信息
    ,isotherright varchar2(2) -- 是否有他项权证
    ,remark varchar2(4000) -- 其他说明
    ,istwotogether varchar2(2) -- 是否两证合一
    ,landno varchar2(900) -- 房产证号
    ,landusenature varchar2(2) -- 土地使用权性质
    ,landusearea number(20,2) -- 土地使用面积
    ,landgainway varchar2(2) -- 土地使用权取得方式
    ,landstartdate date -- 土地使用权起始日期
    ,landenddate date -- 土地使用权到期日期
    ,landuseryear number(3,1) -- 土地使用年限
    ,landusering varchar2(2) -- 土地用途
    ,isrents varchar2(3) -- 是否租赁
    ,hpaddr varchar2(100) -- 承租人
    ,hiresdate date -- 租赁起始日
    ,hireedate date -- 租赁到期日
    ,hireremark varchar2(200) -- 租赁情况说明
    ,tdcurrency varchar2(3) -- 币种
    ,landnumber varchar2(60) -- 土地证书号
    ,iscompleted varchar2(2) -- 房屋是否已竣工
    ,yearlyrental number(20,2) -- 租赁年收入（元）
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
grant select on ${iol_schema}.icms_clr_asset_property_parking to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_property_parking to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_parking to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_parking to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_property_parking is '押品-房地产类之车库信息表';
comment on column ${iol_schema}.icms_clr_asset_property_parking.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.isindepcard is '是否有独立产权证';
comment on column ${iol_schema}.icms_clr_asset_property_parking.parktype is '车库/车位类型';
comment on column ${iol_schema}.icms_clr_asset_property_parking.contno is '房地产买卖合同编号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.tradedate is '购买日期';
comment on column ${iol_schema}.icms_clr_asset_property_parking.tradeprice is '购买总价';
comment on column ${iol_schema}.icms_clr_asset_property_parking.buildingarea is '建筑面积';
comment on column ${iol_schema}.icms_clr_asset_property_parking.usearea is '实用面积';
comment on column ${iol_schema}.icms_clr_asset_property_parking.createyear is '建成年份';
comment on column ${iol_schema}.icms_clr_asset_property_parking.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_property_parking.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_property_parking.counties is '所在县（区）';
comment on column ${iol_schema}.icms_clr_asset_property_parking.street is '街道/村镇/路名';
comment on column ${iol_schema}.icms_clr_asset_property_parking.roomno is '门牌号/弄号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.buildingno is '楼号室号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.address is '房产证或不动产证地址';
comment on column ${iol_schema}.icms_clr_asset_property_parking.buildingname is '楼盘（社区）名称';
comment on column ${iol_schema}.icms_clr_asset_property_parking.buildrightinfo is '房屋产权期限信息';
comment on column ${iol_schema}.icms_clr_asset_property_parking.isotherright is '是否有他项权证';
comment on column ${iol_schema}.icms_clr_asset_property_parking.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_property_parking.istwotogether is '是否两证合一';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landno is '房产证号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landusenature is '土地使用权性质';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landusearea is '土地使用面积';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landgainway is '土地使用权取得方式';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landstartdate is '土地使用权起始日期';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landenddate is '土地使用权到期日期';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landuseryear is '土地使用年限';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landusering is '土地用途';
comment on column ${iol_schema}.icms_clr_asset_property_parking.isrents is '是否租赁';
comment on column ${iol_schema}.icms_clr_asset_property_parking.hpaddr is '承租人';
comment on column ${iol_schema}.icms_clr_asset_property_parking.hiresdate is '租赁起始日';
comment on column ${iol_schema}.icms_clr_asset_property_parking.hireedate is '租赁到期日';
comment on column ${iol_schema}.icms_clr_asset_property_parking.hireremark is '租赁情况说明';
comment on column ${iol_schema}.icms_clr_asset_property_parking.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_property_parking.landnumber is '土地证书号';
comment on column ${iol_schema}.icms_clr_asset_property_parking.iscompleted is '房屋是否已竣工';
comment on column ${iol_schema}.icms_clr_asset_property_parking.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.icms_clr_asset_property_parking.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_property_parking.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_property_parking.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_property_parking.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_property_parking.etl_timestamp is 'ETL处理时间戳';
