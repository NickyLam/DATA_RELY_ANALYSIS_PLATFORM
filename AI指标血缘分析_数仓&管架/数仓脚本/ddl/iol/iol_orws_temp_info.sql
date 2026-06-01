/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_temp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_temp_info
whenever sqlerror continue none;
drop table ${iol_schema}.orws_temp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_temp_info(
    id number(18,0) -- 
    ,name varchar2(225) -- 
    ,employee_no varchar2(75) -- 
    ,sex number(18,0) -- 
    ,folk number(18,0) -- 
    ,native_place varchar2(300) -- 
    ,born_date timestamp -- 
    ,address varchar2(1500) -- 
    ,edu_degree number(18,0) -- 
    ,is_fulltime number(18,0) -- 
    ,employeement_type number(18,0) -- 
    ,clerk_level varchar2(30) -- 
    ,status number(18,0) -- 
    ,mobile varchar2(30) -- 
    ,organ_id number(18,0) -- 
    ,organ_name varchar2(120) -- 
    ,organ_number varchar2(120) -- 
    ,to_organ number(18,0) -- 
    ,to_group number(18,0) -- 
    ,employee_id number(18,0) -- 
    ,become_date timestamp -- 
    ,create_time timestamp -- 
    ,update_time timestamp -- 
    ,create_user_id number(18,0) -- 
    ,update_user_id number(18,0) -- 
    ,email varchar2(75) -- 
    ,office_call varchar2(75) -- 
    ,emp_no varchar2(75) -- 
    ,ismain number(18,0) -- 
    ,belong_emp_no varchar2(75) -- 
    ,external_status number(18,0) -- 
    ,domainid varchar2(30) -- 
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
grant select on ${iol_schema}.orws_temp_info to ${iml_schema};
grant select on ${iol_schema}.orws_temp_info to ${icl_schema};
grant select on ${iol_schema}.orws_temp_info to ${idl_schema};
grant select on ${iol_schema}.orws_temp_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_temp_info is '员工信息表';
comment on column ${iol_schema}.orws_temp_info.id is '';
comment on column ${iol_schema}.orws_temp_info.name is '';
comment on column ${iol_schema}.orws_temp_info.employee_no is '';
comment on column ${iol_schema}.orws_temp_info.sex is '';
comment on column ${iol_schema}.orws_temp_info.folk is '';
comment on column ${iol_schema}.orws_temp_info.native_place is '';
comment on column ${iol_schema}.orws_temp_info.born_date is '';
comment on column ${iol_schema}.orws_temp_info.address is '';
comment on column ${iol_schema}.orws_temp_info.edu_degree is '';
comment on column ${iol_schema}.orws_temp_info.is_fulltime is '';
comment on column ${iol_schema}.orws_temp_info.employeement_type is '';
comment on column ${iol_schema}.orws_temp_info.clerk_level is '';
comment on column ${iol_schema}.orws_temp_info.status is '';
comment on column ${iol_schema}.orws_temp_info.mobile is '';
comment on column ${iol_schema}.orws_temp_info.organ_id is '';
comment on column ${iol_schema}.orws_temp_info.organ_name is '';
comment on column ${iol_schema}.orws_temp_info.organ_number is '';
comment on column ${iol_schema}.orws_temp_info.to_organ is '';
comment on column ${iol_schema}.orws_temp_info.to_group is '';
comment on column ${iol_schema}.orws_temp_info.employee_id is '';
comment on column ${iol_schema}.orws_temp_info.become_date is '';
comment on column ${iol_schema}.orws_temp_info.create_time is '';
comment on column ${iol_schema}.orws_temp_info.update_time is '';
comment on column ${iol_schema}.orws_temp_info.create_user_id is '';
comment on column ${iol_schema}.orws_temp_info.update_user_id is '';
comment on column ${iol_schema}.orws_temp_info.email is '';
comment on column ${iol_schema}.orws_temp_info.office_call is '';
comment on column ${iol_schema}.orws_temp_info.emp_no is '';
comment on column ${iol_schema}.orws_temp_info.ismain is '';
comment on column ${iol_schema}.orws_temp_info.belong_emp_no is '';
comment on column ${iol_schema}.orws_temp_info.external_status is '';
comment on column ${iol_schema}.orws_temp_info.domainid is '';
comment on column ${iol_schema}.orws_temp_info.start_dt is '开始时间';
comment on column ${iol_schema}.orws_temp_info.end_dt is '结束时间';
comment on column ${iol_schema}.orws_temp_info.id_mark is '增删标志';
comment on column ${iol_schema}.orws_temp_info.etl_timestamp is 'ETL处理时间戳';
