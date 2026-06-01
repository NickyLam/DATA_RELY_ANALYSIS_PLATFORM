/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_s_loan_process
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
drop table ${iol_schema}.heps_s_loan_process_ex purge;
alter table ${iol_schema}.heps_s_loan_process add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_s_loan_process truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_s_loan_process_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_s_loan_process where 0=1;

insert /*+ append */ into ${iol_schema}.heps_s_loan_process_ex(
    id -- id
    ,operate_result -- 操作结果：0失败  1成功  2待执行
    ,operator -- 操作人
    ,operate_time -- 操作时间
    ,status -- 更新后状态：00-初审中，01-待分配，02-待下户核验/待补充资料，03-待面谈面签，04-终审中，05-审核通过，06-审核拒绝，07-退回，08-初审不通过，09-状态未名，10-终止，11-待质检员审核
    ,node_name -- 节点名称对应上面状态（提供给前台）
    ,pre_status -- 更新前状态
    ,failure_reason -- 失败原因
    ,task_id -- 任务流水号
    ,remark -- 备注
    ,operate_trace -- 操作轨迹  0 进件申请 1 初审校验 2 抢单 3 分配 4 移交 5 现场签到 6 下户核验 7 面谈面签 8 终审校验
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- id
    ,operate_result -- 操作结果：0失败  1成功  2待执行
    ,operator -- 操作人
    ,operate_time -- 操作时间
    ,status -- 更新后状态：00-初审中，01-待分配，02-待下户核验/待补充资料，03-待面谈面签，04-终审中，05-审核通过，06-审核拒绝，07-退回，08-初审不通过，09-状态未名，10-终止，11-待质检员审核
    ,node_name -- 节点名称对应上面状态（提供给前台）
    ,pre_status -- 更新前状态
    ,failure_reason -- 失败原因
    ,task_id -- 任务流水号
    ,remark -- 备注
    ,operate_trace -- 操作轨迹  0 进件申请 1 初审校验 2 抢单 3 分配 4 移交 5 现场签到 6 下户核验 7 面谈面签 8 终审校验
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_s_loan_process
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_s_loan_process exchange partition p_${batch_date} with table ${iol_schema}.heps_s_loan_process_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_s_loan_process to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_s_loan_process_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_s_loan_process',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);