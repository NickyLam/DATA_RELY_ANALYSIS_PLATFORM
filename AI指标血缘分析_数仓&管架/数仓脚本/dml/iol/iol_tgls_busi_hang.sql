/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_busi_hang
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
drop table ${iol_schema}.tgls_busi_hang_ex purge;
alter table ${iol_schema}.tgls_busi_hang add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_busi_hang truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_busi_hang_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_busi_hang where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_busi_hang_ex(
    stacid -- 账套
    ,systid -- 交易来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,tablcd -- 接口表编码
    ,trdata -- 交易流水数据json数组
    ,status -- 处理状态：0未处理1已处理
    ,sourtp -- 来源（1：手工终止2：错账冲销3:手工补录流水）
    ,dealtp -- 处理方式（1：业务系统重传2：手工修改流水3：标记为重复流水4：已修改核算规则5：已补录核算规则6：无修改重新解析）
    ,retran -- 关联流水号
    ,soursq -- 源流水号
    ,sourdt -- 源交易日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,systid -- 交易来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,tablcd -- 接口表编码
    ,trdata -- 交易流水数据json数组
    ,status -- 处理状态：0未处理1已处理
    ,sourtp -- 来源（1：手工终止2：错账冲销3:手工补录流水）
    ,dealtp -- 处理方式（1：业务系统重传2：手工修改流水3：标记为重复流水4：已修改核算规则5：已补录核算规则6：无修改重新解析）
    ,retran -- 关联流水号
    ,soursq -- 源流水号
    ,sourdt -- 源交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_busi_hang
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_busi_hang exchange partition p_${batch_date} with table ${iol_schema}.tgls_busi_hang_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_busi_hang to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_busi_hang_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_busi_hang',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);