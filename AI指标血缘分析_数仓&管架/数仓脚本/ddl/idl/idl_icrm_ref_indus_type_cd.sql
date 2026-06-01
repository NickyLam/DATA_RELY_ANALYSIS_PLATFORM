/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_indus_type_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_indus_type_cd
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_indus_type_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_indus_type_cd(
    etl_dt date -- 数据日期
    ,indus_type_cd varchar2(10) -- 行业类型代码
    ,indus_type_name varchar2(100) -- 行业类型名称
    ,indus_cate_cd varchar2(10) -- 行业类别代码
    ,indus_cate_name varchar2(100) -- 行业类别名称
    ,indus_gen_cd varchar2(10) -- 行业大类代码
    ,indus_gen_name varchar2(100) -- 行业大类名称
    ,indus_categy_cd varchar2(10) -- 行业门类代码
    ,indus_categy_name varchar2(100) -- 行业门类名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_indus_type_cd to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_indus_type_cd is '行业类型代码表';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_type_cd is '行业类型代码';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_type_name is '行业类型名称';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_cate_cd is '行业类别代码';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_cate_name is '行业类别名称';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_gen_cd is '行业大类代码';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_gen_name is '行业大类名称';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_categy_cd is '行业门类代码';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.indus_categy_name is '行业门类名称';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_indus_type_cd.etl_timestamp is '数据处理时间';
