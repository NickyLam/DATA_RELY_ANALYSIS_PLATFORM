/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_less_les_customer_state
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
drop table ${iol_schema}.less_les_customer_state_ex purge;
alter table ${iol_schema}.less_les_customer_state add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.less_les_customer_state truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.less_les_customer_state_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.less_les_customer_state where 0=1;

insert /*+ append */ into ${iol_schema}.less_les_customer_state_ex(
    datadate -- 数据日期
    ,seqitem -- 序号
    ,customertype -- 客户类型
    ,customername -- 客户名称
    ,customercode -- 客户代码
    ,sumexpse -- 风险暴露总和-合计
    ,unexemptriskexpse -- 风险暴露总和-其中：不可豁免风险暴露
    ,sumexpseratio -- 占一级资本净额比例-合计
    ,unexemptriskexpseratio -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse -- 一般风险暴露
    ,afspecriskexpse -- 特定风险暴露
    ,aftradeacctriskexpse -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse -- 交易对手信用风险暴露
    ,afptentriskexpse -- 潜在风险暴露
    ,afothriskexpse -- 其他风险暴露
    ,moveriskexpse -- 风险缓释转出的风险暴露（转入为负数）
    ,sumunexeriskexpse -- 不考虑风险缓释作用的风险暴露-风险暴露总和
    ,sumunexpseratio -- 不考虑风险缓释作用的风险暴露-占一级资本净额比例
    ,prjbal -- 一级资本净额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    datadate -- 数据日期
    ,seqitem -- 序号
    ,customertype -- 客户类型
    ,customername -- 客户名称
    ,customercode -- 客户代码
    ,sumexpse -- 风险暴露总和-合计
    ,unexemptriskexpse -- 风险暴露总和-其中：不可豁免风险暴露
    ,sumexpseratio -- 占一级资本净额比例-合计
    ,unexemptriskexpseratio -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse -- 一般风险暴露
    ,afspecriskexpse -- 特定风险暴露
    ,aftradeacctriskexpse -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse -- 交易对手信用风险暴露
    ,afptentriskexpse -- 潜在风险暴露
    ,afothriskexpse -- 其他风险暴露
    ,moveriskexpse -- 风险缓释转出的风险暴露（转入为负数）
    ,sumunexeriskexpse -- 不考虑风险缓释作用的风险暴露-风险暴露总和
    ,sumunexpseratio -- 不考虑风险缓释作用的风险暴露-占一级资本净额比例
    ,prjbal -- 一级资本净额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.less_les_customer_state
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.less_les_customer_state exchange partition p_${batch_date} with table ${iol_schema}.less_les_customer_state_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.less_les_customer_state to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.less_les_customer_state_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'less_les_customer_state',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);