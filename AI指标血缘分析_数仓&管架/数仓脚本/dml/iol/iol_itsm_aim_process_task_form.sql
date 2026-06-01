/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_itsm_aim_process_task_form
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
drop table ${iol_schema}.itsm_aim_process_task_form_ex purge;
alter table ${iol_schema}.itsm_aim_process_task_form add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.itsm_aim_process_task_form;

-- 2.3 insert data to ex table
create table ${iol_schema}.itsm_aim_process_task_form_ex nologging
compress
as
select * from ${iol_schema}.itsm_aim_process_task_form where 0=1;

insert /*+ append */ into ${iol_schema}.itsm_aim_process_task_form_ex(
    businesskey -- 工单ID
    ,task_id -- 任务ID
    ,form_name -- 表单名称
    ,fields -- 表单内容
    ,lastupdatetime -- 更新时间
    ,seq -- 同任务序号
    ,user_id -- 处理人
    ,task_name -- 任务节点
    ,form_type -- 表单类型
    ,link_id -- 关联ID
    ,form_html -- 表单配置
    ,is_use -- 是否已经使用过的数据
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    businesskey -- 工单ID
    ,task_id -- 任务ID
    ,form_name -- 表单名称
    ,fields -- 表单内容
    ,lastupdatetime -- 更新时间
    ,seq -- 同任务序号
    ,user_id -- 处理人
    ,task_name -- 任务节点
    ,form_type -- 表单类型
    ,link_id -- 关联ID
    ,form_html -- 表单配置
    ,is_use -- 是否已经使用过的数据
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.itsm_aim_process_task_form
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.itsm_aim_process_task_form exchange partition p_${batch_date} with table ${iol_schema}.itsm_aim_process_task_form_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.itsm_aim_process_task_form to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.itsm_aim_process_task_form_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'itsm_aim_process_task_form',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);