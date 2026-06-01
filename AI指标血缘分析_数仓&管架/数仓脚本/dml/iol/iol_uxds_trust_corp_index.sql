/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_trust_corp_index
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
drop table ${iol_schema}.uxds_trust_corp_index_ex purge;
alter table ${iol_schema}.uxds_trust_corp_index add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_trust_corp_index;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_trust_corp_index_ex nologging
compress
as
select * from ${iol_schema}.uxds_trust_corp_index where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_trust_corp_index_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,trust_company_code -- 信托公司机构代码@关联到corp_basic_info.org_id
    ,ed -- 截止日期
    ,total_use_of_trust_assets -- 信托资产运用合计@单位：万元
    ,total_trust_income -- 信托收入合计@单位：万元
    ,total_trust_fees -- 信托费用合计@单位：万元；信托费用合计=营业费用+营业税金及附加
    ,trust_gains_and_losses -- 信托损益@单位：万元
    ,return_on_capital -- 资本收益率@单位：%
    ,trust_rate_of_return -- 信托报酬率@单位：%
    ,profit_per_capita -- 人均利润@单位：万元
    ,trust_company_name -- 信托公司名称
    ,operating_fee -- 营业费用
    ,operating_taxes_and_surcharge -- 营业税金及附加
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,trust_company_code -- 信托公司机构代码@关联到corp_basic_info.org_id
    ,ed -- 截止日期
    ,total_use_of_trust_assets -- 信托资产运用合计@单位：万元
    ,total_trust_income -- 信托收入合计@单位：万元
    ,total_trust_fees -- 信托费用合计@单位：万元；信托费用合计=营业费用+营业税金及附加
    ,trust_gains_and_losses -- 信托损益@单位：万元
    ,return_on_capital -- 资本收益率@单位：%
    ,trust_rate_of_return -- 信托报酬率@单位：%
    ,profit_per_capita -- 人均利润@单位：万元
    ,trust_company_name -- 信托公司名称
    ,operating_fee -- 营业费用
    ,operating_taxes_and_surcharge -- 营业税金及附加
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_trust_corp_index
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_trust_corp_index exchange partition p_${batch_date} with table ${iol_schema}.uxds_trust_corp_index_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_trust_corp_index to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_trust_corp_index_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_trust_corp_index',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);