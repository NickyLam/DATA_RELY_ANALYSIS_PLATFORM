/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_collect_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_collect_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_collect_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_collect_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,collect_order varchar2(1) -- 自动归集顺序
    ,company varchar2(20) -- 法人
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_settle_card_collect_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_collect_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_collect_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_collect_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_collect_info is '单位结算卡归集信息登记簿';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.collect_order is '自动归集顺序';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_collect_info.etl_timestamp is 'ETL处理时间戳';
