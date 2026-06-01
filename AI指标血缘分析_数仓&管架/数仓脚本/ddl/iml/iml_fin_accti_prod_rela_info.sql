/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_accti_prod_rela_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_accti_prod_rela_info
whenever sqlerror continue none;
drop table ${iml_schema}.fin_accti_prod_rela_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_accti_prod_rela_info(
    intnal_prod_id varchar2(100) -- 内部产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,accti_id varchar2(100) -- 核算编号
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,sob_id varchar2(100) -- 账套编号
    ,prod_attr_cd varchar2(30) -- 产品属性代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.fin_accti_prod_rela_info to ${icl_schema};
grant select on ${iml_schema}.fin_accti_prod_rela_info to ${idl_schema};
grant select on ${iml_schema}.fin_accti_prod_rela_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_accti_prod_rela_info is '核算产品关系信息';
comment on column ${iml_schema}.fin_accti_prod_rela_info.intnal_prod_id is '内部产品编号';
comment on column ${iml_schema}.fin_accti_prod_rela_info.lp_id is '法人编号';
comment on column ${iml_schema}.fin_accti_prod_rela_info.accti_id is '核算编号';
comment on column ${iml_schema}.fin_accti_prod_rela_info.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.fin_accti_prod_rela_info.sob_id is '账套编号';
comment on column ${iml_schema}.fin_accti_prod_rela_info.prod_attr_cd is '产品属性代码';
comment on column ${iml_schema}.fin_accti_prod_rela_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_accti_prod_rela_info.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_accti_prod_rela_info.job_cd is '任务编码';
comment on column ${iml_schema}.fin_accti_prod_rela_info.etl_timestamp is 'ETL处理时间戳';
