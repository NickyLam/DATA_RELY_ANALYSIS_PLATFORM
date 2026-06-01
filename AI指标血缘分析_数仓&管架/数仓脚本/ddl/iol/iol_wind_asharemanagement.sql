/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharemanagement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharemanagement
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharemanagement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharemanagement(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,ann_date varchar2(12) -- 公告日期
    ,s_info_manager_name varchar2(300) -- 姓名
    ,s_info_manager_gender varchar2(15) -- 性别
    ,s_info_manager_education varchar2(30) -- 学历
    ,s_info_manager_nationality varchar2(60) -- 国籍
    ,s_info_manager_birthyear varchar2(12) -- 出生年份
    ,s_info_manager_startdate varchar2(12) -- 任职日期
    ,s_info_manager_leavedate varchar2(12) -- 离职日期
    ,s_info_manager_type number(5,0) -- 管理层类别
    ,s_info_manager_post varchar2(150) -- 职务
    ,s_info_manager_introduction varchar2(4000) -- 个人简历
    ,opdate date -- 
    ,opmode varchar2(2) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_asharemanagement to ${iml_schema};
grant select on ${iol_schema}.wind_asharemanagement to ${icl_schema};
grant select on ${iol_schema}.wind_asharemanagement to ${idl_schema};
grant select on ${iol_schema}.wind_asharemanagement to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharemanagement is '中国a股公司管理层成员';
comment on column ${iol_schema}.wind_asharemanagement.object_id is '对象ID';
comment on column ${iol_schema}.wind_asharemanagement.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_asharemanagement.ann_date is '公告日期';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_name is '姓名';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_gender is '性别';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_education is '学历';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_nationality is '国籍';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_birthyear is '出生年份';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_startdate is '任职日期';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_leavedate is '离职日期';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_type is '管理层类别';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_post is '职务';
comment on column ${iol_schema}.wind_asharemanagement.s_info_manager_introduction is '个人简历';
comment on column ${iol_schema}.wind_asharemanagement.opdate is '';
comment on column ${iol_schema}.wind_asharemanagement.opmode is '';
comment on column ${iol_schema}.wind_asharemanagement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharemanagement.etl_timestamp is 'ETL处理时间戳';
