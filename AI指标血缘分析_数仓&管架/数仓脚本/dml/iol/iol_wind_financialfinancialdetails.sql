/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_financialfinancialdetails
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
drop table ${iol_schema}.wind_financialfinancialdetails_ex purge;
alter table ${iol_schema}.wind_financialfinancialdetails add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_financialfinancialdetails truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_financialfinancialdetails_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_financialfinancialdetails where 0=1;

insert /*+ append */ into ${iol_schema}.wind_financialfinancialdetails_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,statement_type -- 报表类型
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,crncy_code -- 货币代码
    ,subject_name -- 科目名称
    ,item_amount -- 科目金额
    ,classification_number -- 序号
    ,publish_value -- 公布值
    ,publish_counitdimension -- 公布量纲
    ,is_listing_data -- 是否上市后数据
    ,acc_sta_code -- 会计准则类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,statement_type -- 报表类型
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,crncy_code -- 货币代码
    ,subject_name -- 科目名称
    ,item_amount -- 科目金额
    ,classification_number -- 序号
    ,publish_value -- 公布值
    ,publish_counitdimension -- 公布量纲
    ,is_listing_data -- 是否上市后数据
    ,acc_sta_code -- 会计准则类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_financialfinancialdetails
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_financialfinancialdetails exchange partition p_${batch_date} with table ${iol_schema}.wind_financialfinancialdetails_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_financialfinancialdetails to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_financialfinancialdetails_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_financialfinancialdetails',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);