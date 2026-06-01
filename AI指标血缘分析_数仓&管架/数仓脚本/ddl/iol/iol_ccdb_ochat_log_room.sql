/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_ochat_log_room
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_ochat_log_room
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_ochat_log_room purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_ochat_log_room(
    room_no varchar2(100) -- 房间编号
    ,sum_no varchar2(50) -- 服务单号
    ,title varchar2(50) -- 房间标题（可为空）
    ,begin_time date -- 开始时间
    ,end_time date -- 结束时间
    ,video_url varchar2(500) -- 视频回放地址
    ,channel_id varchar2(50) -- 云信房间号
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
grant select on ${iol_schema}.ccdb_ochat_log_room to ${iml_schema};
grant select on ${iol_schema}.ccdb_ochat_log_room to ${icl_schema};
grant select on ${iol_schema}.ccdb_ochat_log_room to ${idl_schema};
grant select on ${iol_schema}.ccdb_ochat_log_room to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_ochat_log_room is '在线客服房间日志流水';
comment on column ${iol_schema}.ccdb_ochat_log_room.room_no is '房间编号';
comment on column ${iol_schema}.ccdb_ochat_log_room.sum_no is '服务单号';
comment on column ${iol_schema}.ccdb_ochat_log_room.title is '房间标题（可为空）';
comment on column ${iol_schema}.ccdb_ochat_log_room.begin_time is '开始时间';
comment on column ${iol_schema}.ccdb_ochat_log_room.end_time is '结束时间';
comment on column ${iol_schema}.ccdb_ochat_log_room.video_url is '视频回放地址';
comment on column ${iol_schema}.ccdb_ochat_log_room.channel_id is '云信房间号';
comment on column ${iol_schema}.ccdb_ochat_log_room.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ccdb_ochat_log_room.etl_timestamp is 'ETL处理时间戳';
