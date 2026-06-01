/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_up_down_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_up_down_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_up_down_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_up_down_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_class varchar2(1) -- 账户等级
    ,company varchar2(20) -- 法人
    ,old_acct_class varchar2(1) -- 升降级前账户类别
    ,seq_no varchar2(50) -- 序号
    ,up_down_type varchar2(10) -- 账户升降级表示符
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_date date -- 交易日期
    ,channel_seq_no varchar2(33) -- 全局流水号|渠道流水号
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
grant select on ${iol_schema}.ncbs_rb_acct_up_down_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_up_down_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_up_down_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_up_down_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_up_down_info is 'ii/iii类账户升降级信息表';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.old_acct_class is '升降级前账户类别';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.up_down_type is '账户升降级表示符';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.channel_seq_no is '全局流水号|渠道流水号';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_up_down_info.etl_timestamp is 'ETL处理时间戳';
