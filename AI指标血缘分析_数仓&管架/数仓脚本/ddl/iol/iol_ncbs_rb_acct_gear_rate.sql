/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_gear_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_gear_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_gear_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_gear_rate(
    internal_key number(15,0) -- 账户内部键值
    ,int_class varchar2(6) -- 利息分类
    ,event_type varchar2(20) -- 事件类型
    ,seq_no varchar2(50) -- 序号
    ,real_rate number(15,8) -- 执行利率
    ,start_date date -- 开始日期
    ,end_date date -- 结束日期
    ,gear_amt number(17,2) -- 档位金额
    ,gear_days number(5,0) -- 档位天数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,client_no varchar2(16) -- 客户编号
    ,period_freq varchar2(5) -- 频率id
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
grant select on ${iol_schema}.ncbs_rb_acct_gear_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_gear_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_gear_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_gear_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_gear_rate is '账户靠档利率表';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.gear_amt is '档位金额';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.gear_days is '档位天数';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_gear_rate.etl_timestamp is 'ETL处理时间戳';
