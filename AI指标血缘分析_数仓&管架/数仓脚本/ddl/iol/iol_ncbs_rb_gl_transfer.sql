/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_transfer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_transfer
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_transfer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_transfer(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,gl_code varchar2(20) -- 科目代码
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,gl_seq_no varchar2(50) -- 总账序号
    ,gl_type varchar2(1) -- 总账类型
    ,narrative varchar2(400) -- 摘要
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_seq_no varchar2(50) -- 交易序号
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,value_date date -- 记账日期
    ,auth_user_id varchar2(8) -- 授权柜员
    ,gl_branch varchar2(12) -- 总账机构
    ,gl_ccy varchar2(3) -- 总账币种
    ,gl_client_no varchar2(16) -- 总账客户号
    ,gl_profit_center varchar2(20) -- 总账利润中心
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,reverse_auth_user_id varchar2(8) -- 冲正交易授权柜员
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
grant select on ${iol_schema}.ncbs_rb_gl_transfer to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_transfer to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_transfer to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_transfer to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_transfer is '资金划拨登记表';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_seq_no is '总账序号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_type is '总账类型';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.value_date is '记账日期';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_branch is '总账机构';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_ccy is '总账币种';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_client_no is '总账客户号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.gl_profit_center is '总账利润中心';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.reverse_auth_user_id is '冲正交易授权柜员';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_gl_transfer.etl_timestamp is 'ETL处理时间戳';
