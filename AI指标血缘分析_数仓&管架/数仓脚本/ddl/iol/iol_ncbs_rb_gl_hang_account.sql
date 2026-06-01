/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_hang_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_hang_account
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_hang_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_hang_account(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,hang_status varchar2(1) -- 挂账状态
    ,mwrite_off_seq_no varchar2(50) -- 最大销账序号
    ,narrative varchar2(400) -- 摘要
    ,oth_bank_flag varchar2(1) -- 对手账户行内标志
    ,hang_end_date date -- 挂账到期日
    ,last_change_date date -- 最后修改日期
    ,last_change_time varchar2(26) -- 上次修改时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,apply_client_no varchar2(16) -- 申请者客户号
    ,auth_user_id varchar2(8) -- 授权柜员
    ,hang_bal number(17,2) -- 挂账余额
    ,hang_total_amt number(17,2) -- 挂账总额
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,settle_acct_name varchar2(200) -- 结算账户户名
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,hang_seq_no varchar2(50) -- 挂账序列号
    ,hang_amt number(17,2) -- 挂账金额
    ,hang_deal_type varchar2(20) -- 挂销账资金的来源和去向
    ,pledge_busi_no varchar2(50) -- 押金业务编号
    ,sub_hang_seq_no varchar2(50) -- 追加挂账子序号
    ,hang_write_off_time varchar2(26) -- 挂销账时间
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
grant select on ${iol_schema}.ncbs_rb_gl_hang_account to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_account to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_account to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_hang_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_hang_account is '挂销账挂账登记簿';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_status is '挂账状态';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.mwrite_off_seq_no is '最大销账序号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.oth_bank_flag is '对手账户行内标志';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_end_date is '挂账到期日';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.last_change_time is '上次修改时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.apply_client_no is '申请者客户号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_bal is '挂账余额';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_total_amt is '挂账总额';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.settle_acct_name is '结算账户户名';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_seq_no is '挂账序列号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_amt is '挂账金额';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_deal_type is '挂销账资金的来源和去向';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.pledge_busi_no is '押金业务编号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.sub_hang_seq_no is '追加挂账子序号';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.hang_write_off_time is '挂销账时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_gl_hang_account.etl_timestamp is 'ETL处理时间戳';
