/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_proj_val_index
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
drop table ${iol_schema}.icms_proj_val_index_ex purge;
alter table ${iol_schema}.icms_proj_val_index add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_proj_val_index;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_proj_val_index_ex nologging
compress
as
select * from ${iol_schema}.icms_proj_val_index where 0=1;

insert /*+ append */ into ${iol_schema}.icms_proj_val_index_ex(
    etl_dt_ora -- 数据日期yyyyMMdd
    ,proj_val_id -- 指标表数据ID,系统简称+序列号
    ,proj_id -- 项目编号
    ,proj_name -- 项目名称
    ,proj_online_dt -- 
    ,dep_name -- 需求提出部门
    ,sys_short_name -- 系统简称
    ,sys_name -- 系统名称
    ,budg_amt -- 预算金额
    ,xq_id -- 需求编号
    ,index_type -- 指标类型
    ,weht_ratio -- 权重比例
    ,index_name -- 指标名称
    ,index_unit -- 指标单位,中文，如:亿元、万元、元、人、万人等
    ,tgt_val -- 目标值,[0,999,99]
    ,index_val -- 指标值,[0,999,99]
    ,stati_peri -- 统计周期,日，或者周
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    etl_dt_ora -- 数据日期yyyyMMdd
    ,proj_val_id -- 指标表数据ID,系统简称+序列号
    ,proj_id -- 项目编号
    ,proj_name -- 项目名称
    ,proj_online_dt -- 
    ,dep_name -- 需求提出部门
    ,sys_short_name -- 系统简称
    ,sys_name -- 系统名称
    ,budg_amt -- 预算金额
    ,xq_id -- 需求编号
    ,index_type -- 指标类型
    ,weht_ratio -- 权重比例
    ,index_name -- 指标名称
    ,index_unit -- 指标单位,中文，如:亿元、万元、元、人、万人等
    ,tgt_val -- 目标值,[0,999,99]
    ,index_val -- 指标值,[0,999,99]
    ,stati_peri -- 统计周期,日，或者周
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_proj_val_index
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_proj_val_index exchange partition p_${batch_date} with table ${iol_schema}.icms_proj_val_index_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_proj_val_index to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_proj_val_index_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_proj_val_index',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);