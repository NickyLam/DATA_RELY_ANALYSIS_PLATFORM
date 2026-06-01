/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_emply_post_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_emply_post_para
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_emply_post_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_emply_post_para(
    etl_dt date -- 数据日期
    ,post_id varchar2(60) -- 职务编号
    ,lp_id varchar2(60) -- 法人编号
    ,post_name varchar2(100) -- 职务名称
    ,post_cate_id varchar2(60) -- 职务类别编号
    ,start_use_status_flg varchar2(10) -- 启用状态标志
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
grant select on ${idl_schema}.aml_ref_emply_post_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_emply_post_para is '员工职务参数';
comment on column ${idl_schema}.aml_ref_emply_post_para.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ref_emply_post_para.post_id is '职务编号';
comment on column ${idl_schema}.aml_ref_emply_post_para.lp_id is '法人编号';
comment on column ${idl_schema}.aml_ref_emply_post_para.post_name is '职务名称';
comment on column ${idl_schema}.aml_ref_emply_post_para.post_cate_id is '职务类别编号';
comment on column ${idl_schema}.aml_ref_emply_post_para.start_use_status_flg is '启用状态标志';
comment on column ${idl_schema}.aml_ref_emply_post_para.job_cd is '任务代码';
comment on column ${idl_schema}.aml_ref_emply_post_para.etl_timestamp is '数据处理时间';
