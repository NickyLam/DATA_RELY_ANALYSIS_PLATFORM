/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbgdhxcostinfo
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
drop table ${iol_schema}.ifms_tbgdhxcostinfo_ex purge;
alter table ${iol_schema}.ifms_tbgdhxcostinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifms_tbgdhxcostinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifms_tbgdhxcostinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbgdhxcostinfo where 0=1;

insert /*+ append */ into ${iol_schema}.ifms_tbgdhxcostinfo_ex(
    ta_code -- ta代码
    ,cfm_date -- 确认日期
    ,cfm_no -- 确认流水号
    ,old_tot_vol -- 原总份额
    ,bag_cost -- 累计流出资金对应的成本
    ,total_cost -- 累计投入成本
    ,rest_cost -- 赎回或到期成本=赎回或到期确认的份额*持仓成本/当天确认前客户持有的总份额
    ,amt1 -- 备份金额1
    ,amt2 -- 备份金额2
    ,amt3 -- 备份金额3
    ,reserve1 -- 备份字段1
    ,reserve2 -- 备份字段2
    ,reserve3 -- 备份字段3
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ta_code -- ta代码
    ,cfm_date -- 确认日期
    ,cfm_no -- 确认流水号
    ,old_tot_vol -- 原总份额
    ,bag_cost -- 累计流出资金对应的成本
    ,total_cost -- 累计投入成本
    ,rest_cost -- 赎回或到期成本=赎回或到期确认的份额*持仓成本/当天确认前客户持有的总份额
    ,amt1 -- 备份金额1
    ,amt2 -- 备份金额2
    ,amt3 -- 备份金额3
    ,reserve1 -- 备份字段1
    ,reserve2 -- 备份字段2
    ,reserve3 -- 备份字段3
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifms_tbgdhxcostinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifms_tbgdhxcostinfo exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbgdhxcostinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbgdhxcostinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifms_tbgdhxcostinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbgdhxcostinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);