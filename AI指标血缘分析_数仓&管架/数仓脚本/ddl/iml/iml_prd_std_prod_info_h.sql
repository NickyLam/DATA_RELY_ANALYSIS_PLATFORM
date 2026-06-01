/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_std_prod_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_std_prod_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_std_prod_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_std_prod_info_h(
    lp_id varchar2(100) -- 法人编号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,prod_cls_id varchar2(100) -- 产品分类编号
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,prod_group_flg varchar2(10) -- 产品组标志
    ,prod_range_cd varchar2(30) -- 产品作用范围代码
    ,provi_merge_flg varchar2(10) -- 计提合并标志
    ,prod_status_cd varchar2(30) -- 产品状态代码
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
grant select on ${iml_schema}.prd_std_prod_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_std_prod_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_std_prod_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_std_prod_info_h is '标准产品信息历史';
comment on column ${iml_schema}.prd_std_prod_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_name is '产品名称';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_cls_id is '产品分类编号';
comment on column ${iml_schema}.prd_std_prod_info_h.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_group_flg is '产品组标志';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_range_cd is '产品作用范围代码';
comment on column ${iml_schema}.prd_std_prod_info_h.provi_merge_flg is '计提合并标志';
comment on column ${iml_schema}.prd_std_prod_info_h.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_std_prod_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_std_prod_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_std_prod_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_std_prod_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_std_prod_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_std_prod_info_h.etl_timestamp is 'ETL处理时间戳';
