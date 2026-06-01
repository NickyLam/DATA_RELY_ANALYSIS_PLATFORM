/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol csrs_reps_ivr_out_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.csrs_reps_ivr_out_info
whenever sqlerror continue none;
drop table ${iol_schema}.csrs_reps_ivr_out_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.csrs_reps_ivr_out_info(
    call_date timestamp -- 呼叫日期
    ,start_time varchar2(22) -- 开始时间
    ,end_time varchar2(22) -- 结束时间
    ,duration number(22) -- 通话时长
    ,time_wait_answer number(22) -- 接起用时
    ,caller_id_number varchar2(15) -- 被呼号码
    ,outgateway varchar2(128) -- 外呼网关
    ,uuid varchar2(40) -- 通道流水标识
    ,ivr_route_point varchar2(13) -- ivr路由点
    ,outbound_result varchar2(2) -- 呼出结果:00客户接听01客户未接
    ,domain varchar2(15) -- 域
    ,vdn_id varchar2(10) -- VDN编号
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
grant select on ${iol_schema}.csrs_reps_ivr_out_info to ${iml_schema};
grant select on ${iol_schema}.csrs_reps_ivr_out_info to ${icl_schema};
grant select on ${iol_schema}.csrs_reps_ivr_out_info to ${idl_schema};
grant select on ${iol_schema}.csrs_reps_ivr_out_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.csrs_reps_ivr_out_info is 'IVR呼出流水表';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.call_date is '呼叫日期';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.start_time is '开始时间';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.end_time is '结束时间';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.duration is '通话时长';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.time_wait_answer is '接起用时';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.caller_id_number is '被呼号码';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.outgateway is '外呼网关';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.uuid is '通道流水标识';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.ivr_route_point is 'ivr路由点';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.outbound_result is '呼出结果:00客户接听01客户未接';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.domain is '域';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.vdn_id is 'VDN编号';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.csrs_reps_ivr_out_info.etl_timestamp is 'ETL处理时间戳';
