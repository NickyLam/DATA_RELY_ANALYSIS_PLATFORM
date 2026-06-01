/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_int_matrix
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_int_matrix
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_int_matrix purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_int_matrix(
    matrix_no varchar2(50) -- 阶梯序号
    ,stage_code varchar2(50) -- 期次代码
    ,int_type varchar2(5) -- 利率类型
    ,year_basis varchar2(3) -- 年基准天数
    ,effect_date date -- 产品生效日期
    ,period_freq varchar2(5) -- 频率id
    ,day_num number(5,0) -- 每期天数
    ,real_rate number(15,8) -- 执行利率
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_int_matrix to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int_matrix to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int_matrix to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int_matrix to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_int_matrix is '期次产品提前支取利率分段表|期次产品提前支取利率分段表，期限靠档利率维护';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.matrix_no is '阶梯序号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.day_num is '每期天数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int_matrix.etl_timestamp is 'ETL处理时间戳';
