/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_rec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_rec
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_rec purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_rec(
    client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,password varchar2(200) -- 密码
    ,phone_no varchar2(20) -- 固定电话
    ,source_type varchar2(6) -- 渠道编号
    ,sign_date date -- 签约日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,phone_name varchar2(200) -- 经办人名称
    ,sign_branch varchar2(12) -- 签约机构
    ,sign_user_id varchar2(8) -- 签约柜员
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
grant select on ${iol_schema}.ncbs_rb_agreement_rec to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_rec to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_rec to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_rec to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_rec is '回单经办人登记簿';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.password is '密码';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.phone_no is '固定电话';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.phone_name is '经办人名称';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.sign_branch is '签约机构';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_rec.etl_timestamp is 'ETL处理时间戳';
