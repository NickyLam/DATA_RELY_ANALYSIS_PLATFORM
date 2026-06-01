/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_corp_userlist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_corp_userlist
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_corp_userlist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_corp_userlist(
    companyid number(20) -- 企业ID
    ,uaid number(20) -- 用户ID
    ,username varchar2(90) -- 用户名
    ,userphone varchar2(33) -- 用户手机号
    ,sex number(10) -- 性别,性别 0:女  1:男
    ,birthdate number(20) -- 生日
    ,workphone varchar2(60) -- 公司座机
    ,workextension varchar2(24) -- 分机号
    ,workemail varchar2(150) -- 企业邮箱
    ,workno varchar2(30) -- 工号
    ,status number(4) -- 成员状态,0:未激活,1:已激活,2拒绝加入
    ,iconid number(20) -- 头像ID
    ,usercustom varchar2(750) -- 用户自定义信息
    ,relationstatus number(4) -- 黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏
    ,friendstatus number(4) -- 消息屏蔽状态,1默认无屏蔽,2有单独配置
    ,usertype number(4) -- 用户类型：默认1个人,2 银企通
    ,certificatetype number(4) -- 证件类型：默认1身份证,2护照
    ,certificatenum varchar2(96) -- 证件号
    ,versions number(20) -- 通讯录版本号
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
    ,applystate number(4) -- 申请状态
    ,applyreason varchar2(765) -- 申请原因
    ,last_request_ip varchar2(100) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbms_t_corp_userlist to ${iml_schema};
grant select on ${iol_schema}.tbms_t_corp_userlist to ${icl_schema};
grant select on ${iol_schema}.tbms_t_corp_userlist to ${idl_schema};
grant select on ${iol_schema}.tbms_t_corp_userlist to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_corp_userlist is '企业名单';
comment on column ${iol_schema}.tbms_t_corp_userlist.companyid is '企业ID';
comment on column ${iol_schema}.tbms_t_corp_userlist.uaid is '用户ID';
comment on column ${iol_schema}.tbms_t_corp_userlist.username is '用户名';
comment on column ${iol_schema}.tbms_t_corp_userlist.userphone is '用户手机号';
comment on column ${iol_schema}.tbms_t_corp_userlist.sex is '性别,性别 0:女  1:男';
comment on column ${iol_schema}.tbms_t_corp_userlist.birthdate is '生日';
comment on column ${iol_schema}.tbms_t_corp_userlist.workphone is '公司座机';
comment on column ${iol_schema}.tbms_t_corp_userlist.workextension is '分机号';
comment on column ${iol_schema}.tbms_t_corp_userlist.workemail is '企业邮箱';
comment on column ${iol_schema}.tbms_t_corp_userlist.workno is '工号';
comment on column ${iol_schema}.tbms_t_corp_userlist.status is '成员状态,0:未激活,1:已激活,2拒绝加入';
comment on column ${iol_schema}.tbms_t_corp_userlist.iconid is '头像ID';
comment on column ${iol_schema}.tbms_t_corp_userlist.usercustom is '用户自定义信息';
comment on column ${iol_schema}.tbms_t_corp_userlist.relationstatus is '黑白名单状态,0默认,1黑名单,2白名单,3全部隐藏';
comment on column ${iol_schema}.tbms_t_corp_userlist.friendstatus is '消息屏蔽状态,1默认无屏蔽,2有单独配置';
comment on column ${iol_schema}.tbms_t_corp_userlist.usertype is '用户类型：默认1个人,2 银企通';
comment on column ${iol_schema}.tbms_t_corp_userlist.certificatetype is '证件类型：默认1身份证,2护照';
comment on column ${iol_schema}.tbms_t_corp_userlist.certificatenum is '证件号';
comment on column ${iol_schema}.tbms_t_corp_userlist.versions is '通讯录版本号';
comment on column ${iol_schema}.tbms_t_corp_userlist.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_corp_userlist.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_corp_userlist.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_corp_userlist.applystate is '申请状态';
comment on column ${iol_schema}.tbms_t_corp_userlist.applyreason is '申请原因';
comment on column ${iol_schema}.tbms_t_corp_userlist.last_request_ip is '';
comment on column ${iol_schema}.tbms_t_corp_userlist.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_corp_userlist.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_corp_userlist.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_corp_userlist.etl_timestamp is 'ETL处理时间戳';
