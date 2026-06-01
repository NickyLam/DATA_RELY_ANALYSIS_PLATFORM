/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_ac_personduty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_ac_personduty
whenever sqlerror continue none;
drop table ${iol_schema}.amis_ac_personduty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_personduty(
    ac_personduty_uuid varchar2(96) -- 主键
    ,ac_project_uuid varchar2(96) -- 问责项目uuid
    ,personduty_name varchar2(383) -- 责任人名称
    ,active_code varchar2(96) -- 在职状态代码
    ,active_name varchar2(383) -- 在职状态名称
    ,sex varchar2(96) -- 性别
    ,old_orgname varchar2(383) -- 原所在机构
    ,old_station varchar2(383) -- 原岗位
    ,level_code varchar2(96) -- 责任人层级代码
    ,level_name varchar2(383) -- 责任人层级名称
    ,curr_org_uuid varchar2(96) -- 现所在机构UUID
    ,curr_org_name varchar2(383) -- 现所在机构名称
    ,curr_station varchar2(383) -- 现岗位
    ,duty_code　 varchar2(96) -- 免责标志代码
    ,duty_name varchar2(383) -- 免责标志名称
    ,reason_desc varchar2(4000) -- 免责理由描述
    ,create_person_uuid varchar2(96) -- 创建人UUID
    ,create_person_name varchar2(383) -- 创建人名称
    ,create_org_name varchar2(383) -- 创建人机构
    ,create_time　 timestamp -- 创建时间
    ,deleted number(1) -- 是否删除,1：删除，0未删除
    ,ac_project_code varchar2(384) -- 问责项目编号
    ,ac_project_name varchar2(383) -- 问责项目名称
    ,ext1 varchar2(383) -- 扩展字段1
    ,ext2 varchar2(383) -- 扩展字段2
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
grant select on ${iol_schema}.amis_ac_personduty to ${iml_schema};
grant select on ${iol_schema}.amis_ac_personduty to ${icl_schema};
grant select on ${iol_schema}.amis_ac_personduty to ${idl_schema};
grant select on ${iol_schema}.amis_ac_personduty to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_ac_personduty is '责任人信息表';
comment on column ${iol_schema}.amis_ac_personduty.ac_personduty_uuid is '主键';
comment on column ${iol_schema}.amis_ac_personduty.ac_project_uuid is '问责项目uuid';
comment on column ${iol_schema}.amis_ac_personduty.personduty_name is '责任人名称';
comment on column ${iol_schema}.amis_ac_personduty.active_code is '在职状态代码';
comment on column ${iol_schema}.amis_ac_personduty.active_name is '在职状态名称';
comment on column ${iol_schema}.amis_ac_personduty.sex is '性别';
comment on column ${iol_schema}.amis_ac_personduty.old_orgname is '原所在机构';
comment on column ${iol_schema}.amis_ac_personduty.old_station is '原岗位';
comment on column ${iol_schema}.amis_ac_personduty.level_code is '责任人层级代码';
comment on column ${iol_schema}.amis_ac_personduty.level_name is '责任人层级名称';
comment on column ${iol_schema}.amis_ac_personduty.curr_org_uuid is '现所在机构UUID';
comment on column ${iol_schema}.amis_ac_personduty.curr_org_name is '现所在机构名称';
comment on column ${iol_schema}.amis_ac_personduty.curr_station is '现岗位';
comment on column ${iol_schema}.amis_ac_personduty.duty_code　 is '免责标志代码';
comment on column ${iol_schema}.amis_ac_personduty.duty_name is '免责标志名称';
comment on column ${iol_schema}.amis_ac_personduty.reason_desc is '免责理由描述';
comment on column ${iol_schema}.amis_ac_personduty.create_person_uuid is '创建人UUID';
comment on column ${iol_schema}.amis_ac_personduty.create_person_name is '创建人名称';
comment on column ${iol_schema}.amis_ac_personduty.create_org_name is '创建人机构';
comment on column ${iol_schema}.amis_ac_personduty.create_time　 is '创建时间';
comment on column ${iol_schema}.amis_ac_personduty.deleted is '是否删除,1：删除，0未删除';
comment on column ${iol_schema}.amis_ac_personduty.ac_project_code is '问责项目编号';
comment on column ${iol_schema}.amis_ac_personduty.ac_project_name is '问责项目名称';
comment on column ${iol_schema}.amis_ac_personduty.ext1 is '扩展字段1';
comment on column ${iol_schema}.amis_ac_personduty.ext2 is '扩展字段2';
comment on column ${iol_schema}.amis_ac_personduty.start_dt is '开始时间';
comment on column ${iol_schema}.amis_ac_personduty.end_dt is '结束时间';
comment on column ${iol_schema}.amis_ac_personduty.id_mark is '增删标志';
comment on column ${iol_schema}.amis_ac_personduty.etl_timestamp is 'ETL处理时间戳';
