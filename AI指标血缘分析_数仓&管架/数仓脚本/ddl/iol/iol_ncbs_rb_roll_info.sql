/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_roll_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_roll_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_roll_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_roll_info(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,new_int_appl_type varchar2(1) -- 新利率启用方式
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,retry_flag varchar2(1) -- 是否重算
    ,roll_freq varchar2(5) -- 利率变更周期
    ,system_id varchar2(20) -- 系统id
    ,tax_flag varchar2(1) -- 是否税信息
    ,tax_resident_flag varchar2(1) -- 税收居民标识
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,new_next_roll_date date -- 新利率变更日期
    ,next_roll_date date -- 下一个利率变更日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_rate number(15,8) -- 行内利率
    ,new_actual_rate number(15,8) -- 新行内利率
    ,new_int_type varchar2(5) -- 新利率类型
    ,new_rate_effect_type varchar2(1) -- 新利率生效方式
    ,new_real_rate number(15,8) -- 新执行利率
    ,new_real_tax_rate number(15,8) -- 新执行税率
    ,new_roll_day varchar2(2) -- 新利率变更日
    ,new_roll_freq varchar2(5) -- 新利率变更周期
    ,new_spread_percent number(11,7) -- 新利率浮动百分比
    ,new_spread_rate number(15,8) -- 新浮动点数
    ,new_spread_tax_percent number(11,7) -- 税率浮动百分比
    ,new_spread_tax_rate number(15,8) -- 税率浮动百分点
    ,real_rate number(15,8) -- 执行利率
    ,roll_day varchar2(2) -- 利率变更日
    ,spread_percent number(11,7) -- 浮动百分比
    ,spread_rate number(15,8) -- 浮动点数
    ,past_fad_rate number(15,8) -- 违约利率
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
grant select on ${iol_schema}.ncbs_rb_roll_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_roll_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_roll_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_roll_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_roll_info is '利率变更流水表';
comment on column ${iol_schema}.ncbs_rb_roll_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_roll_info.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_roll_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_roll_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_roll_info.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_rb_roll_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_roll_info.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_int_appl_type is '新利率启用方式';
comment on column ${iol_schema}.ncbs_rb_roll_info.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_rb_roll_info.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_rb_roll_info.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_rb_roll_info.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_roll_info.tax_flag is '是否税信息';
comment on column ${iol_schema}.ncbs_rb_roll_info.tax_resident_flag is '税收居民标识';
comment on column ${iol_schema}.ncbs_rb_roll_info.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_roll_info.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_next_roll_date is '新利率变更日期';
comment on column ${iol_schema}.ncbs_rb_roll_info.next_roll_date is '下一个利率变更日期';
comment on column ${iol_schema}.ncbs_rb_roll_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_roll_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_roll_info.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_actual_rate is '新行内利率';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_int_type is '新利率类型';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_rate_effect_type is '新利率生效方式';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_real_rate is '新执行利率';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_real_tax_rate is '新执行税率';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_roll_day is '新利率变更日';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_roll_freq is '新利率变更周期';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_spread_percent is '新利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_spread_rate is '新浮动点数';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_spread_tax_percent is '税率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_roll_info.new_spread_tax_rate is '税率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_roll_info.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_roll_info.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_rb_roll_info.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_rb_roll_info.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_rb_roll_info.past_fad_rate is '违约利率';
comment on column ${iol_schema}.ncbs_rb_roll_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_roll_info.etl_timestamp is 'ETL处理时间戳';
