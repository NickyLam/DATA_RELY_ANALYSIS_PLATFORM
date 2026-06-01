/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_int_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_int_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_int_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_int_detail(
    agg number(38,2) -- 积数
    ,client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,cycle_flag varchar2(1) -- 是否结息
    ,cycle_freq varchar2(5) -- 结息频率
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,discnt_ui_flag varchar2(1) -- 折扣利息标志
    ,float_type varchar2(20) -- 利率浮动方式
    ,follow_int_day_type varchar2(1) -- 后续变动日利率取值日类型
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,int_appl_type_prev varchar2(1) -- 上一利率启用方式
    ,int_calc_bal varchar2(2) -- 计息方式
    ,int_cap_flag varchar2(1) -- 资本化标志
    ,int_flag varchar2(1) -- 是否扣划利息标志
    ,layer_agreement varchar2(5) -- 签约分层利率类型
    ,month_basis varchar2(3) -- 月基准
    ,penalty_odi_rate_type varchar2(1) -- 罚息利率使用方式
    ,rate_change_ind varchar2(1) -- 利率变化标志
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,retry_flag varchar2(1) -- 是否重算
    ,roll_freq varchar2(5) -- 利率变更周期
    ,split_rate_flag varchar2(1) -- 利率分段标志
    ,system_id varchar2(20) -- 系统id
    ,tax_accrued_diff number(15,10) -- 利息税差额
    ,tax_type varchar2(2) -- 税种
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,calc_begin_date date -- 利息计算起始日
    ,calc_end_date date -- 利息计算截止日
    ,last_accrual_date date -- 上一利息计提日
    ,last_change_date date -- 最后修改日期
    ,last_cycle_date date -- 上一结息日
    ,last_cycle_date_pre date -- 日切前上一结息日
    ,last_roll_date date -- 上一个利率变更日期
    ,last_true_cycle_date date -- 上一真实结息日
    ,next_accr_date date -- 下一计提日期
    ,next_cycle_date date -- 下一结息日
    ,next_roll_date date -- 下一个利率变更日期
    ,settle_cycle_date date -- 账户结算日期
    ,td_last_accr_date date -- 当期上一计提日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accr_int_day varchar2(2) -- 计提日
    ,accr_period_freq varchar2(5) -- 计提周期
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_fixed_tax_rate number(15,8) -- 分户级固定税率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_percent_tax_rate number(11,7) -- 分户级税率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,acct_spread_tax_rate number(15,8) -- 分户级税率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,agree_agg number(38,2) -- 协议积数
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_int number(17,2) -- 协议利息
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_reduce_amt number(17,2) -- 协议优惠金额
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,discnt_int number(17,2) -- 折扣利息
    ,discnt_int_prev number(17,2) -- 上日前付息
    ,discnt_retain_int number(17,2) -- 未实现利息
    ,float_rate number(15,8) -- 浮动利率
    ,follow_trace_natural_days number(5) -- 回溯自然日天数
    ,follow_trace_workday_days number(5) -- 回溯工作日天数
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_accrued_prev number(17,2) -- 上日累计计提利息
    ,int_accrued_t number(17,2) -- 存期计提累计利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,int_adj_prev number(17,2) -- 上日利息调整(累计)
    ,int_amt number(17,2) -- 利息金额
    ,int_cap_amt number(17,2) -- 利息资本化金额
    ,int_past_due number(17,2) -- 逾期利息值
    ,int_posted number(17,2) -- 结息金额
    ,int_posted_ctd number(17,2) -- 结息日利息金额
    ,int_rem_days number(5) -- 计息剩余天数
    ,int_tax_t number(17,2) -- 存量利息税
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,last_int_past_due number(17,2) -- 上日逾期利息
    ,max_int_rate number(15,8) -- 执行利率上限
    ,min_int_rate number(15,8) -- 执行利率下限
    ,real_rate number(15,8) -- 执行利率
    ,roll_day varchar2(2) -- 利率变更日
    ,spread_percent number(11,7) -- 浮动百分比
    ,spread_rate number(15,8) -- 浮动点数
    ,tax_accrued number(17,2) -- 结息周期内利息税累计金额
    ,tax_accrued_calc_ctd number(25,10) -- 计提日利息税原金额
    ,tax_accrued_ctd number(17,2) -- 计提日利息税
    ,tax_posted number(17,2) -- 利息税累计金额
    ,tax_posted_ctd number(17,2) -- 结息日利息税
    ,tax_rate number(15,8) -- 税率
    ,td_accr_int_day varchar2(2) -- 计提起始日
    ,td_int_num_days number(5) -- 当期累计计息天数
    ,ui_int number(17,2) -- 折扣付出利息
    ,ui_penalty_amt number(17,2) -- 折扣罚息金额
    ,int_day varchar2(2) -- 存贷结息日期
    ,adv_upd_last_date date -- 上日累计已付备份日期
    ,adj_upd_last_date date -- 上日累计调整备份日期
    ,past_fad_rate number(15,8) -- 违约利率
    ,delay_total_amt number(17,2) -- 延迟付息累计金额
    ,discnt_int_last_prev number(17,2) -- 上上日前付息
    ,int_accrued_last_prev number(17,2) -- 上上日累计计提利息
    ,int_adj_last_prev number(17,2) -- 上上日利息调整
    ,total_agg number(38,2) -- 总累计积数
    ,delay_int_amount number(22,2) -- 延迟付息累计供核算金额
    ,delay_int_amount_prev number(22,2) -- 延迟付息累计供核算金额-上日
    ,delay_int_amount_last_prev number(17,2) -- 延迟付息累计供核算金额-上上日
    ,month_total_amount number(17,2) -- 当前月份每日日终余额之和
    ,last_month_total_amount number(17,2) -- 上月的每日日终余额之和
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_acct_int_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_int_detail is '利息明细表';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agg is '积数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.cycle_flag is '是否结息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.discnt_ui_flag is '折扣利息标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.float_type is '利率浮动方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.follow_int_day_type is '后续变动日利率取值日类型';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_appl_type_prev is '上一利率启用方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_cap_flag is '资本化标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_flag is '是否扣划利息标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.layer_agreement is '签约分层利率类型';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.penalty_odi_rate_type is '罚息利率使用方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.rate_change_ind is '利率变化标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.split_rate_flag is '利率分段标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_accrued_diff is '利息税差额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.calc_end_date is '利息计算截止日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_accrual_date is '上一利息计提日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_cycle_date_pre is '日切前上一结息日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_roll_date is '上一个利率变更日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_true_cycle_date is '上一真实结息日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.next_accr_date is '下一计提日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.next_roll_date is '下一个利率变更日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.settle_cycle_date is '账户结算日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.td_last_accr_date is '当期上一计提日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.accr_int_day is '计提日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.accr_period_freq is '计提周期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_fixed_tax_rate is '分户级固定税率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_percent_tax_rate is '分户级税率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.acct_spread_tax_rate is '分户级税率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_agg is '协议积数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_int is '协议利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_reduce_amt is '协议优惠金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.discnt_int is '折扣利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.discnt_int_prev is '上日前付息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.discnt_retain_int is '未实现利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.follow_trace_natural_days is '回溯自然日天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.follow_trace_workday_days is '回溯工作日天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_prev is '上日累计计提利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_t is '存期计提累计利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_adj_prev is '上日利息调整(累计)';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_cap_amt is '利息资本化金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_past_due is '逾期利息值';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_posted_ctd is '结息日利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_rem_days is '计息剩余天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_tax_t is '存量利息税';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_int_past_due is '上日逾期利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.max_int_rate is '执行利率上限';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.min_int_rate is '执行利率下限';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_accrued is '结息周期内利息税累计金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_accrued_calc_ctd is '计提日利息税原金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_accrued_ctd is '计提日利息税';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_posted is '利息税累计金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_posted_ctd is '结息日利息税';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.td_accr_int_day is '计提起始日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.td_int_num_days is '当期累计计息天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.ui_int is '折扣付出利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.ui_penalty_amt is '折扣罚息金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.adv_upd_last_date is '上日累计已付备份日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.adj_upd_last_date is '上日累计调整备份日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.past_fad_rate is '违约利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.delay_total_amt is '延迟付息累计金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.discnt_int_last_prev is '上上日前付息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_accrued_last_prev is '上上日累计计提利息';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.int_adj_last_prev is '上上日利息调整';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.total_agg is '总累计积数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.delay_int_amount is '延迟付息累计供核算金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.delay_int_amount_prev is '延迟付息累计供核算金额-上日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.delay_int_amount_last_prev is '延迟付息累计供核算金额-上上日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.month_total_amount is '当前月份每日日终余额之和';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.last_month_total_amount is '上月的每日日终余额之和';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail.etl_timestamp is 'ETL处理时间戳';
