/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_int_roll
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_int_roll
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_int_roll purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_int_roll(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,appr_flag varchar2(1) -- 复核标志
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,effect_flag varchar2(1) -- 是否生效标志
    ,new_int_appl_type varchar2(1) -- 新利率启用方式
    ,order_no varchar2(50) -- 预约编号
    ,retry_flag varchar2(1) -- 是否重算
    ,tax_flag varchar2(1) -- 是否税信息
    ,int_class varchar2(6) -- 利息分类
    ,effect_date date -- 产品生效日期
    ,new_next_roll_date date -- 新利率变更日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
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
    ,seq_no varchar2(50) -- 序号
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
grant select on ${iol_schema}.ncbs_cl_int_roll to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_int_roll to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_int_roll to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_int_roll to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_int_roll is '利率变更信息表';
comment on column ${iol_schema}.ncbs_cl_int_roll.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_int_roll.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_int_roll.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_int_roll.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_cl_int_roll.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_cl_int_roll.company is '法人';
comment on column ${iol_schema}.ncbs_cl_int_roll.effect_flag is '是否生效标志';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_int_appl_type is '新利率启用方式';
comment on column ${iol_schema}.ncbs_cl_int_roll.order_no is '预约编号';
comment on column ${iol_schema}.ncbs_cl_int_roll.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_cl_int_roll.tax_flag is '是否税信息';
comment on column ${iol_schema}.ncbs_cl_int_roll.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_int_roll.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_next_roll_date is '新利率变更日期';
comment on column ${iol_schema}.ncbs_cl_int_roll.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_int_roll.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_int_roll.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_int_type is '新利率类型';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_rate_effect_type is '新利率生效方式';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_real_rate is '新执行利率';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_real_tax_rate is '新执行税率';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_roll_day is '新利率变更日';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_roll_freq is '新利率变更周期';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_spread_percent is '新利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_spread_rate is '新浮动点数';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_spread_tax_percent is '税率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_int_roll.new_spread_tax_rate is '税率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_int_roll.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_int_roll.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_int_roll.etl_timestamp is 'ETL处理时间戳';
