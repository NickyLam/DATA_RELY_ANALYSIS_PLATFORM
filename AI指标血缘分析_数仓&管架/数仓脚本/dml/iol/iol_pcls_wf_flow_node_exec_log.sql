/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pcls_wf_flow_node_exec_log
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pcls_wf_flow_node_exec_log_ex purge;
alter table ${iol_schema}.pcls_wf_flow_node_exec_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pcls_wf_flow_node_exec_log;

-- 2.3 insert data to ex table
create table ${iol_schema}.pcls_wf_flow_node_exec_log_ex nologging
compress
as
select * from ${iol_schema}.pcls_wf_flow_node_exec_log where 0=1;

insert /*+ append */ into ${iol_schema}.pcls_wf_flow_node_exec_log_ex(
    id -- 主键
    ,log_no -- 执行记录编码
    ,flow_no -- 工作流流程号
    ,node_no -- 节点编码
    ,biz_no -- 主申请编号
    ,sub_biz_no -- 子申请编号
    ,org_no -- 所属机构编号
    ,sub_org_no -- 子机构编码
    ,channel_no -- 所属渠道
    ,product_code -- 所属产品
    ,biz_type -- 流程类型APPL/DRAW/CAS/xx待定
    ,sub_biz_type -- 子流程类型
    ,instance_no -- 工作流实例编号
    ,exec_status -- WAITTING：等待执行，RUNNING：执行中,FINISH:执行结束,FAIL:失败,HANG_UP：挂起,BLOCK：异常挂起
    ,exec_fail_num -- 异常次数
    ,params -- 上下文变量
    ,date_begin -- 开始时间
    ,date_end -- 结束时间
    ,date_created -- 创建时间
    ,created_by -- 创建人
    ,date_updated -- 修改时间
    ,updated_by -- 修改人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键
    ,log_no -- 执行记录编码
    ,flow_no -- 工作流流程号
    ,node_no -- 节点编码
    ,biz_no -- 主申请编号
    ,sub_biz_no -- 子申请编号
    ,org_no -- 所属机构编号
    ,sub_org_no -- 子机构编码
    ,channel_no -- 所属渠道
    ,product_code -- 所属产品
    ,biz_type -- 流程类型APPL/DRAW/CAS/xx待定
    ,sub_biz_type -- 子流程类型
    ,instance_no -- 工作流实例编号
    ,exec_status -- WAITTING：等待执行，RUNNING：执行中,FINISH:执行结束,FAIL:失败,HANG_UP：挂起,BLOCK：异常挂起
    ,exec_fail_num -- 异常次数
    ,params -- 上下文变量
    ,date_begin -- 开始时间
    ,date_end -- 结束时间
    ,date_created -- 创建时间
    ,created_by -- 创建人
    ,date_updated -- 修改时间
    ,updated_by -- 修改人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pcls_wf_flow_node_exec_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pcls_wf_flow_node_exec_log exchange partition p_${batch_date} with table ${iol_schema}.pcls_wf_flow_node_exec_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pcls_wf_flow_node_exec_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pcls_wf_flow_node_exec_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pcls_wf_flow_node_exec_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);