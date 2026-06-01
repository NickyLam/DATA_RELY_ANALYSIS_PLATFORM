/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_old_rec_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_old_rec_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_old_rec_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_old_rec_register(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,old_cmisloan_no varchar2(60) -- 原借据号
    ,old_dd_no number(5) -- 原发放号
    ,old_loan_no varchar2(50) -- 原贷款号
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,reversal varchar2(1) -- 是否冲正标志
    ,tran_date date -- 交易日期
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
grant select on ${iol_schema}.ncbs_cl_old_rec_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_old_rec_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_old_rec_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_old_rec_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_old_rec_register is '借新还旧登记簿';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.company is '法人';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.old_cmisloan_no is '原借据号';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.old_dd_no is '原发放号';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.old_loan_no is '原贷款号';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_old_rec_register.etl_timestamp is 'ETL处理时间戳';
