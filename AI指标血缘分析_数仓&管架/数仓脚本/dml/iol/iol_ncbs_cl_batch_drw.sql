/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_batch_drw
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
drop table ${iol_schema}.ncbs_cl_batch_drw_ex purge;
alter table ${iol_schema}.ncbs_cl_batch_drw add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_batch_drw truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_batch_drw_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_batch_drw where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_batch_drw_ex(
    branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,contract_no -- 合同编号
    ,int_type -- 利率类型
    ,prod_type -- 产品编号
    ,tran_type -- 交易类型
    ,analysis -- 分析类型
    ,anytime_rec_flag -- 随借随还标志
    ,auto_settle_flag -- 自动结清标志
    ,batch_no -- 批次号
    ,calc_by_int -- 是否按正常利率浮动
    ,cmisloan_no -- 客户借据编号
    ,company -- 法人
    ,cycle_freq -- 结息频率
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,guaranty_style -- 担保方式
    ,int_appl_type -- 利率启用方式
    ,job_run_id -- 批处理任务id
    ,month_basis -- 月基准
    ,odi_calc_by_int_flag -- 复利利率是否随执行利率浮动
    ,ododi_calc_by_int -- 复利的复利利率是否随执行利率浮动
    ,ododp_calc_by_int -- 罚息的复利利率是否随执行利率浮动
    ,odp_calc_by_int -- 罚息利率是否随执行利率浮动
    ,pre_repay_deal -- 还款计划变更方式
    ,revolve_flag -- 循环贷款标志
    ,roll_freq -- 利率变更周期
    ,sched_mode -- 还款方式
    ,seq_no -- 序号
    ,tran_status -- 冲补抹标志
    ,year_basis -- 年基准天数
    ,hunting_status -- 持续扣款标志
    ,dd_date -- 贷款发放日期
    ,end_date -- 结束日期
    ,next_cycle_date -- 下一结息日
    ,next_roll_date -- 下一个利率变更日期
    ,start_date -- 开始日期
    ,tran_timestamp -- 交易时间戳
    ,dd_amt -- 发放金额
    ,int_actual_rate -- 正常利息行内利率
    ,int_rate -- 出单利率
    ,loan_no -- 贷款号
    ,odi_actual_rate -- 复利行内利率
    ,odi_int_type -- 复利利率类型
    ,odi_rate -- 贷款复利利率
    ,ododi_actual_rate -- 复利的复利行内利率
    ,ododi_int_type -- 复利的复利利率类型
    ,ododi_rate -- 复利的复利利率
    ,ododp_actual_rate -- 罚息的复利行内利率
    ,ododp_int_type -- 罚息的复利利率类型
    ,ododp_rate -- 罚息复利利率
    ,odp_actual_rate -- 罚息行内利率
    ,odp_int_type -- 罚息利率类型
    ,odp_rate -- 贷款罚息利率
    ,orig_loan_amt -- 贷款签约合同金额
    ,roll_day -- 利率变更日
    ,settle_pay_acct_seq_no -- 结算账户序列号
    ,settle_pay_base_acct_no -- 结算付款账户
    ,settle_rec_acct_seq_no -- 自动回收结算账户序列号
    ,settle_rec_base_acct_no -- 自动回收结算账户账号
    ,settle_wtr_acct_seq_no -- 委托存款账户序列号
    ,settle_wtr_base_acct_no -- 贷款委托账号
    ,settle_wts_acct_seq_no -- 委托结算账户序列号
    ,settle_wts_base_acct_no -- 委托结算账户账号
    ,int_day -- 存贷结息日期
    ,reference -- 交易参考号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    branch -- 机构编号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,contract_no -- 合同编号
    ,int_type -- 利率类型
    ,prod_type -- 产品编号
    ,tran_type -- 交易类型
    ,analysis -- 分析类型
    ,anytime_rec_flag -- 随借随还标志
    ,auto_settle_flag -- 自动结清标志
    ,batch_no -- 批次号
    ,calc_by_int -- 是否按正常利率浮动
    ,cmisloan_no -- 客户借据编号
    ,company -- 法人
    ,cycle_freq -- 结息频率
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,guaranty_style -- 担保方式
    ,int_appl_type -- 利率启用方式
    ,job_run_id -- 批处理任务id
    ,month_basis -- 月基准
    ,odi_calc_by_int_flag -- 复利利率是否随执行利率浮动
    ,ododi_calc_by_int -- 复利的复利利率是否随执行利率浮动
    ,ododp_calc_by_int -- 罚息的复利利率是否随执行利率浮动
    ,odp_calc_by_int -- 罚息利率是否随执行利率浮动
    ,pre_repay_deal -- 还款计划变更方式
    ,revolve_flag -- 循环贷款标志
    ,roll_freq -- 利率变更周期
    ,sched_mode -- 还款方式
    ,seq_no -- 序号
    ,tran_status -- 冲补抹标志
    ,year_basis -- 年基准天数
    ,hunting_status -- 持续扣款标志
    ,dd_date -- 贷款发放日期
    ,end_date -- 结束日期
    ,next_cycle_date -- 下一结息日
    ,next_roll_date -- 下一个利率变更日期
    ,start_date -- 开始日期
    ,tran_timestamp -- 交易时间戳
    ,dd_amt -- 发放金额
    ,int_actual_rate -- 正常利息行内利率
    ,int_rate -- 出单利率
    ,loan_no -- 贷款号
    ,odi_actual_rate -- 复利行内利率
    ,odi_int_type -- 复利利率类型
    ,odi_rate -- 贷款复利利率
    ,ododi_actual_rate -- 复利的复利行内利率
    ,ododi_int_type -- 复利的复利利率类型
    ,ododi_rate -- 复利的复利利率
    ,ododp_actual_rate -- 罚息的复利行内利率
    ,ododp_int_type -- 罚息的复利利率类型
    ,ododp_rate -- 罚息复利利率
    ,odp_actual_rate -- 罚息行内利率
    ,odp_int_type -- 罚息利率类型
    ,odp_rate -- 贷款罚息利率
    ,orig_loan_amt -- 贷款签约合同金额
    ,roll_day -- 利率变更日
    ,settle_pay_acct_seq_no -- 结算账户序列号
    ,settle_pay_base_acct_no -- 结算付款账户
    ,settle_rec_acct_seq_no -- 自动回收结算账户序列号
    ,settle_rec_base_acct_no -- 自动回收结算账户账号
    ,settle_wtr_acct_seq_no -- 委托存款账户序列号
    ,settle_wtr_base_acct_no -- 贷款委托账号
    ,settle_wts_acct_seq_no -- 委托结算账户序列号
    ,settle_wts_base_acct_no -- 委托结算账户账号
    ,int_day -- 存贷结息日期
    ,reference -- 交易参考号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_batch_drw
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_batch_drw exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_batch_drw_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_batch_drw to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_batch_drw_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_batch_drw',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);