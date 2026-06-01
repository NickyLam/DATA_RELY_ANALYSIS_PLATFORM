/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_lm_client_tran_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_lm_client_tran_limit
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_lm_client_tran_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_lm_client_tran_limit(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,prod_type varchar2(12) -- 产品编号
    ,client_no varchar2(16) -- 客户编号
    ,limit_ref varchar2(500) -- 限额编码
    ,limit_max_amt number(17,2) -- 最大限额
    ,limit_min_amt number(17,2) -- 限额最小金额
    ,limit_max_num number(5,0) -- 限额最大笔数
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,limit_main_type varchar2(10) -- 限额大类
    ,limit_reason varchar2(2) -- 限额设置原因|限额设置原因
    ,tran_limit_due_date date -- 交易限额有效期
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
grant select on ${iol_schema}.ncbs_rb_lm_client_tran_limit to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_tran_limit to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_tran_limit to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_lm_client_tran_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_lm_client_tran_limit is '客户交易限额表|记录和查询客户交易限额信息';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_ref is '限额编码';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_max_amt is '最大限额';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_min_amt is '限额最小金额';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_max_num is '限额最大笔数';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.company is '法人';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_main_type is '限额大类';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.limit_reason is '限额设置原因|限额设置原因';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.tran_limit_due_date is '交易限额有效期';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_lm_client_tran_limit.etl_timestamp is 'ETL处理时间戳';
