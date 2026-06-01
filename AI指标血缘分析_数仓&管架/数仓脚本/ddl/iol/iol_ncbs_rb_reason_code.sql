/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_reason_code
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_reason_code
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_reason_code purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_reason_code(
    reason_code varchar2(10) -- 账户用途
    ,borrow_for_repay varchar2(1) -- 是否借新还旧或续存标志
    ,libra_op_time number(15,0) -- libra执行次数
    ,reason_class varchar2(20) -- 原因分类
    ,reason_code_desc varchar2(100) -- 原因代码描述
    ,source_module varchar2(3) -- 源模块
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_reason_code to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_reason_code to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_reason_code to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_reason_code to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_reason_code is '原因代码';
comment on column ${iol_schema}.ncbs_rb_reason_code.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_reason_code.borrow_for_repay is '是否借新还旧或续存标志';
comment on column ${iol_schema}.ncbs_rb_reason_code.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_reason_code.reason_class is '原因分类';
comment on column ${iol_schema}.ncbs_rb_reason_code.reason_code_desc is '原因代码描述';
comment on column ${iol_schema}.ncbs_rb_reason_code.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_reason_code.company is '法人';
comment on column ${iol_schema}.ncbs_rb_reason_code.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_reason_code.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_reason_code.etl_timestamp is 'ETL处理时间戳';
