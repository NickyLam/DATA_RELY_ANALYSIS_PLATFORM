/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_userlogin_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_userlogin_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_userlogin_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_userlogin_log(
    causefailure varchar2(128) -- 失败原因
    ,note1 varchar2(128) -- 备注1
    ,note2 varchar2(128) -- 备注2
    ,note3 varchar2(128) -- 备注3
    ,note4 varchar2(128) -- 备注4
    ,note5 varchar2(128) -- 备注5
    ,loginstate varchar2(2) -- 登录状态 : 0失败 1成功
    ,regtype varchar2(2) -- 登记类型 : 登记类型：0登出 1登入
    ,regtime varchar2(6) -- 登记时间-hhmmss
    ,datereg varchar2(8) -- 登记日期-yyyymmdd
    ,deviceoid varchar2(128) -- 设备oid
    ,hostname varchar2(30) -- 主机名
    ,loginip varchar2(20) -- 登录ip
    ,sessionid varchar2(128) -- sessionid
    ,outflag varchar2(2) -- 1-本人登出，2-强制登出
    ,username varchar2(150) -- 用户名称
    ,usernum varchar2(12) -- 用户编号
    ,appnum varchar2(16) -- 渠道编号
    ,branchnum varchar2(10) -- 机构号
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
grant select on ${iol_schema}.nibs_ib_upm_userlogin_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_userlogin_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_userlogin_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_userlogin_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_userlogin_log is '用户登录登出日志表';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.causefailure is '失败原因';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.note1 is '备注1';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.note2 is '备注2';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.note3 is '备注3';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.note4 is '备注4';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.note5 is '备注5';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.loginstate is '登录状态 : 0失败 1成功';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.regtype is '登记类型 : 登记类型：0登出 1登入';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.regtime is '登记时间-hhmmss';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.datereg is '登记日期-yyyymmdd';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.deviceoid is '设备oid';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.hostname is '主机名';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.loginip is '登录ip';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.sessionid is 'sessionid';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.outflag is '1-本人登出，2-强制登出';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.username is '用户名称';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.usernum is '用户编号';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.appnum is '渠道编号';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.branchnum is '机构号';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_upm_userlogin_log.etl_timestamp is 'ETL处理时间戳';
