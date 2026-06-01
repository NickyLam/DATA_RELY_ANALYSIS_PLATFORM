/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_curr_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_curr_para
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_curr_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_curr_para(
    curr_cd varchar2(10) -- 币种代码
    ,curr_name varchar2(60) -- 币种名称
    ,curr_en_abbr varchar2(60) -- 币种英文简称
    ,curr_sign_cd varchar2(10) -- 币种符号代码
    ,start_use_flg varchar2(10) -- 启用标志
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- 数据日期
    ,id_mark varchar2(10) -- 删除标识
    ,src_table_name varchar2(100) -- 源表名称
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
grant select on ${idl_schema}.aml_ref_curr_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_curr_para is '币种参数表';
comment on column ${idl_schema}.aml_ref_curr_para.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_ref_curr_para.curr_name is '币种名称';
comment on column ${idl_schema}.aml_ref_curr_para.curr_en_abbr is '币种英文简称';
comment on column ${idl_schema}.aml_ref_curr_para.curr_sign_cd is '币种符号代码';
comment on column ${idl_schema}.aml_ref_curr_para.start_use_flg is '启用标志';
comment on column ${idl_schema}.aml_ref_curr_para.create_dt is '创建日期';
comment on column ${idl_schema}.aml_ref_curr_para.update_dt is '更新日期';
comment on column ${idl_schema}.aml_ref_curr_para.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ref_curr_para.id_mark is '删除标识';
comment on column ${idl_schema}.aml_ref_curr_para.src_table_name is '源表名称';
comment on column ${idl_schema}.aml_ref_curr_para.job_cd is '任务代码';
comment on column ${idl_schema}.aml_ref_curr_para.etl_timestamp is '数据处理时间';