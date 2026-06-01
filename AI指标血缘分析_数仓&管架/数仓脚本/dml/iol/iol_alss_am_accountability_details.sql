/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_accountability_details
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
drop table ${iol_schema}.alss_am_accountability_details_ex purge;
alter table ${iol_schema}.alss_am_accountability_details add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alss_am_accountability_details;

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_accountability_details_ex nologging
compress
as
select * from ${iol_schema}.alss_am_accountability_details where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_accountability_details_ex(
    wthsa -- 是否问责
    ,cta_num -- 问责人数
    ,cta_m -- 问责方式
    ,cta_dfa -- 问责扣罚金额（元）
    ,cta_user -- 问责人员
    ,cta_desc -- 说明
    ,cta_doc_id -- 附件
    ,data_release_id -- 发布数据主键
    ,cta_doc_name -- 附件名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    wthsa -- 是否问责
    ,cta_num -- 问责人数
    ,cta_m -- 问责方式
    ,cta_dfa -- 问责扣罚金额（元）
    ,cta_user -- 问责人员
    ,cta_desc -- 说明
    ,cta_doc_id -- 附件
    ,data_release_id -- 发布数据主键
    ,cta_doc_name -- 附件名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_accountability_details
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_accountability_details exchange partition p_${batch_date} with table ${iol_schema}.alss_am_accountability_details_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_accountability_details to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_accountability_details_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_accountability_details',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);