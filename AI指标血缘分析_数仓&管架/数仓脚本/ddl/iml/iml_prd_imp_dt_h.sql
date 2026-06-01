/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_imp_dt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_imp_dt_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_imp_dt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_imp_dt_h(
    prd_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,dt_type_cd varchar2(10) -- 日期类型代码
    ,imp_dt date -- 重要日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_imp_dt_h to ${icl_schema};
grant select on ${iml_schema}.prd_imp_dt_h to ${idl_schema};
grant select on ${iml_schema}.prd_imp_dt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_imp_dt_h is '产品重要日期历史';
comment on column ${iml_schema}.prd_imp_dt_h.prd_id is '产品编号';
comment on column ${iml_schema}.prd_imp_dt_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_imp_dt_h.dt_type_cd is '日期类型代码';
comment on column ${iml_schema}.prd_imp_dt_h.imp_dt is '重要日期';
comment on column ${iml_schema}.prd_imp_dt_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_imp_dt_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_imp_dt_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_imp_dt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_imp_dt_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_imp_dt_h.etl_timestamp is 'ETL处理时间戳';
