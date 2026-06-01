/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareannfinancialindicator
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
drop table ${iol_schema}.wind_ashareannfinancialindicator_ex purge;
alter table ${iol_schema}.wind_ashareannfinancialindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_ashareannfinancialindicator truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareannfinancialindicator_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareannfinancialindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareannfinancialindicator_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,iflisted_data -- 是否上市后数据
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,s_fa_eps_diluted -- 每股收益-摊薄(元)
    ,s_fa_eps_basic -- 每股收益-基本
    ,s_fa_eps_diluted2 -- 每股收益-稀释(元)
    ,s_fa_eps_ex -- 每股收益-扣除(元)
    ,s_fa_eps_exbasic -- 每股收益-扣除/基本
    ,s_fa_eps_exdiluted -- 每股收益-扣除/稀释(元)
    ,s_fa_bps -- 每股净资产(元)
    ,s_fa_bps_sh -- 归属于母公司股东的每股净资产(元)
    ,s_fa_bps_adjust -- 每股净资产-调整(元)
    ,roe_diluted -- 净资产收益率-摊薄(%)
    ,roe_weighted -- 净资产收益率-加权(%)
    ,roe_ex -- 净资产收益率-扣除(%)
    ,roe_exweighted -- 净资产收益率-扣除/加权(%)
    ,net_profit -- 国际会计准则净利润(元)
    ,rd_expense -- 研发费用(元)
    ,s_fa_extraordinary -- 非经常性损益(元)
    ,s_fa_current -- 流动比(%)
    ,s_fa_quick -- 速动比(%)
    ,s_fa_arturn -- 应收账款周转率(%)
    ,s_fa_invturn -- 存货周转率(%)
    ,s_ft_debttoassets -- 资产负债率(%)
    ,s_fa_ocfps -- 每股经营活动产生的现金流量净额(元)
    ,s_fa_yoyocfps -- 同比增长率.每股经营活动产生的现金流量净额(%)
    ,s_fa_deductedprofit -- 扣除非经常性损益后的净利润(扣除少数股东损益)
    ,s_fa_deductedprofit_yoy -- 同比增长率.扣除非经常性损益后的净利润(扣除少数股东损益)(%)
    ,contributionps -- 每股社会贡献值(元)
    ,growth_bps_sh -- 比年初增长率.归属于母公司股东的每股净资产(%)
    ,s_fa_yoyequity -- 比年初增长率.归属母公司的股东权益(%)
    ,yoy_roe_diluted -- 同比增长率.净资产收益率(摊薄)(%)
    ,yoy_net_cash_flows -- 同比增长率.经营活动产生的现金流量净额(%)
    ,s_fa_yoyeps_basic -- 同比增长率.基本每股收益(%)
    ,s_fa_yoyeps_diluted -- 同比增长率.稀释每股收益(%)
    ,s_fa_yoyop -- 同比增长率.营业利润(%)
    ,s_fa_yoyebt -- 同比增长率.利润总额(%)
    ,net_profit_yoy -- 同比增长率.净利润(%)
    ,memo -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,iflisted_data -- 是否上市后数据
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,s_fa_eps_diluted -- 每股收益-摊薄(元)
    ,s_fa_eps_basic -- 每股收益-基本
    ,s_fa_eps_diluted2 -- 每股收益-稀释(元)
    ,s_fa_eps_ex -- 每股收益-扣除(元)
    ,s_fa_eps_exbasic -- 每股收益-扣除/基本
    ,s_fa_eps_exdiluted -- 每股收益-扣除/稀释(元)
    ,s_fa_bps -- 每股净资产(元)
    ,s_fa_bps_sh -- 归属于母公司股东的每股净资产(元)
    ,s_fa_bps_adjust -- 每股净资产-调整(元)
    ,roe_diluted -- 净资产收益率-摊薄(%)
    ,roe_weighted -- 净资产收益率-加权(%)
    ,roe_ex -- 净资产收益率-扣除(%)
    ,roe_exweighted -- 净资产收益率-扣除/加权(%)
    ,net_profit -- 国际会计准则净利润(元)
    ,rd_expense -- 研发费用(元)
    ,s_fa_extraordinary -- 非经常性损益(元)
    ,s_fa_current -- 流动比(%)
    ,s_fa_quick -- 速动比(%)
    ,s_fa_arturn -- 应收账款周转率(%)
    ,s_fa_invturn -- 存货周转率(%)
    ,s_ft_debttoassets -- 资产负债率(%)
    ,s_fa_ocfps -- 每股经营活动产生的现金流量净额(元)
    ,s_fa_yoyocfps -- 同比增长率.每股经营活动产生的现金流量净额(%)
    ,s_fa_deductedprofit -- 扣除非经常性损益后的净利润(扣除少数股东损益)
    ,s_fa_deductedprofit_yoy -- 同比增长率.扣除非经常性损益后的净利润(扣除少数股东损益)(%)
    ,contributionps -- 每股社会贡献值(元)
    ,growth_bps_sh -- 比年初增长率.归属于母公司股东的每股净资产(%)
    ,s_fa_yoyequity -- 比年初增长率.归属母公司的股东权益(%)
    ,yoy_roe_diluted -- 同比增长率.净资产收益率(摊薄)(%)
    ,yoy_net_cash_flows -- 同比增长率.经营活动产生的现金流量净额(%)
    ,s_fa_yoyeps_basic -- 同比增长率.基本每股收益(%)
    ,s_fa_yoyeps_diluted -- 同比增长率.稀释每股收益(%)
    ,s_fa_yoyop -- 同比增长率.营业利润(%)
    ,s_fa_yoyebt -- 同比增长率.利润总额(%)
    ,net_profit_yoy -- 同比增长率.净利润(%)
    ,memo -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareannfinancialindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareannfinancialindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareannfinancialindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareannfinancialindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareannfinancialindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareannfinancialindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);