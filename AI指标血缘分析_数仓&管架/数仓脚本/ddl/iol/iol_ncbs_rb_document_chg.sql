/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_document_chg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_document_chg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_document_chg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_document_chg(
    client_no varchar2(16) -- 客户编号
    ,document_type varchar2(4) -- 客户证件类型
    ,timestamp varchar2(26) -- 时间戳
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,new_document_id varchar2(60) -- 变更后证件号码
    ,old_client_name varchar2(200) -- 原客户名称
    ,old_document_id varchar2(60) -- 变更前证件号码
    ,old_document_type varchar2(4) -- 旧证件类型
    ,new_client_name varchar2(200) -- 新客户名称
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
grant select on ${iol_schema}.ncbs_rb_document_chg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_document_chg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_document_chg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_document_chg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_document_chg is '证件信息变更登记簿';
comment on column ${iol_schema}.ncbs_rb_document_chg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_document_chg.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_document_chg.timestamp is '时间戳';
comment on column ${iol_schema}.ncbs_rb_document_chg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_document_chg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_document_chg.new_document_id is '变更后证件号码';
comment on column ${iol_schema}.ncbs_rb_document_chg.old_client_name is '原客户名称';
comment on column ${iol_schema}.ncbs_rb_document_chg.old_document_id is '变更前证件号码';
comment on column ${iol_schema}.ncbs_rb_document_chg.old_document_type is '旧证件类型';
comment on column ${iol_schema}.ncbs_rb_document_chg.new_client_name is '新客户名称';
comment on column ${iol_schema}.ncbs_rb_document_chg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_document_chg.etl_timestamp is 'ETL处理时间戳';
