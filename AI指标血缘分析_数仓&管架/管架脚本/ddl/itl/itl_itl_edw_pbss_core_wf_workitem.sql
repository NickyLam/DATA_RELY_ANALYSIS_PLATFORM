/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_core_wf_workitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_core_wf_workitem
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_core_wf_workitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_core_wf_workitem(
    id varchar2(32) -- 工作项ID
    ,engine_address number(4,0) -- 引擎地址
    ,root_act_id varchar2(32) -- 顶级流程实例ID
    ,parent_act_id varchar2(32) -- 父活动环节实例ID
    ,activitypath varchar2(256) -- 工作项所属的动作路径
    ,description varchar2(1500) -- 工作项的描述信息
    ,stylesheet varchar2(50) -- 工作项的显示样式表
    ,exclude_participant varchar2(400) -- 排除的参与者（可以是逗号隔开的多人）
    ,workqueue varchar2(128) -- 工作队列
    ,created_time number(20,0) -- 创建时间
    ,reclaim_deadline_time number(20,0) -- 回收时间（超过这个时间点将被回收，实际也是完成的截止时间）
    ,obtain_deadline_time number(20,0) -- 最后开始时间（获取的截止时间）
    ,obtained_time number(20,0) -- 获取时间
    ,submited_time number(20,0) -- 提交时间
    ,pauseed_time number(20,0) -- 挂起时间
    ,exception_pauseed_time number(20,0) -- 异常挂起时间
    ,resumed_time number(20,0) -- 继续运行时间
    ,finished_time number(20,0) -- 完成时间
    ,participant varchar2(128) -- 法定参与者
    ,isrolemanager number(2,0) -- 角色管理者标志
    ,org_business varchar2(32) -- 业务机构
    ,organizationalunit varchar2(256) -- 作业中心
    ,organizationalunittype varchar2(128) -- 组织单元的类型
    ,organizationclassname varchar2(256) -- 映射组织模型的类
    ,operator varchar2(128) -- 动作实际执行者
    ,state number(2,0) -- 状态(1=READY_STATE=就绪，2=FAILED_STATE=失败，3=RUNNING_STATE=运行，4=SUBMIT_STATE=提交，5=SUSPEND_STATE=挂起，9=DELAY_STATE=延后，10=FINISHED_STATE=完成，11=EXPIRED_STATE=超时，12=TERMINATED_STATE=终止，20=POOLED_STATE=池化)
    ,priority number(4,0) -- 优先级
    ,processtype varchar2(15) -- 流程类型(COMMON_TYPE 普通型；PRODUCTION_TYPE 生产型)
    ,obtainid varchar2(50) -- 数据日期
    ,instancepath varchar2(256) -- 父流程实例的ActivityPath
    ,act_id varchar2(32) -- 活动实例
    ,act_def_v_id varchar2(132) -- 活动定义
    ,ref_entity_id varchar2(50) -- 相关实体id
    ,condition_data1 number(8,0) -- 相关数据1（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data2 number(8,0) -- 相关数据2（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data3 number(8,0) -- 相关数据3（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data4 number(8,0) -- 相关数据4（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,share_data1 varchar2(2000) -- 相关数据5
    ,share_data2 varchar2(2000) -- 相关数据6
    ,share_data3 number(17,2) -- 相关数据7
    ,share_data4 date -- 相关数据8
    ,update_ass varchar2(32) -- 修改标记（冗余字段，用于当修改返回0时判定修改是否成功）
    ,root_start_datetime number(20,0) -- 数据日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
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
grant select on ${itl_schema}.itl_edw_pbss_core_wf_workitem to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_core_wf_workitem is '工作项';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.id is '工作项ID';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.engine_address is '引擎地址';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.root_act_id is '顶级流程实例ID';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.parent_act_id is '父活动环节实例ID';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.activitypath is '工作项所属的动作路径';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.description is '工作项的描述信息';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.stylesheet is '工作项的显示样式表';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.exclude_participant is '排除的参与者（可以是逗号隔开的多人）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.workqueue is '工作队列';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.created_time is '创建时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.reclaim_deadline_time is '回收时间（超过这个时间点将被回收，实际也是完成的截止时间）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.obtain_deadline_time is '最后开始时间（获取的截止时间）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.obtained_time is '获取时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.submited_time is '提交时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.pauseed_time is '挂起时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.exception_pauseed_time is '异常挂起时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.resumed_time is '继续运行时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.finished_time is '完成时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.participant is '法定参与者';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.isrolemanager is '角色管理者标志';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.org_business is '业务机构';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.organizationalunit is '作业中心';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.organizationalunittype is '组织单元的类型';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.organizationclassname is '映射组织模型的类';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.operator is '动作实际执行者';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.state is '状态(1=READY_STATE=就绪，2=FAILED_STATE=失败，3=RUNNING_STATE=运行，4=SUBMIT_STATE=提交，5=SUSPEND_STATE=挂起，9=DELAY_STATE=延后，10=FINISHED_STATE=完成，11=EXPIRED_STATE=超时，12=TERMINATED_STATE=终止，20=POOLED_STATE=池化)';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.priority is '优先级';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.processtype is '流程类型(COMMON_TYPE 普通型；PRODUCTION_TYPE 生产型)';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.obtainid is '数据日期';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.instancepath is '父流程实例的ActivityPath';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.act_id is '活动实例';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.act_def_v_id is '活动定义';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.ref_entity_id is '相关实体id';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.condition_data1 is '相关数据1（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.condition_data2 is '相关数据2（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.condition_data3 is '相关数据3（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.condition_data4 is '相关数据4（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.share_data1 is '相关数据5';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.share_data2 is '相关数据6';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.share_data3 is '相关数据7';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.share_data4 is '相关数据8';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.update_ass is '修改标记（冗余字段，用于当修改返回0时判定修改是否成功）';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.root_start_datetime is '数据日期';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pbss_core_wf_workitem.etl_timestamp is 'ETL处理时间戳';