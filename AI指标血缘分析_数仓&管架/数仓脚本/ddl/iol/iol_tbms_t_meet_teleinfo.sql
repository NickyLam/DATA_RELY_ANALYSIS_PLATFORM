/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_meet_teleinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_meet_teleinfo
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_meet_teleinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_meet_teleinfo(
    telemeetid number(10) -- 会议ID
    ,hwid varchar2(30) -- 华为ID
    ,hwconfid varchar2(30) -- 华为会议ID
    ,groupid number(20) -- 群组ID
    ,companyid number(20) -- 企业ID
    ,convener number(20) -- 会议召集人
    ,telemeettime date -- 会议召集时间
    ,telemeettitle varchar2(150) -- 会议主题
    ,telemeettype number(10) -- 会议类型
    ,duration number(10) -- 会议持续时长
    ,begintime date -- 会议开始时间
    ,mark varchar2(4000) -- 会议议题
    ,status number(4) -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
    ,cpwd varchar2(18) -- 会议主席密码
    ,upwd varchar2(18) -- 会议来宾密码
    ,versions number(20) -- 版本号
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
    ,channel number(4) -- 会议渠道，1-eSpace  2-VoIP
    ,jobid number(10) -- 调度任务ID
    ,chairmanid number(20) -- 主持人ID
    ,clientinfo varchar2(1024) -- 存储客户信息，新增时保存整个请求的json
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
grant select on ${iol_schema}.tbms_t_meet_teleinfo to ${iml_schema};
grant select on ${iol_schema}.tbms_t_meet_teleinfo to ${icl_schema};
grant select on ${iol_schema}.tbms_t_meet_teleinfo to ${idl_schema};
grant select on ${iol_schema}.tbms_t_meet_teleinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_meet_teleinfo is '语音会议';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.telemeetid is '会议ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.hwid is '华为ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.hwconfid is '华为会议ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.groupid is '群组ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.companyid is '企业ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.convener is '会议召集人';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.telemeettime is '会议召集时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.telemeettitle is '会议主题';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.telemeettype is '会议类型';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.duration is '会议持续时长';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.begintime is '会议开始时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.mark is '会议议题';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.status is '会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.cpwd is '会议主席密码';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.upwd is '会议来宾密码';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.versions is '版本号';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.channel is '会议渠道，1-eSpace  2-VoIP';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.jobid is '调度任务ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.chairmanid is '主持人ID';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.clientinfo is '存储客户信息，新增时保存整个请求的json';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_meet_teleinfo.etl_timestamp is 'ETL处理时间戳';
