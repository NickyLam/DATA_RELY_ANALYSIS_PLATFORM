/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rpss_relatedparty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rpss_relatedparty
whenever sqlerror continue none;
drop table ${iol_schema}.rpss_relatedparty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_relatedparty(
    related_id varchar2(20) -- 
    ,ywlx varchar2(20) -- 
    ,status_id varchar2(20) -- 
    ,registrant varchar2(100) -- 
    ,registration_org varchar2(100) -- 
    ,registration_date timestamp -- 
    ,last_modified_date timestamp -- 
    ,last_modified_by_user_login varchar2(255) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,approval_date timestamp -- 
    ,approval_person varchar2(50) -- 
    ,reject_reason varchar2(500) -- 
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
grant select on ${iol_schema}.rpss_relatedparty to ${iml_schema};
grant select on ${iol_schema}.rpss_relatedparty to ${icl_schema};
grant select on ${iol_schema}.rpss_relatedparty to ${idl_schema};
grant select on ${iol_schema}.rpss_relatedparty to ${iel_schema};

-- comment
comment on table ${iol_schema}.rpss_relatedparty is '状态 表';
comment on column ${iol_schema}.rpss_relatedparty.related_id is '';
comment on column ${iol_schema}.rpss_relatedparty.ywlx is '';
comment on column ${iol_schema}.rpss_relatedparty.status_id is '';
comment on column ${iol_schema}.rpss_relatedparty.registrant is '';
comment on column ${iol_schema}.rpss_relatedparty.registration_org is '';
comment on column ${iol_schema}.rpss_relatedparty.registration_date is '';
comment on column ${iol_schema}.rpss_relatedparty.last_modified_date is '';
comment on column ${iol_schema}.rpss_relatedparty.last_modified_by_user_login is '';
comment on column ${iol_schema}.rpss_relatedparty.last_updated_stamp is '';
comment on column ${iol_schema}.rpss_relatedparty.last_updated_tx_stamp is '';
comment on column ${iol_schema}.rpss_relatedparty.created_stamp is '';
comment on column ${iol_schema}.rpss_relatedparty.created_tx_stamp is '';
comment on column ${iol_schema}.rpss_relatedparty.approval_date is '';
comment on column ${iol_schema}.rpss_relatedparty.approval_person is '';
comment on column ${iol_schema}.rpss_relatedparty.reject_reason is '';
comment on column ${iol_schema}.rpss_relatedparty.start_dt is '开始时间';
comment on column ${iol_schema}.rpss_relatedparty.end_dt is '结束时间';
comment on column ${iol_schema}.rpss_relatedparty.id_mark is '增删标志';
comment on column ${iol_schema}.rpss_relatedparty.etl_timestamp is 'ETL处理时间戳';
