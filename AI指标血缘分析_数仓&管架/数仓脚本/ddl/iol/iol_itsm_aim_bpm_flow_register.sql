/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol itsm_aim_bpm_flow_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.itsm_aim_bpm_flow_register
whenever sqlerror continue none;
drop table ${iol_schema}.itsm_aim_bpm_flow_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.itsm_aim_bpm_flow_register(
    business_key varchar2(96) -- 业务主键
    ,topicname varchar2(766) -- 流程主题
    ,username varchar2(96) -- 发起人
    ,nickname varchar2(96) -- 发起人中文名称
    ,department varchar2(96) -- 发起人部门
    ,create_time date -- 创建时间
    ,update_time date -- 最后修改日期
    ,status varchar2(2) -- 状态
    ,category_id varchar2(383) -- 模板分类ID
    ,category_name varchar2(600) -- 模板分类名称
    ,model_id varchar2(150) -- 流程模板ID
    ,model_key varchar2(150) -- 流程模板KEY
    ,model_name varchar2(300) -- 流程模板中文名称
    ,flowtype varchar2(2) -- 流程类型
    ,procdef_id varchar2(300) -- 模板部署ID
    ,parent_key varchar2(45) -- 父级ID
    ,unique_key varchar2(45) -- 外键
    ,source_system number(22) -- 流程来源系统
    ,priority varchar2(2) -- 优先级
    ,flowsafe varchar2(2) -- 是否安全事件
    ,serial_str varchar2(96) -- 自定义规则的流水字符串
    ,serial_number varchar2(96) -- 自定义规则的流水号
    ,is_delete number(22) -- 是否删除
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
grant select on ${iol_schema}.itsm_aim_bpm_flow_register to ${iml_schema};
grant select on ${iol_schema}.itsm_aim_bpm_flow_register to ${icl_schema};
grant select on ${iol_schema}.itsm_aim_bpm_flow_register to ${idl_schema};
grant select on ${iol_schema}.itsm_aim_bpm_flow_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.itsm_aim_bpm_flow_register is '流程登记表';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.business_key is '业务主键';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.topicname is '流程主题';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.username is '发起人';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.nickname is '发起人中文名称';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.department is '发起人部门';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.create_time is '创建时间';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.update_time is '最后修改日期';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.status is '状态';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.category_id is '模板分类ID';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.category_name is '模板分类名称';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.model_id is '流程模板ID';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.model_key is '流程模板KEY';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.model_name is '流程模板中文名称';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.flowtype is '流程类型';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.procdef_id is '模板部署ID';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.parent_key is '父级ID';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.unique_key is '外键';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.source_system is '流程来源系统';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.priority is '优先级';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.flowsafe is '是否安全事件';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.serial_str is '自定义规则的流水字符串';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.serial_number is '自定义规则的流水号';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.is_delete is '是否删除';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.itsm_aim_bpm_flow_register.etl_timestamp is 'ETL处理时间戳';
