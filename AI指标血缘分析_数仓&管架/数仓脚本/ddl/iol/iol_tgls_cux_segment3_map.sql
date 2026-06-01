/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cux_segment3_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cux_segment3_map
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cux_segment3_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cux_segment3_map(
    old_seg3 varchar2(30) -- 旧科目编码
    ,new_seg3 varchar2(30) -- 新科目编码
    ,attribute1 varchar2(150) -- 备用
    ,attribute2 varchar2(150) -- 备用
    ,attribute3 varchar2(150) -- 备用
    ,attribute4 varchar2(150) -- 备用
    ,attribute5 varchar2(150) -- 备用
    ,attribute6 varchar2(150) -- 备用
    ,attribute7 varchar2(150) -- 备用
    ,attribute8 varchar2(150) -- 备用
    ,attribute9 varchar2(150) -- 备用
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
grant select on ${iol_schema}.tgls_cux_segment3_map to ${iml_schema};
grant select on ${iol_schema}.tgls_cux_segment3_map to ${icl_schema};
grant select on ${iol_schema}.tgls_cux_segment3_map to ${idl_schema};
grant select on ${iol_schema}.tgls_cux_segment3_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cux_segment3_map is '科目映射中间表-迁移用';
comment on column ${iol_schema}.tgls_cux_segment3_map.old_seg3 is '旧科目编码';
comment on column ${iol_schema}.tgls_cux_segment3_map.new_seg3 is '新科目编码';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute1 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute2 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute3 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute4 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute5 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute6 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute7 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute8 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.attribute9 is '备用';
comment on column ${iol_schema}.tgls_cux_segment3_map.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_cux_segment3_map.etl_timestamp is 'ETL处理时间戳';
