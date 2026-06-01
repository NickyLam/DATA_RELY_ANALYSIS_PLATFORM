/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_int
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_int
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_int purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_int(
    int_type varchar2(5) -- 利率类型
    ,prod_type varchar2(12) -- 产品编号
    ,acct_rate_flag varchar2(1) -- 是否使用分户利率标志
    ,company varchar2(20) -- 法人
    ,days_gear_type varchar2(1) -- 靠档天数计算方式
    ,effect_date_calc_method varchar2(1) -- 计息起始日期取值方法
    ,event_type varchar2(20) -- 事件类型
    ,gear_amt_ind varchar2(1) -- 金额靠档方向
    ,gear_amt_method varchar2(1) -- 金额靠档方式
    ,gear_days_ind varchar2(1) -- 天数靠档方向
    ,gear_days_method varchar2(1) -- 天数靠档方式
    ,group_rule_type varchar2(2) -- 分组规则关系
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,int_calc_method varchar2(2) -- 利息计算方法
    ,int_match_rule varchar2(10) -- 利息明细生效规则
    ,int_recalc_method varchar2(1) -- 利息重算方法
    ,month_basis varchar2(3) -- 月基准
    ,rate_layer_rule varchar2(1) -- 利率分层规则
    ,roll_freq varchar2(5) -- 利率变更周期
    ,round_down_flag varchar2(1) -- 是否截位标志
    ,tax_type varchar2(2) -- 税种
    ,int_class varchar2(6) -- 利息分类
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,int_calc_amt_type varchar2(10) -- 利息计算金额类型
    ,max_rate number(15,8) -- 最大利率
    ,min_rate number(15,8) -- 最小利率
    ,rate_gear_amt_type varchar2(10) -- 利率靠档金额类型
    ,roll_day varchar2(2) -- 利率变更日
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
grant select on ${iol_schema}.ncbs_mb_prod_int to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_int to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_int to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_int to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_int is '产品利率信息表';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_mb_prod_int.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_int.acct_rate_flag is '是否使用分户利率标志';
comment on column ${iol_schema}.ncbs_mb_prod_int.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_int.days_gear_type is '靠档天数计算方式';
comment on column ${iol_schema}.ncbs_mb_prod_int.effect_date_calc_method is '计息起始日期取值方法';
comment on column ${iol_schema}.ncbs_mb_prod_int.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_mb_prod_int.gear_amt_ind is '金额靠档方向';
comment on column ${iol_schema}.ncbs_mb_prod_int.gear_amt_method is '金额靠档方式';
comment on column ${iol_schema}.ncbs_mb_prod_int.gear_days_ind is '天数靠档方向';
comment on column ${iol_schema}.ncbs_mb_prod_int.gear_days_method is '天数靠档方式';
comment on column ${iol_schema}.ncbs_mb_prod_int.group_rule_type is '分组规则关系';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_calc_method is '利息计算方法';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_match_rule is '利息明细生效规则';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_recalc_method is '利息重算方法';
comment on column ${iol_schema}.ncbs_mb_prod_int.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_mb_prod_int.rate_layer_rule is '利率分层规则';
comment on column ${iol_schema}.ncbs_mb_prod_int.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_mb_prod_int.round_down_flag is '是否截位标志';
comment on column ${iol_schema}.ncbs_mb_prod_int.tax_type is '税种';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_mb_prod_int.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_int.int_calc_amt_type is '利息计算金额类型';
comment on column ${iol_schema}.ncbs_mb_prod_int.max_rate is '最大利率';
comment on column ${iol_schema}.ncbs_mb_prod_int.min_rate is '最小利率';
comment on column ${iol_schema}.ncbs_mb_prod_int.rate_gear_amt_type is '利率靠档金额类型';
comment on column ${iol_schema}.ncbs_mb_prod_int.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_mb_prod_int.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_int.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_int.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_int.etl_timestamp is 'ETL处理时间戳';
