/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_fact_ftp261_bsc_a05
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
drop table ${iol_schema}.ftps_fact_ftp261_bsc_a05_ex purge;
alter table ${iol_schema}.ftps_fact_ftp261_bsc_a05 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ftps_fact_ftp261_bsc_a05 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_fact_ftp261_bsc_a05_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ftps_fact_ftp261_bsc_a05 where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_fact_ftp261_bsc_a05_ex(
    data_dt -- 数据日期
    ,org_type_cd -- 机构类型代码（核算/考核）
    ,org_unit_id -- 机构代码
    ,iso_currency_cd -- 币种编码（含折币）
    ,subject_cd -- 科目代码
    ,subject_level -- 科目汇总层级
    ,unit_id -- 货币单位代码
    ,id_ -- 机构时间戳关联字段
    ,t_days -- 本年总天数
    ,cur_bal -- 当前余额
    ,avg_bal -- 日均余额
    ,acc_bal -- 累计余额
    ,acc_int -- 利息收支累计
    ,exercise_interest_rate_x -- 执行利率加权乘积
    ,base_ftp_rate_x -- 原始ftp利率加权乘积
    ,mid_ftp_rate_x -- 内生性调节后ftp利率加权乘积
    ,final_ftp_rate_x -- 最终ftp利率加权乘积
    ,base_ftp_accint -- 原始ftp利息累计
    ,mid_ftp_accint -- 内生性调节后ftp利息累计
    ,final_ftp_accint -- 最终ftp利息累计
    ,base_ftp_accprofit -- 原始ftp利润累计
    ,mid_ftp_accprofit -- 内生性调节后ftp利润累计
    ,final_ftp_accprofit -- 最终ftp利润累计
    ,adjust_inner_accint -- 内生性调节项金额累计
    ,adjust_policy_accint -- 政策性调节项金额累计
    ,adjust_01_accint -- 调节项1金额累计
    ,adjust_02_accint -- 调节项2金额累计
    ,adjust_03_accint -- 调节项3金额累计
    ,adjust_04_accint -- 调节项4金额累计
    ,adjust_05_accint -- 调节项5金额累计
    ,adjust_06_accint -- 调节项6金额累计
    ,adjust_07_accint -- 调节项7金额累计
    ,adjust_08_accint -- 调节项8金额累计
    ,adjust_09_accint -- 调节项9金额累计
    ,adjust_10_accint -- 调节项10金额累计
    ,adjust_11_accint -- 调节项11金额累计
    ,adjust_12_accint -- 调节项12金额累计
    ,adjust_13_accint -- 调节项13金额累计
    ,adjust_14_accint -- 调节项14金额累计
    ,adjust_15_accint -- 调节项15金额累计
    ,adjust_16_accint -- 调节项16金额累计
    ,adjust_17_accint -- 调节项17金额累计
    ,adjust_18_accint -- 调节项18金额累计
    ,adjust_19_accint -- 调节项19金额累计
    ,adjust_20_accint -- 调节项20金额累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期
    ,org_type_cd -- 机构类型代码（核算/考核）
    ,org_unit_id -- 机构代码
    ,iso_currency_cd -- 币种编码（含折币）
    ,subject_cd -- 科目代码
    ,subject_level -- 科目汇总层级
    ,unit_id -- 货币单位代码
    ,id_ -- 机构时间戳关联字段
    ,t_days -- 本年总天数
    ,cur_bal -- 当前余额
    ,avg_bal -- 日均余额
    ,acc_bal -- 累计余额
    ,acc_int -- 利息收支累计
    ,exercise_interest_rate_x -- 执行利率加权乘积
    ,base_ftp_rate_x -- 原始ftp利率加权乘积
    ,mid_ftp_rate_x -- 内生性调节后ftp利率加权乘积
    ,final_ftp_rate_x -- 最终ftp利率加权乘积
    ,base_ftp_accint -- 原始ftp利息累计
    ,mid_ftp_accint -- 内生性调节后ftp利息累计
    ,final_ftp_accint -- 最终ftp利息累计
    ,base_ftp_accprofit -- 原始ftp利润累计
    ,mid_ftp_accprofit -- 内生性调节后ftp利润累计
    ,final_ftp_accprofit -- 最终ftp利润累计
    ,adjust_inner_accint -- 内生性调节项金额累计
    ,adjust_policy_accint -- 政策性调节项金额累计
    ,adjust_01_accint -- 调节项1金额累计
    ,adjust_02_accint -- 调节项2金额累计
    ,adjust_03_accint -- 调节项3金额累计
    ,adjust_04_accint -- 调节项4金额累计
    ,adjust_05_accint -- 调节项5金额累计
    ,adjust_06_accint -- 调节项6金额累计
    ,adjust_07_accint -- 调节项7金额累计
    ,adjust_08_accint -- 调节项8金额累计
    ,adjust_09_accint -- 调节项9金额累计
    ,adjust_10_accint -- 调节项10金额累计
    ,adjust_11_accint -- 调节项11金额累计
    ,adjust_12_accint -- 调节项12金额累计
    ,adjust_13_accint -- 调节项13金额累计
    ,adjust_14_accint -- 调节项14金额累计
    ,adjust_15_accint -- 调节项15金额累计
    ,adjust_16_accint -- 调节项16金额累计
    ,adjust_17_accint -- 调节项17金额累计
    ,adjust_18_accint -- 调节项18金额累计
    ,adjust_19_accint -- 调节项19金额累计
    ,adjust_20_accint -- 调节项20金额累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_fact_ftp261_bsc_a05
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_fact_ftp261_bsc_a05 exchange partition p_${batch_date} with table ${iol_schema}.ftps_fact_ftp261_bsc_a05_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_fact_ftp261_bsc_a05 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_fact_ftp261_bsc_a05_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_fact_ftp261_bsc_a05',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);