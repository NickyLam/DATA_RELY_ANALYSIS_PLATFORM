/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_client_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_client_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_client_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_client_change(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,new_client_no varchar2(16) -- 新客户号
    ,old_client_no varchar2(16) -- 原客户号
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_acct_client_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_client_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_client_change is '账户持有人信息变更表';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.new_client_no is '新客户号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.old_client_no is '原客户号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_client_change.etl_timestamp is 'ETL处理时间戳';
