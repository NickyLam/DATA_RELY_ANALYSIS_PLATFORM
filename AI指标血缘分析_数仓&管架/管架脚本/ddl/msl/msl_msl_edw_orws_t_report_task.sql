/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_t_report_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_report_task
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_report_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_report_task(
    ETL_DT DATE
    ,id number(18)
    ,task_title varchar2(100)
    ,task_status varchar2(2)
    ,explain_advise varchar2(4000)
    ,verification_opinion varchar2(4000)
    ,executive_organ_id number(18)
    ,task_level varchar2(2)
    ,parent_organ_id number(18)
    ,parent_task_id number(18)
    ,task_create_date timestamp(6)
    ,task_report_date timestamp(6)
    ,task_update_date timestamp(6)
    ,is_delete varchar2(2)
    ,curr_operator_id number(18)
    ,operator_entry_time timestamp(6)
    ,business_date timestamp(6)
    ,curr_node_id number(18)
    ,temp_verification_opinion varchar2(4000)
    ,is_selected varchar2(2)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_report_task to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_report_task is '日报上报任务表';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.id is '主键';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_title is '任务标题';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_status is '当前节点';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.explain_advise is '说明建议';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.verification_opinion is '核实意见';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.executive_organ_id is '任务执行机构';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_level is '任务级别';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.parent_organ_id is '上级机构';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.parent_task_id is '上级任务';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_create_date is '创建时间';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_report_date is '上报时间';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.task_update_date is '修改时间';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.is_delete is '是否删除';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.curr_operator_id is '当前操作人';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.operator_entry_time is '操作人进入时间';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.business_date is '业务日期';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.curr_node_id is '当前节点';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.temp_verification_opinion is '临时核实意见';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.is_selected is '是否选中';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.start_dt is '开始日期';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.end_dt is '结束日期';
comment on column ${msl_schema}.msl_edw_orws_t_report_task.id_mark is '删除标识';
