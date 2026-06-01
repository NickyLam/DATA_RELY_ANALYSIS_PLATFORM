/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_schedule(
    amount number(17,2) -- 金额
    ,amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,period_freq varchar2(5) -- 频率id
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,event_type varchar2(20) -- 事件类型
    ,grace_end_month varchar2(1) -- 是否宽限到月末
    ,mid_period varchar2(5) -- 累进间隔期数
    ,sched_mode varchar2(2) -- 还款方式
    ,sched_no varchar2(50) -- 计划编号
    ,schedule_status varchar2(1) -- 计划执行状态
    ,total_times number(5) -- 扣划总次数
    ,end_date date -- 结束日期
    ,grace_date date -- 宽限日
    ,last_deal_date date -- 上一处理日
    ,next_deal_date date -- 下一处理日
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cur_basic_day varchar2(2) -- 当前回收日
    ,deal_day varchar2(2) -- 处理日
    ,fir_period varchar2(5) -- 首段期数
    ,formula_amt number(17,2) -- 每期计划还款额
    ,grace_period number(5) -- 宽限期的天数
    ,second_rec_day varchar2(2) -- 第二回收日
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_rb_acct_schedule to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_schedule to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_schedule to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_schedule is '账户计划表';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.amount is '金额';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.grace_end_month is '是否宽限到月末';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.mid_period is '累进间隔期数';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.sched_no is '计划编号';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.schedule_status is '计划执行状态';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.total_times is '扣划总次数';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.grace_date is '宽限日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.last_deal_date is '上一处理日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.next_deal_date is '下一处理日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.cur_basic_day is '当前回收日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.deal_day is '处理日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.fir_period is '首段期数';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.formula_amt is '每期计划还款额';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.grace_period is '宽限期的天数';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.second_rec_day is '第二回收日';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_schedule.etl_timestamp is 'ETL处理时间戳';
