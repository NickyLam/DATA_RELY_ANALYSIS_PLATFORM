/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_pbc_report_balance
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
drop table ${iol_schema}.fams_pbc_report_balance_ex purge;
alter table ${iol_schema}.fams_pbc_report_balance add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.fams_pbc_report_balance;

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_pbc_report_balance_ex nologging
compress
as
select * from ${iol_schema}.fams_pbc_report_balance where 0=1;

insert /*+ append */ into ${iol_schema}.fams_pbc_report_balance_ex(
    detailuuid -- 明细统计uuid
    ,reporttype -- 报表类型2_1-资管产品资产负债统计
    ,grouptype -- 分组类型 资产-ASSET，负债-DEBT 资产负债合计-ASSETDEBTSUM
    ,propertycode -- 属性代码
    ,cny -- 人民币
    ,usd_to_cny -- 美元折人民币
    ,eur_to_cny -- 欧元折人民币
    ,gbp_to_cny -- 英镑折人民币
    ,jpy_to_cny -- 日元折人民币
    ,oth_to_cny -- 其他币种折人名币
    ,total -- 合计
    ,reportuuid -- 主表关联id
    ,ccy_amount -- 币种金额信息，多币种存值，人民币也存值，格式：CNY,原币金额,折人民币金额;USD,原币金额,折人民币金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    detailuuid -- 明细统计uuid
    ,reporttype -- 报表类型2_1-资管产品资产负债统计
    ,grouptype -- 分组类型 资产-ASSET，负债-DEBT 资产负债合计-ASSETDEBTSUM
    ,propertycode -- 属性代码
    ,cny -- 人民币
    ,usd_to_cny -- 美元折人民币
    ,eur_to_cny -- 欧元折人民币
    ,gbp_to_cny -- 英镑折人民币
    ,jpy_to_cny -- 日元折人民币
    ,oth_to_cny -- 其他币种折人名币
    ,total -- 合计
    ,reportuuid -- 主表关联id
    ,ccy_amount -- 币种金额信息，多币种存值，人民币也存值，格式：CNY,原币金额,折人民币金额;USD,原币金额,折人民币金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_pbc_report_balance
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_pbc_report_balance exchange partition p_${batch_date} with table ${iol_schema}.fams_pbc_report_balance_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_pbc_report_balance to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_pbc_report_balance_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_pbc_report_balance',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);