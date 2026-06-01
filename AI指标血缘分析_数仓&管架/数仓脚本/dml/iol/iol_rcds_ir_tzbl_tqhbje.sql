/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_tzbl_tqhbje
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
drop table ${iol_schema}.rcds_ir_tzbl_tqhbje_ex purge;
alter table ${iol_schema}.rcds_ir_tzbl_tqhbje add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.rcds_ir_tzbl_tqhbje;

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_ir_tzbl_tqhbje_ex nologging
compress
as
select * from ${iol_schema}.rcds_ir_tzbl_tqhbje where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_ir_tzbl_tqhbje_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0601 -- 当前月提前还本金额
    ,var0602 -- 当前月提前还本金额占贷款金额的百分比
    ,var0603 -- 过去3个月提前还款金额的平均值
    ,var0604 -- 过去6个月提前还款金额的平均值
    ,var0605 -- 过去12个月提前还款金额的平均值
    ,var0606 -- 过去3个月提前还款金额的总和
    ,var0607 -- 过去6个月提前还款金额的总和
    ,var0608 -- 过去12个月提前还款金额的总和
    ,var0609 -- 过去3个月提前还款的月份数
    ,var0610 -- 过去6个月提前还款的月份数
    ,var0611 -- 过去12个月提前还款的月份数
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,var0601 -- 当前月提前还本金额
    ,var0602 -- 当前月提前还本金额占贷款金额的百分比
    ,var0603 -- 过去3个月提前还款金额的平均值
    ,var0604 -- 过去6个月提前还款金额的平均值
    ,var0605 -- 过去12个月提前还款金额的平均值
    ,var0606 -- 过去3个月提前还款金额的总和
    ,var0607 -- 过去6个月提前还款金额的总和
    ,var0608 -- 过去12个月提前还款金额的总和
    ,var0609 -- 过去3个月提前还款的月份数
    ,var0610 -- 过去6个月提前还款的月份数
    ,var0611 -- 过去12个月提前还款的月份数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_ir_tzbl_tqhbje
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_ir_tzbl_tqhbje exchange partition p_${batch_date} with table ${iol_schema}.rcds_ir_tzbl_tqhbje_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_tzbl_tqhbje to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_ir_tzbl_tqhbje_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_tzbl_tqhbje',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);