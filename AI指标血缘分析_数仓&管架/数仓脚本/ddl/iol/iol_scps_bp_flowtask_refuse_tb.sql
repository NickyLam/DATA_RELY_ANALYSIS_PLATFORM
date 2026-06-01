/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_flowtask_refuse_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_flowtask_refuse_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_flowtask_refuse_tb(
    task_id varchar2(50) -- 任务号
    ,tradecode varchar2(18) -- 交易码
    ,scene_code varchar2(20) -- 业务场景id
    ,begin_userno varchar2(10) -- 发起柜员
    ,begin_orgno varchar2(10) -- 发起机构
    ,trans_time varchar2(19) -- 交易时间
    ,trans_date varchar2(24) -- 交易日期
    ,doc_id varchar2(64) -- 影像流水号
    ,bank_no varchar2(10) -- 银行号
    ,system_no varchar2(10) -- 系统编号
    ,task_state varchar2(2) -- 业务处理状态
    ,account_no varchar2(100) -- 本行账号
    ,account_name varchar2(200) -- 本行名称
    ,end_time varchar2(19) -- 结束时间
    ,end_date varchar2(21) -- 结束日期
    ,refusal_reason varchar2(1024) -- 拒绝原因
    ,reason_of_error varchar2(3000) -- 差错认定原因（默认为空，由经办人员手工输入）
    ,mode_type varchar2(4) -- 作业模式 1-集中作业；2-远程授权
    ,error_status varchar2(4) -- 状态 1-待作业岗审核；2-待主管审核；3-通过
    ,branch_serial varchar2(64) -- 前台流水号
    ,error_identification_results varchar2(64) -- 差错认定结果(1-是,0-否)
    ,error_identification_classes varchar2(64) -- 差错认定分类
    ,remarks varchar2(500) -- 备注
    ,sqzg_user varchar2(64) -- 授权主管号
    ,operation_status varchar2(500) -- 操作状态 ：01-网点申请回退、02-中心申请回退
    ,problem_class varchar2(500) -- 问题分类
    ,channel_id varchar2(10) -- 渠道id
    ,trans_type varchar2(10) -- 业务大类
    ,y_task_id varchar2(50) -- 原任务号(重提交易)
    ,glob_seq_no varchar2(50) -- 流水号
    ,question_node varchar2(50) -- 问题节点
    ,begin_charge_id varchar2(50) -- 发起主管
    ,question_begin_user_no varchar2(50) -- 问题发起人员
    ,sub_task_id varchar2(50) -- 子任务号
    ,question_begin_date varchar2(14) -- 问题发起日期
    ,question_begin_time varchar2(19) -- 问题发起时间
    ,question_renson varchar2(1024) -- 问题原因
    ,issue_date varchar2(21) -- 发布日期
    ,issue_time varchar2(19) -- 发布时间
    ,approv_results varchar2(2) -- 审核认定结果
    ,approv_remarks varchar2(3000) -- 审核备注
    ,approv_reason varchar2(3000) -- 审核认定原因
    ,approv_status varchar2(2) -- 审批状态
    ,error_identification_remarks varchar2(3000) -- 差错认定备注
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
grant select on ${iol_schema}.scps_bp_flowtask_refuse_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_flowtask_refuse_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_flowtask_refuse_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_flowtask_refuse_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_flowtask_refuse_tb is '流程银行和远程授权退拒件表';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.tradecode is '交易码';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.scene_code is '业务场景id';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.begin_userno is '发起柜员';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.begin_orgno is '发起机构';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.trans_time is '交易时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.trans_date is '交易日期';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.doc_id is '影像流水号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.system_no is '系统编号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.task_state is '业务处理状态';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.account_no is '本行账号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.account_name is '本行名称';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.end_time is '结束时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.end_date is '结束日期';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.refusal_reason is '拒绝原因';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.reason_of_error is '差错认定原因（默认为空，由经办人员手工输入）';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.mode_type is '作业模式 1-集中作业；2-远程授权';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.error_status is '状态 1-待作业岗审核；2-待主管审核；3-通过';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.branch_serial is '前台流水号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.error_identification_results is '差错认定结果(1-是,0-否)';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.error_identification_classes is '差错认定分类';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.remarks is '备注';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.sqzg_user is '授权主管号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.operation_status is '操作状态 ：01-网点申请回退、02-中心申请回退';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.problem_class is '问题分类';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.channel_id is '渠道id';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.trans_type is '业务大类';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.y_task_id is '原任务号(重提交易)';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.glob_seq_no is '流水号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.question_node is '问题节点';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.begin_charge_id is '发起主管';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.question_begin_user_no is '问题发起人员';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.sub_task_id is '子任务号';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.question_begin_date is '问题发起日期';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.question_begin_time is '问题发起时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.question_renson is '问题原因';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.issue_date is '发布日期';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.issue_time is '发布时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.approv_results is '审核认定结果';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.approv_remarks is '审核备注';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.approv_reason is '审核认定原因';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.approv_status is '审批状态';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.error_identification_remarks is '差错认定备注';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_flowtask_refuse_tb.etl_timestamp is 'ETL处理时间戳';
