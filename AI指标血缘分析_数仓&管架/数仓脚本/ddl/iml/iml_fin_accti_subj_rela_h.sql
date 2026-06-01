/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_accti_subj_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_accti_subj_rela_h
whenever sqlerror continue none;
drop table ${iml_schema}.fin_accti_subj_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_accti_subj_rela_h(
    sob_id varchar2(100) -- 账套编号
    ,lp_id varchar2(100) -- 法人编号
    ,accti_id varchar2(100) -- 核算编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,subj_id varchar2(100) -- 科目编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,effect_dt date -- 科目生效日期
    ,invalid_dt date -- 科目失效日期
    ,subj_name varchar2(500) -- 科目名称
    ,status_cd varchar2(30) -- 状态代码
    ,subj_descb varchar2(500) -- 科目描述
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
grant select on ${iml_schema}.fin_accti_subj_rela_h to ${icl_schema};
grant select on ${iml_schema}.fin_accti_subj_rela_h to ${idl_schema};
grant select on ${iml_schema}.fin_accti_subj_rela_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_accti_subj_rela_h is '核算科目关系历史';
comment on column ${iml_schema}.fin_accti_subj_rela_h.sob_id is '账套编号';
comment on column ${iml_schema}.fin_accti_subj_rela_h.lp_id is '法人编号';
comment on column ${iml_schema}.fin_accti_subj_rela_h.accti_id is '核算编号';
comment on column ${iml_schema}.fin_accti_subj_rela_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.fin_accti_subj_rela_h.subj_id is '科目编号';
comment on column ${iml_schema}.fin_accti_subj_rela_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.fin_accti_subj_rela_h.effect_dt is '科目生效日期';
comment on column ${iml_schema}.fin_accti_subj_rela_h.invalid_dt is '科目失效日期';
comment on column ${iml_schema}.fin_accti_subj_rela_h.subj_name is '科目名称';
comment on column ${iml_schema}.fin_accti_subj_rela_h.status_cd is '状态代码';
comment on column ${iml_schema}.fin_accti_subj_rela_h.subj_descb is '科目描述';
comment on column ${iml_schema}.fin_accti_subj_rela_h.start_dt is '开始时间';
comment on column ${iml_schema}.fin_accti_subj_rela_h.end_dt is '结束时间';
comment on column ${iml_schema}.fin_accti_subj_rela_h.id_mark is '增删标志';
comment on column ${iml_schema}.fin_accti_subj_rela_h.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_accti_subj_rela_h.job_cd is '任务编码';
comment on column ${iml_schema}.fin_accti_subj_rela_h.etl_timestamp is 'ETL处理时间戳';
