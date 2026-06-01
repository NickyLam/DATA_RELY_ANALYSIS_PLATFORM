/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_client_tran_limit_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_client_tran_limit_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_client_tran_limit_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_tran_limit_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,limit_level varchar2(5) -- 限制级别
    ,limit_ref varchar2(500) -- 限额编码
    ,limit_type varchar2(2) -- 限额类型
    ,num number(5) -- 数量
    ,operate_flag varchar2(1) -- 操作类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,limit_max_amt number(17,2) -- 最大限额
    ,limit_min_amt number(17,2) -- 限额最小金额
    ,max_amt number(17,2) -- 最大金额
    ,min_amt number(17,2) -- 最小金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,limit_main_type varchar2(10) -- 限额大类
    ,limit_max_num number(5) -- 限额最大笔数
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
grant select on ${iol_schema}.ncbs_rb_client_tran_limit_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_client_tran_limit_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_client_tran_limit_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_client_tran_limit_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_client_tran_limit_hist is '交易限额维护历史信息';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_level is '限制级别';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_ref is '限额编码';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_type is '限额类型';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.num is '数量';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.operate_flag is '操作类型';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_max_amt is '最大限额';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_min_amt is '限额最小金额';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.max_amt is '最大金额';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.min_amt is '最小金额';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_main_type is '限额大类';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.limit_max_num is '限额最大笔数';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_client_tran_limit_hist.etl_timestamp is 'ETL处理时间戳';
