/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_hist(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,amt_type varchar2(10) -- 金额类型
    ,balance number(17,2) -- 余额
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,int_amt number(17,2) -- 利息金额
    ,por_int_tot number(17,2) -- 本息合计
    ,tax_sc number(17,2) -- 账户利息税
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
grant select on ${iol_schema}.ncbs_rb_acct_doss_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss_hist is '久悬户登记簿历史表';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.por_int_tot is '本息合计';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.tax_sc is '账户利息税';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_hist.etl_timestamp is 'ETL处理时间戳';
