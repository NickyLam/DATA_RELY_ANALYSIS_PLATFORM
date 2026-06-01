/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_asharemanagementholdreward
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_asharemanagementholdreward
whenever sqlerror continue none;
drop table ${iol_schema}.wind_asharemanagementholdreward purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_asharemanagementholdreward(
    object_id varchar2(150) -- 
    ,s_info_windcode varchar2(60) -- 
    ,ann_date varchar2(12) -- 
    ,end_date varchar2(12) -- 
    ,crny_code varchar2(15) -- 
    ,s_info_manager_name varchar2(120) -- 
    ,s_info_manager_post varchar2(450) -- 
    ,s_manager_return number(20,4) -- 
    ,s_manager_quantity number(20,4) -- 
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
grant select on ${iol_schema}.wind_asharemanagementholdreward to ${iml_schema};
grant select on ${iol_schema}.wind_asharemanagementholdreward to ${icl_schema};
grant select on ${iol_schema}.wind_asharemanagementholdreward to ${idl_schema};
grant select on ${iol_schema}.wind_asharemanagementholdreward to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_asharemanagementholdreward is '中国a股公司管理层持股及报酬';
comment on column ${iol_schema}.wind_asharemanagementholdreward.object_id is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.s_info_windcode is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.ann_date is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.end_date is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.crny_code is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.s_info_manager_name is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.s_info_manager_post is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.s_manager_return is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.s_manager_quantity is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.opdate is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.opmode is '';
comment on column ${iol_schema}.wind_asharemanagementholdreward.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_asharemanagementholdreward.etl_timestamp is 'ETL处理时间戳';
