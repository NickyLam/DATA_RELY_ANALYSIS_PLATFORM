/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol itsm_aim_process_task_form
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.itsm_aim_process_task_form
whenever sqlerror continue none;
drop table ${iol_schema}.itsm_aim_process_task_form purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.itsm_aim_process_task_form(
    businesskey varchar2(96) -- 工单ID
    ,task_id varchar2(75) -- 任务ID
    ,form_name varchar2(150) -- 表单名称
    ,fields varchar2(4000) -- 表单内容
    ,lastupdatetime date -- 更新时间
    ,seq number(22) -- 同任务序号
    ,user_id varchar2(383) -- 处理人
    ,task_name varchar2(383) -- 任务节点
    ,form_type varchar2(2) -- 表单类型
    ,link_id varchar2(150) -- 关联ID
    ,form_html varchar2(4000) -- 表单配置
    ,is_use number(22) -- 是否已经使用过的数据
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
grant select on ${iol_schema}.itsm_aim_process_task_form to ${iml_schema};
grant select on ${iol_schema}.itsm_aim_process_task_form to ${icl_schema};
grant select on ${iol_schema}.itsm_aim_process_task_form to ${idl_schema};
grant select on ${iol_schema}.itsm_aim_process_task_form to ${iel_schema};

-- comment
comment on table ${iol_schema}.itsm_aim_process_task_form is '审批表单保存信息表';
comment on column ${iol_schema}.itsm_aim_process_task_form.businesskey is '工单ID';
comment on column ${iol_schema}.itsm_aim_process_task_form.task_id is '任务ID';
comment on column ${iol_schema}.itsm_aim_process_task_form.form_name is '表单名称';
comment on column ${iol_schema}.itsm_aim_process_task_form.fields is '表单内容';
comment on column ${iol_schema}.itsm_aim_process_task_form.lastupdatetime is '更新时间';
comment on column ${iol_schema}.itsm_aim_process_task_form.seq is '同任务序号';
comment on column ${iol_schema}.itsm_aim_process_task_form.user_id is '处理人';
comment on column ${iol_schema}.itsm_aim_process_task_form.task_name is '任务节点';
comment on column ${iol_schema}.itsm_aim_process_task_form.form_type is '表单类型';
comment on column ${iol_schema}.itsm_aim_process_task_form.link_id is '关联ID';
comment on column ${iol_schema}.itsm_aim_process_task_form.form_html is '表单配置';
comment on column ${iol_schema}.itsm_aim_process_task_form.is_use is '是否已经使用过的数据';
comment on column ${iol_schema}.itsm_aim_process_task_form.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.itsm_aim_process_task_form.etl_timestamp is 'ETL处理时间戳';
