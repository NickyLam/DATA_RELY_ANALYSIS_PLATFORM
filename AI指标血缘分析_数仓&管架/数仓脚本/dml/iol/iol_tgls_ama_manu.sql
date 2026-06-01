/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_ama_manu
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
drop table ${iol_schema}.tgls_ama_manu_ex purge;
alter table ${iol_schema}.tgls_ama_manu add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_ama_manu truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_ama_manu_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_ama_manu where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_ama_manu_ex(
    stacid -- 账套
    ,loanno -- 贷款账户编号
    ,systid -- 来源系统编号
    ,bsnsdt -- 调账日期
    ,transq -- 调账流水号
    ,tranbr -- 机构编号
    ,remark -- 调账说明
    ,custna -- 客户名称
    ,devatg -- 减值标识y-是n-否
    ,usercd -- 录入人
    ,psauus -- 复核人
    ,transt -- 审批状态1-未审批2-已审批3-审批中4-已作废
    ,adjttg -- 是否调整减值状态,y-是,n-否
    ,devaaf -- 调整后减值标示,y-是,n-否
    ,wkflid -- 流程id
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,loanno -- 贷款账户编号
    ,systid -- 来源系统编号
    ,bsnsdt -- 调账日期
    ,transq -- 调账流水号
    ,tranbr -- 机构编号
    ,remark -- 调账说明
    ,custna -- 客户名称
    ,devatg -- 减值标识y-是n-否
    ,usercd -- 录入人
    ,psauus -- 复核人
    ,transt -- 审批状态1-未审批2-已审批3-审批中4-已作废
    ,adjttg -- 是否调整减值状态,y-是,n-否
    ,devaaf -- 调整后减值标示,y-是,n-否
    ,wkflid -- 流程id
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_ama_manu
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_ama_manu exchange partition p_${batch_date} with table ${iol_schema}.tgls_ama_manu_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_ama_manu to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_ama_manu_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_ama_manu',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);