/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,card_prod_type varchar2(12) -- 卡产品类型
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_card_no varchar2(50) -- 对手卡号
    ,oth_card_prod_type varchar2(12) -- 对手卡产品类型
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
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
grant select on ${iol_schema}.ncbs_rb_settle_card_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_tran_hist is '单位结算卡交易流水表';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.card_prod_type is '卡产品类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_card_no is '对手卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_card_prod_type is '对手卡产品类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_tran_hist.etl_timestamp is 'ETL处理时间戳';
