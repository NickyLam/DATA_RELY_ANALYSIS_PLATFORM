/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_int_matrix
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_int_matrix
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_int_matrix purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_int_matrix(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,int_type varchar2(5) -- 利率类型
    ,period_freq varchar2(5) -- 频率id
    ,company varchar2(20) -- 法人
    ,int_basis varchar2(5) -- 基准利率类型
    ,matrix_no varchar2(50) -- 阶梯序号
    ,year_basis varchar2(3) -- 年基准天数
    ,effect_date date -- 产品生效日期
    ,end_date date -- 结束日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_rate number(15,8) -- 行内利率
    ,base_rate number(15,8) -- 基础汇率
    ,day_num number(5) -- 每期天数
    ,disc_rate number(15,8) -- 利率折扣
    ,matrix_amt number(17,2) -- 阶梯金额
    ,max_percent number(11,7) -- 最大上浮比例
    ,max_rate number(15,8) -- 最大利率
    ,min_percent number(11,7) -- 最小上浮百分比
    ,min_rate number(15,8) -- 最小利率
    ,spread_percent number(11,7) -- 浮动百分比
    ,spread_rate number(15,8) -- 浮动点数
    ,min_spread_percent number(11,7) -- 最小浮动比例
    ,max_spread_rate number(4) -- 最大上浮点差
    ,min_spread_rate number(4) -- 最大下浮点差
    ,max_spread_percent number(11,7) -- 最大下浮比例
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
grant select on ${iol_schema}.ncbs_mb_int_matrix to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_int_matrix to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_int_matrix to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_int_matrix to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_int_matrix is '利率税率阶梯表';
comment on column ${iol_schema}.ncbs_mb_int_matrix.branch is '机构编号';
comment on column ${iol_schema}.ncbs_mb_int_matrix.ccy is '币种';
comment on column ${iol_schema}.ncbs_mb_int_matrix.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_mb_int_matrix.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_mb_int_matrix.company is '法人';
comment on column ${iol_schema}.ncbs_mb_int_matrix.int_basis is '基准利率类型';
comment on column ${iol_schema}.ncbs_mb_int_matrix.matrix_no is '阶梯序号';
comment on column ${iol_schema}.ncbs_mb_int_matrix.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_mb_int_matrix.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_int_matrix.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_mb_int_matrix.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_int_matrix.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_mb_int_matrix.base_rate is '基础汇率';
comment on column ${iol_schema}.ncbs_mb_int_matrix.day_num is '每期天数';
comment on column ${iol_schema}.ncbs_mb_int_matrix.disc_rate is '利率折扣';
comment on column ${iol_schema}.ncbs_mb_int_matrix.matrix_amt is '阶梯金额';
comment on column ${iol_schema}.ncbs_mb_int_matrix.max_percent is '最大上浮比例';
comment on column ${iol_schema}.ncbs_mb_int_matrix.max_rate is '最大利率';
comment on column ${iol_schema}.ncbs_mb_int_matrix.min_percent is '最小上浮百分比';
comment on column ${iol_schema}.ncbs_mb_int_matrix.min_rate is '最小利率';
comment on column ${iol_schema}.ncbs_mb_int_matrix.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_mb_int_matrix.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_mb_int_matrix.min_spread_percent is '最小浮动比例';
comment on column ${iol_schema}.ncbs_mb_int_matrix.max_spread_rate is '最大上浮点差';
comment on column ${iol_schema}.ncbs_mb_int_matrix.min_spread_rate is '最大下浮点差';
comment on column ${iol_schema}.ncbs_mb_int_matrix.max_spread_percent is '最大下浮比例';
comment on column ${iol_schema}.ncbs_mb_int_matrix.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_int_matrix.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_int_matrix.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_int_matrix.etl_timestamp is 'ETL处理时间戳';
