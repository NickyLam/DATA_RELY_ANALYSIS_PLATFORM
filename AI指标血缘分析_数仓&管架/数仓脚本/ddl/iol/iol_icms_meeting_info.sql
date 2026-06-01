/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_meeting_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_meeting_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_meeting_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_meeting_info(
    serialno varchar2(64) -- 会议流水号
    ,meetingsessions varchar2(1000) -- 会议场次
    ,meetingdate varchar2(10) -- 会议日期 yyyy/mm/dd
    ,meetingstarttime varchar2(24) -- 会议开始时间 yyyy/MM/dd hh24:mi:ss
    ,meetingendtime varchar2(24) -- 会议结束时间 yyyy/MM/dd hh24:mi:ss
    ,meetingplace varchar2(4000) -- 会议地点
    ,meetingtype varchar2(10) -- 会议类型 1-大会 2-小会
    ,meetingcompere varchar2(32) -- 会议主持人
    ,meetingrecorder varchar2(32) -- 会议记录人
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新时间
    ,stripline varchar2(6) -- 会议条线
    ,icmsorglevel varchar2(10) -- 机构级别（01-总行，02-分行）
    ,signinstatus varchar2(10) -- 会议发起签到状态（分行用） 0-未发起签到 1-已发起签到
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
grant select on ${iol_schema}.icms_meeting_info to ${iml_schema};
grant select on ${iol_schema}.icms_meeting_info to ${icl_schema};
grant select on ${iol_schema}.icms_meeting_info to ${idl_schema};
grant select on ${iol_schema}.icms_meeting_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_meeting_info is '会议记录表';
comment on column ${iol_schema}.icms_meeting_info.serialno is '会议流水号';
comment on column ${iol_schema}.icms_meeting_info.meetingsessions is '会议场次';
comment on column ${iol_schema}.icms_meeting_info.meetingdate is '会议日期 yyyy/mm/dd';
comment on column ${iol_schema}.icms_meeting_info.meetingstarttime is '会议开始时间 yyyy/MM/dd hh24:mi:ss';
comment on column ${iol_schema}.icms_meeting_info.meetingendtime is '会议结束时间 yyyy/MM/dd hh24:mi:ss';
comment on column ${iol_schema}.icms_meeting_info.meetingplace is '会议地点';
comment on column ${iol_schema}.icms_meeting_info.meetingtype is '会议类型 1-大会 2-小会';
comment on column ${iol_schema}.icms_meeting_info.meetingcompere is '会议主持人';
comment on column ${iol_schema}.icms_meeting_info.meetingrecorder is '会议记录人';
comment on column ${iol_schema}.icms_meeting_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_meeting_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_meeting_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_meeting_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_meeting_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_meeting_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_meeting_info.stripline is '会议条线';
comment on column ${iol_schema}.icms_meeting_info.icmsorglevel is '机构级别（01-总行，02-分行）';
comment on column ${iol_schema}.icms_meeting_info.signinstatus is '会议发起签到状态（分行用） 0-未发起签到 1-已发起签到';
comment on column ${iol_schema}.icms_meeting_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_meeting_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_meeting_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_meeting_info.etl_timestamp is 'ETL处理时间戳';
