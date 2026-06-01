/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_exchange_tran_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_exchange_tran_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_exchange_tran_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_exchange_tran_type(
    tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,ex_type varchar2(1) -- 兑换类型
    ,op_type varchar2(2) -- 兑换方式
    ,libra_op_time number(15) -- libra执行次数
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
grant select on ${iol_schema}.ncbs_rb_exchange_tran_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_exchange_tran_type is '结售汇交易类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.company is '法人';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.ex_type is '兑换类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.op_type is '兑换方式';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_type.etl_timestamp is 'ETL处理时间戳';
