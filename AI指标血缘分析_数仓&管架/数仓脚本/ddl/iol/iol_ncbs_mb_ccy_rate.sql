/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_ccy_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_ccy_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_ccy_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_ccy_rate(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,effect_time varchar2(6) -- 汇率牌价生效时间
    ,quote_type varchar2(1) -- 牌价类型
    ,rate_type varchar2(10) -- 汇率类型
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,central_bank_rate number(15,8) -- 央行参考汇率
    ,exch_buy_rate number(15,8) -- 汇买价
    ,exch_sell_rate number(15,8) -- 汇卖价
    ,max_float_rate number(15,8) -- 最大浮动点
    ,middle_rate number(15,8) -- 中间价
    ,notes_buy_rate number(15,8) -- 钞买价
    ,notes_sell_rate number(15,8) -- 钞卖价
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
grant select on ${iol_schema}.ncbs_mb_ccy_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_ccy_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_ccy_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_ccy_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_ccy_rate is '汇率牌价表';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.branch is '机构编号';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.ccy is '币种';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.company is '法人';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.effect_time is '汇率牌价生效时间';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.central_bank_rate is '央行参考汇率';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.exch_buy_rate is '汇买价';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.exch_sell_rate is '汇卖价';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.max_float_rate is '最大浮动点';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.middle_rate is '中间价';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.notes_buy_rate is '钞买价';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.notes_sell_rate is '钞卖价';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_ccy_rate.etl_timestamp is 'ETL处理时间戳';
