/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_rtc_call_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_rtc_call_info
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_rtc_call_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_rtc_call_info(
    callid varchar2(192) -- 
    ,callname varchar2(96) -- 
    ,appid number(20) -- 
    ,calltype number(4) -- 
    ,caller number(20) -- 
    ,createtime number(20) -- 
    ,extrainfo varchar2(1024) -- 
    ,mediamode number(4) -- 
    ,chairman number(20) -- 
    ,status number(4) -- 
    ,version number(10) -- 
    ,starttime number(20) -- 
    ,finishtime number(20) -- 
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
grant select on ${iol_schema}.tbms_rtc_call_info to ${iml_schema};
grant select on ${iol_schema}.tbms_rtc_call_info to ${icl_schema};
grant select on ${iol_schema}.tbms_rtc_call_info to ${idl_schema};
grant select on ${iol_schema}.tbms_rtc_call_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_rtc_call_info is '公告';
comment on column ${iol_schema}.tbms_rtc_call_info.callid is '';
comment on column ${iol_schema}.tbms_rtc_call_info.callname is '';
comment on column ${iol_schema}.tbms_rtc_call_info.appid is '';
comment on column ${iol_schema}.tbms_rtc_call_info.calltype is '';
comment on column ${iol_schema}.tbms_rtc_call_info.caller is '';
comment on column ${iol_schema}.tbms_rtc_call_info.createtime is '';
comment on column ${iol_schema}.tbms_rtc_call_info.extrainfo is '';
comment on column ${iol_schema}.tbms_rtc_call_info.mediamode is '';
comment on column ${iol_schema}.tbms_rtc_call_info.chairman is '';
comment on column ${iol_schema}.tbms_rtc_call_info.status is '';
comment on column ${iol_schema}.tbms_rtc_call_info.version is '';
comment on column ${iol_schema}.tbms_rtc_call_info.starttime is '';
comment on column ${iol_schema}.tbms_rtc_call_info.finishtime is '';
comment on column ${iol_schema}.tbms_rtc_call_info.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_rtc_call_info.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_rtc_call_info.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_rtc_call_info.etl_timestamp is 'ETL处理时间戳';
