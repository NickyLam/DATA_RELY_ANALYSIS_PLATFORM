/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_dev_devicesupplier_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_dev_devicesupplier_info
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_dev_devicesupplier_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_dev_devicesupplier_info(
    serviceprovnum varchar2(640) -- 服务商编号
    ,serviceprovname varchar2(240) -- 服务商名称
    ,cont varchar2(600) -- 联系人
    ,contactnum varchar2(88) -- 联系电话
    ,cellnum varchar2(88) -- 手机号
    ,contactaddr varchar2(800) -- 联系地址
    ,creator varchar2(10) -- 创建人
    ,creatorbrno varchar2(10) -- 创建人所属机构
    ,startdate varchar2(10) -- 创建日期
    ,starttime varchar2(10) -- 创建时间
    ,modifyuser varchar2(10) -- 最后修改人
    ,modifyuserbrno varchar2(10) -- 最后修改人所属机构
    ,modifdate varchar2(10) -- 最后修改日期
    ,modiftime varchar2(10) -- 最后修改时间
    ,defectsliabilityperiod varchar2(3) -- 保修期(月)
    ,web varchar2(50) -- 公司主页
    ,mailbox varchar2(256) -- 邮箱
    ,wechat varchar2(256) -- 微信
    ,note1 varchar2(512) -- 备注1
    ,note2 varchar2(512) -- 备注2
    ,note3 varchar2(512) -- 备注3
    ,note4 varchar2(512) -- 备注4
    ,note5 varchar2(512) -- 备注5
    ,simpvendorname varchar2(50) -- 厂商名称简称
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
grant select on ${iol_schema}.nibs_ib_dev_devicesupplier_info to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicesupplier_info to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicesupplier_info to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_dev_devicesupplier_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_dev_devicesupplier_info is '设备服务商信息表';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.serviceprovnum is '服务商编号';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.serviceprovname is '服务商名称';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.cont is '联系人';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.contactnum is '联系电话';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.cellnum is '手机号';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.contactaddr is '联系地址';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.creator is '创建人';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.creatorbrno is '创建人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.startdate is '创建日期';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.starttime is '创建时间';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.modifyuser is '最后修改人';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.modifyuserbrno is '最后修改人所属机构';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.modifdate is '最后修改日期';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.modiftime is '最后修改时间';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.defectsliabilityperiod is '保修期(月)';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.web is '公司主页';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.mailbox is '邮箱';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.wechat is '微信';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.note1 is '备注1';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.note2 is '备注2';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.note3 is '备注3';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.note4 is '备注4';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.note5 is '备注5';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.simpvendorname is '厂商名称简称';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_dev_devicesupplier_info.etl_timestamp is 'ETL处理时间戳';
