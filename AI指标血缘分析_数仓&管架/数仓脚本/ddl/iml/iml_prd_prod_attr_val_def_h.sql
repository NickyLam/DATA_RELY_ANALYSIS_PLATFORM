/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_prod_attr_val_def_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_prod_attr_val_def_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_prod_attr_val_def_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_attr_val_def_h(
    attr_key varchar2(60) -- 属性键值
    ,lp_id varchar2(100) -- 法人编号
    ,attr_val varchar2(500) -- 属性值
    ,attr_val_descb varchar2(500) -- 属性值描述
    ,quote_tab varchar2(250) -- 引用表
    ,quote_col varchar2(250) -- 引用列
    ,quote_cond_descb varchar2(500) -- 引用条件描述
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_prod_attr_val_def_h to ${icl_schema};
grant select on ${iml_schema}.prd_prod_attr_val_def_h to ${idl_schema};
grant select on ${iml_schema}.prd_prod_attr_val_def_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_prod_attr_val_def_h is '产品属性值定义历史';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.attr_key is '属性键值';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.attr_val is '属性值';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.attr_val_descb is '属性值描述';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.quote_tab is '引用表';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.quote_col is '引用列';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.quote_cond_descb is '引用条件描述';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_prod_attr_val_def_h.etl_timestamp is 'ETL处理时间戳';
