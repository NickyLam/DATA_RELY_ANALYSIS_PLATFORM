/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_rpt_loan_other_ftp_info_rpm
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
drop table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm_ex purge;
alter table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm_ex(
    data_date -- 数据日期 业务发生时间，取当前日期下的所有业务数据
    ,ftp_tp -- FTP类型 RAFL：贷款FTP利率下限 REFI：再贷款FTP利率
    ,ftp_rate -- FTP价格(%)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期 业务发生时间，取当前日期下的所有业务数据
    ,ftp_tp -- FTP类型 RAFL：贷款FTP利率下限 REFI：再贷款FTP利率
    ,ftp_rate -- FTP价格(%)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_rpt_loan_other_ftp_info_rpm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm exchange partition p_${batch_date} with table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_rpt_loan_other_ftp_info_rpm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);