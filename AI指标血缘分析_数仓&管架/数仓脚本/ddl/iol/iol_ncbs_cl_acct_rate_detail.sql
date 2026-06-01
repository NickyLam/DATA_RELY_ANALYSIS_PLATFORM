/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_rate_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_rate_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_rate_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_rate_detail(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,cycle_flag varchar2(1) -- 是否结息
    ,cycle_freq varchar2(5) -- 结息频率
    ,float_type varchar2(20) -- 利率浮动方式
    ,follow_int_day_type varchar2(1) -- 后续变动日利率取值日类型
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,int_calc_bal varchar2(2) -- 计息方式
    ,int_cap_flag varchar2(1) -- 资本化标志
    ,int_ind_flag varchar2(1) -- 是否计息
    ,month_basis varchar2(3) -- 月基准
    ,penalty_odi_rate_type varchar2(1) -- 罚息利率使用方式
    ,rate_change_ind varchar2(1) -- 利率变化标志
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,retry_flag varchar2(1) -- 是否重算
    ,roll_date date -- 利率变动日
    ,roll_freq varchar2(5) -- 利率变更周期
    ,tax_type varchar2(2) -- 税种
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,last_roll_date date -- 上一个利率变更日期
    ,next_roll_date date -- 下一个利率变更日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accr_int_day varchar2(2) -- 计提日
    ,accr_period_freq varchar2(5) -- 计提周期
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_fixed_tax_rate number(15,8) -- 分户级固定税率
    ,acct_percent_rate varchar2(50) -- 分户级利率浮动百分比
    ,acct_percent_tax_rate number(11,7) -- 分户级税率浮动百分比
    ,acct_spread_rate varchar2(50) -- 分户级利率浮动百分点
    ,acct_spread_tax_rate number(15,8) -- 分户级税率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,float_rate number(15,8) -- 浮动利率
    ,max_int_rate number(15,8) -- 执行利率上限
    ,min_int_rate number(15,8) -- 执行利率下限
    ,real_rate number(15,8) -- 执行利率
    ,roll_day varchar2(2) -- 利率变更日
    ,spread_percent number(11,7) -- 浮动百分比
    ,spread_rate number(15,8) -- 浮动点数
    ,tax_rate number(15,8) -- 税率
    ,int_day varchar2(2) -- 存贷结息日期
    ,is_cross_flag varchar2(1) -- 是否已跨月或跨季
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
grant select on ${iol_schema}.ncbs_cl_acct_rate_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_rate_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_rate_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_rate_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_rate_detail is '计结息配置表';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.cycle_flag is '是否结息';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.float_type is '利率浮动方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.follow_int_day_type is '后续变动日利率取值日类型';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_cap_flag is '资本化标志';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.penalty_odi_rate_type is '罚息利率使用方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.rate_change_ind is '利率变化标志';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.roll_date is '利率变动日';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.tax_type is '税种';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.last_roll_date is '上一个利率变更日期';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.next_roll_date is '下一个利率变更日期';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.accr_int_day is '计提日';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.accr_period_freq is '计提周期';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_fixed_tax_rate is '分户级固定税率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_percent_tax_rate is '分户级税率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.acct_spread_tax_rate is '分户级税率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.max_int_rate is '执行利率上限';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.min_int_rate is '执行利率下限';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.is_cross_flag is '是否已跨月或跨季';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_rate_detail.etl_timestamp is 'ETL处理时间戳';
