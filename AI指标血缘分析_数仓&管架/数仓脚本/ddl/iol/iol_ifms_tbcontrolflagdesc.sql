/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbcontrolflagdesc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbcontrolflagdesc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbcontrolflagdesc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbcontrolflagdesc(
    table_name varchar2(48) -- 
    ,field_name varchar2(64) -- 
    ,position number(22) -- 
    ,table_label varchar2(256) -- 
    ,default_value varchar2(512) -- 
    ,option_visible varchar2(2) -- 
    ,input_type varchar2(2) -- 
    ,table_index number(22) -- 
    ,table_value varchar2(2) -- 
    ,prompt varchar2(375) -- 
    ,remark1 varchar2(375) -- 
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
grant select on ${iol_schema}.ifms_tbcontrolflagdesc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbcontrolflagdesc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbcontrolflagdesc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbcontrolflagdesc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbcontrolflagdesc is '控制字段描述表';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.table_name is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.field_name is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.position is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.table_label is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.default_value is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.option_visible is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.input_type is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.table_index is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.table_value is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.prompt is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.remark1 is '';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbcontrolflagdesc.etl_timestamp is 'ETL处理时间戳';
