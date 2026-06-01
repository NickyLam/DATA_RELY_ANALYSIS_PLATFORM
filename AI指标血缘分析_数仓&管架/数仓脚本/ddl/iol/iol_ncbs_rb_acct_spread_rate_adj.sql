/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_spread_rate_adj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_spread_rate_adj
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_spread_rate_adj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_spread_rate_adj(
    seq_no varchar2(50) -- 序号
    ,internal_key number(15) -- 账户内部键值
    ,client_no varchar2(16) -- 客户编号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,before_acct_spread_rate number(15,8) -- 调整前分户级利率浮动百分点
    ,after_acct_spread_rate number(15,8) -- 调整后分户级利率浮动百分点
    ,before_real_rate number(15,8) -- 调整前执行利率
    ,after_real_rate number(15,8) -- 调整后执行利率
    ,int_class varchar2(6) -- 利息分类
    ,tran_date date -- 交易日期
    ,reference varchar2(50) -- 交易参考号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_acct_spread_rate_adj to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_spread_rate_adj to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_spread_rate_adj to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_spread_rate_adj to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_spread_rate_adj is '账户浮动上限利率变动登记表';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.before_acct_spread_rate is '调整前分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.after_acct_spread_rate is '调整后分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.before_real_rate is '调整前执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.after_real_rate is '调整后执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_spread_rate_adj.etl_timestamp is 'ETL处理时间戳';
