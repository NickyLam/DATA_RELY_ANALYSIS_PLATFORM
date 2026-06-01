/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_internal_acct_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_internal_acct_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_internal_acct_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_internal_acct_mapping(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,tran_type varchar2(10) -- 交易类型
    ,channel_type_rule varchar2(200) -- 渠道类型规则
    ,company varchar2(20) -- 法人
    ,inter_tran_type varchar2(10) -- 内部交易类型
    ,libra_op_time number(15) -- libra执行次数
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,oth_acct_no varchar2(50) -- 对方账号
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
grant select on ${iol_schema}.ncbs_rb_internal_acct_mapping to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_internal_acct_mapping to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_internal_acct_mapping to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_internal_acct_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_internal_acct_mapping is '内部帐账户映射';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.channel_type_rule is '渠道类型规则';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.company is '法人';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.inter_tran_type is '内部交易类型';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.oth_acct_no is '对方账号';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_internal_acct_mapping.etl_timestamp is 'ETL处理时间戳';
