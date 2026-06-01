/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_prod_subj_bal_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_prod_subj_bal_h
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_prod_subj_bal_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_prod_subj_bal_h(
    sob_id varchar2(60) -- 账套编号
    ,lp_id varchar2(60) -- 法人编号
    ,subj_id varchar2(500) -- 科目编号
    ,prod_id varchar2(60) -- 产品编号
    ,src_prod_id varchar2(60) -- 源产品编号
    ,super_subj_id varchar2(60) -- 上级科目编号
    ,subj_level_cd varchar2(10) -- 科目等级代码
    ,bal_dir_cd varchar2(60) -- 科目余额方向
    ,oc_curr_cd varchar2(60) -- 原币币种代码
    ,oc_bal number(30,2) -- 原币余额
    ,dc_curr_cd varchar2(60) -- 本币币种代码
    ,dc_bal number(30,2) -- 本币余额
    ,noth_subor_subj_flg varchar2(60) -- 无下级科目标志
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
grant select on ${iml_schema}.fin_am_prod_subj_bal_h to ${icl_schema};
grant select on ${iml_schema}.fin_am_prod_subj_bal_h to ${idl_schema};
grant select on ${iml_schema}.fin_am_prod_subj_bal_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_prod_subj_bal_h is '资管产品科目余额历史';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.sob_id is '账套编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.subj_id is '科目编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.prod_id is '产品编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.src_prod_id is '源产品编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.super_subj_id is '上级科目编号';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.subj_level_cd is '科目等级代码';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.oc_curr_cd is '原币币种代码';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.oc_bal is '原币余额';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.dc_curr_cd is '本币币种代码';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.dc_bal is '本币余额';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.noth_subor_subj_flg is '无下级科目标志';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.start_dt is '开始时间';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.end_dt is '结束时间';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.id_mark is '增删标志';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_prod_subj_bal_h.etl_timestamp is 'ETL处理时间戳';
