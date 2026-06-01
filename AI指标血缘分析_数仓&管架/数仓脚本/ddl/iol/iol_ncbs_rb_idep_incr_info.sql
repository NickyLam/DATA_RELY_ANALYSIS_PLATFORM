/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_idep_incr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_idep_incr_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_idep_incr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_idep_incr_info(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,idep_sub_type varchar2(2) -- 智能存款子类型
    ,incr_status varchar2(1) -- 增值状态
    ,original_seq_no varchar2(50) -- 源增值流水序号
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dep_amt number(17,2) -- 当日存入金额
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_idep_incr_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_idep_incr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_idep_incr_info is '智能存款增值流水';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.idep_sub_type is '智能存款子类型';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.incr_status is '增值状态';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.original_seq_no is '源增值流水序号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.dep_amt is '当日存入金额';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_idep_incr_info.etl_timestamp is 'ETL处理时间戳';
