/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lmis_asset_lessee_metering_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.lmis_asset_lessee_metering_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.lmis_asset_lessee_metering_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_lessee_metering_info_op purge;
drop table ${iol_schema}.lmis_asset_lessee_metering_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_lessee_metering_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_lessee_metering_info where 0=1;

create table ${iol_schema}.lmis_asset_lessee_metering_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_lessee_metering_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_lessee_metering_info_cl(
            id -- 承租计量ID
            ,lessee_id -- 承租资产ID
            ,metering_date -- 计量日期
            ,book_code -- 账簿代码
            ,period_name -- 期间名称
            ,asset_amount_begin -- 期初使用权资产余额
            ,deprn_amount -- 本期折旧
            ,accumulated_deprn_amount -- 累计折旧
            ,asset_amount_end -- 期末使用权资产余额
            ,payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
            ,period_payable_amount -- 本期应付款（计划付款额不含税）
            ,accumulated_payable_amount -- 累计应付款
            ,payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
            ,amortized_cost_begin -- 期初租赁负债（摊余成本）余额
            ,period_amortized_cost -- 本期租赁负债变化
            ,accumulated_amortized_cost -- 累计租赁负债变化
            ,amortized_cost_end -- 期末租赁负债（摊余成本）余额
            ,interest_begin -- 期初租赁负债-未确认融资费用余额
            ,period_interest -- 本期利息费用
            ,accumulated_interest -- 累计利息费用
            ,interest_end -- 期末租赁负债-未确认融资费用余额
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,asset_adj_amount -- 本期使用权资产价值调整额
            ,asset_mod_amount -- 本期合同变更使用权资产发生额
            ,payable_amount_mod -- 本期合同变更租赁负债应付租赁款
            ,amortized_cost_mod -- 本期合同变更摊余成本发生额
            ,interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
            ,new_account_amount -- 新准则期间损益金额
            ,old_account_amount -- 旧准则期间损益金额
            ,differ_amount -- 新旧准则损益差异
            ,month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
            ,month_amortized_cost -- 本期租赁负债变化(当月累计)
            ,month_period_interest -- 本期利息费用(当月累计)
            ,accumulated_account_amount -- 累计旧准则期间损益金额
            ,date_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_lessee_metering_info_op(
            id -- 承租计量ID
            ,lessee_id -- 承租资产ID
            ,metering_date -- 计量日期
            ,book_code -- 账簿代码
            ,period_name -- 期间名称
            ,asset_amount_begin -- 期初使用权资产余额
            ,deprn_amount -- 本期折旧
            ,accumulated_deprn_amount -- 累计折旧
            ,asset_amount_end -- 期末使用权资产余额
            ,payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
            ,period_payable_amount -- 本期应付款（计划付款额不含税）
            ,accumulated_payable_amount -- 累计应付款
            ,payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
            ,amortized_cost_begin -- 期初租赁负债（摊余成本）余额
            ,period_amortized_cost -- 本期租赁负债变化
            ,accumulated_amortized_cost -- 累计租赁负债变化
            ,amortized_cost_end -- 期末租赁负债（摊余成本）余额
            ,interest_begin -- 期初租赁负债-未确认融资费用余额
            ,period_interest -- 本期利息费用
            ,accumulated_interest -- 累计利息费用
            ,interest_end -- 期末租赁负债-未确认融资费用余额
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,asset_adj_amount -- 本期使用权资产价值调整额
            ,asset_mod_amount -- 本期合同变更使用权资产发生额
            ,payable_amount_mod -- 本期合同变更租赁负债应付租赁款
            ,amortized_cost_mod -- 本期合同变更摊余成本发生额
            ,interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
            ,new_account_amount -- 新准则期间损益金额
            ,old_account_amount -- 旧准则期间损益金额
            ,differ_amount -- 新旧准则损益差异
            ,month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
            ,month_amortized_cost -- 本期租赁负债变化(当月累计)
            ,month_period_interest -- 本期利息费用(当月累计)
            ,accumulated_account_amount -- 累计旧准则期间损益金额
            ,date_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 承租计量ID
    ,nvl(n.lessee_id, o.lessee_id) as lessee_id -- 承租资产ID
    ,nvl(n.metering_date, o.metering_date) as metering_date -- 计量日期
    ,nvl(n.book_code, o.book_code) as book_code -- 账簿代码
    ,nvl(n.period_name, o.period_name) as period_name -- 期间名称
    ,nvl(n.asset_amount_begin, o.asset_amount_begin) as asset_amount_begin -- 期初使用权资产余额
    ,nvl(n.deprn_amount, o.deprn_amount) as deprn_amount -- 本期折旧
    ,nvl(n.accumulated_deprn_amount, o.accumulated_deprn_amount) as accumulated_deprn_amount -- 累计折旧
    ,nvl(n.asset_amount_end, o.asset_amount_end) as asset_amount_end -- 期末使用权资产余额
    ,nvl(n.payable_amount_begin, o.payable_amount_begin) as payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
    ,nvl(n.period_payable_amount, o.period_payable_amount) as period_payable_amount -- 本期应付款（计划付款额不含税）
    ,nvl(n.accumulated_payable_amount, o.accumulated_payable_amount) as accumulated_payable_amount -- 累计应付款
    ,nvl(n.payable_amount_end, o.payable_amount_end) as payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
    ,nvl(n.amortized_cost_begin, o.amortized_cost_begin) as amortized_cost_begin -- 期初租赁负债（摊余成本）余额
    ,nvl(n.period_amortized_cost, o.period_amortized_cost) as period_amortized_cost -- 本期租赁负债变化
    ,nvl(n.accumulated_amortized_cost, o.accumulated_amortized_cost) as accumulated_amortized_cost -- 累计租赁负债变化
    ,nvl(n.amortized_cost_end, o.amortized_cost_end) as amortized_cost_end -- 期末租赁负债（摊余成本）余额
    ,nvl(n.interest_begin, o.interest_begin) as interest_begin -- 期初租赁负债-未确认融资费用余额
    ,nvl(n.period_interest, o.period_interest) as period_interest -- 本期利息费用
    ,nvl(n.accumulated_interest, o.accumulated_interest) as accumulated_interest -- 累计利息费用
    ,nvl(n.interest_end, o.interest_end) as interest_end -- 期末租赁负债-未确认融资费用余额
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.created_date, o.created_date) as created_date -- 创建时间
    ,nvl(n.last_updated_by, o.last_updated_by) as last_updated_by -- 最后更新人
    ,nvl(n.last_updated_date, o.last_updated_date) as last_updated_date -- 最后更新时间
    ,nvl(n.version_number, o.version_number) as version_number -- 版本号
    ,nvl(n.asset_adj_amount, o.asset_adj_amount) as asset_adj_amount -- 本期使用权资产价值调整额
    ,nvl(n.asset_mod_amount, o.asset_mod_amount) as asset_mod_amount -- 本期合同变更使用权资产发生额
    ,nvl(n.payable_amount_mod, o.payable_amount_mod) as payable_amount_mod -- 本期合同变更租赁负债应付租赁款
    ,nvl(n.amortized_cost_mod, o.amortized_cost_mod) as amortized_cost_mod -- 本期合同变更摊余成本发生额
    ,nvl(n.interest_mod, o.interest_mod) as interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
    ,nvl(n.new_account_amount, o.new_account_amount) as new_account_amount -- 新准则期间损益金额
    ,nvl(n.old_account_amount, o.old_account_amount) as old_account_amount -- 旧准则期间损益金额
    ,nvl(n.differ_amount, o.differ_amount) as differ_amount -- 新旧准则损益差异
    ,nvl(n.month_payable_amount, o.month_payable_amount) as month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
    ,nvl(n.month_amortized_cost, o.month_amortized_cost) as month_amortized_cost -- 本期租赁负债变化(当月累计)
    ,nvl(n.month_period_interest, o.month_period_interest) as month_period_interest -- 本期利息费用(当月累计)
    ,nvl(n.accumulated_account_amount, o.accumulated_account_amount) as accumulated_account_amount -- 累计旧准则期间损益金额
    ,nvl(n.date_type, o.date_type) as date_type -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.lmis_asset_lessee_metering_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.lmis_asset_lessee_metering_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.lessee_id <> n.lessee_id
        or o.metering_date <> n.metering_date
        or o.book_code <> n.book_code
        or o.period_name <> n.period_name
        or o.asset_amount_begin <> n.asset_amount_begin
        or o.deprn_amount <> n.deprn_amount
        or o.accumulated_deprn_amount <> n.accumulated_deprn_amount
        or o.asset_amount_end <> n.asset_amount_end
        or o.payable_amount_begin <> n.payable_amount_begin
        or o.period_payable_amount <> n.period_payable_amount
        or o.accumulated_payable_amount <> n.accumulated_payable_amount
        or o.payable_amount_end <> n.payable_amount_end
        or o.amortized_cost_begin <> n.amortized_cost_begin
        or o.period_amortized_cost <> n.period_amortized_cost
        or o.accumulated_amortized_cost <> n.accumulated_amortized_cost
        or o.amortized_cost_end <> n.amortized_cost_end
        or o.interest_begin <> n.interest_begin
        or o.period_interest <> n.period_interest
        or o.accumulated_interest <> n.accumulated_interest
        or o.interest_end <> n.interest_end
        or o.tenant_id <> n.tenant_id
        or o.created_by <> n.created_by
        or o.created_date <> n.created_date
        or o.last_updated_by <> n.last_updated_by
        or o.last_updated_date <> n.last_updated_date
        or o.version_number <> n.version_number
        or o.asset_adj_amount <> n.asset_adj_amount
        or o.asset_mod_amount <> n.asset_mod_amount
        or o.payable_amount_mod <> n.payable_amount_mod
        or o.amortized_cost_mod <> n.amortized_cost_mod
        or o.interest_mod <> n.interest_mod
        or o.new_account_amount <> n.new_account_amount
        or o.old_account_amount <> n.old_account_amount
        or o.differ_amount <> n.differ_amount
        or o.month_payable_amount <> n.month_payable_amount
        or o.month_amortized_cost <> n.month_amortized_cost
        or o.month_period_interest <> n.month_period_interest
        or o.accumulated_account_amount <> n.accumulated_account_amount
        or o.date_type <> n.date_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_lessee_metering_info_cl(
            id -- 承租计量ID
            ,lessee_id -- 承租资产ID
            ,metering_date -- 计量日期
            ,book_code -- 账簿代码
            ,period_name -- 期间名称
            ,asset_amount_begin -- 期初使用权资产余额
            ,deprn_amount -- 本期折旧
            ,accumulated_deprn_amount -- 累计折旧
            ,asset_amount_end -- 期末使用权资产余额
            ,payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
            ,period_payable_amount -- 本期应付款（计划付款额不含税）
            ,accumulated_payable_amount -- 累计应付款
            ,payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
            ,amortized_cost_begin -- 期初租赁负债（摊余成本）余额
            ,period_amortized_cost -- 本期租赁负债变化
            ,accumulated_amortized_cost -- 累计租赁负债变化
            ,amortized_cost_end -- 期末租赁负债（摊余成本）余额
            ,interest_begin -- 期初租赁负债-未确认融资费用余额
            ,period_interest -- 本期利息费用
            ,accumulated_interest -- 累计利息费用
            ,interest_end -- 期末租赁负债-未确认融资费用余额
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,asset_adj_amount -- 本期使用权资产价值调整额
            ,asset_mod_amount -- 本期合同变更使用权资产发生额
            ,payable_amount_mod -- 本期合同变更租赁负债应付租赁款
            ,amortized_cost_mod -- 本期合同变更摊余成本发生额
            ,interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
            ,new_account_amount -- 新准则期间损益金额
            ,old_account_amount -- 旧准则期间损益金额
            ,differ_amount -- 新旧准则损益差异
            ,month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
            ,month_amortized_cost -- 本期租赁负债变化(当月累计)
            ,month_period_interest -- 本期利息费用(当月累计)
            ,accumulated_account_amount -- 累计旧准则期间损益金额
            ,date_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_lessee_metering_info_op(
            id -- 承租计量ID
            ,lessee_id -- 承租资产ID
            ,metering_date -- 计量日期
            ,book_code -- 账簿代码
            ,period_name -- 期间名称
            ,asset_amount_begin -- 期初使用权资产余额
            ,deprn_amount -- 本期折旧
            ,accumulated_deprn_amount -- 累计折旧
            ,asset_amount_end -- 期末使用权资产余额
            ,payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
            ,period_payable_amount -- 本期应付款（计划付款额不含税）
            ,accumulated_payable_amount -- 累计应付款
            ,payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
            ,amortized_cost_begin -- 期初租赁负债（摊余成本）余额
            ,period_amortized_cost -- 本期租赁负债变化
            ,accumulated_amortized_cost -- 累计租赁负债变化
            ,amortized_cost_end -- 期末租赁负债（摊余成本）余额
            ,interest_begin -- 期初租赁负债-未确认融资费用余额
            ,period_interest -- 本期利息费用
            ,accumulated_interest -- 累计利息费用
            ,interest_end -- 期末租赁负债-未确认融资费用余额
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,asset_adj_amount -- 本期使用权资产价值调整额
            ,asset_mod_amount -- 本期合同变更使用权资产发生额
            ,payable_amount_mod -- 本期合同变更租赁负债应付租赁款
            ,amortized_cost_mod -- 本期合同变更摊余成本发生额
            ,interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
            ,new_account_amount -- 新准则期间损益金额
            ,old_account_amount -- 旧准则期间损益金额
            ,differ_amount -- 新旧准则损益差异
            ,month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
            ,month_amortized_cost -- 本期租赁负债变化(当月累计)
            ,month_period_interest -- 本期利息费用(当月累计)
            ,accumulated_account_amount -- 累计旧准则期间损益金额
            ,date_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 承租计量ID
    ,o.lessee_id -- 承租资产ID
    ,o.metering_date -- 计量日期
    ,o.book_code -- 账簿代码
    ,o.period_name -- 期间名称
    ,o.asset_amount_begin -- 期初使用权资产余额
    ,o.deprn_amount -- 本期折旧
    ,o.accumulated_deprn_amount -- 累计折旧
    ,o.asset_amount_end -- 期末使用权资产余额
    ,o.payable_amount_begin -- 期初租赁负债-应付租赁款（不含税）
    ,o.period_payable_amount -- 本期应付款（计划付款额不含税）
    ,o.accumulated_payable_amount -- 累计应付款
    ,o.payable_amount_end -- 期末租赁负债-应付租赁款（不含税）
    ,o.amortized_cost_begin -- 期初租赁负债（摊余成本）余额
    ,o.period_amortized_cost -- 本期租赁负债变化
    ,o.accumulated_amortized_cost -- 累计租赁负债变化
    ,o.amortized_cost_end -- 期末租赁负债（摊余成本）余额
    ,o.interest_begin -- 期初租赁负债-未确认融资费用余额
    ,o.period_interest -- 本期利息费用
    ,o.accumulated_interest -- 累计利息费用
    ,o.interest_end -- 期末租赁负债-未确认融资费用余额
    ,o.tenant_id -- 租户ID
    ,o.created_by -- 创建人
    ,o.created_date -- 创建时间
    ,o.last_updated_by -- 最后更新人
    ,o.last_updated_date -- 最后更新时间
    ,o.version_number -- 版本号
    ,o.asset_adj_amount -- 本期使用权资产价值调整额
    ,o.asset_mod_amount -- 本期合同变更使用权资产发生额
    ,o.payable_amount_mod -- 本期合同变更租赁负债应付租赁款
    ,o.amortized_cost_mod -- 本期合同变更摊余成本发生额
    ,o.interest_mod -- 本期合同变更租赁负债-未确认融资费用发生额
    ,o.new_account_amount -- 新准则期间损益金额
    ,o.old_account_amount -- 旧准则期间损益金额
    ,o.differ_amount -- 新旧准则损益差异
    ,o.month_payable_amount -- 本期租赁负债应付租赁款减少额(本月累计)
    ,o.month_amortized_cost -- 本期租赁负债变化(当月累计)
    ,o.month_period_interest -- 本期利息费用(当月累计)
    ,o.accumulated_account_amount -- 累计旧准则期间损益金额
    ,o.date_type -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.lmis_asset_lessee_metering_info_bk o
    left join ${iol_schema}.lmis_asset_lessee_metering_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.lmis_asset_lessee_metering_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.lmis_asset_lessee_metering_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('lmis_asset_lessee_metering_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.lmis_asset_lessee_metering_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.lmis_asset_lessee_metering_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.lmis_asset_lessee_metering_info exchange partition p_${batch_date} with table ${iol_schema}.lmis_asset_lessee_metering_info_cl;
alter table ${iol_schema}.lmis_asset_lessee_metering_info exchange partition p_20991231 with table ${iol_schema}.lmis_asset_lessee_metering_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lmis_asset_lessee_metering_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_lessee_metering_info_op purge;
drop table ${iol_schema}.lmis_asset_lessee_metering_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.lmis_asset_lessee_metering_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lmis_asset_lessee_metering_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
