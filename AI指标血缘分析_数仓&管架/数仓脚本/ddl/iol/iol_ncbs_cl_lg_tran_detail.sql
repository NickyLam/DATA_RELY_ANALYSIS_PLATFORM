/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_lg_tran_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_lg_tran_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_lg_tran_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_lg_tran_detail(
    dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,lg_acct_type varchar2(10) -- 保函账户类型
    ,lg_tran_type varchar2(10) -- 保函交易类型
    ,seq_no varchar2(50) -- 序号
    ,lg_internal_key number(15) -- 保函账号key值
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,loan_no varchar2(50) -- 贷款号
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
grant select on ${iol_schema}.ncbs_cl_lg_tran_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_lg_tran_detail is '保函交易流水明细表';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.lg_acct_type is '保函账户类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.lg_tran_type is '保函交易类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.lg_internal_key is '保函账号key值';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran_detail.etl_timestamp is 'ETL处理时间戳';
