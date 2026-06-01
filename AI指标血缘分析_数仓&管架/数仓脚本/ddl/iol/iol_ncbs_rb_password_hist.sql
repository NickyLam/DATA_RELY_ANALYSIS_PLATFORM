/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_password_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_password_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_password_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_password_hist(
    pwd_key varchar2(50) -- 账户密码标识符
    ,pwd_type varchar2(2) -- 密码类型
    ,client_no varchar2(16) -- 客户编号
    ,password_new varchar2(200) -- 新密码
    ,password_old varchar2(200) -- 旧密码
    ,tran_date date -- 交易日期
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reference varchar2(50) -- 交易参考号
    ,modify_password_type varchar2(3) -- 密码修改类型
    ,modify_reason varchar2(200) -- 修改原因
    ,password_status varchar2(1) -- 密码状态
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_password_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_password_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_password_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_password_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_password_hist is '帐户密码修改历史表|记录账户密码修改历史';
comment on column ${iol_schema}.ncbs_rb_password_hist.pwd_key is '账户密码标识符';
comment on column ${iol_schema}.ncbs_rb_password_hist.pwd_type is '密码类型';
comment on column ${iol_schema}.ncbs_rb_password_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_password_hist.password_new is '新密码';
comment on column ${iol_schema}.ncbs_rb_password_hist.password_old is '旧密码';
comment on column ${iol_schema}.ncbs_rb_password_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_password_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_password_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_password_hist.modify_password_type is '密码修改类型';
comment on column ${iol_schema}.ncbs_rb_password_hist.modify_reason is '修改原因';
comment on column ${iol_schema}.ncbs_rb_password_hist.password_status is '密码状态';
comment on column ${iol_schema}.ncbs_rb_password_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_password_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_password_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_password_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_password_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_password_hist.etl_timestamp is 'ETL处理时间戳';
