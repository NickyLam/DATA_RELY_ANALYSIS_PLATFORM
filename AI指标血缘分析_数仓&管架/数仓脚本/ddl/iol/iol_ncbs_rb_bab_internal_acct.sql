/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_bab_internal_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_bab_internal_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_bab_internal_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_internal_acct(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,bab_branch varchar2(12) -- 开户机构（承兑机构）
    ,bab_client_no varchar2(16) -- 客户号（机构号）
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
grant select on ${iol_schema}.ncbs_rb_bab_internal_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_bab_internal_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_internal_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_internal_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_bab_internal_acct is '银行承兑汇票内部账户表';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.bab_branch is '开户机构（承兑机构）';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.bab_client_no is '客户号（机构号）';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_bab_internal_acct.etl_timestamp is 'ETL处理时间戳';
