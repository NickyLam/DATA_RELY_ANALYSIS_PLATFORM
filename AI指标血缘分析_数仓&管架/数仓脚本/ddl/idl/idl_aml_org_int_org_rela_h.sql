/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_org_int_org_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_org_int_org_rela_h
whenever sqlerror continue none;
drop table ${idl_schema}.aml_org_int_org_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_org_int_org_rela_h(
    org_id varchar2(60) -- 机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,src_sys_cd varchar2(10) -- 源系统代码
    ,org_rela_type_cd varchar2(10) -- 机构关系类型代码
    ,seq_num varchar2(60) -- 序号
    ,start_dt date -- 开始日期
    ,rela_org_id varchar2(60) -- 关联机构编号
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
    ,etl_dt date -- ETL处理日期
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_org_int_org_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_org_int_org_rela_h is '机构关系历史';
comment on column ${idl_schema}.aml_org_int_org_rela_h.org_id is '机构编号';
comment on column ${idl_schema}.aml_org_int_org_rela_h.lp_id is '法人编号';
comment on column ${idl_schema}.aml_org_int_org_rela_h.src_sys_cd is '源系统代码';
comment on column ${idl_schema}.aml_org_int_org_rela_h.org_rela_type_cd is '机构关系类型代码';
comment on column ${idl_schema}.aml_org_int_org_rela_h.seq_num is '序号';
comment on column ${idl_schema}.aml_org_int_org_rela_h.start_dt is '开始日期';
comment on column ${idl_schema}.aml_org_int_org_rela_h.rela_org_id is '关联机构编号';
comment on column ${idl_schema}.aml_org_int_org_rela_h.end_dt is '结束日期';
comment on column ${idl_schema}.aml_org_int_org_rela_h.id_mark is '删除标识';
comment on column ${idl_schema}.aml_org_int_org_rela_h.src_table_name is '源表名称';
comment on column ${idl_schema}.aml_org_int_org_rela_h.job_cd is '任务代码';
comment on column ${idl_schema}.aml_org_int_org_rela_h.etl_timestamp is '数据处理时间';
comment on column ${idl_schema}.aml_org_int_org_rela_h.etl_dt is 'ETL处理日期';