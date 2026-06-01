/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdws_b_t_cm_contact_call
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdws_b_t_cm_contact_call
whenever sqlerror continue none;
drop table ${iol_schema}.bdws_b_t_cm_contact_call purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdws_b_t_cm_contact_call(
    etl_dt_ora varchar2(4000) -- 数据日期
    ,contact_call_id varchar2(4000) -- 主键
    ,cust_id varchar2(4000) -- 客户编号
    ,call_id varchar2(4000) -- 外呼会话编号
    ,cust_phone varchar2(4000) -- 客户电话号码
    ,call_time varchar2(4000) -- 电话时长
    ,create_time varchar2(4000) -- 创建时间
    ,contact_id varchar2(4000) -- 客户联络主键
    ,caller_id_name varchar2(4000) -- 来电者名字
    ,caller_id_number varchar2(4000) -- 来电号码
    ,destination_number varchar2(4000) -- 被叫号码
    ,hang_up_cause varchar2(4000) -- 电话挂断原因  NORMAL_CLEARING-正常挂断  其他：未正常建立通话
    ,agent_phone varchar2(4000) -- 座席电话
    ,agent_id varchar2(4000) -- 座席工号
    ,record_url varchar2(4000) -- 录音地址
    ,hang_up_cause_cd varchar2(4000) -- 会话接通/断开标志
    ,load_date varchar2(4000) -- 数据日期
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
grant select on ${iol_schema}.bdws_b_t_cm_contact_call to ${iml_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact_call to ${icl_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact_call to ${idl_schema};
grant select on ${iol_schema}.bdws_b_t_cm_contact_call to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdws_b_t_cm_contact_call is '客户联络外呼信息表';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.contact_call_id is '主键';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.cust_id is '客户编号';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.call_id is '外呼会话编号';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.cust_phone is '客户电话号码';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.call_time is '电话时长';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.create_time is '创建时间';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.contact_id is '客户联络主键';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.caller_id_name is '来电者名字';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.caller_id_number is '来电号码';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.destination_number is '被叫号码';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.hang_up_cause is '电话挂断原因  NORMAL_CLEARING-正常挂断  其他：未正常建立通话';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.agent_phone is '座席电话';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.agent_id is '座席工号';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.record_url is '录音地址';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.hang_up_cause_cd is '会话接通/断开标志';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.load_date is '数据日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdws_b_t_cm_contact_call.etl_timestamp is 'ETL处理时间戳';
