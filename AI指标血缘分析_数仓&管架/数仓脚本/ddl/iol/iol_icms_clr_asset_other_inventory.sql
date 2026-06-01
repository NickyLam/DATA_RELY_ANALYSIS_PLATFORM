/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_inventory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_inventory
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_inventory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_inventory(
    clrid varchar2(32) -- 押品编号
    ,inventorytype varchar2(10) -- 存货细类
    ,guarinfono varchar2(200) -- 质押物清单编号
    ,region varchar2(100) -- 品牌/厂家/产地
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,unit varchar2(2) -- 货物计量单位
    ,otherremark varchar2(60) -- 其他计量单位说明
    ,amount number(38,0) -- 货物数量
    ,totalvalue number(24,6) -- 最新核定价格
    ,tdcurrency varchar2(3) -- 币种
    ,registration varchar2(60) -- 中登网登记编号
    ,isreg varchar2(2) -- 是否监管公司监管
    ,regulatory varchar2(100) -- 监管公司名称
    ,regulatorycode varchar2(60) -- 监管公司组织机构代码
    ,certtype varchar2(4) -- 监管公司证件类型
    ,startdate date -- 协议生效日
    ,enddate date -- 协议到期日
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
grant select on ${iol_schema}.icms_clr_asset_other_inventory to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_inventory to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_inventory to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_inventory to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_inventory is '其他类之存货信息表';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.inventorytype is '存货细类';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.guarinfono is '质押物清单编号';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.region is '品牌/厂家/产地';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.unit is '货物计量单位';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.otherremark is '其他计量单位说明';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.amount is '货物数量';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.totalvalue is '最新核定价格';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.registration is '中登网登记编号';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.isreg is '是否监管公司监管';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.regulatory is '监管公司名称';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.regulatorycode is '监管公司组织机构代码';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.certtype is '监管公司证件类型';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.startdate is '协议生效日';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.enddate is '协议到期日';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_inventory.etl_timestamp is 'ETL处理时间戳';
