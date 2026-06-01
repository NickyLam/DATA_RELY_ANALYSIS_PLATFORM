/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_nibs_ib_upm_userlogin_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log(
    etl_dt date
    ,username varchar2(150)
    ,note3 varchar2(128)
    ,datereg varchar2(8)
    ,regtype varchar2(2)
    ,deviceoid varchar2(128)
    ,branchnum varchar2(10)
    ,loginstate varchar2(2)
    ,causefailure varchar2(128)
    ,sessionid varchar2(128)
    ,loginip varchar2(20)
    ,usernum varchar2(12)
    ,note4 varchar2(128)
    ,note5 varchar2(128)
    ,appnum varchar2(16)
    ,note1 varchar2(128)
    ,note2 varchar2(128)
    ,hostname varchar2(30)
    ,regtime varchar2(6)
    ,outflag varchar2(2)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log is '用户登录登出日志表';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.username is '用户名称';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.note3 is '备注3';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.datereg is '登记日期';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.regtype is '登记类型:登记类型：0登出1登入';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.deviceoid is '设备oid';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.branchnum is '机构号';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.loginstate is '登录状态:0失败1成功';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.causefailure is '失败原因';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.sessionid is 'sessionid';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.loginip is '登录ip';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.usernum is '用户编号';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.note4 is '备注4';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.note5 is '备注5';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.appnum is '渠道编号';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.note1 is '备注1';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.note2 is '备注2';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.hostname is '主机名';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.regtime is '登记时间';
comment on column ${msl_schema}.msl_edw_nibs_ib_upm_userlogin_log.outflag is '1-本人登出，2-强制登出';
