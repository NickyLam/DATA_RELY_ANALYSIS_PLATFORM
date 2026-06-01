/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_pbss_core_wf_workitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pbss_core_wf_workitem
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pbss_core_wf_workitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pbss_core_wf_workitem(
    ETL_DT DATE
    ,ID VARCHAR2(32)
    ,ENGINE_ADDRESS NUMBER(4,0)
    ,ROOT_ACT_ID VARCHAR2(32)
    ,PARENT_ACT_ID VARCHAR2(32)
    ,ACTIVITYPATH VARCHAR2(256)
    ,DESCRIPTION VARCHAR2(1500)
    ,STYLESHEET VARCHAR2(50)
    ,EXCLUDE_PARTICIPANT VARCHAR2(400)
    ,WORKQUEUE VARCHAR2(128)
    ,CREATED_TIME NUMBER(20,0)
    ,RECLAIM_DEADLINE_TIME NUMBER(20,0)
    ,OBTAIN_DEADLINE_TIME NUMBER(20,0)
    ,OBTAINED_TIME NUMBER(20,0)
    ,SUBMITED_TIME NUMBER(20,0)
    ,PAUSEED_TIME NUMBER(20,0)
    ,EXCEPTION_PAUSEED_TIME NUMBER(20,0)
    ,RESUMED_TIME NUMBER(20,0)
    ,FINISHED_TIME NUMBER(20,0)
    ,PARTICIPANT VARCHAR2(128)
    ,ISROLEMANAGER NUMBER(2,0)
    ,ORG_BUSINESS VARCHAR2(32)
    ,ORGANIZATIONALUNIT VARCHAR2(256)
    ,ORGANIZATIONALUNITTYPE VARCHAR2(128)
    ,ORGANIZATIONCLASSNAME VARCHAR2(256)
    ,OPERATOR VARCHAR2(128)
    ,STATE NUMBER(2,0)
    ,PRIORITY NUMBER(4,0)
    ,PROCESSTYPE VARCHAR2(15)
    ,OBTAINID VARCHAR2(50)
    ,INSTANCEPATH VARCHAR2(256)
    ,ACT_ID VARCHAR2(32)
    ,ACT_DEF_V_ID VARCHAR2(132)
    ,REF_ENTITY_ID VARCHAR2(50)
    ,CONDITION_DATA1 NUMBER(8,0)
    ,CONDITION_DATA2 NUMBER(8,0)
    ,CONDITION_DATA3 NUMBER(8,0)
    ,CONDITION_DATA4 NUMBER(8,0)
    ,SHARE_DATA1 VARCHAR2(2000)
    ,SHARE_DATA2 VARCHAR2(2000)
    ,SHARE_DATA3 NUMBER(17,2)
    ,SHARE_DATA4 DATE
    ,UPDATE_ASS VARCHAR2(32)
    ,ROOT_START_DATETIME NUMBER(20,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pbss_core_wf_workitem to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pbss_core_wf_workitem is '工作项';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ID is '工作项ID';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ENGINE_ADDRESS is '引擎地址';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ROOT_ACT_ID is '顶级流程实例ID';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.PARENT_ACT_ID is '父活动环节实例ID';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ACTIVITYPATH is '工作项所属的动作路径';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.DESCRIPTION is '工作项的描述信息';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.STYLESHEET is '工作项的显示样式表';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.EXCLUDE_PARTICIPANT is '排除的参与者（可以是逗号隔开的多人）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.WORKQUEUE is '工作队列';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.CREATED_TIME is '创建时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.RECLAIM_DEADLINE_TIME is '回收时间（超过这个时间点将被回收，实际也是完成的截止时间）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.OBTAIN_DEADLINE_TIME is '最后开始时间（获取的截止时间）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.OBTAINED_TIME is '获取时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.SUBMITED_TIME is '提交时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.PAUSEED_TIME is '挂起时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.EXCEPTION_PAUSEED_TIME is '异常挂起时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.RESUMED_TIME is '继续运行时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.FINISHED_TIME is '完成时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.PARTICIPANT is '法定参与者';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ISROLEMANAGER is '角色管理者标志';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ORG_BUSINESS is '业务机构';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ORGANIZATIONALUNIT is '作业中心';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ORGANIZATIONALUNITTYPE is '组织单元的类型';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ORGANIZATIONCLASSNAME is '映射组织模型的类';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.OPERATOR is '动作实际执行者';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.STATE is '状态(1=READY_STATE=就绪，2=FAILED_STATE=失败，3=RUNNING_STATE=运行，4=SUBMIT_STATE=提交，5=SUSPEND_STATE=挂起，9=DELAY_STATE=延后，10=FINISHED_STATE=完成，11=EXPIRED_STATE=超时，12=TERMINATED_STATE=终止，20=POOLED_STATE=池化)';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.PRIORITY is '优先级';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.PROCESSTYPE is '流程类型(COMMON_TYPE 普通型；PRODUCTION_TYPE 生产型)';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.OBTAINID is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.INSTANCEPATH is '父流程实例的ActivityPath';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ACT_ID is '活动实例';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ACT_DEF_V_ID is '活动定义';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.REF_ENTITY_ID is '相关实体id';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.CONDITION_DATA1 is '相关数据1（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.CONDITION_DATA2 is '相关数据2（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.CONDITION_DATA3 is '相关数据3（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.CONDITION_DATA4 is '相关数据4（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.SHARE_DATA1 is '相关数据5';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.SHARE_DATA2 is '相关数据6';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.SHARE_DATA3 is '相关数据7';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.SHARE_DATA4 is '相关数据8';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.UPDATE_ASS is '修改标记（冗余字段，用于当修改返回0时判定修改是否成功）';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ROOT_START_DATETIME is '数据日期';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_pbss_core_wf_workitem.ID_MARK is '增删标志';
