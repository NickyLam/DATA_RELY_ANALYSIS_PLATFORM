/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_emp_edu_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_emp_edu_resume
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_emp_edu_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_emp_edu_resume(
    id number(18) -- 
    ,emp_info number(18) -- 
    ,begin_date timestamp -- 
    ,end_date timestamp -- 
    ,university varchar2(300) -- 
    ,profession varchar2(150) -- 
    ,academic number(18) -- 
    ,degree number(18) -- 
    ,is_fulltime number(2) -- 
    ,creator number(18) -- 
    ,editor number(18) -- 
    ,create_time timestamp -- 
    ,edit_time timestamp -- 
    ,is_economics number(2) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.orws_t_emp_edu_resume to ${iml_schema};
grant select on ${iol_schema}.orws_t_emp_edu_resume to ${icl_schema};
grant select on ${iol_schema}.orws_t_emp_edu_resume to ${idl_schema};
grant select on ${iol_schema}.orws_t_emp_edu_resume to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_emp_edu_resume is '员工教育简历表';
comment on column ${iol_schema}.orws_t_emp_edu_resume.id is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.emp_info is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.begin_date is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.end_date is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.university is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.profession is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.academic is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.degree is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.is_fulltime is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.creator is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.editor is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.create_time is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.edit_time is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.is_economics is '';
comment on column ${iol_schema}.orws_t_emp_edu_resume.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_emp_edu_resume.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_emp_edu_resume.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_emp_edu_resume.etl_timestamp is 'ETL处理时间戳';
