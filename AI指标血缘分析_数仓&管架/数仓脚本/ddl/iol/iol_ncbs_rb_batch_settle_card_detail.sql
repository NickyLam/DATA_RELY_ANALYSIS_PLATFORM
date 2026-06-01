/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_settle_card_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_settle_card_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_settle_card_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_settle_card_detail(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,voucher_no varchar2(50) -- 凭证号码
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,contact_tel varchar2(20) -- 客户联系电话
    ,error_desc varchar2(3000) -- 错误描述
    ,location varchar2(200) -- 客户地址
    ,main_card_flag varchar2(1) -- 主卡标识
    ,mobile_no varchar2(30) -- 电话号码
    ,prefix varchar2(10) -- 前缀
    ,seq_no varchar2(50) -- 序号
    ,sex varchar2(1) -- 性别
    ,birthday date -- 生日
    ,document_expiry_date date -- 证件失效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,acct_ccy varchar2(3) -- 账户币种
    ,card_prod_type varchar2(12) -- 卡产品类型
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,main_card_no varchar2(50) -- 主卡卡号
    ,off_document_id varchar2(60) -- 经办人证件号码
    ,off_document_type varchar2(4) -- 经办人证件类型
    ,operator_name varchar2(200) -- 经办人姓名
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
grant select on ${iol_schema}.ncbs_rb_batch_settle_card_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_settle_card_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_settle_card_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_settle_card_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_settle_card_detail is '批量开卡明细';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.location is '客户地址';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.main_card_flag is '主卡标识';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.sex is '性别';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.birthday is '生日';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.document_expiry_date is '证件失效日期';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.card_prod_type is '卡产品类型';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.main_card_no is '主卡卡号';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.off_document_id is '经办人证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.off_document_type is '经办人证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.operator_name is '经办人姓名';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_settle_card_detail.etl_timestamp is 'ETL处理时间戳';
