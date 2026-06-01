/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_om_tran_msg_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_om_tran_msg_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_om_tran_msg_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_om_tran_msg_info(
    thread_id varchar2(400) -- 线程ID
    ,service_id varchar2(60) -- 服务ID
    ,tran_date date -- 处理日期
    ,proc_status varchar2(20) -- 登录状态
    ,om_apply_no varchar2(60) -- OM变更编号
    ,start_time date -- 开始时间
    ,end_time date -- 终止时间
    ,execution_time varchar2(20) -- 时间间隔
    ,ip_addr varchar2(36) -- IP地址
    ,om_user_id varchar2(60) -- OM用户ID
    ,tran_timestamp date -- 交易时间戳
    ,increase_id varchar2(4000) -- 
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
grant select on ${iol_schema}.ncbs_om_tran_msg_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_om_tran_msg_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_om_tran_msg_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_om_tran_msg_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_om_tran_msg_info is '登录信息记录表';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.thread_id is '线程ID';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.service_id is '服务ID';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.tran_date is '处理日期';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.proc_status is '登录状态';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.om_apply_no is 'OM变更编号';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.start_time is '开始时间';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.end_time is '终止时间';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.execution_time is '时间间隔';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.ip_addr is 'IP地址';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.om_user_id is 'OM用户ID';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.increase_id is '';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_om_tran_msg_info.etl_timestamp is 'ETL处理时间戳';
