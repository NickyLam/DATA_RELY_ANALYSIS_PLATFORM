/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_rpt_ftp_dep_jx
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
drop table ${iol_schema}.ftps_rpt_ftp_dep_jx_ex purge;
alter table ${iol_schema}.ftps_rpt_ftp_dep_jx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ftps_rpt_ftp_dep_jx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_rpt_ftp_dep_jx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ftps_rpt_ftp_dep_jx where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_rpt_ftp_dep_jx_ex(
    data_dt -- 数据日期
    ,tp_code -- 类型编号
    ,tp_desc -- 类型描述
    ,currency_cd -- 币种
    ,term -- 期限
    ,term_cd -- 期限类型代码
    ,base_ftp_rate -- FTP价格(%)
    ,adj01 -- 调整项1(%)
    ,adj02 -- 调整项2(%)
    ,adj03 -- 调整项3(%)
    ,adj04 -- 调整项4(%)
    ,adj05 -- 调整项5(%)
    ,adj06 -- 调整项6(%)
    ,adj07 -- 调整项7(%)
    ,adj08 -- 调整项8(%)
    ,adj09 -- 调整项9(%)
    ,adj10 -- 调整项10(%)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_dt -- 数据日期
    ,tp_code -- 类型编号
    ,tp_desc -- 类型描述
    ,currency_cd -- 币种
    ,term -- 期限
    ,term_cd -- 期限类型代码
    ,base_ftp_rate -- FTP价格(%)
    ,adj01 -- 调整项1(%)
    ,adj02 -- 调整项2(%)
    ,adj03 -- 调整项3(%)
    ,adj04 -- 调整项4(%)
    ,adj05 -- 调整项5(%)
    ,adj06 -- 调整项6(%)
    ,adj07 -- 调整项7(%)
    ,adj08 -- 调整项8(%)
    ,adj09 -- 调整项9(%)
    ,adj10 -- 调整项10(%)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_rpt_ftp_dep_jx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_rpt_ftp_dep_jx exchange partition p_${batch_date} with table ${iol_schema}.ftps_rpt_ftp_dep_jx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_rpt_ftp_dep_jx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_rpt_ftp_dep_jx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_rpt_ftp_dep_jx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);