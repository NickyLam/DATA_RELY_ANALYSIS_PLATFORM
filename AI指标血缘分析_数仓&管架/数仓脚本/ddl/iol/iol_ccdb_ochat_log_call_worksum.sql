/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_ochat_log_call_worksum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_ochat_log_call_worksum
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_ochat_log_call_worksum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_ochat_log_call_worksum(
    sum_no varchar2(50) -- 会话小结流水号
    ,call_id varchar2(100) -- 呼叫流水号
    ,call_date date -- 
    ,skill_group varchar2(30) -- 
    ,account_code varchar2(20) -- 
    ,agent_id varchar2(10) -- 
    ,call_type varchar2(4) -- 
    ,channel varchar2(10) -- 
    ,buss_code varchar2(10) -- 
    ,call_flag varchar2(4) -- 
    ,picktime varchar2(26) -- 
    ,ringtime varchar2(26) -- 
    ,hangtime varchar2(26) -- 
    ,acwtime varchar2(26) -- 
    ,call_no varchar2(50) -- 
    ,ani varchar2(500) -- 
    ,locationid varchar2(10) -- 
    ,filepath varchar2(50) -- 
    ,satisfied_type varchar2(10) -- 
    ,satisfied_time varchar2(30) -- 
    ,fcr varchar2(10) -- 
    ,idcard varchar2(50) -- 
    ,ivr_node_name varchar2(100) -- 
    ,ivr_node_code varchar2(50) -- 
    ,callback_state varchar2(2) -- 
    ,by_gone varchar2(7) -- 
    ,ext_no varchar2(50) -- 
    ,province_name varchar2(50) -- 
    ,city_name varchar2(100) -- 
    ,workbill_type_code varchar2(100) -- 
    ,workbill_type_name varchar2(200) -- 
    ,email varchar2(600) -- 
    ,emp_name varchar2(300) -- 
    ,is_invite varchar2(50) -- 
    ,duplicate_sign varchar2(2) -- 
    ,line_no varchar2(4) -- 
    ,recordid varchar2(30) -- 
    ,status varchar2(4) -- 小结表状态：1.暂存 2.保存
    ,firsts varchar2(4000) -- 
    ,cust_active varchar2(4000) -- 
    ,remark varchar2(500) -- 
    ,cust_no varchar2(50) -- 客户号
    ,cust_name varchar2(100) -- 客户姓名
    ,device_no varchar2(100) -- 设备号
    ,buss_type varchar2(20) -- 
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
grant select on ${iol_schema}.ccdb_ochat_log_call_worksum to ${iml_schema};
grant select on ${iol_schema}.ccdb_ochat_log_call_worksum to ${icl_schema};
grant select on ${iol_schema}.ccdb_ochat_log_call_worksum to ${idl_schema};
grant select on ${iol_schema}.ccdb_ochat_log_call_worksum to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_ochat_log_call_worksum is '在线客服小结表';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.sum_no is '会话小结流水号';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.call_id is '呼叫流水号';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.call_date is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.skill_group is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.account_code is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.agent_id is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.call_type is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.channel is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.buss_code is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.call_flag is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.picktime is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.ringtime is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.hangtime is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.acwtime is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.call_no is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.ani is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.locationid is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.filepath is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.satisfied_type is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.satisfied_time is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.fcr is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.idcard is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.ivr_node_name is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.ivr_node_code is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.callback_state is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.by_gone is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.ext_no is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.province_name is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.city_name is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.workbill_type_code is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.workbill_type_name is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.email is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.emp_name is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.is_invite is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.duplicate_sign is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.line_no is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.recordid is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.status is '小结表状态：1.暂存 2.保存';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.firsts is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.cust_active is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.remark is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.cust_no is '客户号';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.cust_name is '客户姓名';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.device_no is '设备号';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.buss_type is '';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ccdb_ochat_log_call_worksum.etl_timestamp is 'ETL处理时间戳';
