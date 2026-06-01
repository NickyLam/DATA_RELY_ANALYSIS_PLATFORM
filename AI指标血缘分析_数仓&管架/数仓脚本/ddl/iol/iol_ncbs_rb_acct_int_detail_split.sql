/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_int_detail_split
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_int_detail_split
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_int_detail_split purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_int_detail_split(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,company varchar2(20) -- 法人
    ,irl_seq_no varchar2(50) -- 费率编号
    ,month_basis varchar2(3) -- 月基准
    ,near_period varchar2(20) -- 分段周期
    ,near_period_type varchar2(10) -- 分段周期类型
    ,peri_seq_no varchar2(50) -- 周期分段序号
    ,peri_split_id varchar2(50) -- 周期分段id
    ,system_id varchar2(20) -- 系统id
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accr_amt number(17,2) -- 计提金额
    ,accr_days number(5) -- 计提天数
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_reduce_amt number(17,2) -- 协议优惠金额
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,float_rate number(15,8) -- 浮动利率
    ,near_amt number(17,2) -- 靠档金额
    ,real_rate number(15,8) -- 执行利率
    ,delay_int_amount number(22,2) -- 延迟付息累计供核算金额
    ,delay_int_amount_prev number(22,2) -- 延迟付息累计供核算金额-上日
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
grant select on ${iol_schema}.ncbs_rb_acct_int_detail_split to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail_split to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail_split to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_int_detail_split to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_int_detail_split is '账户利息明细分段明细';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.near_period is '分段周期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.near_period_type is '分段周期类型';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.peri_seq_no is '周期分段序号';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.peri_split_id is '周期分段id';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.accr_amt is '计提金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.accr_days is '计提天数';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.agree_reduce_amt is '协议优惠金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.near_amt is '靠档金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.delay_int_amount is '延迟付息累计供核算金额';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.delay_int_amount_prev is '延迟付息累计供核算金额-上日';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_int_detail_split.etl_timestamp is 'ETL处理时间戳';
