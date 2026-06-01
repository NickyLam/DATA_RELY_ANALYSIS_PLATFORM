/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_channel_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_channel_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_channel_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_channel_tran_hist(
    acct_name varchar2(200) -- 账户名称
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_tran_status varchar2(1) -- 渠道业务处理状态
    ,collate_flag varchar2(1) -- 对账标识
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,narrative varchar2(400) -- 摘要
    ,prefix varchar2(10) -- 前缀
    ,reversal varchar2(1) -- 是否冲正标志
    ,seq_no varchar2(50) -- 序号
    ,channel varchar2(10) -- 渠道
    ,settlement_date date -- 清算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,book_branch varchar2(12) -- 贷款银行
    ,gl_branch varchar2(12) -- 总账机构
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_no varchar2(50) -- 对方账号
    ,settle_branch varchar2(12) -- 清算机构
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
grant select on ${iol_schema}.ncbs_rb_channel_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_channel_tran_hist is '核心外围统一流水登记簙';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.channel_tran_status is '渠道业务处理状态';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.collate_flag is '对账标识';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.settlement_date is '清算日期';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.book_branch is '贷款银行';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.gl_branch is '总账机构';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.oth_acct_no is '对方账号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_channel_tran_hist.etl_timestamp is 'ETL处理时间戳';
