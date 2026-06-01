/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_amt_calc_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_amt_calc_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_amt_calc_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_amt_calc_type(
    amt_type varchar2(10) -- 金额类型
    ,amt_calc_desc varchar2(50) -- 金额计算类型描述
    ,amt_calc_type varchar2(1) -- 金额计算类型
    ,calc_formula varchar2(50) -- 计算公式
    ,company varchar2(20) -- 法人
    ,tran_hist_amt varchar2(200) -- 登记交易流水金额类型
    ,tran_hist_flag varchar2(1) -- 登记交流流水标志
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
grant select on ${iol_schema}.ncbs_rb_amt_calc_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_amt_calc_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_amt_calc_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_amt_calc_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_amt_calc_type is '金额计算类型定义表';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.amt_calc_desc is '金额计算类型描述';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.amt_calc_type is '金额计算类型';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.calc_formula is '计算公式';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.company is '法人';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.tran_hist_amt is '登记交易流水金额类型';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.tran_hist_flag is '登记交流流水标志';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_amt_calc_type.etl_timestamp is 'ETL处理时间戳';
