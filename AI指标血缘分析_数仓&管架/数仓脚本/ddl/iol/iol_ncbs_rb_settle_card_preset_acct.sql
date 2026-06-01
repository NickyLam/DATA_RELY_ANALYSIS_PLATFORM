/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_settle_card_preset_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_settle_card_preset_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_settle_card_preset_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_settle_card_preset_acct(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,branch_name varchar2(200) -- 银行机构名称
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_in_out varchar2(1) -- 是否行内行外
    ,card_pb_ind varchar2(1) -- 卡/折标志
    ,company varchar2(20) -- 法人
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,settle_base_acct_no varchar2(50) -- 结算账号
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
grant select on ${iol_schema}.ncbs_rb_settle_card_preset_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_preset_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_preset_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_settle_card_preset_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_settle_card_preset_acct is '单位结算卡预设账户表';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.branch_name is '银行机构名称';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.bank_in_out is '是否行内行外';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.card_pb_ind is '卡/折标志';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_settle_card_preset_acct.etl_timestamp is 'ETL处理时间戳';
