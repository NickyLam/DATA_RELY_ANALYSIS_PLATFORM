/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fund_direction_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fund_direction_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fund_direction_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fund_direction_details(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,fund_source varchar2(50) -- 资金来源
    ,reg_type varchar2(1) -- 登记类型
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,agent_name varchar2(200) -- 办理人姓名
    ,bab_internal_base_acct_no varchar2(50) -- 内部账户账号
    ,fund_to_acct_no varchar2(30) -- 资金去向账号
    ,fund_acct_purpose varchar2(2) -- 账户资金用途
    ,fund_from_acct_no varchar2(30) -- 资金来源账号
    ,fund_from_bank_no varchar2(50) -- 资金来源支付行号
    ,fund_from_name varchar2(200) -- 资金来源户名
    ,fund_to_bank_no varchar2(50) -- 资金去向支付行号
    ,fund_to_name varchar2(200) -- 资金去向户名
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
grant select on ${iol_schema}.ncbs_rb_fund_direction_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fund_direction_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fund_direction_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fund_direction_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fund_direction_details is '资金来源去向登记表';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_source is '资金来源';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.reg_type is '登记类型';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.agent_name is '办理人姓名';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.bab_internal_base_acct_no is '内部账户账号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_to_acct_no is '资金去向账号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_acct_purpose is '账户资金用途';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_from_acct_no is '资金来源账号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_from_bank_no is '资金来源支付行号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_from_name is '资金来源户名';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_to_bank_no is '资金去向支付行号';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.fund_to_name is '资金去向户名';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fund_direction_details.etl_timestamp is 'ETL处理时间戳';
