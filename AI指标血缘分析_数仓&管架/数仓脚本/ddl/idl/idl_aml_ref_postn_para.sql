/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_postn_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_postn_para
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_postn_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_postn_para(
    post_id varchar2(250) -- 岗位编号
    ,org_id varchar2(60) -- 机构编号
    ,post_name varchar2(150) -- 岗位名称
    ,base_post_flg varchar2(10) -- 基准岗位标志
    ,strip_line_id varchar2(60) -- 条线编号
    ,order_id varchar2(60) -- 序列编号
    ,type_cd varchar2(10) -- 类型代码
    ,status_cd varchar2(10) -- 状态代码
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
grant select on ${idl_schema}.aml_ref_postn_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_postn_para is '职位参数';
comment on column ${idl_schema}.aml_ref_postn_para.post_id is '岗位编号';
comment on column ${idl_schema}.aml_ref_postn_para.org_id is '机构编号';
comment on column ${idl_schema}.aml_ref_postn_para.post_name is '岗位名称';
comment on column ${idl_schema}.aml_ref_postn_para.base_post_flg is '基准岗位标志';
comment on column ${idl_schema}.aml_ref_postn_para.strip_line_id is '条线编号';
comment on column ${idl_schema}.aml_ref_postn_para.order_id is '序列编号';
comment on column ${idl_schema}.aml_ref_postn_para.type_cd is '类型代码';
comment on column ${idl_schema}.aml_ref_postn_para.status_cd is '状态代码';
comment on column ${idl_schema}.aml_ref_postn_para.create_dt is '创建日期';
comment on column ${idl_schema}.aml_ref_postn_para.update_dt is '更新日期';
comment on column ${idl_schema}.aml_ref_postn_para.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ref_postn_para.id_mark is '删除标识';
comment on column ${idl_schema}.aml_ref_postn_para.src_table_name is '源表名称';
comment on column ${idl_schema}.aml_ref_postn_para.job_cd is '任务代码';
comment on column ${idl_schema}.aml_ref_postn_para.etl_timestamp is '数据处理时间';