/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_irregular_schedule_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_irregular_schedule_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_irregular_schedule_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_irregular_schedule_hist(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,period_freq varchar2(5) -- 频率id
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,calc_times number(5) -- 气球贷计算期次
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,event_type varchar2(20) -- 事件类型
    ,grace_type varchar2(3) -- 宽限期类型
    ,mid_period varchar2(5) -- 累进间隔期数
    ,sched_mode varchar2(2) -- 还款方式
    ,sched_seq_no varchar2(50) -- 还款计划序号
    ,sub_sched_mode varchar2(3) -- 当前子计划方式
    ,end_date date -- 结束日期
    ,int_next_deal_date date -- 下一利息处理日期
    ,next_deal_date date -- 下一处理日
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,add_ratio number(11,7) -- 累进比例
    ,deal_day varchar2(2) -- 处理日
    ,fir_period varchar2(5) -- 首段期数
    ,grace_period number(5) -- 宽限期的天数
    ,int_deal_day varchar2(2) -- 利息回收日
    ,int_period_freq varchar2(5) -- 结息周期
    ,total_amt number(17,2) -- 总金额
    ,add_amt number(17,2) -- 累进金额
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
grant select on ${iol_schema}.ncbs_cl_irregular_schedule_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_irregular_schedule_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_irregular_schedule_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_irregular_schedule_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_irregular_schedule_hist is '不规则还款计划历史表';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.calc_times is '气球贷计算期次';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.grace_type is '宽限期类型';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.mid_period is '累进间隔期数';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.sched_seq_no is '还款计划序号';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.sub_sched_mode is '当前子计划方式';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.int_next_deal_date is '下一利息处理日期';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.next_deal_date is '下一处理日';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.add_ratio is '累进比例';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.deal_day is '处理日';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.fir_period is '首段期数';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.grace_period is '宽限期的天数';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.int_deal_day is '利息回收日';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.int_period_freq is '结息周期';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.add_amt is '累进金额';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_irregular_schedule_hist.etl_timestamp is 'ETL处理时间戳';
