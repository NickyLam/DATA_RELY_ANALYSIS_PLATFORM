/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_tran_stats
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_tran_stats
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_tran_stats purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_tran_stats(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,source_type varchar2(6) -- 渠道编号
    ,tran_class varchar2(10) -- 交易分类
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,total_amt_d number(17,2) -- 日累计交易金额
    ,total_amt_m number(17,2) -- 月累计交易金额
    ,total_amt_q number(17,2) -- 季累计交易金额
    ,total_amt_w number(17,2) -- 周累计交易金额
    ,total_amt_y number(17,2) -- 年累计交易金额
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
grant select on ${iol_schema}.ncbs_rb_acct_tran_stats to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_tran_stats to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_tran_stats to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_tran_stats to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_tran_stats is '账户累计交易额统计表';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.tran_class is '交易分类';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.total_amt_d is '日累计交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.total_amt_m is '月累计交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.total_amt_q is '季累计交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.total_amt_w is '周累计交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.total_amt_y is '年累计交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_tran_stats.etl_timestamp is 'ETL处理时间戳';
