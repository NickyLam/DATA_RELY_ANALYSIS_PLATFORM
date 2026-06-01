/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_contact_certificate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_contact_certificate
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_contact_certificate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_contact_certificate(
    party_id varchar2(30) -- 当事人编号
    ,contact_certificate_id varchar2(30) -- 证件编号
    ,from_date timestamp -- 有效期起始时间
    ,thru_date timestamp -- 有效期结束时间
    ,role_type_id varchar2(30) -- 当事人角色类型
    ,last_updated_stamp timestamp -- 曾用名最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,main_documents_sign varchar2(30) -- 主证件标志
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
grant select on ${iol_schema}.eifs_party_contact_certificate to ${iml_schema};
grant select on ${iol_schema}.eifs_party_contact_certificate to ${icl_schema};
grant select on ${iol_schema}.eifs_party_contact_certificate to ${idl_schema};
grant select on ${iol_schema}.eifs_party_contact_certificate to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_contact_certificate is '证件关联当事人表';
comment on column ${iol_schema}.eifs_party_contact_certificate.party_id is '当事人编号';
comment on column ${iol_schema}.eifs_party_contact_certificate.contact_certificate_id is '证件编号';
comment on column ${iol_schema}.eifs_party_contact_certificate.from_date is '有效期起始时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.thru_date is '有效期结束时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.role_type_id is '当事人角色类型';
comment on column ${iol_schema}.eifs_party_contact_certificate.last_updated_stamp is '曾用名最后更新时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.main_documents_sign is '主证件标志';
comment on column ${iol_schema}.eifs_party_contact_certificate.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_contact_certificate.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_contact_certificate.etl_timestamp is 'ETL处理时间戳';
