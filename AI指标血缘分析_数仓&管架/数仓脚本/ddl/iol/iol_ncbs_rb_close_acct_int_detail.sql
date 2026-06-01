/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_close_acct_int_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_close_acct_int_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_close_acct_int_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_close_acct_int_detail(
    internal_key number(15) -- 账户内部键值
    ,int_class varchar2(6) -- 利息分类
    ,accr_period_freq varchar2(5) -- 计提周期
    ,next_accr_date date -- 下一计提日期
    ,last_accrual_date date -- 上一利息计提日
    ,cycle_flag varchar2(1) -- 是否结息
    ,int_cap_flag varchar2(1) -- 资本化标志
    ,next_cycle_date date -- 下一结息日
    ,last_cycle_date date -- 上一结息日
    ,last_true_cycle_date date -- 上一真实结息日
    ,last_cycle_date_pre date -- 日切前上一结息日
    ,cycle_freq varchar2(5) -- 结息频率
    ,accr_int_day varchar2(2) -- 计提日
    ,int_day varchar2(2) -- 存贷结息日期
    ,int_type varchar2(5) -- 利率类型
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_prev number(17,2) -- 上日累计计提利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_prev number(17,2) -- 上日利息调整(累计)
    ,int_posted number(17,2) -- 结息金额
    ,calc_begin_date date -- 利息计算起始日
    ,calc_end_date date -- 利息计算截止日
    ,last_change_date date -- 最后修改日期
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,client_no varchar2(16) -- 客户编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,adj_upd_last_date date -- 上日累计调整备份日期
    ,adv_upd_last_date date -- 上日累计已付备份日期
    ,int_accrued_last_prev number(17,2) -- 上上日累计计提利息
    ,int_adj_last_prev number(17,2) -- 上上日利息调整（累计）
    ,discnt_int_last_prev number(17,2) -- 上上日前付息
    ,month_total_amount number(17,2) -- 当月累计日终余额
    ,last_month_total_amount number(17,2) -- 上月累计日终余额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_close_acct_int_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_close_acct_int_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_close_acct_int_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_close_acct_int_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_close_acct_int_detail is '已销户账户利息调整登记簿';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.accr_period_freq is '计提周期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.next_accr_date is '下一计提日期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_accrual_date is '上一利息计提日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.cycle_flag is '是否结息';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_cap_flag is '资本化标志';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_true_cycle_date is '上一真实结息日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_cycle_date_pre is '日切前上一结息日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.accr_int_day is '计提日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_accrued_prev is '上日累计计提利息';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_adj_prev is '上日利息调整(累计)';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.calc_end_date is '利息计算截止日';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.adj_upd_last_date is '上日累计调整备份日期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.adv_upd_last_date is '上日累计已付备份日期';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_accrued_last_prev is '上上日累计计提利息';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.int_adj_last_prev is '上上日利息调整（累计）';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.discnt_int_last_prev is '上上日前付息';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.month_total_amount is '当月累计日终余额';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.last_month_total_amount is '上月累计日终余额';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_close_acct_int_detail.etl_timestamp is 'ETL处理时间戳';
