/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_task_monitoring_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_task_monitoring_config
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_task_monitoring_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_task_monitoring_config(
    etl_dt date -- 数据日期
    ,id varchar2(32) -- 主键
    ,task_monitoring_code varchar2(32) -- 流程银行任务监控分类code
    ,task_monitoring_name varchar2(200) -- 流程银行任务监控分类name
    ,star varchar2(32) -- 分类状态[0:未配置,1:已配置]
    ,task_monitoring_type varchar2(32) -- 流程银行任务监控分类[1:业务类型大类,2:业务类型明细,3:岗位]
    ,parent_id varchar2(32) -- 业务类型明细所属大类ID
    ,ave_mission varchar2(10) -- 人均待处理任务数
    ,tache_type varchar2(1) -- 环节类型
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pbss_task_monitoring_config to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_task_monitoring_config is '';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.id is '主键';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.task_monitoring_code is '流程银行任务监控分类code';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.task_monitoring_name is '流程银行任务监控分类name';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.star is '分类状态[0:未配置,1:已配置]';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.task_monitoring_type is '流程银行任务监控分类[1:业务类型大类,2:业务类型明细,3:岗位]';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.parent_id is '业务类型明细所属大类ID';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.ave_mission is '人均待处理任务数';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.tache_type is '环节类型';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.start_dt is '开始日期';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.end_dt is '结束日期';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.id_mark is '删除标识';
comment on column ${itl_schema}.itl_edw_pbss_task_monitoring_config.etl_timestamp is 'ETL处理时间戳';