/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_sys_user
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_sys_user
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_sys_user purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_user(
    id varchar2(96) -- 
    ,begin_use_time date -- 
    ,code varchar2(765) -- 
    ,email varchar2(150) -- 
    ,is_admin number(10,0) -- 
    ,login_name varchar2(90) -- 
    ,password varchar2(96) -- 
    ,phone varchar2(45) -- 
    ,salt varchar2(96) -- 
    ,sex number(10,0) -- 
    ,status number(10,0) -- 
    ,username varchar2(90) -- 
    ,corp_id varchar2(96) -- 
    ,user_cadn varchar2(600) -- 
    ,login_type number(10,0) -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
    ,create_time date -- 
    ,create_by varchar2(96) -- 
    ,update_time date -- 
    ,update_by varchar2(96) -- 
    ,show_report number(10,0) -- 
    ,sys_skin varchar2(30) -- 
    ,tenant_id varchar2(96) -- 租户ID
    ,hx_wy_user_id varchar2(150) -- 华兴网银用户id
    ,cert_code varchar2(300) -- 操作员证件号码
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
grant select on ${iol_schema}.tmss_sys_user to ${iml_schema};
grant select on ${iol_schema}.tmss_sys_user to ${icl_schema};
grant select on ${iol_schema}.tmss_sys_user to ${idl_schema};
grant select on ${iol_schema}.tmss_sys_user to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_sys_user is '系统用户表';
comment on column ${iol_schema}.tmss_sys_user.id is '';
comment on column ${iol_schema}.tmss_sys_user.begin_use_time is '';
comment on column ${iol_schema}.tmss_sys_user.code is '';
comment on column ${iol_schema}.tmss_sys_user.email is '';
comment on column ${iol_schema}.tmss_sys_user.is_admin is '';
comment on column ${iol_schema}.tmss_sys_user.login_name is '';
comment on column ${iol_schema}.tmss_sys_user.password is '';
comment on column ${iol_schema}.tmss_sys_user.phone is '';
comment on column ${iol_schema}.tmss_sys_user.salt is '';
comment on column ${iol_schema}.tmss_sys_user.sex is '';
comment on column ${iol_schema}.tmss_sys_user.status is '';
comment on column ${iol_schema}.tmss_sys_user.username is '';
comment on column ${iol_schema}.tmss_sys_user.corp_id is '';
comment on column ${iol_schema}.tmss_sys_user.user_cadn is '';
comment on column ${iol_schema}.tmss_sys_user.login_type is '用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式';
comment on column ${iol_schema}.tmss_sys_user.create_time is '';
comment on column ${iol_schema}.tmss_sys_user.create_by is '';
comment on column ${iol_schema}.tmss_sys_user.update_time is '';
comment on column ${iol_schema}.tmss_sys_user.update_by is '';
comment on column ${iol_schema}.tmss_sys_user.show_report is '';
comment on column ${iol_schema}.tmss_sys_user.sys_skin is '';
comment on column ${iol_schema}.tmss_sys_user.tenant_id is '租户ID';
comment on column ${iol_schema}.tmss_sys_user.hx_wy_user_id is '华兴网银用户id';
comment on column ${iol_schema}.tmss_sys_user.cert_code is '操作员证件号码';
comment on column ${iol_schema}.tmss_sys_user.start_dt is '开始时间';
comment on column ${iol_schema}.tmss_sys_user.end_dt is '结束时间';
comment on column ${iol_schema}.tmss_sys_user.id_mark is '增删标志';
comment on column ${iol_schema}.tmss_sys_user.etl_timestamp is 'ETL处理时间戳';
