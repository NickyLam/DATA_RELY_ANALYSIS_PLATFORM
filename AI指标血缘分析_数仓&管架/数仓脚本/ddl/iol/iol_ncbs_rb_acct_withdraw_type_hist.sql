/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_withdraw_type_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_withdraw_type_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_withdraw_type_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_withdraw_type_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_nature varchar2(10) -- 存款账户类型
    ,company varchar2(20) -- 法人
    ,defend_num number(5) -- 维护次数
    ,seq_no varchar2(50) -- 序号
    ,withdraw_key varchar2(200) -- 支取方式主键
    ,withdraw_operate_type varchar2(1) -- 支取方式操作类型
    ,withdrawal_type_new varchar2(1) -- 新支取方式
    ,withdrawal_type_old varchar2(1) -- 旧支取方式
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
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
grant select on ${iol_schema}.ncbs_rb_acct_withdraw_type_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_withdraw_type_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_withdraw_type_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_withdraw_type_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_withdraw_type_hist is '账户支取方式历史';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.defend_num is '维护次数';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.withdraw_key is '支取方式主键';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.withdraw_operate_type is '支取方式操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.withdrawal_type_new is '新支取方式';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.withdrawal_type_old is '旧支取方式';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_withdraw_type_hist.etl_timestamp is 'ETL处理时间戳';
