/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_rule_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_rule_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_rule_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_rule_define(
    client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acr_rate_type varchar2(1) -- 计提利率规则
    ,company varchar2(20) -- 法人
    ,fee_type varchar2(20) -- 费率类型
    ,observe_flag varchar2(1) -- 是否设置观察日
    ,retry_flag varchar2(1) -- 是否重算
    ,rule_desc varchar2(100) -- 规则描述
    ,stage_code varchar2(50) -- 期次代码
    ,stage_init_price number(17,2) -- 期初价格
    ,stage_risk_level varchar2(2) -- 期次风险等级
    ,struct_class varchar2(1) -- 结构性存款结构分类
    ,touch_flag varchar2(1) -- 是否触碰
    ,touch_stop_flag varchar2(1) -- 是否终止产品
    ,touch_type varchar2(3) -- 触碰类型
    ,underlying_id varchar2(50) -- 标的物代码
    ,effect_date date -- 产品生效日期
    ,maturity_date date -- 到期日期
    ,observe_end_date date -- 观察终止日期
    ,observe_start_date date -- 观察起始日期
    ,settle_date date -- 结算日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accr_rate number(15,8) -- 计提利率
    ,actual_rate number(15,8) -- 行内利率
    ,amt_unit number(17,2) -- 金额单位
    ,auth_user_id varchar2(8) -- 授权柜员
    ,float_rate number(15,8) -- 浮动利率
    ,high_grade_rate number(15,8) -- 高档利率
    ,high_threshold number(17,2) -- 最高价格
    ,in_section_days number(5) -- 区间内天数
    ,init_amt number(17,2) -- 认购起存金额
    ,low_end_rate number(15,8) -- 低档利率
    ,low_threshold number(17,2) -- 最低价格
    ,open_rate number(15,8) -- 开户利率
    ,out_section_days number(5) -- 区间外天数
    ,pre_rate number(15,8) -- 提前支取利率
    ,real_rate number(15,8) -- 执行利率
    ,sg_max_amt number(17,2) -- 单笔认购最大金额
    ,stage_fixed_rate number(15,8) -- 期次级固定利率
    ,stage_low_limit number(17,2) -- 期次成立最低额度
    ,stage_percent_rate number(11,7) -- 期次级浮动百分比
    ,stage_spread_rate number(15,8) -- 期次级浮动百分点
    ,touch_percent number(11,7) -- 触碰百分比
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,years_rate number(15,8) -- 年化利率
    ,settle_days number(5) -- 清算天数
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_rule_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_rule_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_rule_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_rule_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_rule_define is '期次规则定义表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.acr_rate_type is '计提利率规则';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.observe_flag is '是否设置观察日';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.retry_flag is '是否重算';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.rule_desc is '规则描述';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_init_price is '期初价格';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_risk_level is '期次风险等级';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.struct_class is '结构性存款结构分类';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.touch_flag is '是否触碰';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.touch_stop_flag is '是否终止产品';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.touch_type is '触碰类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.underlying_id is '标的物代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.observe_end_date is '观察终止日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.observe_start_date is '观察起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.settle_date is '结算日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.accr_rate is '计提利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.amt_unit is '金额单位';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.high_grade_rate is '高档利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.high_threshold is '最高价格';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.in_section_days is '区间内天数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.init_amt is '认购起存金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.low_end_rate is '低档利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.low_threshold is '最低价格';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.open_rate is '开户利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.out_section_days is '区间外天数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.pre_rate is '提前支取利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.sg_max_amt is '单笔认购最大金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_fixed_rate is '期次级固定利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_low_limit is '期次成立最低额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_percent_rate is '期次级浮动百分比';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.stage_spread_rate is '期次级浮动百分点';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.touch_percent is '触碰百分比';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.years_rate is '年化利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.settle_days is '清算天数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_rule_define.etl_timestamp is 'ETL处理时间戳';
