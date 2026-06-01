/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_ats_login_control
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_ats_login_control
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_ats_login_control purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_ats_login_control(
    alc_cstno varchar2(32) -- 登录客户号
    ,alc_userno varchar2(32) -- 登录用户号
    ,alc_sessionid varchar2(64) -- 登录时记录下的sessionId
    ,alc_create_time varchar2(14) -- 该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串
    ,alc_serveraddress varchar2(40) -- 存储会话数据的服务器(ip:port)
    ,alc_clientip varchar2(40) -- 客户登陆IP
    ,alc_channel varchar2(4) -- 客户登录渠道
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
grant select on ${iol_schema}.osbs_ats_login_control to ${iml_schema};
grant select on ${iol_schema}.osbs_ats_login_control to ${icl_schema};
grant select on ${iol_schema}.osbs_ats_login_control to ${idl_schema};
grant select on ${iol_schema}.osbs_ats_login_control to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_ats_login_control is '客户登录控制表';
comment on column ${iol_schema}.osbs_ats_login_control.alc_cstno is '登录客户号';
comment on column ${iol_schema}.osbs_ats_login_control.alc_userno is '登录用户号';
comment on column ${iol_schema}.osbs_ats_login_control.alc_sessionid is '登录时记录下的sessionId';
comment on column ${iol_schema}.osbs_ats_login_control.alc_create_time is '该条登录数据的记录时间,格式yyyyMMddHH24miss的字符串';
comment on column ${iol_schema}.osbs_ats_login_control.alc_serveraddress is '存储会话数据的服务器(ip:port)';
comment on column ${iol_schema}.osbs_ats_login_control.alc_clientip is '客户登陆IP';
comment on column ${iol_schema}.osbs_ats_login_control.alc_channel is '客户登录渠道';
comment on column ${iol_schema}.osbs_ats_login_control.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_ats_login_control.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_ats_login_control.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_ats_login_control.etl_timestamp is 'ETL处理时间戳';
