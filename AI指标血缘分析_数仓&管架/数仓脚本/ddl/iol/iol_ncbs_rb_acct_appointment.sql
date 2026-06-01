/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_appointment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_appointment
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_appointment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_appointment(
    acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_type varchar2(3) -- 客户类型
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,apply_id varchar2(50) -- 申请预约编号
    ,appointment_status varchar2(2) -- 预约状态
    ,category_type varchar2(3) -- 存款人类别
    ,company varchar2(20) -- 法人
    ,apply_due_date date -- 预约到期日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
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
grant select on ${iol_schema}.ncbs_rb_acct_appointment to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_appointment to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_appointment to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_appointment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_appointment is '账户预约表';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.apply_id is '申请预约编号';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.appointment_status is '预约状态';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.category_type is '存款人类别';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.apply_due_date is '预约到期日';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_appointment.etl_timestamp is 'ETL处理时间戳';
