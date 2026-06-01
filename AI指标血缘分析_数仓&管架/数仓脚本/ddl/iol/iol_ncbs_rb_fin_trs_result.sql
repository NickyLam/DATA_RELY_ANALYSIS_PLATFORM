/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fin_trs_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fin_trs_result
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fin_trs_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fin_trs_result(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_msg varchar2(3000) -- 错误代码
    ,trs_flag varchar2(6) -- 转入转出标志
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,oth_internal_key number(15) -- 对手账户内部键
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
grant select on ${iol_schema}.ncbs_rb_fin_trs_result to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fin_trs_result to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_trs_result to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fin_trs_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fin_trs_result is '理财转入转出异常登记簿';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.trs_flag is '转入转出标志';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_fin_trs_result.etl_timestamp is 'ETL处理时间戳';
