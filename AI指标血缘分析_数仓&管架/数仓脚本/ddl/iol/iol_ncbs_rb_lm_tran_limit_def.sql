/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_lm_tran_limit_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_lm_tran_limit_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_lm_tran_limit_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_tran_limit_def(
    ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,deal_flow varchar2(1) -- 处理方式
    ,enable_define varchar2(1) -- 允许自定义标志
    ,limit_desc varchar2(200) -- 限制说明
    ,limit_level varchar2(5) -- 限制级别
    ,limit_ref varchar2(500) -- 限额编码
    ,limit_status varchar2(1) -- 限额状态
    ,limit_type varchar2(2) -- 限额类型
    ,libra_op_time number(15) -- libra执行次数
    ,effect_date date -- 产品生效日期
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,limit_max_amt number(17,2) -- 最大限额
    ,limit_min_amt number(17,2) -- 限额最小金额
    ,limit_main_type varchar2(10) -- 限额大类
    ,limit_term varchar2(5) -- 限额累计频率
    ,limit_check_method varchar2(1) -- 限额检查方式，标识按照金额检查，按照笔数检查，两者均检查
    ,limit_max_num number(5) -- 限额最大笔数
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
grant select on ${iol_schema}.ncbs_rb_lm_tran_limit_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_lm_tran_limit_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_tran_limit_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_tran_limit_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_lm_tran_limit_def is '交易限额定义表';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.company is '法人';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.deal_flow is '处理方式';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.enable_define is '允许自定义标志';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_desc is '限制说明';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_level is '限制级别';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_ref is '限额编码';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_status is '限额状态';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_type is '限额类型';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_max_amt is '最大限额';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_min_amt is '限额最小金额';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_main_type is '限额大类';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_term is '限额累计频率';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_check_method is '限额检查方式，标识按照金额检查，按照笔数检查，两者均检查';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.limit_max_num is '限额最大笔数';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_lm_tran_limit_def.etl_timestamp is 'ETL处理时间戳';
