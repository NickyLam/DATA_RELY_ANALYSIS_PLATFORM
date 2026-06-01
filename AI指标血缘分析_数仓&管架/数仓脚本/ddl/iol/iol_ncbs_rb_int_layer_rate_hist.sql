/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_int_layer_rate_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_int_layer_rate_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_int_layer_rate_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_layer_rate_hist(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,irl_seq_no varchar2(50) -- 费率编号
    ,month_basis varchar2(3) -- 月基准
    ,near_period varchar2(20) -- 分段周期
    ,near_period_type varchar2(10) -- 分段周期类型
    ,system_id varchar2(20) -- 系统id
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,end_date date -- 结束日期
    ,split_date date -- 分段时计算开始日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accr_amt number(17,2) -- 计提金额
    ,accr_days number(5) -- 计提天数
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,float_rate number(15,8) -- 浮动利率
    ,near_amt number(17,2) -- 靠档金额
    ,real_rate number(15,8) -- 执行利率
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
grant select on ${iol_schema}.ncbs_rb_int_layer_rate_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_int_layer_rate_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_int_layer_rate_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_int_layer_rate_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_int_layer_rate_hist is '分户利率分层历史表';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.near_period is '分段周期';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.near_period_type is '分段周期类型';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.split_date is '分段时计算开始日期';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.accr_amt is '计提金额';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.accr_days is '计提天数';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.near_amt is '靠档金额';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_int_layer_rate_hist.etl_timestamp is 'ETL处理时间戳';
