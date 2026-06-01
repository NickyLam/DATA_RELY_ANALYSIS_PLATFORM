/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_nct_todolist
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
drop table ${iol_schema}.nibs_nct_todolist_ex purge;
alter table ${iol_schema}.nibs_nct_todolist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_nct_todolist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_nct_todolist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_nct_todolist where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_nct_todolist_ex(
    task_id -- 任务id
    ,enclosure -- 附件（影像id）
    ,teller_name -- 发起人柜员名称
    ,teller_post -- 发起人柜员岗位
    ,branch_no -- 机构编号
    ,manager_id -- 审批人编号
    ,manager_name -- 审批人名称
    ,manager_post -- 审批人岗位
    ,reason -- 申请原因
    ,apply_date -- 申请日期 yyyymmdd
    ,create_date -- 创建日期 yyyymmdd
    ,create_time -- 创建时间 hhmmss
    ,update_date -- 更新日期 yyyymmdd
    ,update_time -- 更新时间 hhmmss
    ,remark -- 标题
    ,status -- 1：审批中，2：审批通过，3：已拒绝，4-已取消
    ,busitype -- 业务类型 1-机构重新签到 2-柜员免签退 3-查证信息补录
    ,teller_no -- 发起人柜员编号
    ,currhandletype -- 当前处理状态-P正在处理
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    task_id -- 任务id
    ,enclosure -- 附件（影像id）
    ,teller_name -- 发起人柜员名称
    ,teller_post -- 发起人柜员岗位
    ,branch_no -- 机构编号
    ,manager_id -- 审批人编号
    ,manager_name -- 审批人名称
    ,manager_post -- 审批人岗位
    ,reason -- 申请原因
    ,apply_date -- 申请日期 yyyymmdd
    ,create_date -- 创建日期 yyyymmdd
    ,create_time -- 创建时间 hhmmss
    ,update_date -- 更新日期 yyyymmdd
    ,update_time -- 更新时间 hhmmss
    ,remark -- 标题
    ,status -- 1：审批中，2：审批通过，3：已拒绝，4-已取消
    ,busitype -- 业务类型 1-机构重新签到 2-柜员免签退 3-查证信息补录
    ,teller_no -- 发起人柜员编号
    ,currhandletype -- 当前处理状态-P正在处理
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_nct_todolist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_nct_todolist exchange partition p_${batch_date} with table ${iol_schema}.nibs_nct_todolist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_nct_todolist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_nct_todolist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_nct_todolist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);