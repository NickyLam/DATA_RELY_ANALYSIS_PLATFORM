/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_am_case_involvement
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
drop table ${iol_schema}.alss_am_case_involvement_ex purge;
alter table ${iol_schema}.alss_am_case_involvement add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.alss_am_case_involvement;

-- 2.3 insert data to ex table
create table ${iol_schema}.alss_am_case_involvement_ex nologging
compress
as
select * from ${iol_schema}.alss_am_case_involvement where 0=1;

insert /*+ append */ into ${iol_schema}.alss_am_case_involvement_ex(
    input_date -- 通报日期
    ,case_typ -- 案件类型
    ,sfip_date -- 首笔涉案日
    ,involved_amount -- 涉案金额
    ,whether_pre_control -- 是否提前管控
    ,victim -- 受害人
    ,fpsi_pft_date -- 首次公安止付时间
    ,aum_m_avg_bal -- AUM月均值（涉案前）
    ,facm_date -- 首笔自主管控时间（当前有效）
    ,after_calc_day_lmt -- 日限额（涉案前）
    ,froa_date -- 首次风险单预警日
    ,data_release_id -- 发布数据主键
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    input_date -- 通报日期
    ,case_typ -- 案件类型
    ,sfip_date -- 首笔涉案日
    ,involved_amount -- 涉案金额
    ,whether_pre_control -- 是否提前管控
    ,victim -- 受害人
    ,fpsi_pft_date -- 首次公安止付时间
    ,aum_m_avg_bal -- AUM月均值（涉案前）
    ,facm_date -- 首笔自主管控时间（当前有效）
    ,after_calc_day_lmt -- 日限额（涉案前）
    ,froa_date -- 首次风险单预警日
    ,data_release_id -- 发布数据主键
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.alss_am_case_involvement
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.alss_am_case_involvement exchange partition p_${batch_date} with table ${iol_schema}.alss_am_case_involvement_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_am_case_involvement to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.alss_am_case_involvement_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_am_case_involvement',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);