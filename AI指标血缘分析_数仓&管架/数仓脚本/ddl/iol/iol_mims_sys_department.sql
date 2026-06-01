/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_sys_department
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_sys_department
whenever sqlerror continue none;
drop table ${iol_schema}.mims_sys_department purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_sys_department(
    deptcode varchar2(30) -- 
    ,superdeptcode varchar2(30) -- 
    ,deptname varchar2(150) -- 
    ,deptdesc varchar2(300) -- 
    ,flag number(22) -- 
    ,level_code number(22) -- 
    ,branchcode varchar2(30) -- 
    ,depttype varchar2(8) -- 
    ,deptseq varchar2(150) -- 
    ,busiaddress varchar2(90) -- 
    ,postcode varchar2(15) -- 
    ,createdate varchar2(15) -- 
    ,areacode varchar2(9) -- 
    ,bline varchar2(30) -- 
    ,supercode varchar2(30) -- 
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
grant select on ${iol_schema}.mims_sys_department to ${iml_schema};
grant select on ${iol_schema}.mims_sys_department to ${icl_schema};
grant select on ${iol_schema}.mims_sys_department to ${idl_schema};
grant select on ${iol_schema}.mims_sys_department to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_sys_department is '';
comment on column ${iol_schema}.mims_sys_department.deptcode is '';
comment on column ${iol_schema}.mims_sys_department.superdeptcode is '';
comment on column ${iol_schema}.mims_sys_department.deptname is '';
comment on column ${iol_schema}.mims_sys_department.deptdesc is '';
comment on column ${iol_schema}.mims_sys_department.flag is '';
comment on column ${iol_schema}.mims_sys_department.level_code is '';
comment on column ${iol_schema}.mims_sys_department.branchcode is '';
comment on column ${iol_schema}.mims_sys_department.depttype is '';
comment on column ${iol_schema}.mims_sys_department.deptseq is '';
comment on column ${iol_schema}.mims_sys_department.busiaddress is '';
comment on column ${iol_schema}.mims_sys_department.postcode is '';
comment on column ${iol_schema}.mims_sys_department.createdate is '';
comment on column ${iol_schema}.mims_sys_department.areacode is '';
comment on column ${iol_schema}.mims_sys_department.bline is '';
comment on column ${iol_schema}.mims_sys_department.supercode is '';
comment on column ${iol_schema}.mims_sys_department.start_dt is '开始时间';
comment on column ${iol_schema}.mims_sys_department.end_dt is '结束时间';
comment on column ${iol_schema}.mims_sys_department.id_mark is '增删标志';
comment on column ${iol_schema}.mims_sys_department.etl_timestamp is 'ETL处理时间戳';
