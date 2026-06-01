/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_sys_user_login_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_sys_user_login_log
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_sys_user_login_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_user_login_log(
    id varchar2(96) -- 
    ,login_name varchar2(96) -- 
    ,type number(2,0) -- 登录类型,1密码登录、2证书登录,代码往后扩展
    ,host varchar2(45) -- 登录的IP
    ,user_agent varchar2(4000) -- 登录浏览器类型
    ,login_date date -- 
    ,logout_date date -- 
    ,reason varchar2(765) -- 失败原因
    ,session_id varchar2(108) -- 
    ,mac varchar2(192) -- MAC地址
    ,login_system varchar2(3) -- 登录系统，0企业端，1银行端
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
grant select on ${iol_schema}.tmss_sys_user_login_log to ${iml_schema};
grant select on ${iol_schema}.tmss_sys_user_login_log to ${icl_schema};
grant select on ${iol_schema}.tmss_sys_user_login_log to ${idl_schema};
grant select on ${iol_schema}.tmss_sys_user_login_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_sys_user_login_log is '用户登录日志表';
comment on column ${iol_schema}.tmss_sys_user_login_log.id is '';
comment on column ${iol_schema}.tmss_sys_user_login_log.login_name is '';
comment on column ${iol_schema}.tmss_sys_user_login_log.type is '登录类型,1密码登录、2证书登录,代码往后扩展';
comment on column ${iol_schema}.tmss_sys_user_login_log.host is '登录的IP';
comment on column ${iol_schema}.tmss_sys_user_login_log.user_agent is '登录浏览器类型';
comment on column ${iol_schema}.tmss_sys_user_login_log.login_date is '';
comment on column ${iol_schema}.tmss_sys_user_login_log.logout_date is '';
comment on column ${iol_schema}.tmss_sys_user_login_log.reason is '失败原因';
comment on column ${iol_schema}.tmss_sys_user_login_log.session_id is '';
comment on column ${iol_schema}.tmss_sys_user_login_log.mac is 'MAC地址';
comment on column ${iol_schema}.tmss_sys_user_login_log.login_system is '登录系统，0企业端，1银行端';
comment on column ${iol_schema}.tmss_sys_user_login_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tmss_sys_user_login_log.etl_timestamp is 'ETL处理时间戳';
