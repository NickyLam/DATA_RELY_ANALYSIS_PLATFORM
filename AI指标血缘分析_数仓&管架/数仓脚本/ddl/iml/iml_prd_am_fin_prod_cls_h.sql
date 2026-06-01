/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_am_fin_prod_cls_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_am_fin_prod_cls_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_am_fin_prod_cls_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_fin_prod_cls_h(
    fin_prod_id varchar2(100) -- 金融产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,brch_seq_num varchar2(100) -- 分支序号
    ,bank_int_prod_level2_cls_cd varchar2(30) -- 行内产品二级分类代码
    ,bank_int_prod_level3_cls_cd varchar2(30) -- 行内产品三级分类代码
    ,bank_int_prod_level4_cls_cd varchar2(30) -- 行内产品四级分类代码
    ,bank_int_prod_level5_cls_cd varchar2(30) -- 行内产品五级分类代码
    ,std_prod_id varchar2(60) -- 标准产品编号
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
grant select on ${iml_schema}.prd_am_fin_prod_cls_h to ${icl_schema};
grant select on ${iml_schema}.prd_am_fin_prod_cls_h to ${idl_schema};
grant select on ${iml_schema}.prd_am_fin_prod_cls_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_am_fin_prod_cls_h is '资管金融产品分类历史';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.brch_seq_num is '分支序号';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.bank_int_prod_level2_cls_cd is '行内产品二级分类代码';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.bank_int_prod_level3_cls_cd is '行内产品三级分类代码';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.bank_int_prod_level4_cls_cd is '行内产品四级分类代码';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.bank_int_prod_level5_cls_cd is '行内产品五级分类代码';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_am_fin_prod_cls_h.etl_timestamp is 'ETL处理时间戳';
