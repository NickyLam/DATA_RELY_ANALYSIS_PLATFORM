/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pre_close_change_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pre_close_change_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pre_close_change_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pre_close_change_reg(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,company varchar2(20) -- 法人
    ,use_status varchar2(1) -- 使用状态
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_pre_close_change_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pre_close_change_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pre_close_change_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pre_close_change_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pre_close_change_reg is '预销户状态变化登记表';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.use_status is '使用状态';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_pre_close_change_reg.etl_timestamp is 'ETL处理时间戳';
