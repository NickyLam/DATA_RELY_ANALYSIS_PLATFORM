/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_channel_tran_acct_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_channel_tran_acct_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_channel_tran_acct_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_channel_tran_acct_mapping(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
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
grant select on ${iol_schema}.ncbs_rb_channel_tran_acct_mapping to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_acct_mapping to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_acct_mapping to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_channel_tran_acct_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_channel_tran_acct_mapping is '配置渠道、交易类型对应内部账号表';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.company is '法人';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_channel_tran_acct_mapping.etl_timestamp is 'ETL处理时间戳';
