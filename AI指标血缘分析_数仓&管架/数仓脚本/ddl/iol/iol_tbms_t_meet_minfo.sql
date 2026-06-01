/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_meet_minfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_meet_minfo
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_meet_minfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_meet_minfo(
    mid number(10) -- 会议ID
    ,groupid number(20) -- 群组ID
    ,companyid number(20) -- 企业ID
    ,convener number(20) -- 会议召集人
    ,mctime date -- 会议召集时间
    ,mtitle varchar2(150) -- 会议主题
    ,mtime number(10) -- 会议时长
    ,msite varchar2(180) -- 会议地点
    ,begintime date -- 会议开始时间
    ,status number(4) -- 会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束
    ,mark varchar2(4000) -- 会议议题
    ,mutid number(20) -- 重复会议ID
    ,jobid number(10) -- 调度任务ID
    ,versions number(20) -- 企业业务版本号
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
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
grant select on ${iol_schema}.tbms_t_meet_minfo to ${iml_schema};
grant select on ${iol_schema}.tbms_t_meet_minfo to ${icl_schema};
grant select on ${iol_schema}.tbms_t_meet_minfo to ${idl_schema};
grant select on ${iol_schema}.tbms_t_meet_minfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_meet_minfo is '会议';
comment on column ${iol_schema}.tbms_t_meet_minfo.mid is '会议ID';
comment on column ${iol_schema}.tbms_t_meet_minfo.groupid is '群组ID';
comment on column ${iol_schema}.tbms_t_meet_minfo.companyid is '企业ID';
comment on column ${iol_schema}.tbms_t_meet_minfo.convener is '会议召集人';
comment on column ${iol_schema}.tbms_t_meet_minfo.mctime is '会议召集时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.mtitle is '会议主题';
comment on column ${iol_schema}.tbms_t_meet_minfo.mtime is '会议时长';
comment on column ${iol_schema}.tbms_t_meet_minfo.msite is '会议地点';
comment on column ${iol_schema}.tbms_t_meet_minfo.begintime is '会议开始时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.status is '会议状态,1：倒计时 2：未开始 3：进行中 4：已取消 5：已结束';
comment on column ${iol_schema}.tbms_t_meet_minfo.mark is '会议议题';
comment on column ${iol_schema}.tbms_t_meet_minfo.mutid is '重复会议ID';
comment on column ${iol_schema}.tbms_t_meet_minfo.jobid is '调度任务ID';
comment on column ${iol_schema}.tbms_t_meet_minfo.versions is '企业业务版本号';
comment on column ${iol_schema}.tbms_t_meet_minfo.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_meet_minfo.clientinfo is '存储客户信息，新增时保存整个请求的json';
comment on column ${iol_schema}.tbms_t_meet_minfo.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_meet_minfo.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_meet_minfo.etl_timestamp is 'ETL处理时间戳';
