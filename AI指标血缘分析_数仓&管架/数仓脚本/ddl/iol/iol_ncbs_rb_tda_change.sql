/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tda_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tda_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tda_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tda_change(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,change_tda_seq_no varchar2(50) -- 存期变更交易序号
    ,change_tda_status varchar2(1) -- 存期变更状态
    ,company varchar2(20) -- 法人
    ,tda_change_type varchar2(1) -- 存期变更类型
    ,maturity_date date -- 到期日期
    ,new_maturity_date date -- 新到期日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,new_term varchar2(5) -- 新期限
    ,new_term_type varchar2(1) -- 新存期类型
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
grant select on ${iol_schema}.ncbs_rb_tda_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tda_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tda_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tda_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tda_change is '存期变更流水表';
comment on column ${iol_schema}.ncbs_rb_tda_change.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_tda_change.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_tda_change.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_tda_change.term is '存期';
comment on column ${iol_schema}.ncbs_rb_tda_change.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_tda_change.change_tda_seq_no is '存期变更交易序号';
comment on column ${iol_schema}.ncbs_rb_tda_change.change_tda_status is '存期变更状态';
comment on column ${iol_schema}.ncbs_rb_tda_change.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tda_change.tda_change_type is '存期变更类型';
comment on column ${iol_schema}.ncbs_rb_tda_change.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_tda_change.new_maturity_date is '新到期日';
comment on column ${iol_schema}.ncbs_rb_tda_change.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_tda_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tda_change.new_term is '新期限';
comment on column ${iol_schema}.ncbs_rb_tda_change.new_term_type is '新存期类型';
comment on column ${iol_schema}.ncbs_rb_tda_change.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_tda_change.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tda_change.etl_timestamp is 'ETL处理时间戳';
