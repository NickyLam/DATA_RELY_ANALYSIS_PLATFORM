/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_ac_project_punishment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_ac_project_punishment
whenever sqlerror continue none;
drop table ${iol_schema}.amis_ac_project_punishment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_project_punishment(
    ac_project_punishment_uuid varchar2(96) -- 处分uuid
    ,nishment_code varchar2(96) -- 处分编号
    ,ac_project_uuid varchar2(96) -- 问责项目uuid
    ,personduty_name varchar2(96) -- 责任人名称
    ,ac_personduty_uuid varchar2(96) -- 责任人记录id
    ,old_orgname varchar2(383) -- 原所在机构
    ,old_station varchar2(383) -- 原岗位
    ,curr_org_uuid varchar2(96) -- 现所在机构uuid
    ,curr_org_name varchar2(383) -- 现所在机构名称
    ,curr_station varchar2(383) -- 现岗位
    ,ac_project_name varchar2(383) -- 问责项目名称
    ,account_number varchar2(383) -- 问责文号
    ,dispatch_uuid varchar2(96) -- 发文uuid
    ,dispatch_name varchar2(383) -- 发文标题
    ,dispatch_org varchar2(384) -- 发文单位
    ,dispatch_time timestamp -- 发文时间
    ,punishment_type varchar2(384) -- 处分类型
    ,disciplinary_punishment varchar2(384) -- 纪律处分
    ,economic_punishment varchar2(384) -- 经济处罚
    ,organization_punishment varchar2(384) -- 组织处理
    ,other_punishment varchar2(384) -- 其他处分
    ,exemption_punishment varchar2(4000) -- 免于处分原因
    ,punishment_reason varchar2(4000) -- 处分原因
    ,exe_org_uuid varchar2(96) -- 执行机构uuid
    ,exe_org_name varchar2(384) -- 执行机构名称
    ,create_person_uuid varchar2(96) -- 处分录入人uuid
    ,create_person_name varchar2(96) -- 处分录入人名称
    ,create_date timestamp -- 处分录入时间
    ,exe_date timestamp -- 提交执行时间
    ,create_org_uuid varchar2(96) -- 处分录入机构uuid
    ,create_org_name varchar2(384) -- 处分录入机构
    ,deleted number(1,0) -- 删除标识
    ,punishment_ext1 varchar2(4000) -- 扩展字段1
    ,punishment_ext2 varchar2(4000) -- 扩展字段2
    ,punishment_type_code varchar2(384) -- 处分类型code
    ,punishment_ext3 varchar2(384) -- 扩展字段3
    ,punishment_ext4 varchar2(384) -- 扩展字段4
    ,punishment_ext5 varchar2(384) -- 扩展字段5
    ,status number(1,0) -- 状态
    ,disciplinary_punishment_code varchar2(96) -- 纪律处分code
    ,organization_punishment_code varchar2(96) -- 组织处理code
    ,other_punishment_code varchar2(96) -- 其他处分code
    ,punishment_accordance varchar2(4000) -- 处分依据
    ,disciplinary_punishment_deadline varchar2(96) -- 纪律处分期限
    ,disciplinary_punishment_start_time timestamp -- 纪律处分处罚时间
    ,disciplinary_punishment_end_time timestamp -- 纪律处分解除时间
    ,organization_punishment_deadline varchar2(96) -- 组织处理期限
    ,organization_punishment_start_time timestamp -- 组织处理处罚时间
    ,organization_punishment_end_time timestamp -- 组织处理解除时间
    ,other_punishment_desc varchar2(300) -- 处分具体处分
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
grant select on ${iol_schema}.amis_ac_project_punishment to ${iml_schema};
grant select on ${iol_schema}.amis_ac_project_punishment to ${icl_schema};
grant select on ${iol_schema}.amis_ac_project_punishment to ${idl_schema};
grant select on ${iol_schema}.amis_ac_project_punishment to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_ac_project_punishment is '问责项目处分录入表';
comment on column ${iol_schema}.amis_ac_project_punishment.ac_project_punishment_uuid is '处分uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.nishment_code is '处分编号';
comment on column ${iol_schema}.amis_ac_project_punishment.ac_project_uuid is '问责项目uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.personduty_name is '责任人名称';
comment on column ${iol_schema}.amis_ac_project_punishment.ac_personduty_uuid is '责任人记录id';
comment on column ${iol_schema}.amis_ac_project_punishment.old_orgname is '原所在机构';
comment on column ${iol_schema}.amis_ac_project_punishment.old_station is '原岗位';
comment on column ${iol_schema}.amis_ac_project_punishment.curr_org_uuid is '现所在机构uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.curr_org_name is '现所在机构名称';
comment on column ${iol_schema}.amis_ac_project_punishment.curr_station is '现岗位';
comment on column ${iol_schema}.amis_ac_project_punishment.ac_project_name is '问责项目名称';
comment on column ${iol_schema}.amis_ac_project_punishment.account_number is '问责文号';
comment on column ${iol_schema}.amis_ac_project_punishment.dispatch_uuid is '发文uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.dispatch_name is '发文标题';
comment on column ${iol_schema}.amis_ac_project_punishment.dispatch_org is '发文单位';
comment on column ${iol_schema}.amis_ac_project_punishment.dispatch_time is '发文时间';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_type is '处分类型';
comment on column ${iol_schema}.amis_ac_project_punishment.disciplinary_punishment is '纪律处分';
comment on column ${iol_schema}.amis_ac_project_punishment.economic_punishment is '经济处罚';
comment on column ${iol_schema}.amis_ac_project_punishment.organization_punishment is '组织处理';
comment on column ${iol_schema}.amis_ac_project_punishment.other_punishment is '其他处分';
comment on column ${iol_schema}.amis_ac_project_punishment.exemption_punishment is '免于处分原因';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_reason is '处分原因';
comment on column ${iol_schema}.amis_ac_project_punishment.exe_org_uuid is '执行机构uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.exe_org_name is '执行机构名称';
comment on column ${iol_schema}.amis_ac_project_punishment.create_person_uuid is '处分录入人uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.create_person_name is '处分录入人名称';
comment on column ${iol_schema}.amis_ac_project_punishment.create_date is '处分录入时间';
comment on column ${iol_schema}.amis_ac_project_punishment.exe_date is '提交执行时间';
comment on column ${iol_schema}.amis_ac_project_punishment.create_org_uuid is '处分录入机构uuid';
comment on column ${iol_schema}.amis_ac_project_punishment.create_org_name is '处分录入机构';
comment on column ${iol_schema}.amis_ac_project_punishment.deleted is '删除标识';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_ext1 is '扩展字段1';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_ext2 is '扩展字段2';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_type_code is '处分类型code';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_ext3 is '扩展字段3';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_ext4 is '扩展字段4';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_ext5 is '扩展字段5';
comment on column ${iol_schema}.amis_ac_project_punishment.status is '状态';
comment on column ${iol_schema}.amis_ac_project_punishment.disciplinary_punishment_code is '纪律处分code';
comment on column ${iol_schema}.amis_ac_project_punishment.organization_punishment_code is '组织处理code';
comment on column ${iol_schema}.amis_ac_project_punishment.other_punishment_code is '其他处分code';
comment on column ${iol_schema}.amis_ac_project_punishment.punishment_accordance is '处分依据';
comment on column ${iol_schema}.amis_ac_project_punishment.disciplinary_punishment_deadline is '纪律处分期限';
comment on column ${iol_schema}.amis_ac_project_punishment.disciplinary_punishment_start_time is '纪律处分处罚时间';
comment on column ${iol_schema}.amis_ac_project_punishment.disciplinary_punishment_end_time is '纪律处分解除时间';
comment on column ${iol_schema}.amis_ac_project_punishment.organization_punishment_deadline is '组织处理期限';
comment on column ${iol_schema}.amis_ac_project_punishment.organization_punishment_start_time is '组织处理处罚时间';
comment on column ${iol_schema}.amis_ac_project_punishment.organization_punishment_end_time is '组织处理解除时间';
comment on column ${iol_schema}.amis_ac_project_punishment.other_punishment_desc is '处分具体处分';
comment on column ${iol_schema}.amis_ac_project_punishment.start_dt is '开始时间';
comment on column ${iol_schema}.amis_ac_project_punishment.end_dt is '结束时间';
comment on column ${iol_schema}.amis_ac_project_punishment.id_mark is '增删标志';
comment on column ${iol_schema}.amis_ac_project_punishment.etl_timestamp is 'ETL处理时间戳';
