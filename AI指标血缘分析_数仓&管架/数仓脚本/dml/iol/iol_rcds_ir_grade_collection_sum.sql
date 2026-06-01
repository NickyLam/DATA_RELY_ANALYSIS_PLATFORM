/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_grade_collection_sum
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
drop table ${iol_schema}.rcds_ir_grade_collection_sum_ex purge;
alter table ${iol_schema}.rcds_ir_grade_collection_sum add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rcds_ir_grade_collection_sum truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_ir_grade_collection_sum_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_grade_collection_sum where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_ir_grade_collection_sum_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,loan_total_bal -- 贷款余额
    ,rist_level -- 风险等级
    ,grade -- 评分结果
    ,warning_level -- 预警优先级
    ,collection_level -- 催收优先级
    ,remark -- 备注
    ,mode_type -- 评分模型类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,loan_no -- 借据号
    ,data_dt -- 数据日期
    ,loan_biz_type_cd -- 业务品种代码
    ,loan_total_bal -- 贷款余额
    ,rist_level -- 风险等级
    ,grade -- 评分结果
    ,warning_level -- 预警优先级
    ,collection_level -- 催收优先级
    ,remark -- 备注
    ,mode_type -- 评分模型类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_ir_grade_collection_sum
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_ir_grade_collection_sum exchange partition p_${batch_date} with table ${iol_schema}.rcds_ir_grade_collection_sum_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_grade_collection_sum to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_ir_grade_collection_sum_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_grade_collection_sum',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);