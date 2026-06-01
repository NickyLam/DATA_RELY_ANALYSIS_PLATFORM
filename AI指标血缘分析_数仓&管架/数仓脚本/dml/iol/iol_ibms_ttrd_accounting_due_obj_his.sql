/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_accounting_due_obj_his
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
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_accounting_due_obj_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_accounting_due_obj_his;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_accounting_due_obj_his_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_accounting_due_obj_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_accounting_due_obj_his_ex(
    obj_id -- 对象id
    ,tsk_id -- 任务id
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,prmr_inst_id -- 主指令id
    ,currency -- 币种
    ,pay_amount -- 支付余额
    ,receive_amount -- 收取余额
    ,open_time -- 开仓时间
    ,update_time -- 更新时间
    ,first_prmr_inst_id -- 首次挂账主指令号
    ,inst_type -- 存储维度的指令类型
    ,inst_ext_acct_id -- 外部账户
    ,inst_int_acct_id -- 内部账户
    ,inst_trade_grp_id -- 组合号
    ,inst_i_code -- 金融工具代码
    ,inst_a_type -- 金融工具类型
    ,inst_m_type -- 金融工具市场
    ,state -- 挂账状态
    ,pay_cp -- 支付成本
    ,receive_cp -- 收取成本
    ,pay_ai -- 支付利息
    ,receive_ai -- 收取利息
    ,pay_fee -- 支付费用
    ,receive_fee -- 收取费用
    ,pay_cash -- 支付资金
    ,receive_cash -- 收取资金
    ,inst_custom_dim1 -- 扩展维度1
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    obj_id -- 对象id
    ,tsk_id -- 任务id
    ,beg_date -- 开始日期
    ,end_date -- 结束日期
    ,prmr_inst_id -- 主指令id
    ,currency -- 币种
    ,pay_amount -- 支付余额
    ,receive_amount -- 收取余额
    ,open_time -- 开仓时间
    ,update_time -- 更新时间
    ,first_prmr_inst_id -- 首次挂账主指令号
    ,inst_type -- 存储维度的指令类型
    ,inst_ext_acct_id -- 外部账户
    ,inst_int_acct_id -- 内部账户
    ,inst_trade_grp_id -- 组合号
    ,inst_i_code -- 金融工具代码
    ,inst_a_type -- 金融工具类型
    ,inst_m_type -- 金融工具市场
    ,state -- 挂账状态
    ,pay_cp -- 支付成本
    ,receive_cp -- 收取成本
    ,pay_ai -- 支付利息
    ,receive_ai -- 收取利息
    ,pay_fee -- 支付费用
    ,receive_fee -- 收取费用
    ,pay_cash -- 支付资金
    ,receive_cash -- 收取资金
    ,inst_custom_dim1 -- 扩展维度1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_accounting_due_obj_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_accounting_due_obj_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_accounting_due_obj_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_accounting_due_obj_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);