/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_wechat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_wechat
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_wechat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_wechat(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_level varchar2(2) -- 签约级别
    ,company varchar2(20) -- 法人
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_agreement_wechat to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_wechat to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_wechat to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_wechat to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_wechat is '协议表（微信签约）';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.agreement_level is '签约级别';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_wechat.etl_timestamp is 'ETL处理时间戳';
