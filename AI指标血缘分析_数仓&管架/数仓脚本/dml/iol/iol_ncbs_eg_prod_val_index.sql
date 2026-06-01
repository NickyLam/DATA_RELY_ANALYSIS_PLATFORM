/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_eg_prod_val_index
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
drop table ${iol_schema}.ncbs_eg_prod_val_index_ex purge;
alter table ${iol_schema}.ncbs_eg_prod_val_index add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_eg_prod_val_index;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_eg_prod_val_index_ex nologging
compress
as
select * from ${iol_schema}.ncbs_eg_prod_val_index where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_eg_prod_val_index_ex(
    tran_date -- 交易日期
    ,seq_no -- 序号
    ,project_no -- 项目编号
    ,project_name -- 项目名称
    ,start_date -- 开始日期
    ,dept_name -- 部门名称
    ,belong_system -- 归属系统
    ,system_name -- 系统名称
    ,amount -- 金额
    ,amend_seq_no -- 变更序号
    ,part_type -- 指标类型
    ,weight -- 权重
    ,param_part -- 指标名称
    ,unit -- 单位
    ,data_value -- 数据值
    ,current_value -- 当前值
    ,term_type -- 期限单位
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tran_date -- 交易日期
    ,seq_no -- 序号
    ,project_no -- 项目编号
    ,project_name -- 项目名称
    ,start_date -- 开始日期
    ,dept_name -- 部门名称
    ,belong_system -- 归属系统
    ,system_name -- 系统名称
    ,amount -- 金额
    ,amend_seq_no -- 变更序号
    ,part_type -- 指标类型
    ,weight -- 权重
    ,param_part -- 指标名称
    ,unit -- 单位
    ,data_value -- 数据值
    ,current_value -- 当前值
    ,term_type -- 期限单位
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_eg_prod_val_index
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_eg_prod_val_index exchange partition p_${batch_date} with table ${iol_schema}.ncbs_eg_prod_val_index_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_eg_prod_val_index to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_eg_prod_val_index_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_eg_prod_val_index',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);