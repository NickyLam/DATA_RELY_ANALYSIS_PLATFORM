/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_roll_info
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
drop table ${iol_schema}.ncbs_cl_roll_info_ex purge;
alter table ${iol_schema}.ncbs_cl_roll_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_roll_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_roll_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_roll_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_roll_info_ex(
    client_no -- 客户编号
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,calc_by_int -- 是否按正常利率浮动
    ,company -- 法人
    ,int_appl_type -- 利率启用方式
    ,new_int_appl_type -- 新利率启用方式
    ,rate_effect_type -- 利率生效方式
    ,retry_flag -- 是否重算
    ,roll_freq -- 利率变更周期
    ,seq_no -- 序号
    ,tax_flag -- 是否税信息
    ,int_class -- 利息分类
    ,change_date -- 交换日期
    ,new_next_roll_date -- 新利率变更日期
    ,next_roll_date -- 下一个利率变更日期
    ,tran_timestamp -- 交易时间戳
    ,actual_rate -- 行内利率
    ,new_actual_rate -- 新行内利率
    ,new_int_type -- 新利率类型
    ,new_rate_effect_type -- 新利率生效方式
    ,new_real_rate -- 新执行利率
    ,new_real_tax_rate -- 新执行税率
    ,new_roll_day -- 新利率变更日
    ,new_roll_freq -- 新利率变更周期
    ,new_spread_percent -- 新利率浮动百分比
    ,new_spread_rate -- 新浮动点数
    ,new_spread_tax_percent -- 税率浮动百分比
    ,new_spread_tax_rate -- 税率浮动百分点
    ,real_rate -- 执行利率
    ,roll_day -- 利率变更日
    ,spread_percent -- 浮动百分比
    ,spread_rate -- 浮动点数
    ,rate_change_type -- 利率变更类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,calc_by_int -- 是否按正常利率浮动
    ,company -- 法人
    ,int_appl_type -- 利率启用方式
    ,new_int_appl_type -- 新利率启用方式
    ,rate_effect_type -- 利率生效方式
    ,retry_flag -- 是否重算
    ,roll_freq -- 利率变更周期
    ,seq_no -- 序号
    ,tax_flag -- 是否税信息
    ,int_class -- 利息分类
    ,change_date -- 交换日期
    ,new_next_roll_date -- 新利率变更日期
    ,next_roll_date -- 下一个利率变更日期
    ,tran_timestamp -- 交易时间戳
    ,actual_rate -- 行内利率
    ,new_actual_rate -- 新行内利率
    ,new_int_type -- 新利率类型
    ,new_rate_effect_type -- 新利率生效方式
    ,new_real_rate -- 新执行利率
    ,new_real_tax_rate -- 新执行税率
    ,new_roll_day -- 新利率变更日
    ,new_roll_freq -- 新利率变更周期
    ,new_spread_percent -- 新利率浮动百分比
    ,new_spread_rate -- 新浮动点数
    ,new_spread_tax_percent -- 税率浮动百分比
    ,new_spread_tax_rate -- 税率浮动百分点
    ,real_rate -- 执行利率
    ,roll_day -- 利率变更日
    ,spread_percent -- 浮动百分比
    ,spread_rate -- 浮动点数
    ,rate_change_type -- 利率变更类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_roll_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_roll_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_roll_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_roll_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_roll_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_roll_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);