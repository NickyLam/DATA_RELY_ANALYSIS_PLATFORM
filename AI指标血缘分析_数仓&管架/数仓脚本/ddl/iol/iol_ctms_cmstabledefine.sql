/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_cmstabledefine
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_cmstabledefine
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_cmstabledefine purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_cmstabledefine(
    cmstabledefine_id number(22,0) -- 
    ,aspclient_id number(22,0) -- 
    ,f_type varchar2(2) -- 
    ,field_name varchar2(75) -- 
    ,field_desc varchar2(75) -- 
    ,field_parent number(22,0) -- 
    ,modify_time timestamp -- 
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
grant select on ${iol_schema}.ctms_cmstabledefine to ${iml_schema};
grant select on ${iol_schema}.ctms_cmstabledefine to ${icl_schema};
grant select on ${iol_schema}.ctms_cmstabledefine to ${idl_schema};
grant select on ${iol_schema}.ctms_cmstabledefine to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_cmstabledefine is '码值表';
comment on column ${iol_schema}.ctms_cmstabledefine.cmstabledefine_id is '';
comment on column ${iol_schema}.ctms_cmstabledefine.aspclient_id is '';
comment on column ${iol_schema}.ctms_cmstabledefine.f_type is '';
comment on column ${iol_schema}.ctms_cmstabledefine.field_name is '';
comment on column ${iol_schema}.ctms_cmstabledefine.field_desc is '';
comment on column ${iol_schema}.ctms_cmstabledefine.field_parent is '';
comment on column ${iol_schema}.ctms_cmstabledefine.modify_time is '';
comment on column ${iol_schema}.ctms_cmstabledefine.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_cmstabledefine.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_cmstabledefine.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_cmstabledefine.etl_timestamp is 'ETL处理时间戳';
