/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_indus_type_cd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_indus_type_cd
whenever sqlerror continue none;
drop table ${iml_schema}.ref_indus_type_cd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_indus_type_cd(
    indus_type_cd varchar2(10) -- 行业类型代码
    ,indus_type_name varchar2(100) -- 行业类型名称
    ,indus_cate_cd varchar2(10) -- 行业类别代码
    ,indus_cate_name varchar2(100) -- 行业类别名称
    ,indus_gen_cd varchar2(10) -- 行业大类代码
    ,indus_gen_name varchar2(100) -- 行业大类名称
    ,indus_categy_cd varchar2(10) -- 行业门类代码
    ,indus_categy_name varchar2(100) -- 行业门类名称
	,valid_flg varchar2(10) --有效标志
	,invalid_dt date --失效日期
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
;

-- grant
grant select on ${iml_schema}.ref_indus_type_cd to ${icl_schema};
grant select on ${iml_schema}.ref_indus_type_cd to ${idl_schema};
grant select on ${iml_schema}.ref_indus_type_cd to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_indus_type_cd is '行业类型代码表';
comment on column ${iml_schema}.ref_indus_type_cd.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.ref_indus_type_cd.indus_type_name is '行业类型名称';
comment on column ${iml_schema}.ref_indus_type_cd.indus_cate_cd is '行业类别代码';
comment on column ${iml_schema}.ref_indus_type_cd.indus_cate_name is '行业类别名称';
comment on column ${iml_schema}.ref_indus_type_cd.indus_gen_cd is '行业大类代码';
comment on column ${iml_schema}.ref_indus_type_cd.indus_gen_name is '行业大类名称';
comment on column ${iml_schema}.ref_indus_type_cd.indus_categy_cd is '行业门类代码';
comment on column ${iml_schema}.ref_indus_type_cd.indus_categy_name is '行业门类名称';
comment on column ${iml_schema}.ref_indus_type_cd.valid_flg is '有效标志';
comment on column ${iml_schema}.ref_indus_type_cd.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_indus_type_cd.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_indus_type_cd.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_indus_type_cd.job_cd is '任务编码';
comment on column ${iml_schema}.ref_indus_type_cd.etl_timestamp is 'ETL处理时间戳';
