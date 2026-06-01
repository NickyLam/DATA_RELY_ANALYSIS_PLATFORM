/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondanalysisshc
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
drop table ${iol_schema}.wind_cbondanalysisshc_ex purge;
alter table ${iol_schema}.wind_cbondanalysisshc add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_cbondanalysisshc truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cbondanalysisshc_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbondanalysisshc where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cbondanalysisshc_ex(
    s_info_windcode -- Wind代码
    ,trade_dt -- 交易日期
    ,b_anal_matu_cnbd -- 待偿期(年)
    ,b_anal_dirty_cnbd -- 日间估价全价
    ,b_anal_accrint_cnbd -- 日间应计利息
    ,b_anal_net_cnbd -- 估价净价
    ,b_anal_yield_cnbd -- 估价收益率(%)
    ,b_anal_modidura_cnbd -- 估价修正久期
    ,b_anal_cnvxty_cnbd -- 估价凸性
    ,b_anal_vobp_cnbd -- 估价基点价值
    ,b_anal_sprdura_cnbd -- 估价利差久期
    ,b_anal_sprcnxt_cnbd -- 估价利差凸性
    ,b_anal_price -- 市场全价
    ,b_anal_netprice -- 市场净价
    ,b_anal_yield -- 市场收益率(%)
    ,b_anal_modifiedduration -- 市场修正久期
    ,b_anal_convexity -- 市场凸性
    ,b_anal_bpvalue -- 市场基点价值
    ,b_anal_sduration -- 市场利差久期
    ,b_anal_scnvxty -- 市场利差凸性
    ,b_anal_interestduration_cnbd -- 估价利率久期
    ,b_anal_interestcnvxty_cnbd -- 估价利率凸性
    ,b_anal_interestduration -- 市场利率久期
    ,b_anal_interestcnvxty -- 市场利率凸性
    ,b_anal_price_cnbd -- 日终估价全价
    ,b_anal_bpyield -- 日终应计利息
    ,b_anal_surpluscapital -- 剩余本金
    ,b_anal_exchange -- 流通场所
    ,b_anal_credibility -- 可信度
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    s_info_windcode -- Wind代码
    ,trade_dt -- 交易日期
    ,b_anal_matu_cnbd -- 待偿期(年)
    ,b_anal_dirty_cnbd -- 日间估价全价
    ,b_anal_accrint_cnbd -- 日间应计利息
    ,b_anal_net_cnbd -- 估价净价
    ,b_anal_yield_cnbd -- 估价收益率(%)
    ,b_anal_modidura_cnbd -- 估价修正久期
    ,b_anal_cnvxty_cnbd -- 估价凸性
    ,b_anal_vobp_cnbd -- 估价基点价值
    ,b_anal_sprdura_cnbd -- 估价利差久期
    ,b_anal_sprcnxt_cnbd -- 估价利差凸性
    ,b_anal_price -- 市场全价
    ,b_anal_netprice -- 市场净价
    ,b_anal_yield -- 市场收益率(%)
    ,b_anal_modifiedduration -- 市场修正久期
    ,b_anal_convexity -- 市场凸性
    ,b_anal_bpvalue -- 市场基点价值
    ,b_anal_sduration -- 市场利差久期
    ,b_anal_scnvxty -- 市场利差凸性
    ,b_anal_interestduration_cnbd -- 估价利率久期
    ,b_anal_interestcnvxty_cnbd -- 估价利率凸性
    ,b_anal_interestduration -- 市场利率久期
    ,b_anal_interestcnvxty -- 市场利率凸性
    ,b_anal_price_cnbd -- 日终估价全价
    ,b_anal_bpyield -- 日终应计利息
    ,b_anal_surpluscapital -- 剩余本金
    ,b_anal_exchange -- 流通场所
    ,b_anal_credibility -- 可信度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cbondanalysisshc
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cbondanalysisshc exchange partition p_${batch_date} with table ${iol_schema}.wind_cbondanalysisshc_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondanalysisshc to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cbondanalysisshc_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondanalysisshc',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);