/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_ir_points_pool_result
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
drop table ${iol_schema}.rcds_ir_points_pool_result_ex purge;
alter table ${iol_schema}.rcds_ir_points_pool_result add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rcds_ir_points_pool_result truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_ir_points_pool_result_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rcds_ir_points_pool_result where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_ir_points_pool_result_ex(
    key_id -- 主键
    ,loan_no -- 借据号
    ,grade_key_id -- 申请评分流水号
    ,data_dt -- 数据日期
    ,pd -- 违约率PD
    ,pd_ci_1 -- -95%CI(PD)
    ,pd_ci_2 -- +95%CI(PD)
    ,lgd -- 违约损失率LGD
    ,lgd_ci_1 -- 95%CI-(LGD)
    ,lgd_ci_2 -- 95%CI+(LGD)
    ,pool_type -- 分池模型类型
    ,mode_type -- 评分模型类型
    ,pd_logical_deteil -- PD逻辑描述
    ,lgd_logical_deteil -- LGD逻辑描述
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    key_id -- 主键
    ,loan_no -- 借据号
    ,grade_key_id -- 申请评分流水号
    ,data_dt -- 数据日期
    ,pd -- 违约率PD
    ,pd_ci_1 -- -95%CI(PD)
    ,pd_ci_2 -- +95%CI(PD)
    ,lgd -- 违约损失率LGD
    ,lgd_ci_1 -- 95%CI-(LGD)
    ,lgd_ci_2 -- 95%CI+(LGD)
    ,pool_type -- 分池模型类型
    ,mode_type -- 评分模型类型
    ,pd_logical_deteil -- PD逻辑描述
    ,lgd_logical_deteil -- LGD逻辑描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_ir_points_pool_result
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_ir_points_pool_result exchange partition p_${batch_date} with table ${iol_schema}.rcds_ir_points_pool_result_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_ir_points_pool_result to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_ir_points_pool_result_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_ir_points_pool_result',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);