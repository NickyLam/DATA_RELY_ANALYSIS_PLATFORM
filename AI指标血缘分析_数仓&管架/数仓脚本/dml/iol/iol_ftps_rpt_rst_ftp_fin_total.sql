/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_rpt_rst_ftp_fin_total
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
drop table ${iol_schema}.ftps_rpt_rst_ftp_fin_total_ex purge;
alter table ${iol_schema}.ftps_rpt_rst_ftp_fin_total add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ftps_rpt_rst_ftp_fin_total;

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_rpt_rst_ftp_fin_total_ex nologging
compress
as
select * from ${iol_schema}.ftps_rpt_rst_ftp_fin_total where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_rpt_rst_ftp_fin_total_ex(
    data_dt -- 数据日期
    ,org_code -- 部门机构ID
    ,tp_pricing -- 定价方案类型
    ,currency_code -- 币种编号
    ,subject_type -- 业务类型
    ,cur_bal -- 当前余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,final_ftp_accint_day -- 最终FTP利息日累计
    ,final_ftp_accint_month -- 最终FTP利息月累计
    ,final_ftp_accint_quar -- 最终FTP利息季累计
    ,final_ftp_accint_year -- 最终FTP利息年累计
    ,accint_day -- 当日外部利息收支
    ,accint_month -- 当月累计外部利息收支
    ,accint_quar -- 当季累计外部利息收支
    ,accint_year -- 当年累计外部利息收支
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期
    ,org_code -- 部门机构ID
    ,tp_pricing -- 定价方案类型
    ,currency_code -- 币种编号
    ,subject_type -- 业务类型
    ,cur_bal -- 当前余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,final_ftp_accint_day -- 最终FTP利息日累计
    ,final_ftp_accint_month -- 最终FTP利息月累计
    ,final_ftp_accint_quar -- 最终FTP利息季累计
    ,final_ftp_accint_year -- 最终FTP利息年累计
    ,accint_day -- 当日外部利息收支
    ,accint_month -- 当月累计外部利息收支
    ,accint_quar -- 当季累计外部利息收支
    ,accint_year -- 当年累计外部利息收支
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_rpt_rst_ftp_fin_total
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_rpt_rst_ftp_fin_total exchange partition p_${batch_date} with table ${iol_schema}.ftps_rpt_rst_ftp_fin_total_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_rpt_rst_ftp_fin_total to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_rpt_rst_ftp_fin_total_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_rpt_rst_ftp_fin_total',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);