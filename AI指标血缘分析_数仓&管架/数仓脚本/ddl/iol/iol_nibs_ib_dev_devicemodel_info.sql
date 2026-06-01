/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_dev_devicemodel_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_dev_devicemodel_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_dev_devicemodel_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_devicemodel_info(
    devicemodel varchar2(80) -- 设备型号
    ,devicetypenum varchar2(800) -- 设备类型
    ,doyouneedgetin varchar2(5) -- 是否需领入 : 0-否 1-是 标志为是的则需要走激活流程
    ,devicebrand varchar2(180) -- 设备品牌
    ,serviceprovnum varchar2(800) -- 厂商编号
    ,devmodulelist varchar2(100) -- 模块列表
    ,devdisboxnum varchar2(100) -- 废钞箱个数
    ,devboxnum varchar2(100) -- 钞箱个数
    ,mainusernum varchar2(10) -- 创建人
    ,mainbranchnum varchar2(10) -- 创建人所属机构
    ,startdate varchar2(10) -- 创建日期
    ,starttime varchar2(10) -- 创建时间
    ,modifyuser varchar2(10) -- 最后修改人
    ,modifyuserbrno varchar2(10) -- 最后修改人所属机构
    ,modifdate varchar2(10) -- 最后修改日期
    ,modiftime varchar2(10) -- 最后修改时间
    ,defectsliabilityperiod varchar2(3) -- 保修期(月)
    ,note1 varchar2(640) -- 备注1
    ,note2 varchar2(640) -- 备注2
    ,note3 varchar2(640) -- 备注3
    ,note4 varchar2(640) -- 备注4
    ,note5 varchar2(640) -- 备注5
    ,devmodelid varchar2(160) -- 型号id
    ,devcardbox varchar2(100) -- 卡箱个数
    ,creator varchar2(10) -- 创建人
    ,creatorbrno varchar2(10) -- 创建人所属机构
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nibs_ib_dev_devicemodel_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicemodel_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicemodel_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicemodel_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_dev_devicemodel_info is '设备型号表';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devicemodel is '设备型号';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devicetypenum is '设备类型';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.doyouneedgetin is '是否需领入 : 0-否 1-是 标志为是的则需要走激活流程';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devicebrand is '设备品牌';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.serviceprovnum is '厂商编号';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devmodulelist is '模块列表';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devdisboxnum is '废钞箱个数';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devboxnum is '钞箱个数';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.mainusernum is '创建人';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.mainbranchnum is '创建人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.startdate is '创建日期';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.starttime is '创建时间';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.modifyuser is '最后修改人';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.modifyuserbrno is '最后修改人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.modifdate is '最后修改日期';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.modiftime is '最后修改时间';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.defectsliabilityperiod is '保修期(月)';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.note1 is '备注1';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.note2 is '备注2';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.note3 is '备注3';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.note4 is '备注4';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.note5 is '备注5';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devmodelid is '型号id';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.devcardbox is '卡箱个数';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.creator is '创建人';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.creatorbrno is '创建人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_dev_devicemodel_info.etl_timestamp is 'ETL处理时间戳';
