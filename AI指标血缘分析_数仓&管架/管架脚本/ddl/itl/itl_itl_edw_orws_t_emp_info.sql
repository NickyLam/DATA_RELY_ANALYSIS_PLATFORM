/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_t_emp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_t_emp_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_t_emp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_t_emp_info(
    id number(18) -- 
    ,employeeinfo number(18) -- 
    ,name varchar2(150) -- 
    ,sex number(18) -- 
    ,born_date timestamp(6) -- 
    ,marriage varchar2(10) -- 
    ,office_call varchar2(50) -- 
    ,mobile varchar2(20) -- 
    ,isservice number(2) -- 
    ,to_organ number(18) -- 
    ,emp_no varchar2(50) -- 
    ,teller_no varchar2(50) -- 
    ,job_date timestamp(6) -- 
    ,become_date timestamp(6) -- 
    ,emptype number(18) -- 
    ,status number(18) -- 
    ,dimission_date timestamp(6) -- 
    ,position number(18) -- 
    ,teller_level number(18) -- 
    ,position_type number(18) -- 
    ,service_date timestamp(6) -- 
    ,workroom varchar2(100) -- 
    ,speciality varchar2(1500) -- 
    ,create_time timestamp(6) -- 
    ,update_time timestamp(6) -- 
    ,create_emp number(18) -- 
    ,update_emp number(18) -- 
    ,address varchar2(1200) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_orws_t_emp_info to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_t_emp_info is '职业生涯个人信息表';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.id is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.employeeinfo is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.name is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.sex is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.born_date is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.marriage is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.office_call is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.mobile is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.isservice is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.to_organ is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.emp_no is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.teller_no is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.job_date is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.become_date is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.emptype is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.status is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.dimission_date is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.position is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.teller_level is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.position_type is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.service_date is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.workroom is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.speciality is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.create_time is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.update_time is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.create_emp is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.update_emp is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.address is '';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_orws_t_emp_info.etl_timestamp is 'ETL处理时间戳';