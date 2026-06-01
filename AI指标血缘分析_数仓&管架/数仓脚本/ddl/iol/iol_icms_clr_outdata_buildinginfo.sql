/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_outdata_buildinginfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_outdata_buildinginfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_outdata_buildinginfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_outdata_buildinginfo(
    buildingno varchar2(30) -- 楼盘编号
    ,buildingname varchar2(300) -- 楼盘名称
    ,buildingalias varchar2(600) -- 楼盘别名
    ,genus varchar2(30) -- 行政区域
    ,area varchar2(1000) -- 片区
    ,neighbouraddress varchar2(2000) -- 小区地址
    ,longitude varchar2(30) -- 经度
    ,latitude varchar2(30) -- 纬度
    ,cooperatename varchar2(50) -- 开发商
    ,completdate date -- 竣工时间
    ,sertypename varchar2(30) -- 物业类别
    ,area1 varchar2(500) -- 所属区域
    ,traffic varchar2(100) -- 交通便捷度
    ,nature varchar2(100) -- 自然环境
    ,naturedes varchar2(100) -- 人文环境
    ,living varchar2(100) -- 公共配套设施
    ,buildingnomaturity varchar2(100) -- 居住社区成熟度
    ,bfapsr varchar2(100) -- 建筑外观与公共装修（英文全称：Building Facade and Public Space Renovation）
    ,fae varchar2(100) -- 设施设备（英文全称：Facilities and Equipment）
    ,pmal varchar2(100) -- 物业管理资质等级（英文全称：Property Management and Accreditation Level）
    ,pa varchar2(100) -- 泊车条件（英文全称：Parking Availability）
    ,wonsdh varchar2(100) -- 是否学区房（英文全称：Whether or not School District Housing）
    ,far varchar2(100) -- 容积率（英文全称：Floor Area Ratio）
    ,wonsfd varchar2(100) -- 是否待拆迁（英文全称：Whether or not Scheduled for Demolition）
    ,remark varchar2(200) -- 备注
    ,ler varchar2(100) -- 平面布置优劣度（英文全称：Layout Effectiveness Rating
    ,landscape varchar2(100) -- 景观
    ,architecturaltectonics varchar2(100) -- 建筑结构
    ,inputuserid varchar2(64) -- 创建用户
    ,inputorgid varchar2(64) -- 创建用户所属机构
    ,datasource varchar2(2) -- 数据来源（0-本地/房讯通，1-世联）
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
grant select on ${iol_schema}.icms_clr_outdata_buildinginfo to ${iml_schema};
grant select on ${iol_schema}.icms_clr_outdata_buildinginfo to ${icl_schema};
grant select on ${iol_schema}.icms_clr_outdata_buildinginfo to ${idl_schema};
grant select on ${iol_schema}.icms_clr_outdata_buildinginfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_outdata_buildinginfo is '楼盘信息表--外部数据';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.buildingno is '楼盘编号';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.buildingname is '楼盘名称';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.buildingalias is '楼盘别名';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.genus is '行政区域';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.area is '片区';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.neighbouraddress is '小区地址';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.longitude is '经度';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.latitude is '纬度';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.cooperatename is '开发商';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.completdate is '竣工时间';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.sertypename is '物业类别';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.area1 is '所属区域';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.traffic is '交通便捷度';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.nature is '自然环境';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.naturedes is '人文环境';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.living is '公共配套设施';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.buildingnomaturity is '居住社区成熟度';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.bfapsr is '建筑外观与公共装修（英文全称：Building Facade and Public Space Renovation）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.fae is '设施设备（英文全称：Facilities and Equipment）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.pmal is '物业管理资质等级（英文全称：Property Management and Accreditation Level）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.pa is '泊车条件（英文全称：Parking Availability）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.wonsdh is '是否学区房（英文全称：Whether or not School District Housing）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.far is '容积率（英文全称：Floor Area Ratio）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.wonsfd is '是否待拆迁（英文全称：Whether or not Scheduled for Demolition）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.remark is '备注';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.ler is '平面布置优劣度（英文全称：Layout Effectiveness Rating';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.landscape is '景观';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.architecturaltectonics is '建筑结构';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.inputuserid is '创建用户';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.inputorgid is '创建用户所属机构';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.datasource is '数据来源（0-本地/房讯通，1-世联）';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_outdata_buildinginfo.etl_timestamp is 'ETL处理时间戳';
