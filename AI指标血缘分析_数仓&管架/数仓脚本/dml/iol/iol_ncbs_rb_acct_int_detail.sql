/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_int_detail
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
drop table ${iol_schema}.ncbs_rb_acct_int_detail_ex purge;
alter table ${iol_schema}.ncbs_rb_acct_int_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_acct_int_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_acct_int_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_int_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_int_detail_ex(
    agg -- 积数
    ,client_no -- 客户编号
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,agree_change_type -- 协议变动方式
    ,calc_by_int -- 是否按正常利率浮动
    ,company -- 法人
    ,cycle_flag -- 是否结息
    ,cycle_freq -- 结息频率
    ,dac_value -- dac值防篡改加密
    ,discnt_ui_flag -- 折扣利息标志
    ,float_type -- 利率浮动方式
    ,follow_int_day_type -- 后续变动日利率取值日类型
    ,int_accrued_diff -- 计提金额差额
    ,int_appl_type -- 利率启用方式
    ,int_appl_type_prev -- 上一利率启用方式
    ,int_calc_bal -- 计息方式
    ,int_cap_flag -- 资本化标志
    ,int_flag -- 是否扣划利息标志
    ,layer_agreement -- 签约分层利率类型
    ,month_basis -- 月基准
    ,penalty_odi_rate_type -- 罚息利率使用方式
    ,rate_change_ind -- 利率变化标志
    ,rate_effect_type -- 利率生效方式
    ,retry_flag -- 是否重算
    ,roll_freq -- 利率变更周期
    ,split_rate_flag -- 利率分段标志
    ,system_id -- 系统id
    ,tax_accrued_diff -- 利息税差额
    ,tax_type -- 税种
    ,year_basis -- 年基准天数
    ,int_class -- 利息分类
    ,calc_begin_date -- 利息计算起始日
    ,calc_end_date -- 利息计算截止日
    ,last_accrual_date -- 上一利息计提日
    ,last_change_date -- 最后修改日期
    ,last_cycle_date -- 上一结息日
    ,last_cycle_date_pre -- 日切前上一结息日
    ,last_roll_date -- 上一个利率变更日期
    ,last_true_cycle_date -- 上一真实结息日
    ,next_accr_date -- 下一计提日期
    ,next_cycle_date -- 下一结息日
    ,next_roll_date -- 下一个利率变更日期
    ,settle_cycle_date -- 账户结算日期
    ,td_last_accr_date -- 当期上一计提日
    ,tran_timestamp -- 交易时间戳
    ,accr_int_day -- 计提日
    ,accr_period_freq -- 计提周期
    ,acct_fixed_rate -- 分户级固定利率
    ,acct_fixed_tax_rate -- 分户级固定税率
    ,acct_percent_rate -- 分户级利率浮动百分比
    ,acct_percent_tax_rate -- 分户级税率浮动百分比
    ,acct_spread_rate -- 分户级利率浮动百分点
    ,acct_spread_tax_rate -- 分户级税率浮动百分点
    ,actual_rate -- 行内利率
    ,agree_agg -- 协议积数
    ,agree_fixed_rate -- 协议固定利率
    ,agree_int -- 协议利息
    ,agree_percent_rate -- 协议浮动百分比
    ,agree_reduce_amt -- 协议优惠金额
    ,agree_spread_rate -- 协议浮动百分点
    ,discnt_int -- 折扣利息
    ,discnt_int_prev -- 上日前付息
    ,discnt_retain_int -- 未实现利息
    ,float_rate -- 浮动利率
    ,follow_trace_natural_days -- 回溯自然日天数
    ,follow_trace_workday_days -- 回溯工作日天数
    ,int_accrued -- 累计计提
    ,int_accrued_calc_ctd -- 计提日计提实际金额
    ,int_accrued_ctd -- 计提日计提利息
    ,int_accrued_prev -- 上日累计计提利息
    ,int_accrued_t -- 存期计提累计利息
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,int_adj_prev -- 上日利息调整(累计)
    ,int_amt -- 利息金额
    ,int_cap_amt -- 利息资本化金额
    ,int_past_due -- 逾期利息值
    ,int_posted -- 结息金额
    ,int_posted_ctd -- 结息日利息金额
    ,int_rem_days -- 计息剩余天数
    ,int_tax_t -- 存量利息税
    ,last_change_user_id -- 最后修改柜员
    ,last_int_past_due -- 上日逾期利息
    ,max_int_rate -- 执行利率上限
    ,min_int_rate -- 执行利率下限
    ,real_rate -- 执行利率
    ,roll_day -- 利率变更日
    ,spread_percent -- 浮动百分比
    ,spread_rate -- 浮动点数
    ,tax_accrued -- 结息周期内利息税累计金额
    ,tax_accrued_calc_ctd -- 计提日利息税原金额
    ,tax_accrued_ctd -- 计提日利息税
    ,tax_posted -- 利息税累计金额
    ,tax_posted_ctd -- 结息日利息税
    ,tax_rate -- 税率
    ,td_accr_int_day -- 计提起始日
    ,td_int_num_days -- 当期累计计息天数
    ,ui_int -- 折扣付出利息
    ,ui_penalty_amt -- 折扣罚息金额
    ,int_day -- 存贷结息日期
    ,adv_upd_last_date -- 上日累计已付备份日期
    ,adj_upd_last_date -- 上日累计调整备份日期
    ,past_fad_rate -- 违约利率
    ,delay_total_amt -- 延迟付息累计金额
    ,discnt_int_last_prev -- 上上日前付息
    ,int_accrued_last_prev -- 上上日累计计提利息
    ,int_adj_last_prev -- 上上日利息调整
    ,total_agg -- 总累计积数
    ,delay_int_amount -- 延迟付息累计供核算金额
    ,delay_int_amount_prev -- 延迟付息累计供核算金额-上日
    ,delay_int_amount_last_prev -- 
    ,month_total_amount -- 
    ,last_month_total_amount -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    agg -- 积数
    ,client_no -- 客户编号
    ,int_type -- 利率类型
    ,internal_key -- 账户内部键值
    ,agree_change_type -- 协议变动方式
    ,calc_by_int -- 是否按正常利率浮动
    ,company -- 法人
    ,cycle_flag -- 是否结息
    ,cycle_freq -- 结息频率
    ,dac_value -- dac值防篡改加密
    ,discnt_ui_flag -- 折扣利息标志
    ,float_type -- 利率浮动方式
    ,follow_int_day_type -- 后续变动日利率取值日类型
    ,int_accrued_diff -- 计提金额差额
    ,int_appl_type -- 利率启用方式
    ,int_appl_type_prev -- 上一利率启用方式
    ,int_calc_bal -- 计息方式
    ,int_cap_flag -- 资本化标志
    ,int_flag -- 是否扣划利息标志
    ,layer_agreement -- 签约分层利率类型
    ,month_basis -- 月基准
    ,penalty_odi_rate_type -- 罚息利率使用方式
    ,rate_change_ind -- 利率变化标志
    ,rate_effect_type -- 利率生效方式
    ,retry_flag -- 是否重算
    ,roll_freq -- 利率变更周期
    ,split_rate_flag -- 利率分段标志
    ,system_id -- 系统id
    ,tax_accrued_diff -- 利息税差额
    ,tax_type -- 税种
    ,year_basis -- 年基准天数
    ,int_class -- 利息分类
    ,calc_begin_date -- 利息计算起始日
    ,calc_end_date -- 利息计算截止日
    ,last_accrual_date -- 上一利息计提日
    ,last_change_date -- 最后修改日期
    ,last_cycle_date -- 上一结息日
    ,last_cycle_date_pre -- 日切前上一结息日
    ,last_roll_date -- 上一个利率变更日期
    ,last_true_cycle_date -- 上一真实结息日
    ,next_accr_date -- 下一计提日期
    ,next_cycle_date -- 下一结息日
    ,next_roll_date -- 下一个利率变更日期
    ,settle_cycle_date -- 账户结算日期
    ,td_last_accr_date -- 当期上一计提日
    ,tran_timestamp -- 交易时间戳
    ,accr_int_day -- 计提日
    ,accr_period_freq -- 计提周期
    ,acct_fixed_rate -- 分户级固定利率
    ,acct_fixed_tax_rate -- 分户级固定税率
    ,acct_percent_rate -- 分户级利率浮动百分比
    ,acct_percent_tax_rate -- 分户级税率浮动百分比
    ,acct_spread_rate -- 分户级利率浮动百分点
    ,acct_spread_tax_rate -- 分户级税率浮动百分点
    ,actual_rate -- 行内利率
    ,agree_agg -- 协议积数
    ,agree_fixed_rate -- 协议固定利率
    ,agree_int -- 协议利息
    ,agree_percent_rate -- 协议浮动百分比
    ,agree_reduce_amt -- 协议优惠金额
    ,agree_spread_rate -- 协议浮动百分点
    ,discnt_int -- 折扣利息
    ,discnt_int_prev -- 上日前付息
    ,discnt_retain_int -- 未实现利息
    ,float_rate -- 浮动利率
    ,follow_trace_natural_days -- 回溯自然日天数
    ,follow_trace_workday_days -- 回溯工作日天数
    ,int_accrued -- 累计计提
    ,int_accrued_calc_ctd -- 计提日计提实际金额
    ,int_accrued_ctd -- 计提日计提利息
    ,int_accrued_prev -- 上日累计计提利息
    ,int_accrued_t -- 存期计提累计利息
    ,int_adj -- 利息调增金额
    ,int_adj_ctd -- 计提日利息调整
    ,int_adj_prev -- 上日利息调整(累计)
    ,int_amt -- 利息金额
    ,int_cap_amt -- 利息资本化金额
    ,int_past_due -- 逾期利息值
    ,int_posted -- 结息金额
    ,int_posted_ctd -- 结息日利息金额
    ,int_rem_days -- 计息剩余天数
    ,int_tax_t -- 存量利息税
    ,last_change_user_id -- 最后修改柜员
    ,last_int_past_due -- 上日逾期利息
    ,max_int_rate -- 执行利率上限
    ,min_int_rate -- 执行利率下限
    ,real_rate -- 执行利率
    ,roll_day -- 利率变更日
    ,spread_percent -- 浮动百分比
    ,spread_rate -- 浮动点数
    ,tax_accrued -- 结息周期内利息税累计金额
    ,tax_accrued_calc_ctd -- 计提日利息税原金额
    ,tax_accrued_ctd -- 计提日利息税
    ,tax_posted -- 利息税累计金额
    ,tax_posted_ctd -- 结息日利息税
    ,tax_rate -- 税率
    ,td_accr_int_day -- 计提起始日
    ,td_int_num_days -- 当期累计计息天数
    ,ui_int -- 折扣付出利息
    ,ui_penalty_amt -- 折扣罚息金额
    ,int_day -- 存贷结息日期
    ,adv_upd_last_date -- 上日累计已付备份日期
    ,adj_upd_last_date -- 上日累计调整备份日期
    ,past_fad_rate -- 违约利率
    ,delay_total_amt -- 延迟付息累计金额
    ,discnt_int_last_prev -- 上上日前付息
    ,int_accrued_last_prev -- 上上日累计计提利息
    ,int_adj_last_prev -- 上上日利息调整
    ,total_agg -- 总累计积数
    ,delay_int_amount -- 延迟付息累计供核算金额
    ,delay_int_amount_prev -- 延迟付息累计供核算金额-上日
    ,delay_int_amount_last_prev -- 
    ,month_total_amount -- 
    ,last_month_total_amount -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_acct_int_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_acct_int_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_int_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_int_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_acct_int_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_int_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);