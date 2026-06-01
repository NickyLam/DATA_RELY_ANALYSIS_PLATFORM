/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_payment
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_payment(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,blacklist_ind_flag varchar2(1) -- 是否黑名单客户
    ,company varchar2(20) -- 法人
    ,channel varchar2(10) -- 渠道
    ,tran_date date -- 交易日期
    ,oth_acct_name varchar2(200) -- 对方账户名称
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_ccy varchar2(3) -- 对手账户币种
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
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
grant select on ${iol_schema}.ncbs_rb_acct_payment to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_payment to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_payment to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_payment is '定向支付信息表';
comment on column ${iol_schema}.ncbs_rb_acct_payment.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_payment.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_acct_payment.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_payment.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_payment.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.blacklist_ind_flag is '是否黑名单客户';
comment on column ${iol_schema}.ncbs_rb_acct_payment.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_payment.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_acct_payment.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_acct_name is '对方账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_ccy is '对手账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_acct_payment.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_acct_payment.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_payment.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_payment.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_payment.etl_timestamp is 'ETL处理时间戳';
