/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjbzqtzsy
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
drop table ${iol_schema}.pams_jxbb_zjbzqtzsy_ex purge;
alter table ${iol_schema}.pams_jxbb_zjbzqtzsy add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_zjbzqtzsy truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_zjbzqtzsy_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zjbzqtzsy where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjbzqtzsy_ex(
    tjrq -- 统计日期
    ,zqdm -- 债券代码
    ,jxdxdh -- 绩效对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,ldpz -- 联动品种
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,tzsy -- 调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,khjlgh -- 客户经理工号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,zqdm -- 债券代码
    ,jxdxdh -- 绩效对象代号
    ,jgdh -- 机构代号
    ,jgmc -- 机构名称
    ,ldpz -- 联动品种
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,tzsy -- 调整收益
    ,tzsyylj -- 调整收益月累计
    ,tzsyjlj -- 调整收益季累计
    ,tzsynlj -- 调整收益年累计
    ,khjlgh -- 客户经理工号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_zjbzqtzsy
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_zjbzqtzsy exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zjbzqtzsy_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zjbzqtzsy to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_zjbzqtzsy_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zjbzqtzsy',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);