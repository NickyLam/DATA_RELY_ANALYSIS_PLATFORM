/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkbalancesheetsimple
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
drop table ${iol_schema}.wind_hkbalancesheetsimple_ex purge;
alter table ${iol_schema}.wind_hkbalancesheetsimple add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hkbalancesheetsimple truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hkbalancesheetsimple_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkbalancesheetsimple where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hkbalancesheetsimple_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,report_period -- 截至日期
    ,tot_cur_assets -- 流动资产合计
    ,tot_non_cur_assets -- 非流动资产合计
    ,tot_assets -- 总资产
    ,tot_cur_liab -- 流动负债合计
    ,tot_non_cur_liab -- 非流动负债合计
    ,total_liabilities -- 总负债
    ,parsh_int -- 股东权益
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy -- 股东权益合计
    ,crncy_code -- 货币代码
    ,ann_dt -- 公告日期
    ,acc_sta_code -- 会计准则类型代码
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,report_period -- 截至日期
    ,tot_cur_assets -- 流动资产合计
    ,tot_non_cur_assets -- 非流动资产合计
    ,tot_assets -- 总资产
    ,tot_cur_liab -- 流动负债合计
    ,tot_non_cur_liab -- 非流动负债合计
    ,total_liabilities -- 总负债
    ,parsh_int -- 股东权益
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy -- 股东权益合计
    ,crncy_code -- 货币代码
    ,ann_dt -- 公告日期
    ,acc_sta_code -- 会计准则类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hkbalancesheetsimple
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hkbalancesheetsimple exchange partition p_${batch_date} with table ${iol_schema}.wind_hkbalancesheetsimple_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkbalancesheetsimple to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hkbalancesheetsimple_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkbalancesheetsimple',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);