/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_report_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_report_task
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_report_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_report_task(
    id number(18) -- 主键
    ,task_title varchar2(150) -- 任务标题
    ,task_status varchar2(3) -- 当前节点
    ,explain_advise varchar2(4000) -- 说明建议
    ,verification_opinion varchar2(4000) -- 核实意见
    ,executive_organ_id number(18) -- 任务执行机构
    ,task_level varchar2(3) -- 任务级别
    ,parent_organ_id number(18) -- 上级机构
    ,parent_task_id number(18) -- 上级任务
    ,task_create_date timestamp -- 创建时间
    ,task_report_date timestamp -- 上报时间
    ,task_update_date timestamp -- 修改时间
    ,is_delete varchar2(3) -- 是否删除
    ,curr_operator_id number(18) -- 当前操作人
    ,operator_entry_time timestamp -- 操作人进入时间
    ,business_date timestamp -- 业务日期
    ,curr_node_id number(18) -- 当前节点
    ,temp_verification_opinion varchar2(4000) -- 临时核实意见
    ,is_selected varchar2(3) -- 是否选中
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
grant select on ${iol_schema}.orws_t_report_task to ${iml_schema};
grant select on ${iol_schema}.orws_t_report_task to ${icl_schema};
grant select on ${iol_schema}.orws_t_report_task to ${idl_schema};
grant select on ${iol_schema}.orws_t_report_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_report_task is '日报上报任务表';
comment on column ${iol_schema}.orws_t_report_task.id is '主键';
comment on column ${iol_schema}.orws_t_report_task.task_title is '任务标题';
comment on column ${iol_schema}.orws_t_report_task.task_status is '当前节点';
comment on column ${iol_schema}.orws_t_report_task.explain_advise is '说明建议';
comment on column ${iol_schema}.orws_t_report_task.verification_opinion is '核实意见';
comment on column ${iol_schema}.orws_t_report_task.executive_organ_id is '任务执行机构';
comment on column ${iol_schema}.orws_t_report_task.task_level is '任务级别';
comment on column ${iol_schema}.orws_t_report_task.parent_organ_id is '上级机构';
comment on column ${iol_schema}.orws_t_report_task.parent_task_id is '上级任务';
comment on column ${iol_schema}.orws_t_report_task.task_create_date is '创建时间';
comment on column ${iol_schema}.orws_t_report_task.task_report_date is '上报时间';
comment on column ${iol_schema}.orws_t_report_task.task_update_date is '修改时间';
comment on column ${iol_schema}.orws_t_report_task.is_delete is '是否删除';
comment on column ${iol_schema}.orws_t_report_task.curr_operator_id is '当前操作人';
comment on column ${iol_schema}.orws_t_report_task.operator_entry_time is '操作人进入时间';
comment on column ${iol_schema}.orws_t_report_task.business_date is '业务日期';
comment on column ${iol_schema}.orws_t_report_task.curr_node_id is '当前节点';
comment on column ${iol_schema}.orws_t_report_task.temp_verification_opinion is '临时核实意见';
comment on column ${iol_schema}.orws_t_report_task.is_selected is '是否选中';
comment on column ${iol_schema}.orws_t_report_task.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_report_task.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_report_task.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_report_task.etl_timestamp is 'ETL处理时间戳';
