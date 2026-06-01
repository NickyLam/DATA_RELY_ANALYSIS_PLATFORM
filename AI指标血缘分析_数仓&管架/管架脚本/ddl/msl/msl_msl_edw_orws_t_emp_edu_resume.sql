/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_orws_t_emp_edu_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_emp_edu_resume
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_emp_edu_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_emp_edu_resume(
    etl_dt date
    ,id number(18)
    ,emp_info number(18)
    ,begin_date timestamp(6)
    ,end_date timestamp(6)
    ,university varchar2(200)
    ,profession varchar2(100)
    ,academic number(18)
    ,degree number(18)
    ,is_fulltime number(2)
    ,creator number(18)
    ,editor number(18)
    ,create_time timestamp(6)
    ,edit_time timestamp(6)
    ,is_economics number(2)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_emp_edu_resume to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_emp_edu_resume is '员工教育简历表';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.id is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.emp_info is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.begin_date is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.end_date is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.university is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.profession is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.academic is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.degree is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.is_fulltime is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.creator is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.editor is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.create_time is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.edit_time is '';
comment on column ${msl_schema}.msl_edw_orws_t_emp_edu_resume.is_economics is '';
