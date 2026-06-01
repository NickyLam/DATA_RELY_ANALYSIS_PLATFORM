/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_fcurr_subj_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_fcurr_subj_map
whenever sqlerror continue none;
drop table ${iml_schema}.ref_fcurr_subj_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_fcurr_subj_map(
    dept_id varchar2(60) -- 部门编号
    ,subj_id varchar2(60) -- 科目编号
    ,subj_name varchar2(375) -- 科目名称
    ,core_bus_id varchar2(60) -- 核心业务编号
    ,curr_cd varchar2(10) -- 币种代码
    ,bic_code varchar2(375) -- BIC码
    ,bal_dir_cd varchar2(15) -- 科目余额方向
    ,check_entry_flg varchar2(10) -- 对账标志
    ,core_org_id varchar2(60) -- 核心机构编号
    ,entry_way_name varchar2(150) -- 记账方式名称
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
grant select on ${iml_schema}.ref_fcurr_subj_map to ${icl_schema};
grant select on ${iml_schema}.ref_fcurr_subj_map to ${idl_schema};
grant select on ${iml_schema}.ref_fcurr_subj_map to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_fcurr_subj_map is '外币科目映射';
comment on column ${iml_schema}.ref_fcurr_subj_map.dept_id is '部门编号';
comment on column ${iml_schema}.ref_fcurr_subj_map.subj_id is '科目编号';
comment on column ${iml_schema}.ref_fcurr_subj_map.subj_name is '科目名称';
comment on column ${iml_schema}.ref_fcurr_subj_map.core_bus_id is '核心业务编号';
comment on column ${iml_schema}.ref_fcurr_subj_map.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_fcurr_subj_map.bic_code is 'BIC码';
comment on column ${iml_schema}.ref_fcurr_subj_map.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.ref_fcurr_subj_map.check_entry_flg is '对账标志';
comment on column ${iml_schema}.ref_fcurr_subj_map.core_org_id is '核心机构编号';
comment on column ${iml_schema}.ref_fcurr_subj_map.entry_way_name is '记账方式名称';
comment on column ${iml_schema}.ref_fcurr_subj_map.start_dt is '开始时间';
comment on column ${iml_schema}.ref_fcurr_subj_map.end_dt is '结束时间';
comment on column ${iml_schema}.ref_fcurr_subj_map.id_mark is '增删标志';
comment on column ${iml_schema}.ref_fcurr_subj_map.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_fcurr_subj_map.job_cd is '任务编码';
comment on column ${iml_schema}.ref_fcurr_subj_map.etl_timestamp is 'ETL处理时间戳';
