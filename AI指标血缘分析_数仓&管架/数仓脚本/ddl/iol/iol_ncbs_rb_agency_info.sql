/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agency_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agency_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agency_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agency_info(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,agency_type varchar2(1) -- 代发代扣类型
    ,agreement_id varchar2(50) -- 协议编号
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,batch_end_time varchar2(26) -- 批次处理终止时间戳
    ,batch_start_time varchar2(26) -- 批次处理起始时间戳
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,batch_failure_reason varchar2(200) -- 批处理失败原因
    ,failure_reason varchar2(200) -- 失败原因
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_agency_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agency_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agency_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agency_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agency_info is '批量代发代扣交易信息表';
comment on column ${iol_schema}.ncbs_rb_agency_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_agency_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agency_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agency_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agency_info.agency_type is '代发代扣类型';
comment on column ${iol_schema}.ncbs_rb_agency_info.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agency_info.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_agency_info.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_agency_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agency_info.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_agency_info.batch_end_time is '批次处理终止时间戳';
comment on column ${iol_schema}.ncbs_rb_agency_info.batch_start_time is '批次处理起始时间戳';
comment on column ${iol_schema}.ncbs_rb_agency_info.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_agency_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_agency_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agency_info.batch_failure_reason is '批处理失败原因';
comment on column ${iol_schema}.ncbs_rb_agency_info.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_agency_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_agency_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_agency_info.etl_timestamp is 'ETL处理时间戳';
