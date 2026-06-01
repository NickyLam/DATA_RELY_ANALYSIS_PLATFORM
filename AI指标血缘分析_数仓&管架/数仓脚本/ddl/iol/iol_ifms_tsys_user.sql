/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tsys_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tsys_user
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tsys_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_user(
    user_id varchar2(48) -- 
    ,branch_code varchar2(24) -- 
    ,dep_code varchar2(24) -- 
    ,user_name varchar2(255) -- 
    ,user_pwd varchar2(128) -- 
    ,user_type varchar2(12) -- 
    ,user_status varchar2(12) -- 
    ,lock_status varchar2(12) -- 
    ,create_date number(22) -- 
    ,modify_date number(22) -- 
    ,pass_modify_date number(22) -- 
    ,remark varchar2(1000) -- 
    ,ext_field_1 varchar2(384) -- 
    ,ext_field_2 varchar2(384) -- 
    ,ext_field_3 varchar2(384) -- 
    ,ext_field_4 varchar2(384) -- 
    ,ext_field_5 varchar2(384) -- 
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
grant select on ${iol_schema}.ifms_tsys_user to ${iml_schema};
grant select on ${iol_schema}.ifms_tsys_user to ${icl_schema};
grant select on ${iol_schema}.ifms_tsys_user to ${idl_schema};
grant select on ${iol_schema}.ifms_tsys_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tsys_user is '系统用户表';
comment on column ${iol_schema}.ifms_tsys_user.user_id is '';
comment on column ${iol_schema}.ifms_tsys_user.branch_code is '';
comment on column ${iol_schema}.ifms_tsys_user.dep_code is '';
comment on column ${iol_schema}.ifms_tsys_user.user_name is '';
comment on column ${iol_schema}.ifms_tsys_user.user_pwd is '';
comment on column ${iol_schema}.ifms_tsys_user.user_type is '';
comment on column ${iol_schema}.ifms_tsys_user.user_status is '';
comment on column ${iol_schema}.ifms_tsys_user.lock_status is '';
comment on column ${iol_schema}.ifms_tsys_user.create_date is '';
comment on column ${iol_schema}.ifms_tsys_user.modify_date is '';
comment on column ${iol_schema}.ifms_tsys_user.pass_modify_date is '';
comment on column ${iol_schema}.ifms_tsys_user.remark is '';
comment on column ${iol_schema}.ifms_tsys_user.ext_field_1 is '';
comment on column ${iol_schema}.ifms_tsys_user.ext_field_2 is '';
comment on column ${iol_schema}.ifms_tsys_user.ext_field_3 is '';
comment on column ${iol_schema}.ifms_tsys_user.ext_field_4 is '';
comment on column ${iol_schema}.ifms_tsys_user.ext_field_5 is '';
comment on column ${iol_schema}.ifms_tsys_user.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tsys_user.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tsys_user.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tsys_user.etl_timestamp is 'ETL处理时间戳';
