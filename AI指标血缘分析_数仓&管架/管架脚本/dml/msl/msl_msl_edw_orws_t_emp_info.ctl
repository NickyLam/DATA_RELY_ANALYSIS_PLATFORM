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
infile '${data_path}/orws_t_emp_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_orws_t_emp_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,id char(4000) nullif id=blanks 
    ,employeeinfo char(4000) nullif employeeinfo=blanks 
    ,name char(4000) nullif name=blanks 
    ,sex char(4000) nullif sex=blanks 
    ,born_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif born_date=blanks 
    ,marriage char(4000) nullif marriage=blanks 
    ,office_call char(4000) nullif office_call=blanks 
    ,mobile char(4000) nullif mobile=blanks 
    ,isservice char(4000) nullif isservice=blanks 
    ,to_organ char(4000) nullif to_organ=blanks 
    ,emp_no char(4000) nullif emp_no=blanks 
    ,teller_no char(4000) nullif teller_no=blanks 
    ,job_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif job_date=blanks 
    ,become_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif become_date=blanks 
    ,emptype char(4000) nullif emptype=blanks 
    ,status char(4000) nullif status=blanks 
    ,dimission_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif dimission_date=blanks 
    ,"POSITION" char(4000) nullif "POSITION"=blanks 
    ,teller_level char(4000) nullif teller_level=blanks 
    ,position_type char(4000) nullif position_type=blanks 
    ,service_date timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif service_date=blanks 
    ,workroom char(4000) nullif workroom=blanks 
    ,speciality char(4000) nullif speciality=blanks 
    ,create_time timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif create_time=blanks 
    ,update_time timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif update_time=blanks 
    ,create_emp char(4000) nullif create_emp=blanks 
    ,update_emp char(4000) nullif update_emp=blanks 
    ,address char(4000) nullif address=blanks 
)