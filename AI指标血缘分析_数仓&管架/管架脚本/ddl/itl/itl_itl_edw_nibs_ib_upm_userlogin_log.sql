/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_nibs_ib_upm_userlogin_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log(
    username varchar2(150) -- 用户名称
    ,note3 varchar2(128) -- 备注3
    ,datereg varchar2(8) -- 登记日期
    ,regtype varchar2(2) -- 登记类型:登记类型：0登出1登入
    ,deviceoid varchar2(128) -- 设备oid
    ,branchnum varchar2(10) -- 机构号
    ,loginstate varchar2(2) -- 登录状态:0失败1成功
    ,causefailure varchar2(128) -- 失败原因
    ,sessionid varchar2(128) -- sessionid
    ,loginip varchar2(20) -- 登录ip
    ,usernum varchar2(12) -- 用户编号
    ,note4 varchar2(128) -- 备注4
    ,note5 varchar2(128) -- 备注5
    ,appnum varchar2(16) -- 渠道编号
    ,note1 varchar2(128) -- 备注1
    ,note2 varchar2(128) -- 备注2
    ,hostname varchar2(30) -- 主机名
    ,regtime varchar2(6) -- 登记时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log is '用户登录登出日志表';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.username is '用户名称';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.note3 is '备注3';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.datereg is '登记日期';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.regtype is '登记类型:登记类型：0登出1登入';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.deviceoid is '设备oid';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.branchnum is '机构号';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.loginstate is '登录状态:0失败1成功';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.causefailure is '失败原因';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.sessionid is 'sessionid';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.loginip is '登录ip';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.usernum is '用户编号';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.note4 is '备注4';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.note5 is '备注5';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.appnum is '渠道编号';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.note1 is '备注1';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.note2 is '备注2';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.hostname is '主机名';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.regtime is '登记时间';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_nibs_ib_upm_userlogin_log.etl_timestamp is 'ETL处理时间戳';
