/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_idep_incr_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_idep_incr_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_idep_incr_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_idep_incr_rate(
    client_no varchar2(16) -- 客户编号
    ,period_freq varchar2(5) -- 频率id
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,int_class varchar2(6) -- 利息分类
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,day_num number(5) -- 每期天数
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
grant select on ${iol_schema}.ncbs_rb_idep_incr_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_idep_incr_rate is '智能存款靠档信息';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.company is '法人';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.day_num is '每期天数';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.near_amt is '靠档金额';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_idep_incr_rate.etl_timestamp is 'ETL处理时间戳';
