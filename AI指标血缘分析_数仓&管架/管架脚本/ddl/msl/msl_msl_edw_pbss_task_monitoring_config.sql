/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_pbss_task_monitoring_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pbss_task_monitoring_config
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pbss_task_monitoring_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pbss_task_monitoring_config(
    ETL_DT DATE
    ,id varchar2(32)
    ,task_monitoring_code varchar2(32)
    ,task_monitoring_name varchar2(200)
    ,star varchar2(32)
    ,task_monitoring_type varchar2(32)
    ,parent_id varchar2(32)
    ,ave_mission varchar2(10)
    ,tache_type varchar2(1)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pbss_task_monitoring_config to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pbss_task_monitoring_config is '';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.id is '主键';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.task_monitoring_code is '流程银行任务监控分类code';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.task_monitoring_name is '流程银行任务监控分类name';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.star is '分类状态[0:未配置,1:已配置]';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.task_monitoring_type is '流程银行任务监控分类[1:业务类型大类,2:业务类型明细,3:岗位]';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.parent_id is '业务类型明细所属大类ID';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.ave_mission is '人均待处理任务数';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.tache_type is '环节类型';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.start_dt is '开始日期';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.end_dt is '结束日期';
comment on column ${msl_schema}.msl_edw_pbss_task_monitoring_config.id_mark is '删除标识';
