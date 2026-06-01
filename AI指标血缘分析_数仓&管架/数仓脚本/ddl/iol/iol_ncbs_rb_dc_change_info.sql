/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_change_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_change_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_change_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_change_info(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,branch varchar2(12) -- 机构编号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,new_settle_acct_ccy varchar2(3) -- 新利息入账账户币种
    ,new_settle_acct_name varchar2(200) -- 新利息入账账户名称
    ,new_settle_acct_seq_no varchar2(5) -- 新利息入账账户序列号
    ,new_settle_base_acct_no varchar2(50) -- 新利息入账账号
    ,new_settle_prod_type varchar2(12) -- 新利息入账账户产品类型
    ,old_acct_name varchar2(200) -- 原账户名称
    ,old_acct_seq_no varchar2(10) -- 原账户序列号
    ,old_base_acct_no varchar2(50) -- 原账号
    ,old_ccy varchar2(3) -- 原币种
    ,old_client_no varchar2(16) -- 原客户号
    ,old_prod_type varchar2(12) -- 原产品类型
    ,old_settle_acct_ccy varchar2(3) -- 原利息入账账户币种
    ,old_settle_acct_name varchar2(200) -- 原利息入账账户名称
    ,old_settle_acct_seq_no varchar2(5) -- 原利息入账账户序列号
    ,old_settle_base_acct_no varchar2(50) -- 原利息入账账号
    ,old_settle_prod_type varchar2(12) -- 原利息入账账户产品类型
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
grant select on ${iol_schema}.ncbs_rb_dc_change_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_change_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_change_info is '大额存单转让信息登记簿';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.new_settle_acct_ccy is '新利息入账账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.new_settle_acct_name is '新利息入账账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.new_settle_acct_seq_no is '新利息入账账户序列号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.new_settle_base_acct_no is '新利息入账账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.new_settle_prod_type is '新利息入账账户产品类型';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_acct_name is '原账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_acct_seq_no is '原账户序列号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_base_acct_no is '原账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_ccy is '原币种';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_client_no is '原客户号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_prod_type is '原产品类型';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_settle_acct_ccy is '原利息入账账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_settle_acct_name is '原利息入账账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_settle_acct_seq_no is '原利息入账账户序列号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_settle_base_acct_no is '原利息入账账号';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.old_settle_prod_type is '原利息入账账户产品类型';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_change_info.etl_timestamp is 'ETL处理时间戳';
