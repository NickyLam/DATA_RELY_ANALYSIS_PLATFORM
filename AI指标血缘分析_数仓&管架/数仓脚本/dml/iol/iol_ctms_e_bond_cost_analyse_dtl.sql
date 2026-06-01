/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_e_bond_cost_analyse_dtl
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
drop table ${iol_schema}.ctms_e_bond_cost_analyse_dtl_ex purge;
alter table ${iol_schema}.ctms_e_bond_cost_analyse_dtl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ctms_e_bond_cost_analyse_dtl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_e_bond_cost_analyse_dtl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_e_bond_cost_analyse_dtl where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_e_bond_cost_analyse_dtl_ex(
    settledate -- 数据日期
    ,account_type -- 账户分类
    ,third_type -- 简易三分类
    ,security_id -- 债券代码
    ,security_name -- 债券名称
    ,security_type -- 债券类别代码
    ,security_type_name -- 债券类别名称
    ,currency -- 币种
    ,position -- 券面总额
    ,residual_qty -- 剩余本金
    ,price_yield -- 到期收益率
    ,net_price -- 市场净价/折溢摊净价
    ,term_to_maturity -- 剩余期限/年
    ,mduration -- 修正久期
    ,floatingpl -- 浮动盈亏
    ,pfolio_id -- 投组编号
    ,pfolio_name -- 投组名称
    ,dirty_market_value -- 全价市值
    ,is_qualified -- 是否合格债券
    ,issuer_name -- 发行人名称
    ,issuer_label -- 发行人ECIF客户号
    ,dmp_time -- 创建时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    settledate -- 数据日期
    ,account_type -- 账户分类
    ,third_type -- 简易三分类
    ,security_id -- 债券代码
    ,security_name -- 债券名称
    ,security_type -- 债券类别代码
    ,security_type_name -- 债券类别名称
    ,currency -- 币种
    ,position -- 券面总额
    ,residual_qty -- 剩余本金
    ,price_yield -- 到期收益率
    ,net_price -- 市场净价/折溢摊净价
    ,term_to_maturity -- 剩余期限/年
    ,mduration -- 修正久期
    ,floatingpl -- 浮动盈亏
    ,pfolio_id -- 投组编号
    ,pfolio_name -- 投组名称
    ,dirty_market_value -- 全价市值
    ,is_qualified -- 是否合格债券
    ,issuer_name -- 发行人名称
    ,issuer_label -- 发行人ECIF客户号
    ,dmp_time -- 创建时间戳
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_e_bond_cost_analyse_dtl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_e_bond_cost_analyse_dtl exchange partition p_${batch_date} with table ${iol_schema}.ctms_e_bond_cost_analyse_dtl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_e_bond_cost_analyse_dtl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_e_bond_cost_analyse_dtl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_e_bond_cost_analyse_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);