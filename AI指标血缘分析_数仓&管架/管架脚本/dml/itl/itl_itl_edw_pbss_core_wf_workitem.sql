/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_core_wf_workitem
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_pbss_core_wf_workitem drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_core_wf_workitem drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_core_wf_workitem add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_core_wf_workitem partition for (to_date('${batch_date}','yyyymmdd')) (
    id -- 工作项ID
    ,engine_address -- 引擎地址
    ,root_act_id -- 顶级流程实例ID
    ,parent_act_id -- 父活动环节实例ID
    ,activitypath -- 工作项所属的动作路径
    ,description -- 工作项的描述信息
    ,stylesheet -- 工作项的显示样式表
    ,exclude_participant -- 排除的参与者（可以是逗号隔开的多人）
    ,workqueue -- 工作队列
    ,created_time -- 创建时间
    ,reclaim_deadline_time -- 回收时间（超过这个时间点将被回收，实际也是完成的截止时间）
    ,obtain_deadline_time -- 最后开始时间（获取的截止时间）
    ,obtained_time -- 获取时间
    ,submited_time -- 提交时间
    ,pauseed_time -- 挂起时间
    ,exception_pauseed_time -- 异常挂起时间
    ,resumed_time -- 继续运行时间
    ,finished_time -- 完成时间
    ,participant -- 法定参与者
    ,isrolemanager -- 角色管理者标志
    ,org_business -- 业务机构
    ,organizationalunit -- 作业中心
    ,organizationalunittype -- 组织单元的类型
    ,organizationclassname -- 映射组织模型的类
    ,operator -- 动作实际执行者
    ,state -- 状态(1=READY_STATE=就绪，2=FAILED_STATE=失败，3=RUNNING_STATE=运行，4=SUBMIT_STATE=提交，5=SUSPEND_STATE=挂起，9=DELAY_STATE=延后，10=FINISHED_STATE=完成，11=EXPIRED_STATE=超时，12=TERMINATED_STATE=终止，20=POOLED_STATE=池化)
    ,priority -- 优先级
    ,processtype -- 流程类型(COMMON_TYPE 普通型；PRODUCTION_TYPE 生产型)
    ,obtainid -- 数据日期
    ,instancepath -- 父流程实例的ActivityPath
    ,act_id -- 活动实例
    ,act_def_v_id -- 活动定义
    ,ref_entity_id -- 相关实体id
    ,condition_data1 -- 相关数据1（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data2 -- 相关数据2（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data3 -- 相关数据3（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,condition_data4 -- 相关数据4（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,share_data1 -- 相关数据5
    ,share_data2 -- 相关数据6
    ,share_data3 -- 相关数据7
    ,share_data4 -- 相关数据8
    ,update_ass -- 修改标记（冗余字段，用于当修改返回0时判定修改是否成功）
    ,root_start_datetime -- 数据日期
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(id), ' ') as id -- 工作项ID
    ,nvl(trim(engine_address), 0) as engine_address -- 引擎地址
    ,nvl(trim(root_act_id), ' ') as root_act_id -- 顶级流程实例ID
    ,nvl(trim(parent_act_id), ' ') as parent_act_id -- 父活动环节实例ID
    ,nvl(trim(activitypath), ' ') as activitypath -- 工作项所属的动作路径
    ,nvl(trim(description), ' ') as description -- 工作项的描述信息
    ,nvl(trim(stylesheet), ' ') as stylesheet -- 工作项的显示样式表
    ,nvl(trim(exclude_participant), ' ') as exclude_participant -- 排除的参与者（可以是逗号隔开的多人）
    ,nvl(trim(workqueue), ' ') as workqueue -- 工作队列
    ,nvl(trim(created_time), 0) as created_time -- 创建时间
    ,nvl(trim(reclaim_deadline_time), 0) as reclaim_deadline_time -- 回收时间（超过这个时间点将被回收，实际也是完成的截止时间）
    ,nvl(trim(obtain_deadline_time), 0) as obtain_deadline_time -- 最后开始时间（获取的截止时间）
    ,nvl(trim(obtained_time), 0) as obtained_time -- 获取时间
    ,nvl(trim(submited_time), 0) as submited_time -- 提交时间
    ,nvl(trim(pauseed_time), 0) as pauseed_time -- 挂起时间
    ,nvl(trim(exception_pauseed_time), 0) as exception_pauseed_time -- 异常挂起时间
    ,nvl(trim(resumed_time), 0) as resumed_time -- 继续运行时间
    ,nvl(trim(finished_time), 0) as finished_time -- 完成时间
    ,nvl(trim(participant), ' ') as participant -- 法定参与者
    ,nvl(trim(isrolemanager), 0) as isrolemanager -- 角色管理者标志
    ,nvl(trim(org_business), ' ') as org_business -- 业务机构
    ,nvl(trim(organizationalunit), ' ') as organizationalunit -- 作业中心
    ,nvl(trim(organizationalunittype), ' ') as organizationalunittype -- 组织单元的类型
    ,nvl(trim(organizationclassname), ' ') as organizationclassname -- 映射组织模型的类
    ,nvl(trim(operator), ' ') as operator -- 动作实际执行者
    ,nvl(trim(state), 0) as state -- 状态(1=READY_STATE=就绪，2=FAILED_STATE=失败，3=RUNNING_STATE=运行，4=SUBMIT_STATE=提交，5=SUSPEND_STATE=挂起，9=DELAY_STATE=延后，10=FINISHED_STATE=完成，11=EXPIRED_STATE=超时，12=TERMINATED_STATE=终止，20=POOLED_STATE=池化)
    ,nvl(trim(priority), 0) as priority -- 优先级
    ,nvl(trim(processtype), ' ') as processtype -- 流程类型(COMMON_TYPE 普通型；PRODUCTION_TYPE 生产型)
    ,nvl(trim(obtainid), ' ') as obtainid -- 数据日期
    ,nvl(trim(instancepath), ' ') as instancepath -- 父流程实例的ActivityPath
    ,nvl(trim(act_id), ' ') as act_id -- 活动实例
    ,nvl(trim(act_def_v_id), ' ') as act_def_v_id -- 活动定义
    ,nvl(trim(ref_entity_id), ' ') as ref_entity_id -- 相关实体id
    ,nvl(trim(condition_data1), 0) as condition_data1 -- 相关数据1（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,nvl(trim(condition_data2), 0) as condition_data2 -- 相关数据2（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,nvl(trim(condition_data3), 0) as condition_data3 -- 相关数据3（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,nvl(trim(condition_data4), 0) as condition_data4 -- 相关数据4（整型数据，在自动节点之间传递与覆盖规则为大数优先，应用场景是一票否决）
    ,nvl(trim(share_data1), ' ') as share_data1 -- 相关数据5
    ,nvl(trim(share_data2), ' ') as share_data2 -- 相关数据6
    ,nvl(trim(share_data3), 0) as share_data3 -- 相关数据7
    ,nvl(share_data4, to_date('00010101', 'yyyymmdd')) as share_data4 -- 相关数据8
    ,nvl(trim(update_ass), ' ') as update_ass -- 修改标记（冗余字段，用于当修改返回0时判定修改是否成功）
    ,nvl(trim(root_start_datetime), 0) as root_start_datetime -- 数据日期
    ,nvl(start_dt, to_date('00010101', 'yyyymmdd')) as start_dt -- 开始时间
    ,nvl(end_dt, to_date('00010101', 'yyyymmdd')) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_core_wf_workitem
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_core_wf_workitem to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_core_wf_workitem',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);