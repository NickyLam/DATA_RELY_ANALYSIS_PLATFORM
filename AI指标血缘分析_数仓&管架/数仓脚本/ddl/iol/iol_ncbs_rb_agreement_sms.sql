/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_sms
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_sms
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_sms purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_sms(
    client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,internal_key number(15) -- 账户内部键值
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_level varchar2(2) -- 签约级别
    ,company varchar2(20) -- 法人
    ,contact_tel varchar2(20) -- 客户联系电话
    ,fee_type varchar2(20) -- 费率类型
    ,gender_flag varchar2(1) -- 适用性别
    ,position varchar2(10) -- 职位
    ,take_sign_flag varchar2(1) -- 最小金额发送短信标志
    ,sms_open_flag varchar2(3) -- 短信开通三位标识符
    ,document_expiry_date date -- 证件失效日期
    ,next_charge_date date -- 下一收费日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cash_min_amt number(17,2) -- 短信发送最小现金金额
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,charge_day varchar2(2) -- 收费日
    ,charge_period_freq varchar2(5) -- 收费频率
    ,charge_to_base_acct_no varchar2(50) -- 收费账号
    ,fee_amt number(17,2) -- 费用金额
    ,take_in_sign_cash number(17,2) -- 转入最小金额（现金）
    ,take_out_sign number(17,2) -- 转出最小金额（转账）
    ,take_out_sign_cash number(17,2) -- 转出最小金额（现金）
    ,tran_min_amt number(17,2) -- 短信发送最小转账金额
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
grant select on ${iol_schema}.ncbs_rb_agreement_sms to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sms to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sms to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sms to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_sms is '短信签约表';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.agreement_level is '签约级别';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.contact_tel is '客户联系电话';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.gender_flag is '适用性别';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.position is '职位';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.take_sign_flag is '最小金额发送短信标志';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.sms_open_flag is '短信开通三位标识符';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.document_expiry_date is '证件失效日期';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.next_charge_date is '下一收费日期';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.cash_min_amt is '短信发送最小现金金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.charge_day is '收费日';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.charge_period_freq is '收费频率';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.charge_to_base_acct_no is '收费账号';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.take_in_sign_cash is '转入最小金额（现金）';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.take_out_sign is '转出最小金额（转账）';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.take_out_sign_cash is '转出最小金额（现金）';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.tran_min_amt is '短信发送最小转账金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_sms.etl_timestamp is 'ETL处理时间戳';
