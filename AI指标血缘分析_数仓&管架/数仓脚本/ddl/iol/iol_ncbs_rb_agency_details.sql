/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agency_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agency_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agency_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agency_details(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,address varchar2(400) -- 地址
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,agency_type varchar2(1) -- 代发代扣类型
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,comments varchar2(200) -- 附言
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
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
grant select on ${iol_schema}.ncbs_rb_agency_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agency_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agency_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agency_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agency_details is '批量代发代扣明细表';
comment on column ${iol_schema}.ncbs_rb_agency_details.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_agency_details.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agency_details.address is '地址';
comment on column ${iol_schema}.ncbs_rb_agency_details.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agency_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agency_details.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agency_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agency_details.agency_type is '代发代扣类型';
comment on column ${iol_schema}.ncbs_rb_agency_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_agency_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_agency_details.comments is '附言';
comment on column ${iol_schema}.ncbs_rb_agency_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agency_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agency_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agency_details.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agency_details.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_agency_details.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_agency_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_agency_details.etl_timestamp is 'ETL处理时间戳';
