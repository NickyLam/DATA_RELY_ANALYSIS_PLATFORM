/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hxyhbalancesheet
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
drop table ${iol_schema}.wind_hxyhbalancesheet_ex purge;
alter table ${iol_schema}.wind_hxyhbalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hxyhbalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hxyhbalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hxyhbalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hxyhbalancesheet_ex(
    object_id -- 对象ID
    ,comp_id -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,iflisted_data -- 是否上市后数据
    ,crncy_code -- 货币代码
    ,prepay -- 预付账款
    ,inventories -- 存货
    ,acct_rcv -- 应收账款
    ,tot_cur_assets -- 流动资产合计
    ,tot_assets -- 资产合计
    ,st_borrow -- 短期借款
    ,int_payable -- 应付利息
    ,non_cur_liab_due_within_1y -- 一年内到期的非流动负债
    ,tot_cur_liab -- 流动负债合计
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,total_liabilities -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,comp_id -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,iflisted_data -- 是否上市后数据
    ,crncy_code -- 货币代码
    ,prepay -- 预付账款
    ,inventories -- 存货
    ,acct_rcv -- 应收账款
    ,tot_cur_assets -- 流动资产合计
    ,tot_assets -- 资产合计
    ,st_borrow -- 短期借款
    ,int_payable -- 应付利息
    ,non_cur_liab_due_within_1y -- 一年内到期的非流动负债
    ,tot_cur_liab -- 流动负债合计
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,total_liabilities -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hxyhbalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hxyhbalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_hxyhbalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hxyhbalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hxyhbalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hxyhbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);