/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_fact_fin_zh_total_n001
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
drop table ${iol_schema}.ftps_fact_fin_zh_total_n001_ex purge;
alter table ${iol_schema}.ftps_fact_fin_zh_total_n001 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ftps_fact_fin_zh_total_n001 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_fact_fin_zh_total_n001_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ftps_fact_fin_zh_total_n001 where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_fact_fin_zh_total_n001_ex(
    data_dt -- 数据日期
    ,branch_no -- 查询机构号
    ,currency_code -- 币种
    ,subject_type -- 资产负债标志
    ,department -- 归属部门
    ,fin_group -- 资金组
    ,range_cd -- 口径编号
    ,range_name -- 口径名称
    ,cur_bal -- 余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,final_ftp_accint_day -- 当天FTP收支
    ,final_ftp_accint_month -- 月累计FTP收支
    ,final_ftp_accint_quar -- 季累计FTP收支
    ,final_ftp_accint_year -- 年累计FTP收支
    ,accint_day -- 当天外部利息
    ,accint_month -- 月累计外部利息
    ,accint_quar -- 季累计外部利息
    ,accint_year -- 年累计外部利息
    ,avgbal_month -- 月日均余额
    ,avgbal_year -- 年日均余额
    ,t_days -- 当年天数
    ,subject_code -- 科目号
    ,tp_fund -- 定价类型
    ,tp_ftp -- 余额类型（ACTUAL-实际，VIRTUAL-虚拟）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期
    ,branch_no -- 查询机构号
    ,currency_code -- 币种
    ,subject_type -- 资产负债标志
    ,department -- 归属部门
    ,fin_group -- 资金组
    ,range_cd -- 口径编号
    ,range_name -- 口径名称
    ,cur_bal -- 余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,final_ftp_accint_day -- 当天FTP收支
    ,final_ftp_accint_month -- 月累计FTP收支
    ,final_ftp_accint_quar -- 季累计FTP收支
    ,final_ftp_accint_year -- 年累计FTP收支
    ,accint_day -- 当天外部利息
    ,accint_month -- 月累计外部利息
    ,accint_quar -- 季累计外部利息
    ,accint_year -- 年累计外部利息
    ,avgbal_month -- 月日均余额
    ,avgbal_year -- 年日均余额
    ,t_days -- 当年天数
    ,subject_code -- 科目号
    ,tp_fund -- 定价类型
    ,tp_ftp -- 余额类型（ACTUAL-实际，VIRTUAL-虚拟）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_fact_fin_zh_total_n001
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_fact_fin_zh_total_n001 exchange partition p_${batch_date} with table ${iol_schema}.ftps_fact_fin_zh_total_n001_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_fact_fin_zh_total_n001 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_fact_fin_zh_total_n001_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_fact_fin_zh_total_n001',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);