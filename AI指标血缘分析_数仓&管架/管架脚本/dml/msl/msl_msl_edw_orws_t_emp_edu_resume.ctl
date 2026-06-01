-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/orws_t_emp_edu_resume.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_emp_edu_resume
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,id char(4000) nullif id=blanks 
    ,emp_info char(4000) nullif emp_info=blanks 
    ,begin_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif begin_date=blanks 
    ,end_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif end_date=blanks 
    ,university char(4000) nullif university=blanks 
    ,profession char(4000) nullif profession=blanks 
    ,academic char(4000) nullif academic=blanks 
    ,degree char(4000) nullif degree=blanks 
    ,is_fulltime char(4000) nullif is_fulltime=blanks 
    ,creator char(4000) nullif creator=blanks 
    ,editor char(4000) nullif editor=blanks 
    ,create_time timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif create_time=blanks 
    ,edit_time timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif edit_time=blanks 
    ,is_economics char(4000) nullif is_economics=blanks 
)