/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_currency
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_currency
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_currency purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_currency(
    ccy varchar2(3) -- 币种
    ,ccy_desc varchar2(50) -- 币种描述
    ,ccy_group_code varchar2(3) -- 货币组代码
    ,ccy_group_flag varchar2(1) -- 是否货币组
    ,ccy_int_code varchar2(3) -- 币种内部码
    ,ccy_symbol varchar2(3) -- 币种符号
    ,company varchar2(20) -- 法人
    ,day_basis varchar2(5) -- 基准天数
    ,deci_desc varchar2(50) -- 小数描述
    ,deci_places varchar2(10) -- 小数位
    ,integer_desc varchar2(50) -- 整数描述
    ,quote_type varchar2(1) -- 牌价类型
    ,round_trunc varchar2(1) -- 舍入
    ,weekend1 varchar2(3) -- 周末1
    ,weekend2 varchar2(3) -- 周末2
    ,spot_date date -- 即期日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,fixing_days number(5) -- 固定日期
    ,pay_advice_days number(5) -- 付/收款通知日
    ,position_limit number(17,2) -- 净头寸限额
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
grant select on ${iol_schema}.ncbs_fm_currency to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_currency to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_currency to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_currency to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_currency is '币种基本信息表';
comment on column ${iol_schema}.ncbs_fm_currency.ccy is '币种';
comment on column ${iol_schema}.ncbs_fm_currency.ccy_desc is '币种描述';
comment on column ${iol_schema}.ncbs_fm_currency.ccy_group_code is '货币组代码';
comment on column ${iol_schema}.ncbs_fm_currency.ccy_group_flag is '是否货币组';
comment on column ${iol_schema}.ncbs_fm_currency.ccy_int_code is '币种内部码';
comment on column ${iol_schema}.ncbs_fm_currency.ccy_symbol is '币种符号';
comment on column ${iol_schema}.ncbs_fm_currency.company is '法人';
comment on column ${iol_schema}.ncbs_fm_currency.day_basis is '基准天数';
comment on column ${iol_schema}.ncbs_fm_currency.deci_desc is '小数描述';
comment on column ${iol_schema}.ncbs_fm_currency.deci_places is '小数位';
comment on column ${iol_schema}.ncbs_fm_currency.integer_desc is '整数描述';
comment on column ${iol_schema}.ncbs_fm_currency.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_fm_currency.round_trunc is '舍入';
comment on column ${iol_schema}.ncbs_fm_currency.weekend1 is '周末1';
comment on column ${iol_schema}.ncbs_fm_currency.weekend2 is '周末2';
comment on column ${iol_schema}.ncbs_fm_currency.spot_date is '即期日期';
comment on column ${iol_schema}.ncbs_fm_currency.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_currency.fixing_days is '固定日期';
comment on column ${iol_schema}.ncbs_fm_currency.pay_advice_days is '付/收款通知日';
comment on column ${iol_schema}.ncbs_fm_currency.position_limit is '净头寸限额';
comment on column ${iol_schema}.ncbs_fm_currency.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_currency.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_currency.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_currency.etl_timestamp is 'ETL处理时间戳';
