/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_client_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_client_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_client_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_client_relation(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reason_code varchar2(10) -- 账户用途
    ,acct_class varchar2(1) -- 账户等级
    ,acct_nature varchar2(10) -- 存款账户类型
    ,acct_real_flag varchar2(1) -- 账户虚实标志
    ,app_flag varchar2(1) -- 附属卡标志
    ,company varchar2(20) -- 法人
    ,default_settle_acct varchar2(1) -- 是否默认结算账户
    ,individual_flag varchar2(1) -- 对公对私标志
    ,is_card varchar2(1) -- 是否卡
    ,is_corp_settle_card varchar2(1) -- 单位结算卡标志
    ,lead_acct_flag varchar2(1) -- 主账户标志
    ,reason_code_desc varchar2(100) -- 原因代码描述
    ,shard_id varchar2(5) -- 分库标志
    ,source_type varchar2(6) -- 渠道编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_acct_no varchar2(50) -- 实际账号
    ,parent_internal_key number(15) -- 上级账户标识符
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
grant select on ${iol_schema}.ncbs_rb_acct_client_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_client_relation is '账户客户关系表';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_real_flag is '账户虚实标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.app_flag is '附属卡标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.default_settle_acct is '是否默认结算账户';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.is_card is '是否卡';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.is_corp_settle_card is '单位结算卡标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.lead_acct_flag is '主账户标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.reason_code_desc is '原因代码描述';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.shard_id is '分库标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.actual_acct_no is '实际账号';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.parent_internal_key is '上级账户标识符';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_relation.etl_timestamp is 'ETL处理时间戳';
