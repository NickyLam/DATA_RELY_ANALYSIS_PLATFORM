/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_att_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_att_flow
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_att_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_att_flow(
    attid number(20) -- 考勤流水
    ,uaid number(20) -- 用户Id
    ,companyid number(20) -- 企业Id
    ,attdate date -- 考勤日期
    ,opttime date -- 打卡时间
    ,opttype number(4) -- 打卡方式
    ,macaddr varchar2(300) -- MAC地址
    ,wifiname varchar2(150) -- 话题Id
    ,longitude varchar2(60) -- 用户当前经度
    ,latitude varchar2(60) -- 用户当前维度
    ,reginname varchar2(150) -- 位置名称
    ,status number(4) -- 打卡状态
    ,outsign number(4) -- 外勤打卡状态
    ,mark varchar2(765) -- 备注
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
grant select on ${iol_schema}.tbms_t_att_flow to ${iml_schema};
grant select on ${iol_schema}.tbms_t_att_flow to ${icl_schema};
grant select on ${iol_schema}.tbms_t_att_flow to ${idl_schema};
grant select on ${iol_schema}.tbms_t_att_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_att_flow is '考勤打卡';
comment on column ${iol_schema}.tbms_t_att_flow.attid is '考勤流水';
comment on column ${iol_schema}.tbms_t_att_flow.uaid is '用户Id';
comment on column ${iol_schema}.tbms_t_att_flow.companyid is '企业Id';
comment on column ${iol_schema}.tbms_t_att_flow.attdate is '考勤日期';
comment on column ${iol_schema}.tbms_t_att_flow.opttime is '打卡时间';
comment on column ${iol_schema}.tbms_t_att_flow.opttype is '打卡方式';
comment on column ${iol_schema}.tbms_t_att_flow.macaddr is 'MAC地址';
comment on column ${iol_schema}.tbms_t_att_flow.wifiname is '话题Id';
comment on column ${iol_schema}.tbms_t_att_flow.longitude is '用户当前经度';
comment on column ${iol_schema}.tbms_t_att_flow.latitude is '用户当前维度';
comment on column ${iol_schema}.tbms_t_att_flow.reginname is '位置名称';
comment on column ${iol_schema}.tbms_t_att_flow.status is '打卡状态';
comment on column ${iol_schema}.tbms_t_att_flow.outsign is '外勤打卡状态';
comment on column ${iol_schema}.tbms_t_att_flow.mark is '备注';
comment on column ${iol_schema}.tbms_t_att_flow.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_att_flow.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_att_flow.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_att_flow.clientinfo is '存储客户信息，新增时保存整个请求的json';
comment on column ${iol_schema}.tbms_t_att_flow.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_att_flow.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_att_flow.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_att_flow.etl_timestamp is 'ETL处理时间戳';
