/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_clean
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_clean
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_clean purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_clean(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
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
grant select on ${iol_schema}.ncbs_rb_acct_clean to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_clean to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_clean to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_clean to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_clean is '账户清理登记';
comment on column ${iol_schema}.ncbs_rb_acct_clean.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_clean.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_clean.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_clean.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_clean.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_clean.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_clean.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_clean.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_clean.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_clean.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_clean.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_clean.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_clean.etl_timestamp is 'ETL处理时间戳';
