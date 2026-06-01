/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_vehicle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_vehicle
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_vehicle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_vehicle(
    serialno varchar2(64) -- 流水号
    ,spstoreadd1 varchar2(510) -- 专卖店地址1
    ,corporgid varchar2(64) -- 法人机构编号
    ,sellcomname varchar2(128) -- 销售商名称
    ,managertelephone varchar2(40) -- 电话
    ,vehicletype varchar2(36) -- 车辆类型
    ,importflag varchar2(12) -- 是否为进口车是否为进口车（代码：1-是2-否）
    ,loadweight number(24,8) -- 载重
    ,cooperatemode varchar2(36) -- 合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)
    ,updatedate date -- 更新日期
    ,brand varchar2(64) -- 车辆品牌
    ,cylindercapacity varchar2(64) -- 气缸容量
    ,updateorgid varchar2(64) -- 更新机构
    ,vehicleno varchar2(64) -- 车辆编号
    ,color varchar2(36) -- 颜色
    ,inputorgid varchar2(64) -- 登记机构
    ,brandmodel varchar2(160) -- 品牌型号
    ,supplier varchar2(160) -- 供应商
    ,grossweight number(24,8) -- 毛重
    ,coopbrand varchar2(32) -- 合作品牌
    ,fueltype varchar2(36) -- 驱动燃料类型
    ,coopbrandname varchar2(120) -- 合作品牌名称
    ,ratedload number(22) -- 额定载客人数
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,sellbranchcount number(22,0) -- 销售网点数量
    ,inputdate date -- 登记日期
    ,standno number(22) -- 站位数目
    ,totalweight number(24,8) -- 总重
    ,managername varchar2(160) -- 负责人姓名
    ,managercerttype varchar2(72) -- 负责人证件类型
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,manudate date -- 生产日期
    ,spstoreadd2 varchar2(510) -- 专卖店地址2
    ,managercertid varchar2(128) -- 负责人证件号码
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
grant select on ${iol_schema}.icms_partner_vehicle to ${iml_schema};
grant select on ${iol_schema}.icms_partner_vehicle to ${icl_schema};
grant select on ${iol_schema}.icms_partner_vehicle to ${idl_schema};
grant select on ${iol_schema}.icms_partner_vehicle to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_vehicle is '车辆信息车辆信息';
comment on column ${iol_schema}.icms_partner_vehicle.serialno is '流水号';
comment on column ${iol_schema}.icms_partner_vehicle.spstoreadd1 is '专卖店地址1';
comment on column ${iol_schema}.icms_partner_vehicle.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_partner_vehicle.sellcomname is '销售商名称';
comment on column ${iol_schema}.icms_partner_vehicle.managertelephone is '电话';
comment on column ${iol_schema}.icms_partner_vehicle.vehicletype is '车辆类型';
comment on column ${iol_schema}.icms_partner_vehicle.importflag is '是否为进口车是否为进口车（代码：1-是2-否）';
comment on column ${iol_schema}.icms_partner_vehicle.loadweight is '载重';
comment on column ${iol_schema}.icms_partner_vehicle.cooperatemode is '合作模式合作模式(代码：1-经销商模式2-生产商模式3-经销商模式+生产商模式)';
comment on column ${iol_schema}.icms_partner_vehicle.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_vehicle.brand is '车辆品牌';
comment on column ${iol_schema}.icms_partner_vehicle.cylindercapacity is '气缸容量';
comment on column ${iol_schema}.icms_partner_vehicle.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_vehicle.vehicleno is '车辆编号';
comment on column ${iol_schema}.icms_partner_vehicle.color is '颜色';
comment on column ${iol_schema}.icms_partner_vehicle.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_vehicle.brandmodel is '品牌型号';
comment on column ${iol_schema}.icms_partner_vehicle.supplier is '供应商';
comment on column ${iol_schema}.icms_partner_vehicle.grossweight is '毛重';
comment on column ${iol_schema}.icms_partner_vehicle.coopbrand is '合作品牌';
comment on column ${iol_schema}.icms_partner_vehicle.fueltype is '驱动燃料类型';
comment on column ${iol_schema}.icms_partner_vehicle.coopbrandname is '合作品牌名称';
comment on column ${iol_schema}.icms_partner_vehicle.ratedload is '额定载客人数';
comment on column ${iol_schema}.icms_partner_vehicle.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_vehicle.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_vehicle.sellbranchcount is '销售网点数量';
comment on column ${iol_schema}.icms_partner_vehicle.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_vehicle.standno is '站位数目';
comment on column ${iol_schema}.icms_partner_vehicle.totalweight is '总重';
comment on column ${iol_schema}.icms_partner_vehicle.managername is '负责人姓名';
comment on column ${iol_schema}.icms_partner_vehicle.managercerttype is '负责人证件类型';
comment on column ${iol_schema}.icms_partner_vehicle.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_partner_vehicle.manudate is '生产日期';
comment on column ${iol_schema}.icms_partner_vehicle.spstoreadd2 is '专卖店地址2';
comment on column ${iol_schema}.icms_partner_vehicle.managercertid is '负责人证件号码';
comment on column ${iol_schema}.icms_partner_vehicle.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_vehicle.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_vehicle.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_vehicle.etl_timestamp is 'ETL处理时间戳';
