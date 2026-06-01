/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gl_write_off_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gl_write_off_account
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gl_write_off_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gl_write_off_account(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,write_off_seq_no varchar2(50) -- 销账序号
    ,write_off_status varchar2(1) -- 销账状态
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,hang_bal number(17,2) -- 挂账余额
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,write_off_amt number(17,2) -- 销账金额
    ,hang_seq_no varchar2(50) -- 挂账序列号
    ,hang_deal_type varchar2(20) -- 挂销账资金的来源和去向
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
grant select on ${iol_schema}.ncbs_rb_gl_write_off_account to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gl_write_off_account to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_write_off_account to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gl_write_off_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gl_write_off_account is '挂销账销账登记簿';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.write_off_seq_no is '销账序号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.write_off_status is '销账状态';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.hang_bal is '挂账余额';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.write_off_amt is '销账金额';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.hang_seq_no is '挂账序列号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.hang_deal_type is '挂销账资金的来源和去向';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.sub_hang_seq_no is '追加挂账子序号';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.hang_write_off_time is '挂销账时间';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_gl_write_off_account.etl_timestamp is 'ETL处理时间戳';
