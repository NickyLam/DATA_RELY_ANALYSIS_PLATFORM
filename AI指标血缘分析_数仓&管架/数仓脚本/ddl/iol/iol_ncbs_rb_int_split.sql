/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_int_split
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_int_split
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_int_split purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_split(
    base_acct_no varchar2(64) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,after_int_accrued_diff number(15,10) -- 期末计提差额
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,company varchar2(20) -- 法人
    ,cr_rating varchar2(3) -- 客户信用等级
    ,event_type varchar2(20) -- 事件类型
    ,int_calc_bal varchar2(2) -- 计息方式
    ,irl_gene_str varchar2(200) -- 利率因子字符串
    ,month_basis varchar2(3) -- 月基准
    ,pre_int_accrued_diff number(15,10) -- 期初计提差额
    ,source_type varchar2(6) -- 渠道编号
    ,split_rate_flag varchar2(1) -- 利率分段标志
    ,system_id varchar2(20) -- 系统id
    ,tax_type varchar2(2) -- 税种
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,calc_begin_date date -- 利息计算起始日
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,td_end_accr_date date -- 计提结束日期
    ,td_last_accr_date date -- 当期上一计提日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,after_int_accrued number(17,2) -- 期末累计计提
    ,after_int_adj number(17,2) -- 期末累计调整
    ,after_tax_accrued number(17,2) -- 期末累计利息税
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_reduce_amt number(17,2) -- 协议优惠金额
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,cur_int_accrued number(17,2) -- 当期累计计提
    ,cur_int_adj number(17,2) -- 当期累计调整
    ,cur_tax_accrued number(17,2) -- 当期累计利息税
    ,float_rate number(15,8) -- 浮动利率
    ,int_amt number(17,2) -- 利息金额
    ,pre_int_accrued number(17,2) -- 期初累计计提
    ,pre_int_adj number(17,2) -- 期初累计调整
    ,pre_tax_accrued number(17,2) -- 期初累计利息税
    ,real_rate number(15,8) -- 执行利率
    ,tax_rate number(15,8) -- 税率
    ,td_accr_int_day varchar2(2) -- 计提起始日
    ,td_int_num_days number(5) -- 当期累计计息天数
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_int_split to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_int_split to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_int_split to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_int_split to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_int_split is '利率分段表';
comment on column ${iol_schema}.ncbs_rb_int_split.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_int_split.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_int_split.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_int_split.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_int_split.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_int_split.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_int_split.after_int_accrued_diff is '期末计提差额';
comment on column ${iol_schema}.ncbs_rb_int_split.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_rb_int_split.company is '法人';
comment on column ${iol_schema}.ncbs_rb_int_split.cr_rating is '客户信用等级';
comment on column ${iol_schema}.ncbs_rb_int_split.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_int_split.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_int_split.irl_gene_str is '利率因子字符串';
comment on column ${iol_schema}.ncbs_rb_int_split.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_int_split.pre_int_accrued_diff is '期初计提差额';
comment on column ${iol_schema}.ncbs_rb_int_split.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_int_split.split_rate_flag is '利率分段标志';
comment on column ${iol_schema}.ncbs_rb_int_split.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_int_split.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_int_split.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_int_split.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_int_split.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_rb_int_split.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_int_split.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_int_split.td_end_accr_date is '计提结束日期';
comment on column ${iol_schema}.ncbs_rb_int_split.td_last_accr_date is '当期上一计提日';
comment on column ${iol_schema}.ncbs_rb_int_split.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_int_split.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_int_split.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_int_split.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_int_split.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_int_split.after_int_accrued is '期末累计计提';
comment on column ${iol_schema}.ncbs_rb_int_split.after_int_adj is '期末累计调整';
comment on column ${iol_schema}.ncbs_rb_int_split.after_tax_accrued is '期末累计利息税';
comment on column ${iol_schema}.ncbs_rb_int_split.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_rb_int_split.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_rb_int_split.agree_reduce_amt is '协议优惠金额';
comment on column ${iol_schema}.ncbs_rb_int_split.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_rb_int_split.cur_int_accrued is '当期累计计提';
comment on column ${iol_schema}.ncbs_rb_int_split.cur_int_adj is '当期累计调整';
comment on column ${iol_schema}.ncbs_rb_int_split.cur_tax_accrued is '当期累计利息税';
comment on column ${iol_schema}.ncbs_rb_int_split.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_int_split.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_int_split.pre_int_accrued is '期初累计计提';
comment on column ${iol_schema}.ncbs_rb_int_split.pre_int_adj is '期初累计调整';
comment on column ${iol_schema}.ncbs_rb_int_split.pre_tax_accrued is '期初累计利息税';
comment on column ${iol_schema}.ncbs_rb_int_split.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_int_split.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_int_split.td_accr_int_day is '计提起始日';
comment on column ${iol_schema}.ncbs_rb_int_split.td_int_num_days is '当期累计计息天数';
comment on column ${iol_schema}.ncbs_rb_int_split.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_int_split.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_int_split.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_int_split.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_int_split.etl_timestamp is 'ETL处理时间戳';
