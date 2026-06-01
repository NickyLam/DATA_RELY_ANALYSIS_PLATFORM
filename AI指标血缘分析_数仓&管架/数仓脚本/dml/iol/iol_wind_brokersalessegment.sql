/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_brokersalessegment
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
drop table ${iol_schema}.wind_brokersalessegment_ex purge;
alter table ${iol_schema}.wind_brokersalessegment add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_brokersalessegment truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_brokersalessegment_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_brokersalessegment where 0=1;

insert /*+ append */ into ${iol_schema}.wind_brokersalessegment_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,s_info_compname -- 公司名称
    ,report_period -- 报告期
    ,crncy_code -- 货币代码
    ,s_segment_itemcode -- 项目类别
    ,s_segment_item -- 主营业务项目
    ,s_segment_sales -- 主营业务收入(元)
    ,s_segment_profit -- 主营业务利润(元)
    ,s_segment_cost -- 主营业务成本(元)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,s_info_compname -- 公司名称
    ,report_period -- 报告期
    ,crncy_code -- 货币代码
    ,s_segment_itemcode -- 项目类别
    ,s_segment_item -- 主营业务项目
    ,s_segment_sales -- 主营业务收入(元)
    ,s_segment_profit -- 主营业务利润(元)
    ,s_segment_cost -- 主营业务成本(元)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_brokersalessegment
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_brokersalessegment exchange partition p_${batch_date} with table ${iol_schema}.wind_brokersalessegment_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_brokersalessegment to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_brokersalessegment_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_brokersalessegment',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);