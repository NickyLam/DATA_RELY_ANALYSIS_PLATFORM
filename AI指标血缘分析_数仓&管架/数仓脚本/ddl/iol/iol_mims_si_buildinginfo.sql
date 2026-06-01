/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_buildinginfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_buildinginfo
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_buildinginfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_buildinginfo(
    buildingno varchar2(45) -- 楼盘编号
    ,buildingname varchar2(450) -- 楼盘名称
    ,buildingalias varchar2(450) -- 楼盘别名
    ,genus varchar2(45) -- 行政区域
    ,area varchar2(1500) -- 片区
    ,neighbouraddress varchar2(1500) -- 小区地址
    ,longitude varchar2(45) -- 经度
    ,latitude varchar2(45) -- 维度
    ,cooperatename varchar2(75) -- 开发商
    ,completdate varchar2(45) -- 竣工时间
    ,sertypename varchar2(45) -- 物业类别
    ,area1 varchar2(750) -- 所属区域
    ,traffic varchar2(150) -- 交通便捷度
    ,nature varchar2(150) -- 自然环境
    ,naturedes varchar2(150) -- 人文环境
    ,living varchar2(150) -- 公共配套设施
    ,buildingnomaturity varchar2(150) -- 居住社区成熟度
    ,jzwgggzx varchar2(150) -- 建筑外观与公共装修
    ,sssb varchar2(150) -- 设施设备
    ,wyglzzdj varchar2(150) -- 物业管理资质等级
    ,bctj varchar2(150) -- 泊车条件
    ,sfxqf varchar2(150) -- 是否学区房
    ,rjl varchar2(150) -- 容积率
    ,sfdcq varchar2(150) -- 是否待拆迁
    ,remark varchar2(150) -- 备注
    ,pmbzyld varchar2(150) -- 平面布置优劣度
    ,jg varchar2(150) -- 景观
    ,jzjg varchar2(150) -- 建筑结构
    ,account varchar2(15) -- 用户
    ,createrdept varchar2(15) -- 
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
grant select on ${iol_schema}.mims_si_buildinginfo to ${iml_schema};
grant select on ${iol_schema}.mims_si_buildinginfo to ${icl_schema};
grant select on ${iol_schema}.mims_si_buildinginfo to ${idl_schema};
grant select on ${iol_schema}.mims_si_buildinginfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_buildinginfo is '楼盘小区信息';
comment on column ${iol_schema}.mims_si_buildinginfo.buildingno is '楼盘编号';
comment on column ${iol_schema}.mims_si_buildinginfo.buildingname is '楼盘名称';
comment on column ${iol_schema}.mims_si_buildinginfo.buildingalias is '楼盘别名';
comment on column ${iol_schema}.mims_si_buildinginfo.genus is '行政区域';
comment on column ${iol_schema}.mims_si_buildinginfo.area is '片区';
comment on column ${iol_schema}.mims_si_buildinginfo.neighbouraddress is '小区地址';
comment on column ${iol_schema}.mims_si_buildinginfo.longitude is '经度';
comment on column ${iol_schema}.mims_si_buildinginfo.latitude is '维度';
comment on column ${iol_schema}.mims_si_buildinginfo.cooperatename is '开发商';
comment on column ${iol_schema}.mims_si_buildinginfo.completdate is '竣工时间';
comment on column ${iol_schema}.mims_si_buildinginfo.sertypename is '物业类别';
comment on column ${iol_schema}.mims_si_buildinginfo.area1 is '所属区域';
comment on column ${iol_schema}.mims_si_buildinginfo.traffic is '交通便捷度';
comment on column ${iol_schema}.mims_si_buildinginfo.nature is '自然环境';
comment on column ${iol_schema}.mims_si_buildinginfo.naturedes is '人文环境';
comment on column ${iol_schema}.mims_si_buildinginfo.living is '公共配套设施';
comment on column ${iol_schema}.mims_si_buildinginfo.buildingnomaturity is '居住社区成熟度';
comment on column ${iol_schema}.mims_si_buildinginfo.jzwgggzx is '建筑外观与公共装修';
comment on column ${iol_schema}.mims_si_buildinginfo.sssb is '设施设备';
comment on column ${iol_schema}.mims_si_buildinginfo.wyglzzdj is '物业管理资质等级';
comment on column ${iol_schema}.mims_si_buildinginfo.bctj is '泊车条件';
comment on column ${iol_schema}.mims_si_buildinginfo.sfxqf is '是否学区房';
comment on column ${iol_schema}.mims_si_buildinginfo.rjl is '容积率';
comment on column ${iol_schema}.mims_si_buildinginfo.sfdcq is '是否待拆迁';
comment on column ${iol_schema}.mims_si_buildinginfo.remark is '备注';
comment on column ${iol_schema}.mims_si_buildinginfo.pmbzyld is '平面布置优劣度';
comment on column ${iol_schema}.mims_si_buildinginfo.jg is '景观';
comment on column ${iol_schema}.mims_si_buildinginfo.jzjg is '建筑结构';
comment on column ${iol_schema}.mims_si_buildinginfo.account is '用户';
comment on column ${iol_schema}.mims_si_buildinginfo.createrdept is '';
comment on column ${iol_schema}.mims_si_buildinginfo.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_buildinginfo.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_buildinginfo.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_buildinginfo.etl_timestamp is 'ETL处理时间戳';
