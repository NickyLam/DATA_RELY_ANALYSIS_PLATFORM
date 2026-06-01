/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_institution_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_institution_map
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_institution_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_map(
    i_id number(16,0) -- 机构id
    ,parent_id number(16,0) -- 上级机构id
    ,sort number(3,0) -- 机构树节点排列顺序
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
grant select on ${iol_schema}.ibms_ttrd_institution_map to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_map to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_map to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_institution_map is '机构层级表';
comment on column ${iol_schema}.ibms_ttrd_institution_map.i_id is '机构id';
comment on column ${iol_schema}.ibms_ttrd_institution_map.parent_id is '上级机构id';
comment on column ${iol_schema}.ibms_ttrd_institution_map.sort is '机构树节点排列顺序';
comment on column ${iol_schema}.ibms_ttrd_institution_map.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_institution_map.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_institution_map.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_institution_map.etl_timestamp is 'ETL处理时间戳';
