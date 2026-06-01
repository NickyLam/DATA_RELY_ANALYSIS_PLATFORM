/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_tbl_task_his
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
drop table ${iol_schema}.bdms_tbl_task_his_ex purge;
alter table ${iol_schema}.bdms_tbl_task_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdms_tbl_task_his truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdms_tbl_task_his_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_tbl_task_his where 0=1;

insert /*+ append */ into ${iol_schema}.bdms_tbl_task_his_ex(
    id -- 主键ID
    ,task_id -- 任务编号
    ,process_id -- 流程实例编号
    ,node_id -- 节点编号
    ,task_name -- 任务名称
    ,task_flag -- 任务完成标志
    ,assign_id -- 操作员编号
    ,task_description -- 审批描述
    ,task_comment -- 备注
    ,create_time -- 创建时间
    ,taked_time -- 领用时间
    ,deal_time -- 处理时间
    ,name1 -- 备用字段1
    ,name2 -- 业务批次ID
    ,name3 -- 备用字段3
    ,name4 -- 业务汇总金额
    ,name5 -- 业务机构编号
    ,name6 -- 上级机构编号
    ,name7 -- 备用字段7
    ,name8 -- 备用字段8
    ,task_mark -- 任务备注
    ,protocol_no -- 业务协议编号
    ,contract_id -- 业务批次ID
    ,node_name -- 节点名称
    ,assign_name -- 操作员名称
    ,parent_id -- 父节点ID
    ,approve_flag -- 审批意见: 1-同意 2-拒绝 3-退回
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 主键ID
    ,task_id -- 任务编号
    ,process_id -- 流程实例编号
    ,node_id -- 节点编号
    ,task_name -- 任务名称
    ,task_flag -- 任务完成标志
    ,assign_id -- 操作员编号
    ,task_description -- 审批描述
    ,task_comment -- 备注
    ,create_time -- 创建时间
    ,taked_time -- 领用时间
    ,deal_time -- 处理时间
    ,name1 -- 备用字段1
    ,name2 -- 业务批次ID
    ,name3 -- 备用字段3
    ,name4 -- 业务汇总金额
    ,name5 -- 业务机构编号
    ,name6 -- 上级机构编号
    ,name7 -- 备用字段7
    ,name8 -- 备用字段8
    ,task_mark -- 任务备注
    ,protocol_no -- 业务协议编号
    ,contract_id -- 业务批次ID
    ,node_name -- 节点名称
    ,assign_name -- 操作员名称
    ,parent_id -- 父节点ID
    ,approve_flag -- 审批意见: 1-同意 2-拒绝 3-退回
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdms_tbl_task_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdms_tbl_task_his exchange partition p_${batch_date} with table ${iol_schema}.bdms_tbl_task_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_tbl_task_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdms_tbl_task_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_tbl_task_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);