/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cd_card_journal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cd_card_journal
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cd_card_journal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_journal(
    base_acct_no varchar2(64) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,card_journal_status varchar2(1) -- 卡流水状态
    ,card_seq_no varchar2(50) -- 卡系统流水号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,merchant_code varchar2(50) -- 商行编号
    ,res_seq_no varchar2(50) -- 限制编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,terminal_no varchar2(50) -- 终端id
    ,terminal_seq_no varchar2(50) -- 终端流水号
    ,cup_date date -- 银联日期
    ,fts_date date -- 主机日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cd_card_journal to ${iml_schema};
grant select on ${iol_schema}.ncbs_cd_card_journal to ${icl_schema};
grant select on ${iol_schema}.ncbs_cd_card_journal to ${idl_schema};
grant select on ${iol_schema}.ncbs_cd_card_journal to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cd_card_journal is '卡流水表';
comment on column ${iol_schema}.ncbs_cd_card_journal.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_cd_card_journal.card_no is '卡号';
comment on column ${iol_schema}.ncbs_cd_card_journal.ccy is '币种';
comment on column ${iol_schema}.ncbs_cd_card_journal.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cd_card_journal.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cd_card_journal.remark is '备注';
comment on column ${iol_schema}.ncbs_cd_card_journal.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cd_card_journal.card_journal_status is '卡流水状态';
comment on column ${iol_schema}.ncbs_cd_card_journal.card_seq_no is '卡系统流水号';
comment on column ${iol_schema}.ncbs_cd_card_journal.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cd_card_journal.company is '法人';
comment on column ${iol_schema}.ncbs_cd_card_journal.error_code is '错误码';
comment on column ${iol_schema}.ncbs_cd_card_journal.merchant_code is '商行编号';
comment on column ${iol_schema}.ncbs_cd_card_journal.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cd_card_journal.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_cd_card_journal.terminal_no is '终端id';
comment on column ${iol_schema}.ncbs_cd_card_journal.terminal_seq_no is '终端流水号';
comment on column ${iol_schema}.ncbs_cd_card_journal.cup_date is '银联日期';
comment on column ${iol_schema}.ncbs_cd_card_journal.fts_date is '主机日期';
comment on column ${iol_schema}.ncbs_cd_card_journal.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cd_card_journal.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cd_card_journal.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cd_card_journal.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cd_card_journal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cd_card_journal.etl_timestamp is 'ETL处理时间戳';
