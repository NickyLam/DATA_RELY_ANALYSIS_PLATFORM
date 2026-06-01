/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_vtrd_obj_id
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_vtrd_obj_id
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_vtrd_obj_id purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_obj_id(
    i_code varchar2(120) -- 金融工具代码
    ,a_type varchar2(30) -- 金融工具资产类型
    ,m_type varchar2(30) -- 金融工具资产类型
    ,old_obj_id varchar2(45) -- 老核算对象id
    ,new_obj_id varchar2(45) -- 新核算对象id
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
grant select on ${iol_schema}.ibms_vtrd_obj_id to ${iml_schema};
grant select on ${iol_schema}.ibms_vtrd_obj_id to ${icl_schema};
grant select on ${iol_schema}.ibms_vtrd_obj_id to ${idl_schema};
grant select on ${iol_schema}.ibms_vtrd_obj_id to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_vtrd_obj_id is '';
comment on column ${iol_schema}.ibms_vtrd_obj_id.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_vtrd_obj_id.a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_vtrd_obj_id.m_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_vtrd_obj_id.old_obj_id is '老核算对象id';
comment on column ${iol_schema}.ibms_vtrd_obj_id.new_obj_id is '新核算对象id';
comment on column ${iol_schema}.ibms_vtrd_obj_id.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_vtrd_obj_id.etl_timestamp is 'ETL处理时间戳';
