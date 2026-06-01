/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_index_field_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_index_field_map
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_index_field_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_index_field_map(
    uuid varchar2(64) -- UUID
    ,indexid varchar2(256) -- 指标ID
    ,fieldcode varchar2(256) -- 字段标识
    ,fieldname varchar2(256) -- 字段名称
    ,source varchar2(256) -- 数据来源
    ,filedvalue varchar2(64) -- 字段值
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
grant select on ${iol_schema}.rsts_cpr_index_field_map to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_index_field_map to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_index_field_map to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_index_field_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_index_field_map is '指标字段映射表';
comment on column ${iol_schema}.rsts_cpr_index_field_map.uuid is 'UUID';
comment on column ${iol_schema}.rsts_cpr_index_field_map.indexid is '指标ID';
comment on column ${iol_schema}.rsts_cpr_index_field_map.fieldcode is '字段标识';
comment on column ${iol_schema}.rsts_cpr_index_field_map.fieldname is '字段名称';
comment on column ${iol_schema}.rsts_cpr_index_field_map.source is '数据来源';
comment on column ${iol_schema}.rsts_cpr_index_field_map.filedvalue is '字段值';
comment on column ${iol_schema}.rsts_cpr_index_field_map.start_dt is '开始时间';
comment on column ${iol_schema}.rsts_cpr_index_field_map.end_dt is '结束时间';
comment on column ${iol_schema}.rsts_cpr_index_field_map.id_mark is '增删标志';
comment on column ${iol_schema}.rsts_cpr_index_field_map.etl_timestamp is 'ETL处理时间戳';
