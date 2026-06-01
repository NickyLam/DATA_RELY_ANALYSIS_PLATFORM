/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pn_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pn_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pn_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pn_register(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,remark varchar2(600) -- 备注
    ,bill_apply_no varchar2(50) -- 本票申请书号码
    ,bill_apply_prefix varchar2(10) -- 本票申请书前缀
    ,bill_apply_type varchar2(10) -- 本票申请书类型
    ,bill_no varchar2(30) -- 票据号码
    ,bill_pswd varchar2(20) -- 票据密押
    ,bill_status varchar2(2) -- 票据状态
    ,bill_type varchar2(1) -- 票据种类
    ,company varchar2(20) -- 法人
    ,medium_no varchar2(50) -- 介质号码
    ,payer_tele varchar2(20) -- 收款人联系电话
    ,payment_type varchar2(10) -- 兑付方式
    ,serial_no varchar2(50) -- 支付流水号
    ,tranfer_cash_flag varchar2(1) -- 现转标识
    ,bill_apply_date date -- 本票申请书日期
    ,bill_sign_date date -- 票据登记日期
    ,last_tran_date date -- 最后交易日期
    ,payment_date date -- 兑付日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,bill_sign_branch varchar2(12) -- 票据签发机构
    ,bill_sign_user_id varchar2(8) -- 签发柜员
    ,bill_tran_amt number(17,2) -- 出票金额
    ,payee_acct_ccy varchar2(3) -- 收款人账户币种
    ,payee_acct_name varchar2(200) -- 收款人名称
    ,payee_acct_seq_no varchar2(5) -- 收款人账户序列号
    ,payee_base_acct_no varchar2(50) -- 收款人账号
    ,payee_prod_type varchar2(12) -- 收款人账户产品类型
    ,payer_acct_ccy varchar2(3) -- 付款账户币种
    ,payer_acct_name varchar2(200) -- 付款人账户名称
    ,payer_acct_seq_no varchar2(5) -- 付款人账户序号
    ,payer_bank_code varchar2(20) -- 付款人账户机构
    ,payer_bank_name varchar2(400) -- 出票行名称
    ,payer_base_acct_no varchar2(50) -- 付款人账号
    ,payer_document_id varchar2(60) -- 付款人证件号码
    ,payer_document_type varchar2(4) -- 付款人证件类型
    ,payer_prod_type varchar2(12) -- 付款人账户产品类型
    ,payment_bank_no varchar2(20) -- 兑付行行号
    ,refuse_reason varchar2(200) -- 拒绝原因
    ,sign_ccy varchar2(3) -- 签发币种
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
grant select on ${iol_schema}.ncbs_rb_pn_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pn_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pn_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pn_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pn_register is '本票签发登记簿';
comment on column ${iol_schema}.ncbs_rb_pn_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pn_register.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_pn_register.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_apply_no is '本票申请书号码';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_apply_prefix is '本票申请书前缀';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_apply_type is '本票申请书类型';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_no is '票据号码';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_pswd is '票据密押';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_status is '票据状态';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_type is '票据种类';
comment on column ${iol_schema}.ncbs_rb_pn_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pn_register.medium_no is '介质号码';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_tele is '收款人联系电话';
comment on column ${iol_schema}.ncbs_rb_pn_register.payment_type is '兑付方式';
comment on column ${iol_schema}.ncbs_rb_pn_register.serial_no is '支付流水号';
comment on column ${iol_schema}.ncbs_rb_pn_register.tranfer_cash_flag is '现转标识';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_apply_date is '本票申请书日期';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_sign_date is '票据登记日期';
comment on column ${iol_schema}.ncbs_rb_pn_register.last_tran_date is '最后交易日期';
comment on column ${iol_schema}.ncbs_rb_pn_register.payment_date is '兑付日期';
comment on column ${iol_schema}.ncbs_rb_pn_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pn_register.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_pn_register.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_sign_branch is '票据签发机构';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_sign_user_id is '签发柜员';
comment on column ${iol_schema}.ncbs_rb_pn_register.bill_tran_amt is '出票金额';
comment on column ${iol_schema}.ncbs_rb_pn_register.payee_acct_ccy is '收款人账户币种';
comment on column ${iol_schema}.ncbs_rb_pn_register.payee_acct_name is '收款人名称';
comment on column ${iol_schema}.ncbs_rb_pn_register.payee_acct_seq_no is '收款人账户序列号';
comment on column ${iol_schema}.ncbs_rb_pn_register.payee_base_acct_no is '收款人账号';
comment on column ${iol_schema}.ncbs_rb_pn_register.payee_prod_type is '收款人账户产品类型';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_acct_ccy is '付款账户币种';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_acct_name is '付款人账户名称';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_acct_seq_no is '付款人账户序号';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_bank_code is '付款人账户机构';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_bank_name is '出票行名称';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_base_acct_no is '付款人账号';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_document_id is '付款人证件号码';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_document_type is '付款人证件类型';
comment on column ${iol_schema}.ncbs_rb_pn_register.payer_prod_type is '付款人账户产品类型';
comment on column ${iol_schema}.ncbs_rb_pn_register.payment_bank_no is '兑付行行号';
comment on column ${iol_schema}.ncbs_rb_pn_register.refuse_reason is '拒绝原因';
comment on column ${iol_schema}.ncbs_rb_pn_register.sign_ccy is '签发币种';
comment on column ${iol_schema}.ncbs_rb_pn_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pn_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pn_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pn_register.etl_timestamp is 'ETL处理时间戳';
