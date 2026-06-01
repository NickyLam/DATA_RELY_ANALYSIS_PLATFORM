/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_loan_int_default
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_loan_int_default
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_loan_int_default purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_int_default(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,company varchar2(20) -- 法人
    ,cycle_freq varchar2(5) -- 结息频率
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,int_cap_flag varchar2(1) -- 资本化标志
    ,int_ind_flag varchar2(1) -- 是否计息
    ,month_basis varchar2(3) -- 月基准
    ,penalty_odi_rate_type varchar2(1) -- 罚息利率使用方式
    ,rate_effect_type varchar2(1) -- 利率生效方式
    ,roll_freq varchar2(5) -- 利率变更周期
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,calc_begin_date date -- 利息计算起始日
    ,calc_end_date date -- 利息计算截止日
    ,last_change_date date -- 最后修改日期
    ,next_cycle_date date -- 下一结息日
    ,next_roll_date date -- 下一个利率变更日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,float_rate number(15,8) -- 浮动利率
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,max_int_rate number(15,8) -- 执行利率上限
    ,min_int_rate number(15,8) -- 执行利率下限
    ,real_rate number(15,8) -- 执行利率
    ,roll_day varchar2(2) -- 利率变更日
    ,spread_percent number(11,7) -- 浮动百分比
    ,spread_rate number(15,8) -- 浮动点数
    ,int_day varchar2(2) -- 存贷结息日期
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
grant select on ${iol_schema}.ncbs_cl_loan_int_default to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_loan_int_default to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_int_default to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_loan_int_default to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_loan_int_default is '贷款合同利率信息表';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.company is '法人';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_cap_flag is '资本化标志';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.penalty_odi_rate_type is '罚息利率使用方式';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.rate_effect_type is '利率生效方式';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.calc_end_date is '利息计算截止日';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.next_roll_date is '下一个利率变更日期';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.max_int_rate is '执行利率上限';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.min_int_rate is '执行利率下限';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_loan_int_default.etl_timestamp is 'ETL处理时间戳';
