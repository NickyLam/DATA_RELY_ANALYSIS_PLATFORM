/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_partner_building
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_partner_building
whenever sqlerror continue none;
drop table ${iol_schema}.icms_partner_building purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_partner_building(
    buildingno varchar2(64) -- 楼盘编号
    ,buildingdevelopers varchar2(160) -- 楼盘开发商
    ,constructarea number(18,2) -- 总建筑面积
    ,updatedate date -- 更新日期
    ,buildingperiod number(22) -- 楼盘期数
    ,updataflag varchar2(2) -- 批量更新标识
    ,repo varchar2(12) -- 回购回购(是/否)
    ,projectprograminglicense varchar2(64) -- 建设工程规划许可证编号
    ,inputuserid varchar2(64) -- 登记人
    ,inuptorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,prjtotalincom number(24,6) -- 项目总销售收入
    ,city varchar2(36) -- 区域城市
    ,landprograminglicense varchar2(64) -- 建筑用地规划许可证编号
    ,maincertificatedate date -- 大产证办理日期
    ,inputdate date -- 登记日期
    ,housetype varchar2(36) -- 房产类型
    ,landcertlicense varchar2(64) -- 土地使用证编号
    ,updateuserid varchar2(64) -- 更新人
    ,startpermitlicense varchar2(64) -- 开工许可证编号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,buildingname varchar2(160) -- 楼盘名称
    ,devotesum number(24,6) -- 总投资金额
    ,floorarea number(18,2) -- 总占地面积
    ,predictfinishdate date -- 预计竣工日期
    ,practicalfinishdate date -- 实际竣工日期
    ,deliverydate date -- 交房日期
    ,remark varchar2(1000) -- 备注
    ,corporgid varchar2(64) -- 法人机构编号
    ,salelicense varchar2(64) -- 销售许可证
    ,houseflag varchar2(12) -- 房屋状况房屋状况(代码：1-期房2-现房3-其他)
    ,saledhousenum number(22) -- 已销售房套数
    ,seatingposition varchar2(400) -- 坐落位置
    ,landusedeadline date -- 土地使用截止年限
    ,prjotherpric number(24,6) -- 其他部分销售总价
    ,housestatus varchar2(36) -- 楼盘状态
    ,prjrightname varchar2(80) -- 项目权利人名称
    ,landcharacter varchar2(160) -- 土地性质
    ,prjbegday date -- 项目开工时间
    ,prjreadyinv number(24,6) -- 已投资金额
    ,appendant varchar2(1000) -- 附属物
    ,sidecertificatedate date -- 小产证办理日期
    ,updateflag varchar2(12) -- 批量更新标识
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
grant select on ${iol_schema}.icms_partner_building to ${iml_schema};
grant select on ${iol_schema}.icms_partner_building to ${icl_schema};
grant select on ${iol_schema}.icms_partner_building to ${idl_schema};
grant select on ${iol_schema}.icms_partner_building to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_partner_building is '楼盘信息楼盘信息';
comment on column ${iol_schema}.icms_partner_building.buildingno is '楼盘编号';
comment on column ${iol_schema}.icms_partner_building.buildingdevelopers is '楼盘开发商';
comment on column ${iol_schema}.icms_partner_building.constructarea is '总建筑面积';
comment on column ${iol_schema}.icms_partner_building.updatedate is '更新日期';
comment on column ${iol_schema}.icms_partner_building.buildingperiod is '楼盘期数';
comment on column ${iol_schema}.icms_partner_building.updataflag is '批量更新标识';
comment on column ${iol_schema}.icms_partner_building.repo is '回购回购(是/否)';
comment on column ${iol_schema}.icms_partner_building.projectprograminglicense is '建设工程规划许可证编号';
comment on column ${iol_schema}.icms_partner_building.inputuserid is '登记人';
comment on column ${iol_schema}.icms_partner_building.inuptorgid is '登记机构';
comment on column ${iol_schema}.icms_partner_building.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_partner_building.prjtotalincom is '项目总销售收入';
comment on column ${iol_schema}.icms_partner_building.city is '区域城市';
comment on column ${iol_schema}.icms_partner_building.landprograminglicense is '建筑用地规划许可证编号';
comment on column ${iol_schema}.icms_partner_building.maincertificatedate is '大产证办理日期';
comment on column ${iol_schema}.icms_partner_building.inputdate is '登记日期';
comment on column ${iol_schema}.icms_partner_building.housetype is '房产类型';
comment on column ${iol_schema}.icms_partner_building.landcertlicense is '土地使用证编号';
comment on column ${iol_schema}.icms_partner_building.updateuserid is '更新人';
comment on column ${iol_schema}.icms_partner_building.startpermitlicense is '开工许可证编号';
comment on column ${iol_schema}.icms_partner_building.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_partner_building.buildingname is '楼盘名称';
comment on column ${iol_schema}.icms_partner_building.devotesum is '总投资金额';
comment on column ${iol_schema}.icms_partner_building.floorarea is '总占地面积';
comment on column ${iol_schema}.icms_partner_building.predictfinishdate is '预计竣工日期';
comment on column ${iol_schema}.icms_partner_building.practicalfinishdate is '实际竣工日期';
comment on column ${iol_schema}.icms_partner_building.deliverydate is '交房日期';
comment on column ${iol_schema}.icms_partner_building.remark is '备注';
comment on column ${iol_schema}.icms_partner_building.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_partner_building.salelicense is '销售许可证';
comment on column ${iol_schema}.icms_partner_building.houseflag is '房屋状况房屋状况(代码：1-期房2-现房3-其他)';
comment on column ${iol_schema}.icms_partner_building.saledhousenum is '已销售房套数';
comment on column ${iol_schema}.icms_partner_building.seatingposition is '坐落位置';
comment on column ${iol_schema}.icms_partner_building.landusedeadline is '土地使用截止年限';
comment on column ${iol_schema}.icms_partner_building.prjotherpric is '其他部分销售总价';
comment on column ${iol_schema}.icms_partner_building.housestatus is '楼盘状态';
comment on column ${iol_schema}.icms_partner_building.prjrightname is '项目权利人名称';
comment on column ${iol_schema}.icms_partner_building.landcharacter is '土地性质';
comment on column ${iol_schema}.icms_partner_building.prjbegday is '项目开工时间';
comment on column ${iol_schema}.icms_partner_building.prjreadyinv is '已投资金额';
comment on column ${iol_schema}.icms_partner_building.appendant is '附属物';
comment on column ${iol_schema}.icms_partner_building.sidecertificatedate is '小产证办理日期';
comment on column ${iol_schema}.icms_partner_building.updateflag is '批量更新标识';
comment on column ${iol_schema}.icms_partner_building.start_dt is '开始时间';
comment on column ${iol_schema}.icms_partner_building.end_dt is '结束时间';
comment on column ${iol_schema}.icms_partner_building.id_mark is '增删标志';
comment on column ${iol_schema}.icms_partner_building.etl_timestamp is 'ETL处理时间戳';
