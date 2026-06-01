/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_office
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_office
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_office purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_office(
    office_code varchar2(24) -- 
    ,office_name varchar2(96) -- 
    ,short_name varchar2(250) -- 
    ,parent_code varchar2(32) -- 
    ,branch_code varchar2(24) -- 
    ,dep_code varchar2(24) -- 
    ,office_path varchar2(384) -- 
    ,remark varchar2(1000) -- 
    ,ext_field_1 varchar2(384) -- 
    ,ext_field_2 varchar2(384) -- 
    ,ext_field_3 varchar2(384) -- 
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
grant select on ${iol_schema}.ifms_tsys_office to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_office to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_office to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_office to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_office is '系统岗位表';
comment on column ${iol_schema}.ifms_tsys_office.office_code is '';
comment on column ${iol_schema}.ifms_tsys_office.office_name is '';
comment on column ${iol_schema}.ifms_tsys_office.short_name is '';
comment on column ${iol_schema}.ifms_tsys_office.parent_code is '';
comment on column ${iol_schema}.ifms_tsys_office.branch_code is '';
comment on column ${iol_schema}.ifms_tsys_office.dep_code is '';
comment on column ${iol_schema}.ifms_tsys_office.office_path is '';
comment on column ${iol_schema}.ifms_tsys_office.remark is '';
comment on column ${iol_schema}.ifms_tsys_office.ext_field_1 is '';
comment on column ${iol_schema}.ifms_tsys_office.ext_field_2 is '';
comment on column ${iol_schema}.ifms_tsys_office.ext_field_3 is '';
comment on column ${iol_schema}.ifms_tsys_office.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tsys_office.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tsys_office.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tsys_office.etl_timestamp is 'ETL处理时间戳';
