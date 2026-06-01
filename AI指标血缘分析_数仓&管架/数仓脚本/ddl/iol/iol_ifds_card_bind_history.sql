/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifds_card_bind_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifds_card_bind_history
whenever sqlerror continue none;
drop table ${iol_schema}.ifds_card_bind_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifds_card_bind_history(
    tran_seq_no varchar2(60) -- 交易流水
    ,billing_account_id varchar2(30) -- e账户编号
    ,card_no varchar2(30) -- 卡号
    ,card_name varchar2(383) -- 户名
    ,customer_no varchar2(30) -- 客户号
    ,card_type_id varchar2(30) -- 卡类型
    ,other_bank_flag varchar2(2) -- 本他行标志
    ,bank_offices_no varchar2(30) -- 绑卡开户网点
    ,bind_date timestamp -- 绑定时间
    ,operate_time timestamp -- 操作时间
    ,status_id varchar2(30) -- 状态
    ,amount number(18,2) -- 预绑金额
    ,simp_pay_flag varchar2(2) -- 是否快捷支付
    ,bank_number varchar2(30) -- 归属行
    ,bank_name varchar2(383) -- 行名
    ,third_party_id varchar2(60) -- 商户号
    ,third_party_name varchar2(383) -- 商户名称
    ,channel varchar2(30) -- 通道
    ,cancel_date timestamp -- 状态结束日期
    ,account_type varchar2(30) -- 账户类型
    ,card_flag varchar2(30) -- 卡类型
    ,limited_amount varchar2(30) -- 限额
    ,is_limiteo varchar2(2) -- 是否限额
    ,default_card varchar2(30) -- 是否默认卡
    ,business_type varchar2(12) -- 业务类型
    ,financial_institution_code varchar2(60) -- 开户银行金融机构编码
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
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
grant select on ${iol_schema}.ifds_card_bind_history to ${iml_schema};
grant select on ${iol_schema}.ifds_card_bind_history to ${icl_schema};
grant select on ${iol_schema}.ifds_card_bind_history to ${idl_schema};
grant select on ${iol_schema}.ifds_card_bind_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifds_card_bind_history is '绑卡历史';
comment on column ${iol_schema}.ifds_card_bind_history.tran_seq_no is '交易流水';
comment on column ${iol_schema}.ifds_card_bind_history.billing_account_id is 'e账户编号';
comment on column ${iol_schema}.ifds_card_bind_history.card_no is '卡号';
comment on column ${iol_schema}.ifds_card_bind_history.card_name is '户名';
comment on column ${iol_schema}.ifds_card_bind_history.customer_no is '客户号';
comment on column ${iol_schema}.ifds_card_bind_history.card_type_id is '卡类型';
comment on column ${iol_schema}.ifds_card_bind_history.other_bank_flag is '本他行标志';
comment on column ${iol_schema}.ifds_card_bind_history.bank_offices_no is '绑卡开户网点';
comment on column ${iol_schema}.ifds_card_bind_history.bind_date is '绑定时间';
comment on column ${iol_schema}.ifds_card_bind_history.operate_time is '操作时间';
comment on column ${iol_schema}.ifds_card_bind_history.status_id is '状态';
comment on column ${iol_schema}.ifds_card_bind_history.amount is '预绑金额';
comment on column ${iol_schema}.ifds_card_bind_history.simp_pay_flag is '是否快捷支付';
comment on column ${iol_schema}.ifds_card_bind_history.bank_number is '归属行';
comment on column ${iol_schema}.ifds_card_bind_history.bank_name is '行名';
comment on column ${iol_schema}.ifds_card_bind_history.third_party_id is '商户号';
comment on column ${iol_schema}.ifds_card_bind_history.third_party_name is '商户名称';
comment on column ${iol_schema}.ifds_card_bind_history.channel is '通道';
comment on column ${iol_schema}.ifds_card_bind_history.cancel_date is '状态结束日期';
comment on column ${iol_schema}.ifds_card_bind_history.account_type is '账户类型';
comment on column ${iol_schema}.ifds_card_bind_history.card_flag is '卡类型';
comment on column ${iol_schema}.ifds_card_bind_history.limited_amount is '限额';
comment on column ${iol_schema}.ifds_card_bind_history.is_limiteo is '是否限额';
comment on column ${iol_schema}.ifds_card_bind_history.default_card is '是否默认卡';
comment on column ${iol_schema}.ifds_card_bind_history.business_type is '业务类型';
comment on column ${iol_schema}.ifds_card_bind_history.financial_institution_code is '开户银行金融机构编码';
comment on column ${iol_schema}.ifds_card_bind_history.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.ifds_card_bind_history.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.ifds_card_bind_history.created_stamp is '创建时间';
comment on column ${iol_schema}.ifds_card_bind_history.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.ifds_card_bind_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifds_card_bind_history.etl_timestamp is 'ETL处理时间戳';
