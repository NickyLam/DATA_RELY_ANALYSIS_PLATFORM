/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amis_ac_account_project
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amis_ac_account_project
whenever sqlerror continue none;
drop table ${iol_schema}.amis_ac_account_project purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_account_project(
    ac_account_project_uuid varchar2(96) -- 主键
    ,account_type_code varchar2(96) -- 问责类型code
    ,account_type_desc varchar2(4000) -- 问责类型描述
    ,project_name varchar2(384) -- 关联项目
    ,acc_project_code varchar2(96) -- 问责项目编号
    ,account_item varchar2(4000) -- 问责事项
    ,description varchar2(4000) -- 基本情况
    ,loss_amount number(16,2) -- 损失金额
    ,remarks varchar2(4000) -- 备注
    ,account_imp_dept varchar2(384) -- 问责实施部门
    ,create_person_uuid varchar2(96) -- 创建人uuid
    ,create_person_name varchar2(384) -- 创建人姓名
    ,create_org_name varchar2(384) -- 创建人机构
    ,create_time date -- 创建时间
    ,create_org_uuid varchar2(96) -- 创建人机构uuid
    ,create_dept varchar2(384) -- 创建人部门
    ,create_dept_uuid varchar2(96) -- 创建人部门uuid
    ,state number(5,0) -- 审批状态
    ,current_node number(5,0) -- 当前阶段
    ,deleted number(5,0) -- 删除标志位
    ,ext1 varchar2(1500) -- 扩展字段
    ,ext2 varchar2(1500) -- 扩展字段
    ,ext3 varchar2(1500) -- 扩展字段
    ,client_code varchar2(96) -- 委托单位code
    ,client_desc varchar2(4000) -- 委托单位
    ,client_date timestamp -- 委托日期
    ,project_state number(5,0) -- 项目状态
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
grant select on ${iol_schema}.amis_ac_account_project to ${iml_schema};
grant select on ${iol_schema}.amis_ac_account_project to ${icl_schema};
grant select on ${iol_schema}.amis_ac_account_project to ${idl_schema};
grant select on ${iol_schema}.amis_ac_account_project to ${iel_schema};

-- comment
comment on table ${iol_schema}.amis_ac_account_project is '问责项目表';
comment on column ${iol_schema}.amis_ac_account_project.ac_account_project_uuid is '主键';
comment on column ${iol_schema}.amis_ac_account_project.account_type_code is '问责类型code';
comment on column ${iol_schema}.amis_ac_account_project.account_type_desc is '问责类型描述';
comment on column ${iol_schema}.amis_ac_account_project.project_name is '关联项目';
comment on column ${iol_schema}.amis_ac_account_project.acc_project_code is '问责项目编号';
comment on column ${iol_schema}.amis_ac_account_project.account_item is '问责事项';
comment on column ${iol_schema}.amis_ac_account_project.description is '基本情况';
comment on column ${iol_schema}.amis_ac_account_project.loss_amount is '损失金额';
comment on column ${iol_schema}.amis_ac_account_project.remarks is '备注';
comment on column ${iol_schema}.amis_ac_account_project.account_imp_dept is '问责实施部门';
comment on column ${iol_schema}.amis_ac_account_project.create_person_uuid is '创建人uuid';
comment on column ${iol_schema}.amis_ac_account_project.create_person_name is '创建人姓名';
comment on column ${iol_schema}.amis_ac_account_project.create_org_name is '创建人机构';
comment on column ${iol_schema}.amis_ac_account_project.create_time is '创建时间';
comment on column ${iol_schema}.amis_ac_account_project.create_org_uuid is '创建人机构uuid';
comment on column ${iol_schema}.amis_ac_account_project.create_dept is '创建人部门';
comment on column ${iol_schema}.amis_ac_account_project.create_dept_uuid is '创建人部门uuid';
comment on column ${iol_schema}.amis_ac_account_project.state is '审批状态';
comment on column ${iol_schema}.amis_ac_account_project.current_node is '当前阶段';
comment on column ${iol_schema}.amis_ac_account_project.deleted is '删除标志位';
comment on column ${iol_schema}.amis_ac_account_project.ext1 is '扩展字段';
comment on column ${iol_schema}.amis_ac_account_project.ext2 is '扩展字段';
comment on column ${iol_schema}.amis_ac_account_project.ext3 is '扩展字段';
comment on column ${iol_schema}.amis_ac_account_project.client_code is '委托单位code';
comment on column ${iol_schema}.amis_ac_account_project.client_desc is '委托单位';
comment on column ${iol_schema}.amis_ac_account_project.client_date is '委托日期';
comment on column ${iol_schema}.amis_ac_account_project.project_state is '项目状态';
comment on column ${iol_schema}.amis_ac_account_project.start_dt is '开始时间';
comment on column ${iol_schema}.amis_ac_account_project.end_dt is '结束时间';
comment on column ${iol_schema}.amis_ac_account_project.id_mark is '增删标志';
comment on column ${iol_schema}.amis_ac_account_project.etl_timestamp is 'ETL处理时间戳';
