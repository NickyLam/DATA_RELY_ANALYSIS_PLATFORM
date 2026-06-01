/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_draft_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_draft_status
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_draft_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_draft_status(
    id varchar2(60) -- 
    ,draft_number varchar2(45) -- 
    ,reserve3 varchar2(450) -- 
    ,store_status varchar2(23) -- 
    ,status varchar2(450) -- 
    ,src_type varchar2(9) -- 
    ,last_txn_date convert_error -- 
    ,stan_status varchar2(2) -- 
    ,stan_status_cn varchar2(6) -- 
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
grant select on ${iol_schema}.bdms_draft_status to ${iml_schema};
grant select on ${iol_schema}.bdms_draft_status to ${icl_schema};
grant select on ${iol_schema}.bdms_draft_status to ${idl_schema};
grant select on ${iol_schema}.bdms_draft_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_draft_status is '码值表';
comment on column ${iol_schema}.bdms_draft_status.id is '';
comment on column ${iol_schema}.bdms_draft_status.draft_number is '';
comment on column ${iol_schema}.bdms_draft_status.reserve3 is '';
comment on column ${iol_schema}.bdms_draft_status.store_status is '';
comment on column ${iol_schema}.bdms_draft_status.status is '';
comment on column ${iol_schema}.bdms_draft_status.src_type is '';
comment on column ${iol_schema}.bdms_draft_status.last_txn_date is '';
comment on column ${iol_schema}.bdms_draft_status.stan_status is '';
comment on column ${iol_schema}.bdms_draft_status.stan_status_cn is '';
comment on column ${iol_schema}.bdms_draft_status.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_draft_status.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_draft_status.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_draft_status.etl_timestamp is 'ETL处理时间戳';
