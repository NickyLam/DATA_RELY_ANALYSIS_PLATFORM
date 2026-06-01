/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_int_rate_form_msg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_int_rate_form_msg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_int_rate_form_msg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_int_rate_form_msg(
    base_acct_no varchar2(64) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,reason varchar2(200) -- 原因
    ,company varchar2(20) -- 法人
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,valid_from_date date -- 有效期起始日期
    ,valid_thru_date date -- 有效期截止日期
    ,disc_base_rate number(15,8) -- 基准利率1
    ,float_point number(15,8) -- 浮动点差
    ,real_rate number(15,8) -- 执行利率
    ,int_rate_term varchar2(2) -- 利率协议期限
    ,add_agreement_flag varchar2(1) -- 新增协议标志
    ,pre_int_rate_form_no varchar2(50) -- 原审批单号
    ,auth_client_flag varchar2(1) -- 是否为我行授信客户
    ,pri_amt_limit number(17,2) -- 申请本金金额上限
    ,int_valid_from_date date -- 利率优惠有效期起始日期
    ,int_valid_thru_date date -- 利率优惠有效期截止日期
    ,int_agreement_status varchar2(1) -- 利率协议状态
    ,int_rate_form_apply_type varchar2(2) -- 利率审批申请类别
    ,auth_client_payment number(17,2) -- 授信客户的综合收益请款
    ,new_acct_no_flag varchar2(1) -- 是否为新账号
    ,rb_prod_term varchar2(2) -- 存款期限
    ,int_rate_rb_prod_type varchar2(3) -- 利率审批单存款品种
    ,int_rate_form_no varchar2(50) -- 利率审批单单号
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,internal_key number(15) -- 账户内部键值
    ,diff_quote_rate number(15,8) -- 差异化利率
    ,keep_min_bal number(17,2) -- 最小留存金额
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
grant select on ${iol_schema}.ncbs_rb_int_rate_form_msg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_int_rate_form_msg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_int_rate_form_msg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_int_rate_form_msg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_int_rate_form_msg is '利率审批单信息表';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.reason is '原因';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.valid_from_date is '有效期起始日期';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.valid_thru_date is '有效期截止日期';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.disc_base_rate is '基准利率1';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.float_point is '浮动点差';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_rate_term is '利率协议期限';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.add_agreement_flag is '新增协议标志';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.pre_int_rate_form_no is '原审批单号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.auth_client_flag is '是否为我行授信客户';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.pri_amt_limit is '申请本金金额上限';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_valid_from_date is '利率优惠有效期起始日期';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_valid_thru_date is '利率优惠有效期截止日期';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_agreement_status is '利率协议状态';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_rate_form_apply_type is '利率审批申请类别';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.auth_client_payment is '授信客户的综合收益请款';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.new_acct_no_flag is '是否为新账号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.rb_prod_term is '存款期限';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_rate_rb_prod_type is '利率审批单存款品种';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.int_rate_form_no is '利率审批单单号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.diff_quote_rate is '差异化利率';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.keep_min_bal is '最小留存金额';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_int_rate_form_msg.etl_timestamp is 'ETL处理时间戳';
