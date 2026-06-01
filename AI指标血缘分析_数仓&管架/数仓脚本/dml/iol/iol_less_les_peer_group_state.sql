/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_less_les_peer_group_state
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
drop table ${iol_schema}.less_les_peer_group_state_ex purge;
alter table ${iol_schema}.less_les_peer_group_state add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.less_les_peer_group_state truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.less_les_peer_group_state_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.less_les_peer_group_state where 0=1;

insert /*+ append */ into ${iol_schema}.less_les_peer_group_state_ex(
    datadate -- 数据日期
    ,seqitem -- 序号
    ,customertype -- 客户类型
    ,customername -- 客户名称
    ,customercode -- 客户代码
    ,sumexpse -- 风险暴露总和-合计
    ,unexemptriskexpse -- 风险暴露总和-其中：不可豁免风险暴露
    ,firstcapnarat -- 占一级资本净额比例-合计
    ,unexemptriskexpseprop -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse -- 一般风险暴露-合计
    ,lacibank -- 一般风险暴露-其中：拆放同业
    ,ibank_offer -- 拆放同业-其中：同业拆借
    ,ibankbrw_money -- 拆放同业-其中：同业借款
    ,storibank -- 一般风险暴露-其中：存放同业
    ,buyresalezy -- 一般风险暴露-其中：买入返售(质押式)
    ,ibankbond -- 一般风险暴露-其中：同业债券
    ,policyfidebt -- 同业债券-其中：政策性金融债
    ,ibankreceipt -- 一般风险暴露-其中：同业存单
    ,sumprod -- 特定风险暴露-合计
    ,zgprod -- 特定风险暴露-资产管理产品
    ,trustprod -- 资产管理产品-其中：信托产品
    ,nbrk_evnchrem -- 资产管理产品-其中：非保本理财
    ,secuastmgmtprod -- 资产管理产品-其中：证券业资管产品
    ,zqprod -- 特定风险暴露-资产证券化产品
    ,aftradeacctriskexpse -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse -- 交易对手信用风险暴露-合计
    ,courtdertool -- 交易对手信用风险暴露-其中：场外衍生工具
    ,secufinancetrade -- 交易对手信用风险暴露-其中：证券融资交易
    ,afptentriskexpse -- 潜在风险暴露
    ,afothriskexpse -- 其他风险暴露
    ,moveriskexpse -- 风险缓释转出的风险暴露（转入为负数）
    ,summoverisk -- 不考虑风险缓释作用的风险暴露总和
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
    ,firstcapnarat -- 占一级资本净额比例-合计
    ,unexemptriskexpseprop -- 占一级资本净额比例-其中：不可豁免风险暴露
    ,afcomnriskexpse -- 一般风险暴露-合计
    ,lacibank -- 一般风险暴露-其中：拆放同业
    ,ibank_offer -- 拆放同业-其中：同业拆借
    ,ibankbrw_money -- 拆放同业-其中：同业借款
    ,storibank -- 一般风险暴露-其中：存放同业
    ,buyresalezy -- 一般风险暴露-其中：买入返售(质押式)
    ,ibankbond -- 一般风险暴露-其中：同业债券
    ,policyfidebt -- 同业债券-其中：政策性金融债
    ,ibankreceipt -- 一般风险暴露-其中：同业存单
    ,sumprod -- 特定风险暴露-合计
    ,zgprod -- 特定风险暴露-资产管理产品
    ,trustprod -- 资产管理产品-其中：信托产品
    ,nbrk_evnchrem -- 资产管理产品-其中：非保本理财
    ,secuastmgmtprod -- 资产管理产品-其中：证券业资管产品
    ,zqprod -- 特定风险暴露-资产证券化产品
    ,aftradeacctriskexpse -- 交易账簿风险暴露
    ,aftradecpcrdtriskexpse -- 交易对手信用风险暴露-合计
    ,courtdertool -- 交易对手信用风险暴露-其中：场外衍生工具
    ,secufinancetrade -- 交易对手信用风险暴露-其中：证券融资交易
    ,afptentriskexpse -- 潜在风险暴露
    ,afothriskexpse -- 其他风险暴露
    ,moveriskexpse -- 风险缓释转出的风险暴露（转入为负数）
    ,summoverisk -- 不考虑风险缓释作用的风险暴露总和
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.less_les_peer_group_state
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.less_les_peer_group_state exchange partition p_${batch_date} with table ${iol_schema}.less_les_peer_group_state_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.less_les_peer_group_state to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.less_les_peer_group_state_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'less_les_peer_group_state',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);