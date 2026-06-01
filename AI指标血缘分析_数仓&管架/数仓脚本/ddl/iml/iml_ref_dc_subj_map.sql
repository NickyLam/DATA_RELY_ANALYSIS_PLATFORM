/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_dc_subj_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_dc_subj_map
whenever sqlerror continue none;
drop table ${iml_schema}.ref_dc_subj_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_dc_subj_map(
    dept_id varchar2(60) -- 部门编号
    ,subj_id varchar2(60) -- 科目编号
    ,core_bus_id varchar2(60) -- 核心业务编号
    ,bal_dir_cd varchar2(15) -- 科目余额方向
    ,bal_check_entry_flg varchar2(10) -- 余额对账标志
    ,check_entry_flg varchar2(10) -- 对账标志
    ,curr_cd varchar2(10) -- 币种代码
    ,org_id varchar2(60) -- 机构编号
    ,entry_way_name varchar2(150) -- 记账方式名称
    ,bus_dept_id varchar2(100) -- 业务部门编号
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
grant select on ${iml_schema}.ref_dc_subj_map to ${icl_schema};
grant select on ${iml_schema}.ref_dc_subj_map to ${idl_schema};
grant select on ${iml_schema}.ref_dc_subj_map to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_dc_subj_map is '本币科目映射';
comment on column ${iml_schema}.ref_dc_subj_map.dept_id is '部门编号';
comment on column ${iml_schema}.ref_dc_subj_map.subj_id is '科目编号';
comment on column ${iml_schema}.ref_dc_subj_map.core_bus_id is '核心业务编号';
comment on column ${iml_schema}.ref_dc_subj_map.bal_dir_cd is '科目余额方向';
comment on column ${iml_schema}.ref_dc_subj_map.bal_check_entry_flg is '余额对账标志';
comment on column ${iml_schema}.ref_dc_subj_map.check_entry_flg is '对账标志';
comment on column ${iml_schema}.ref_dc_subj_map.curr_cd is '币种代码';
comment on column ${iml_schema}.ref_dc_subj_map.org_id is '机构编号';
comment on column ${iml_schema}.ref_dc_subj_map.entry_way_name is '记账方式名称';
comment on column ${iml_schema}.ref_dc_subj_map.bus_dept_id is '业务部门编号';
comment on column ${iml_schema}.ref_dc_subj_map.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ref_dc_subj_map.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_dc_subj_map.job_cd is '任务编码';
comment on column ${iml_schema}.ref_dc_subj_map.etl_timestamp is 'ETL处理时间戳';
