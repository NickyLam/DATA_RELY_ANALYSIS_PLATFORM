/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cpms_t_account_quanyi_point
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
drop table ${iol_schema}.cpms_t_account_quanyi_point_ex purge;
alter table ${iol_schema}.cpms_t_account_quanyi_point add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cpms_t_account_quanyi_point truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cpms_t_account_quanyi_point_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cpms_t_account_quanyi_point where 0=1;

insert /*+ append */ into ${iol_schema}.cpms_t_account_quanyi_point_ex(
    branch_no -- 分行号
    ,branch_no_name -- 分行名称
    ,org_no -- 机构号
    ,org_no_name -- 机构名称
    ,pty_id -- 客户号
    ,pty_name -- 客户名称
    ,equity_count -- 权益积分
    ,val_end_dt -- 有效结束日期(格式为YYYY1230，消费时优先使用今年到期的权益积分)
    ,is_valid -- 是否有效标志(0-有效 1-失效)
    ,last_ope_time -- 最后操作时间(yyyyMMddhhmmss)
    ,final_oper_pers -- 最后操作人
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    branch_no -- 分行号
    ,branch_no_name -- 分行名称
    ,org_no -- 机构号
    ,org_no_name -- 机构名称
    ,pty_id -- 客户号
    ,pty_name -- 客户名称
    ,equity_count -- 权益积分
    ,val_end_dt -- 有效结束日期(格式为YYYY1230，消费时优先使用今年到期的权益积分)
    ,is_valid -- 是否有效标志(0-有效 1-失效)
    ,last_ope_time -- 最后操作时间(yyyyMMddhhmmss)
    ,final_oper_pers -- 最后操作人
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cpms_t_account_quanyi_point
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cpms_t_account_quanyi_point exchange partition p_${batch_date} with table ${iol_schema}.cpms_t_account_quanyi_point_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cpms_t_account_quanyi_point to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cpms_t_account_quanyi_point_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cpms_t_account_quanyi_point',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);