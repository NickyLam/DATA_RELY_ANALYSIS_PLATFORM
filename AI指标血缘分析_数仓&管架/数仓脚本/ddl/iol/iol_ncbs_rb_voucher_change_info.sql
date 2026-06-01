/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_change_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_change_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_change_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_change_info(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,lost_no varchar2(50) -- 挂失编号
    ,mb_voucher_change_no varchar2(50) -- 凭证更换编号
    ,new_prefix varchar2(10) -- 新凭证前缀
    ,prefix varchar2(10) -- 前缀
    ,res_seq_no varchar2(50) -- 限制编号
    ,voucher_change_reason varchar2(200) -- 更换原因
    ,voucher_change_type varchar2(2) -- 凭证变更类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,new_card_no varchar2(50) -- 新卡号
    ,new_doc_type varchar2(10) -- 新凭证类型
    ,new_voucher_no varchar2(50) -- 新凭证号码
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_voucher_change_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_change_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_change_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_change_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_change_info is '凭证更换信息表';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.lost_no is '挂失编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.mb_voucher_change_no is '凭证更换编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.new_prefix is '新凭证前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.voucher_change_reason is '更换原因';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.voucher_change_type is '凭证变更类型';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.new_card_no is '新卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.new_doc_type is '新凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.new_voucher_no is '新凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_change_info.etl_timestamp is 'ETL处理时间戳';
