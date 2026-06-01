/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml fin_am_subj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.fin_am_subj_info
whenever sqlerror continue none;
drop table ${iml_schema}.fin_am_subj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_am_subj_info(
    tepla_sob_id varchar2(60) -- 模板账套编号
    ,lp_id varchar2(60) -- 法人编号
    ,subj_id varchar2(60) -- 科目编号
    ,subj_name varchar2(250) -- 科目名称
    ,super_subj_id varchar2(60) -- 上级科目编号
    ,bal_dir_cd varchar2(60) -- 科目余额方向
    ,subj_level_cd varchar2(10) -- 科目等级代码
    ,accti_qtty_flg varchar2(60) -- 核算数量标志
    ,int_accr_flg varchar2(60) -- 计息标志
    ,allow_od_flg varchar2(60) -- 允许透支标志
    ,create_level4_subj_flg varchar2(60) -- 生成四级科目标志
    ,subj_acct_type_cd varchar2(10) -- 科目账户类型代码
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.fin_am_subj_info to ${icl_schema};
grant select on ${iml_schema}.fin_am_subj_info to ${idl_schema};
grant select on ${iml_schema}.fin_am_subj_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.fin_am_subj_info is '资管科目信息';
comment on column ${iml_schema}.fin_am_subj_info.tepla_sob_id is '模板账套编号';
comment on column ${iml_schema}.fin_am_subj_info.lp_id is '法人编号';
comment on column ${iml_schema}.fin_am_subj_info.subj_id is '科目编号';
comment on column ${iml_schema}.fin_am_subj_info.subj_name is '科目名称';
comment on column ${iml_schema}.fin_am_subj_info.super_subj_id is '上级科目编号';
comment on column ${iml_schema}.fin_am_subj_info.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.fin_am_subj_info.subj_level_cd is '科目等级代码';
comment on column ${iml_schema}.fin_am_subj_info.accti_qtty_flg is '核算数量标志';
comment on column ${iml_schema}.fin_am_subj_info.int_accr_flg is '计息标志';
comment on column ${iml_schema}.fin_am_subj_info.allow_od_flg is '允许透支标志';
comment on column ${iml_schema}.fin_am_subj_info.create_level4_subj_flg is '生成四级科目标志';
comment on column ${iml_schema}.fin_am_subj_info.subj_acct_type_cd is '科目账户类型代码';
comment on column ${iml_schema}.fin_am_subj_info.entry_org_id is '记账机构编号';
comment on column ${iml_schema}.fin_am_subj_info.create_dt is '创建日期';
comment on column ${iml_schema}.fin_am_subj_info.update_dt is '更新日期';
comment on column ${iml_schema}.fin_am_subj_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.fin_am_subj_info.id_mark is '增删标志';
comment on column ${iml_schema}.fin_am_subj_info.src_table_name is '源表名称';
comment on column ${iml_schema}.fin_am_subj_info.job_cd is '任务编码';
comment on column ${iml_schema}.fin_am_subj_info.etl_timestamp is 'ETL处理时间戳';
