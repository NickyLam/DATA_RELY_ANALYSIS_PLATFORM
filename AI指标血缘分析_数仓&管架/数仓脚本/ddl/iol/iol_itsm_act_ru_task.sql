/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol itsm_act_ru_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.itsm_act_ru_task
whenever sqlerror continue none;
drop table ${iol_schema}.itsm_act_ru_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.itsm_act_ru_task(
    id_ varchar2(96) -- 任务序号
    ,rev_ number(22) -- 类型
    ,execution_id_ varchar2(96) -- 执行编号
    ,proc_inst_id_ varchar2(96) -- 任务句柄
    ,proc_def_id_ varchar2(96) -- 模型编号
    ,scope_id_ varchar2(383) -- 
    ,sub_scope_id_ varchar2(383) -- 
    ,scope_type_ varchar2(383) -- 
    ,scope_definition_id_ varchar2(383) -- 
    ,name_ varchar2(766) -- 节点名称
    ,parent_task_id_ varchar2(96) -- 父节点任务ID
    ,description_ varchar2(4000) -- 
    ,task_def_key_ varchar2(383) -- 节点编号
    ,owner_ varchar2(383) -- 原处理人
    ,assignee_ varchar2(383) -- 当前处理人
    ,delegation_ varchar2(96) -- 说明
    ,priority_ number(22) -- 权重
    ,create_time_ timestamp -- 任务开始时间
    ,due_date_ date -- 
    ,category_ varchar2(383) -- 
    ,suspension_state_ number(22) -- 悬挂状态
    ,tenant_id_ varchar2(383) -- 
    ,form_key_ varchar2(383) -- 
    ,claim_time_ date -- 告警时间
    ,is_count_enabled_ number(22) -- 是否计数
    ,var_count_ number(22) -- 计算值
    ,id_link_count_ number(22) -- 
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
grant select on ${iol_schema}.itsm_act_ru_task to ${iml_schema};
grant select on ${iol_schema}.itsm_act_ru_task to ${icl_schema};
grant select on ${iol_schema}.itsm_act_ru_task to ${idl_schema};
grant select on ${iol_schema}.itsm_act_ru_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.itsm_act_ru_task is '当前任务表';
comment on column ${iol_schema}.itsm_act_ru_task.id_ is '任务序号';
comment on column ${iol_schema}.itsm_act_ru_task.rev_ is '类型';
comment on column ${iol_schema}.itsm_act_ru_task.execution_id_ is '执行编号';
comment on column ${iol_schema}.itsm_act_ru_task.proc_inst_id_ is '任务句柄';
comment on column ${iol_schema}.itsm_act_ru_task.proc_def_id_ is '模型编号';
comment on column ${iol_schema}.itsm_act_ru_task.scope_id_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.sub_scope_id_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.scope_type_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.scope_definition_id_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.name_ is '节点名称';
comment on column ${iol_schema}.itsm_act_ru_task.parent_task_id_ is '父节点任务ID';
comment on column ${iol_schema}.itsm_act_ru_task.description_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.task_def_key_ is '节点编号';
comment on column ${iol_schema}.itsm_act_ru_task.owner_ is '原处理人';
comment on column ${iol_schema}.itsm_act_ru_task.assignee_ is '当前处理人';
comment on column ${iol_schema}.itsm_act_ru_task.delegation_ is '说明';
comment on column ${iol_schema}.itsm_act_ru_task.priority_ is '权重';
comment on column ${iol_schema}.itsm_act_ru_task.create_time_ is '任务开始时间';
comment on column ${iol_schema}.itsm_act_ru_task.due_date_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.category_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.suspension_state_ is '悬挂状态';
comment on column ${iol_schema}.itsm_act_ru_task.tenant_id_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.form_key_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.claim_time_ is '告警时间';
comment on column ${iol_schema}.itsm_act_ru_task.is_count_enabled_ is '是否计数';
comment on column ${iol_schema}.itsm_act_ru_task.var_count_ is '计算值';
comment on column ${iol_schema}.itsm_act_ru_task.id_link_count_ is '';
comment on column ${iol_schema}.itsm_act_ru_task.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.itsm_act_ru_task.etl_timestamp is 'ETL处理时间戳';
