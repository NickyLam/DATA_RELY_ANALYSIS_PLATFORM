/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_aindexvaluation
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
drop table ${iol_schema}.wind_aindexvaluation_ex purge;
alter table ${iol_schema}.wind_aindexvaluation add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_aindexvaluation truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_aindexvaluation_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_aindexvaluation where 0=1;

insert /*+ append */ into ${iol_schema}.wind_aindexvaluation_ex(
    object_id -- 对象ID
    ,s_info_windcode -- 指数Wind代码
    ,trade_dt -- 交易日期
    ,con_num -- 成分股数量
    ,pe_lyr -- 市盈率(PE,LYR)
    ,pe_ttm -- 市盈率(PE,TTM)
    ,pb_lf -- 市净率(PB,LF)
    ,pcf_lyr -- 市现率(PCF,LYR)
    ,pcf_ttm -- 市现率(PCF,TTM)
    ,ps_lyr -- 市销率(PS,LYR)
    ,ps_ttm -- 市销率(PS,TTM)
    ,mv_total -- 当日总市值合计（元）
    ,mv_float -- 当日流通市值合计（元）
    ,dividend_yield -- 股息率
    ,peg_his -- 历史PEG
    ,tot_shr -- 总股本合计（股）
    ,tot_shr_float -- 流通股本合计（股）
    ,tot_shr_free -- 自由流通股本合计（股）
    ,turnover -- 换手率
    ,turnover_free -- 换手率(自由流通)
    ,est_net_profit_y1 -- 预测净利润(Y1)
    ,est_net_profit_y2 -- 预测净利润(Y2)
    ,est_bus_inc_y1 -- 预测营业收入(Y1)
    ,est_bus_inc_y2 -- 预测营业收入(Y2)
    ,est_eps_y1 -- 预测每股收益(Y1)
    ,est_eps_y2 -- 预测每股收益(Y2)
    ,est_yoyprofit_y1 -- 预测净利润同比增速(Y1)
    ,est_yoyprofit_y2 -- 预测净利润同比增速(Y2)
    ,est_yoygr_y1 -- 预测营业收入同比增速(Y1)
    ,est_yoygr_y2 -- 预测营业收入同比增速(Y2)
    ,est_pe_y1 -- 预测PE(Y1)
    ,est_pe_y2 -- 预测PE(Y2)
    ,est_peg_y1 -- 预测PEG(Y1)
    ,est_peg_y2 -- 预测PEG(Y2)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- 指数Wind代码
    ,trade_dt -- 交易日期
    ,con_num -- 成分股数量
    ,pe_lyr -- 市盈率(PE,LYR)
    ,pe_ttm -- 市盈率(PE,TTM)
    ,pb_lf -- 市净率(PB,LF)
    ,pcf_lyr -- 市现率(PCF,LYR)
    ,pcf_ttm -- 市现率(PCF,TTM)
    ,ps_lyr -- 市销率(PS,LYR)
    ,ps_ttm -- 市销率(PS,TTM)
    ,mv_total -- 当日总市值合计（元）
    ,mv_float -- 当日流通市值合计（元）
    ,dividend_yield -- 股息率
    ,peg_his -- 历史PEG
    ,tot_shr -- 总股本合计（股）
    ,tot_shr_float -- 流通股本合计（股）
    ,tot_shr_free -- 自由流通股本合计（股）
    ,turnover -- 换手率
    ,turnover_free -- 换手率(自由流通)
    ,est_net_profit_y1 -- 预测净利润(Y1)
    ,est_net_profit_y2 -- 预测净利润(Y2)
    ,est_bus_inc_y1 -- 预测营业收入(Y1)
    ,est_bus_inc_y2 -- 预测营业收入(Y2)
    ,est_eps_y1 -- 预测每股收益(Y1)
    ,est_eps_y2 -- 预测每股收益(Y2)
    ,est_yoyprofit_y1 -- 预测净利润同比增速(Y1)
    ,est_yoyprofit_y2 -- 预测净利润同比增速(Y2)
    ,est_yoygr_y1 -- 预测营业收入同比增速(Y1)
    ,est_yoygr_y2 -- 预测营业收入同比增速(Y2)
    ,est_pe_y1 -- 预测PE(Y1)
    ,est_pe_y2 -- 预测PE(Y2)
    ,est_peg_y1 -- 预测PEG(Y1)
    ,est_peg_y2 -- 预测PEG(Y2)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_aindexvaluation
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_aindexvaluation exchange partition p_${batch_date} with table ${iol_schema}.wind_aindexvaluation_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_aindexvaluation to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_aindexvaluation_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_aindexvaluation',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);