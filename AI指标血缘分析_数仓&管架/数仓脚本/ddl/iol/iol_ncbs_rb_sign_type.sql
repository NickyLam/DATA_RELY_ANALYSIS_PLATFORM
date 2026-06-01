/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_sign_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_sign_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_sign_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_sign_type(
    agreement_close_acct_flag varchar2(1) -- 签约后是否允许销户
    ,company varchar2(20) -- 法人
    ,exclude_type varchar2(200) -- 协议互斥类型(多个用,分割)
    ,repick_flag varchar2(1) -- 是否允许重复签约
    ,sign_type varchar2(20) -- 签约类型
    ,sign_type_desc varchar2(100) -- 协议类型描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_sign_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_sign_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_sign_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_sign_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_sign_type is '协议类型参数表';
comment on column ${iol_schema}.ncbs_rb_sign_type.agreement_close_acct_flag is '签约后是否允许销户';
comment on column ${iol_schema}.ncbs_rb_sign_type.company is '法人';
comment on column ${iol_schema}.ncbs_rb_sign_type.exclude_type is '协议互斥类型(多个用,分割)';
comment on column ${iol_schema}.ncbs_rb_sign_type.repick_flag is '是否允许重复签约';
comment on column ${iol_schema}.ncbs_rb_sign_type.sign_type is '签约类型';
comment on column ${iol_schema}.ncbs_rb_sign_type.sign_type_desc is '协议类型描述';
comment on column ${iol_schema}.ncbs_rb_sign_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_sign_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_sign_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_sign_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_sign_type.etl_timestamp is 'ETL处理时间戳';
