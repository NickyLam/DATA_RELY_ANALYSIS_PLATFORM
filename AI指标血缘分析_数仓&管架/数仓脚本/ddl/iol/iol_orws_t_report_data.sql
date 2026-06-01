/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_report_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_report_data
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_report_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_report_data(
    id number(18) -- 主键
    ,bmc_id number(18) -- 业务监测内容
    ,yesterday_condition varchar2(4000) -- 当天情况
    ,sb_confirmation_feedback varchar2(4000) -- 详情确认反馈支行上报
    ,bb_confirmation_feedback varchar2(4000) -- 详情确认反馈分行上报
    ,hb_confirmation_feedback varchar2(4000) -- 详情确认反馈总行上报
    ,is_count varchar2(3) -- 是否汇总
    ,mmd_id number(18) -- 模型监控数据编号
    ,executive_organ_id number(18) -- 任务执行机构
    ,rdata_level varchar2(3) -- 数据级别
    ,task_id number(18) -- 任务id
    ,rdata_status varchar2(3) -- 数据状态
    ,problem_id number(18) -- 问题流程编号
    ,flow_up_status number(1) -- 是否后续跟踪
    ,risk_level number(18) -- 风险等级
    ,approve_status number(18) -- 审批状态
    ,reportto_node_id number(18) -- 上报节点
    ,business_date varchar2(27) -- 业务日期
    ,templatetype_id varchar2(150) -- 模板id
    ,sb_status_feedback varchar2(3) -- 是否正常支行上报
    ,bb_status_feedback varchar2(3) -- 是否正常分行上报
    ,hb_status_feedback varchar2(3) -- 是否正常总行上报
    ,is_overdue number(1) -- 是否超期处理
    ,upgrade_date timestamp -- 风险升级日期
    ,approve_days number(5) -- 处理天数
    ,flow_up_id number(18) -- 跟进数据id
    ,approve_date timestamp -- 数据处理日期
    ,is_manualup number(1) -- 是否手动升级
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
grant select on ${iol_schema}.orws_t_report_data to ${iml_schema};
grant select on ${iol_schema}.orws_t_report_data to ${icl_schema};
grant select on ${iol_schema}.orws_t_report_data to ${idl_schema};
grant select on ${iol_schema}.orws_t_report_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_report_data is '日报上报数据表';
comment on column ${iol_schema}.orws_t_report_data.id is '主键';
comment on column ${iol_schema}.orws_t_report_data.bmc_id is '业务监测内容';
comment on column ${iol_schema}.orws_t_report_data.yesterday_condition is '当天情况';
comment on column ${iol_schema}.orws_t_report_data.sb_confirmation_feedback is '详情确认反馈支行上报';
comment on column ${iol_schema}.orws_t_report_data.bb_confirmation_feedback is '详情确认反馈分行上报';
comment on column ${iol_schema}.orws_t_report_data.hb_confirmation_feedback is '详情确认反馈总行上报';
comment on column ${iol_schema}.orws_t_report_data.is_count is '是否汇总';
comment on column ${iol_schema}.orws_t_report_data.mmd_id is '模型监控数据编号';
comment on column ${iol_schema}.orws_t_report_data.executive_organ_id is '任务执行机构';
comment on column ${iol_schema}.orws_t_report_data.rdata_level is '数据级别';
comment on column ${iol_schema}.orws_t_report_data.task_id is '任务id';
comment on column ${iol_schema}.orws_t_report_data.rdata_status is '数据状态';
comment on column ${iol_schema}.orws_t_report_data.problem_id is '问题流程编号';
comment on column ${iol_schema}.orws_t_report_data.flow_up_status is '是否后续跟踪';
comment on column ${iol_schema}.orws_t_report_data.risk_level is '风险等级';
comment on column ${iol_schema}.orws_t_report_data.approve_status is '审批状态';
comment on column ${iol_schema}.orws_t_report_data.reportto_node_id is '上报节点';
comment on column ${iol_schema}.orws_t_report_data.business_date is '业务日期';
comment on column ${iol_schema}.orws_t_report_data.templatetype_id is '模板id';
comment on column ${iol_schema}.orws_t_report_data.sb_status_feedback is '是否正常支行上报';
comment on column ${iol_schema}.orws_t_report_data.bb_status_feedback is '是否正常分行上报';
comment on column ${iol_schema}.orws_t_report_data.hb_status_feedback is '是否正常总行上报';
comment on column ${iol_schema}.orws_t_report_data.is_overdue is '是否超期处理';
comment on column ${iol_schema}.orws_t_report_data.upgrade_date is '风险升级日期';
comment on column ${iol_schema}.orws_t_report_data.approve_days is '处理天数';
comment on column ${iol_schema}.orws_t_report_data.flow_up_id is '跟进数据id';
comment on column ${iol_schema}.orws_t_report_data.approve_date is '数据处理日期';
comment on column ${iol_schema}.orws_t_report_data.is_manualup is '是否手动升级';
comment on column ${iol_schema}.orws_t_report_data.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_report_data.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_report_data.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_report_data.etl_timestamp is 'ETL处理时间戳';
