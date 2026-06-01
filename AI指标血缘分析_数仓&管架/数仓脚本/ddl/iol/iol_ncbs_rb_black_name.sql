/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_black_name
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_black_name
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_black_name purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_black_name(
    acct_status varchar2(1) -- 账户状态
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,black_no varchar2(50) -- 黑名单编号
    ,black_seq varchar2(50) -- 黑名单序号
    ,company varchar2(20) -- 法人
    ,list_source varchar2(1) -- 名单来源
    ,our_bank_flag varchar2(1) -- 黑名单客户标志
    ,uncounter_desc varchar2(50) -- 入表原因
    ,create_date date -- 创建日期
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,remark1 varchar2(600) -- 备注1
    ,remark2 varchar2(600) -- 备注2
    ,remark3 varchar2(600) -- 备注3
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
grant select on ${iol_schema}.ncbs_rb_black_name to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_black_name to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_black_name to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_black_name to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_black_name is '核心黑名单表';
comment on column ${iol_schema}.ncbs_rb_black_name.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_black_name.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_black_name.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_black_name.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_black_name.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_black_name.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_black_name.black_no is '黑名单编号';
comment on column ${iol_schema}.ncbs_rb_black_name.black_seq is '黑名单序号';
comment on column ${iol_schema}.ncbs_rb_black_name.company is '法人';
comment on column ${iol_schema}.ncbs_rb_black_name.list_source is '名单来源';
comment on column ${iol_schema}.ncbs_rb_black_name.our_bank_flag is '黑名单客户标志';
comment on column ${iol_schema}.ncbs_rb_black_name.uncounter_desc is '入表原因';
comment on column ${iol_schema}.ncbs_rb_black_name.create_date is '创建日期';
comment on column ${iol_schema}.ncbs_rb_black_name.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_black_name.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_black_name.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_black_name.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_black_name.remark2 is '备注2';
comment on column ${iol_schema}.ncbs_rb_black_name.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rb_black_name.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_black_name.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_black_name.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_black_name.etl_timestamp is 'ETL处理时间戳';
