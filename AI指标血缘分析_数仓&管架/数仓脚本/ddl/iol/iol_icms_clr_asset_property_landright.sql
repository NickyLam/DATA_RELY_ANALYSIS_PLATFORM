/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_property_landright
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_property_landright
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_property_landright purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_property_landright(
    clrid varchar2(32) -- 押品编号
    ,landno varchar2(200) -- 土地证号
    ,warrantsno varchar2(200) -- 土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）
    ,landusenature varchar2(4) -- 土地使用权性质
    ,landgainway varchar2(4) -- 土地使用权取得方式
    ,landstartdate date -- 土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）
    ,landenddate date -- 土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）
    ,landusering varchar2(4) -- 土地用途
    ,landusearea number(20,2) -- 土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）
    ,landtype varchar2(4) -- 闲置土地类型
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,counties varchar2(60) -- 所在县（区）
    ,street varchar2(120) -- 街道/村镇/路名
    ,address varchar2(200) -- 土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）
    ,landdec varchar2(120) -- 宗地号
    ,tradedate date -- 购买时间
    ,tradeprice number(20,2) -- 购买价格
    ,isattachments varchar2(4) -- 是否有地上附着物
    ,attachmenttype varchar2(4) -- 附着物种类
    ,buildterm number(38,0) -- 地上建筑物项数
    ,attachmentowner varchar2(100) -- 附着物所有权人名称
    ,attachmentregion varchar2(100) -- 附着物所有权人范围
    ,overallfloorage number(20,2) -- 地上附着物总面积
    ,remark varchar2(4000) -- 其他说明
    ,tdcurrency varchar2(3) -- 币种
    ,landsubtype varchar2(10) -- 使用权细类
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
grant select on ${iol_schema}.icms_clr_asset_property_landright to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_property_landright to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_landright to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_property_landright to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_property_landright is '房地产类之土地使用权或经营权信息表';
comment on column ${iol_schema}.icms_clr_asset_property_landright.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landno is '土地证号';
comment on column ${iol_schema}.icms_clr_asset_property_landright.warrantsno is '土地承包经营权权证号（该字段仅文化旅游用地使用权和其他土地使用权这两类使用）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landusenature is '土地使用权性质';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landgainway is '土地使用权取得方式';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landstartdate is '土地使用权起始日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权取得日期-（文化旅游用地使用权和其他土地使用权）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landenddate is '土地使用权到期日期-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权到期日期-（文化旅游用地使用权和其他土地使用权）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landusering is '土地用途';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landusearea is '土地使用权面积-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权面积(平方米)-（文化旅游用地使用权和其他土地使用权）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landtype is '闲置土地类型';
comment on column ${iol_schema}.icms_clr_asset_property_landright.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_property_landright.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_property_landright.counties is '所在县（区）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.street is '街道/村镇/路名';
comment on column ${iol_schema}.icms_clr_asset_property_landright.address is '土地详细地址-(除了文化旅游用地使用权和其他土地使用权这两类)/土地承包经营权地址-（文化旅游用地使用权和其他土地使用权）';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landdec is '宗地号';
comment on column ${iol_schema}.icms_clr_asset_property_landright.tradedate is '购买时间';
comment on column ${iol_schema}.icms_clr_asset_property_landright.tradeprice is '购买价格';
comment on column ${iol_schema}.icms_clr_asset_property_landright.isattachments is '是否有地上附着物';
comment on column ${iol_schema}.icms_clr_asset_property_landright.attachmenttype is '附着物种类';
comment on column ${iol_schema}.icms_clr_asset_property_landright.buildterm is '地上建筑物项数';
comment on column ${iol_schema}.icms_clr_asset_property_landright.attachmentowner is '附着物所有权人名称';
comment on column ${iol_schema}.icms_clr_asset_property_landright.attachmentregion is '附着物所有权人范围';
comment on column ${iol_schema}.icms_clr_asset_property_landright.overallfloorage is '地上附着物总面积';
comment on column ${iol_schema}.icms_clr_asset_property_landright.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_property_landright.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_property_landright.landsubtype is '使用权细类';
comment on column ${iol_schema}.icms_clr_asset_property_landright.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_property_landright.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_property_landright.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_property_landright.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_property_landright.etl_timestamp is 'ETL处理时间戳';
