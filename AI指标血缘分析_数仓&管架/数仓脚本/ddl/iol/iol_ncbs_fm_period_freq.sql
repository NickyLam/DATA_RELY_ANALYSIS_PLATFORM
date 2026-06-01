/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_period_freq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_period_freq
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_period_freq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_period_freq(
    period_freq varchar2(5) -- 频率id
    ,add_no number(5) -- 每期数量
    ,company varchar2(20) -- 法人
    ,first_last varchar2(1) -- 期初/期末
    ,force_work_day varchar2(1) -- 节假日是否顺延
    ,half_month varchar2(1) -- 半月标识
    ,period_freq_desc varchar2(50) -- 周期频率描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,client_spread number(15,8) -- 客户浮动
    ,day_mth varchar2(1) -- 每期单位
    ,day_num number(5) -- 每期天数
    ,prior_days number(5) -- 期限单位值
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
grant select on ${iol_schema}.ncbs_fm_period_freq to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_period_freq to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_period_freq to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_period_freq to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_period_freq is '周期频率表';
comment on column ${iol_schema}.ncbs_fm_period_freq.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_fm_period_freq.add_no is '每期数量';
comment on column ${iol_schema}.ncbs_fm_period_freq.company is '法人';
comment on column ${iol_schema}.ncbs_fm_period_freq.first_last is '期初/期末';
comment on column ${iol_schema}.ncbs_fm_period_freq.force_work_day is '节假日是否顺延';
comment on column ${iol_schema}.ncbs_fm_period_freq.half_month is '半月标识';
comment on column ${iol_schema}.ncbs_fm_period_freq.period_freq_desc is '周期频率描述';
comment on column ${iol_schema}.ncbs_fm_period_freq.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_period_freq.client_spread is '客户浮动';
comment on column ${iol_schema}.ncbs_fm_period_freq.day_mth is '每期单位';
comment on column ${iol_schema}.ncbs_fm_period_freq.day_num is '每期天数';
comment on column ${iol_schema}.ncbs_fm_period_freq.prior_days is '期限单位值';
comment on column ${iol_schema}.ncbs_fm_period_freq.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_period_freq.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_period_freq.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_period_freq.etl_timestamp is 'ETL处理时间戳';
