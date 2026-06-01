/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_rrps_rpt_report_result_archive_data
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data partition for (to_date('${batch_date}','yyyymmdd')) (
    archive_type -- 数据类型(01-归档数据/02-回灌数据)
    ,index_no -- 指标标识
    ,data_date -- 数据日期
    ,org_no -- 机构标识
    ,currency -- 币种
    ,index_val -- 指标值
    ,template_id -- 模板ID
    ,sys_time -- 操作日期
    ,sys_ind -- 系统标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(archive_type), ' ') as archive_type -- 数据类型(01-归档数据/02-回灌数据)
    ,nvl(trim(index_no), ' ') as index_no -- 指标标识
    ,nvl(trim(data_date), ' ') as data_date -- 数据日期
    ,nvl(trim(org_no), ' ') as org_no -- 机构标识
    ,nvl(trim(currency), ' ') as currency -- 币种
    ,nvl(trim(index_val), 0) as index_val -- 指标值
    ,nvl(trim(template_id), ' ') as template_id -- 模板ID
    ,nvl(trim(sys_time), ' ') as sys_time -- 操作日期
    ,nvl(trim(sys_ind), ' ') as sys_ind -- 系统标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_rrps_rpt_report_result_archive_data
where etl_dt=to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_rrps_rpt_report_result_archive_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);