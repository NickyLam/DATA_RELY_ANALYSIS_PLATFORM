/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_contra_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_contra_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_contra_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_contra_info(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contra_acct_name varchar2(200) -- 对手账号名称
    ,contra_base_acct_no varchar2(50) -- 交易对手账号
    ,contra_client_no varchar2(16) -- 对方客户号
    ,contra_acct_open_date date -- 对手账户开户日期
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
grant select on ${iol_schema}.ncbs_rb_acct_contra_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_contra_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_contra_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_contra_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_contra_info is '内部户交易对手信息表';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.contra_acct_name is '对手账号名称';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.contra_base_acct_no is '交易对手账号';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.contra_client_no is '对方客户号';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.contra_acct_open_date is '对手账户开户日期';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_contra_info.etl_timestamp is 'ETL处理时间戳';
