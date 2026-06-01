/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_htes_buss_msg_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_htes_buss_msg_log
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_htes_buss_msg_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_buss_msg_log(
    id varchar2(60) -- ID
    ,buss_id varchar2(60) -- 报文解析表ID
    ,txn_sender varchar2(9) -- 交易发送方
    ,txn_rceiver varchar2(9) -- 交易接收方
    ,msg_id varchar2(53) -- 报文标识号
    ,msg_dt varchar2(12) -- 交易日期
    ,msg_tm varchar2(21) -- 交易时间
    ,msg_no varchar2(18) -- 报文编号
    ,orgnl_msg_id varchar2(53) -- 原始报文号
    ,orgnl_msg_dt varchar2(12) -- 原始报文日期
    ,orgnl_msg_tm varchar2(21) -- 原始报文时间
    ,txn_status varchar2(3) -- 交易状态： 00 处理中 01 处理完成 02 处理失败 03 处理异常 04 自动清退 05 核对差错处理补收成功
    ,reserver1 varchar2(384) -- 保留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,last_upd_txn_id varchar2(15) -- 最后交易ID
    ,buss_flag varchar2(3) -- 报文方向： 01 发送 02 接收 03 通知
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 创建时间
    ,last_upd_opr varchar2(45) -- 最后更新人
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
grant select on ${iol_schema}.bdms_htes_buss_msg_log to ${iml_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_log to ${icl_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_log to ${idl_schema};
grant select on ${iol_schema}.bdms_htes_buss_msg_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_htes_buss_msg_log is '业务相关报文流水表';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.id is 'ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.buss_id is '报文解析表ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.txn_sender is '交易发送方';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.txn_rceiver is '交易接收方';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.msg_id is '报文标识号';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.msg_dt is '交易日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.msg_tm is '交易时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.msg_no is '报文编号';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.orgnl_msg_id is '原始报文号';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.orgnl_msg_dt is '原始报文日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.orgnl_msg_tm is '原始报文时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.txn_status is '交易状态： 00 处理中 01 处理完成 02 处理失败 03 处理异常 04 自动清退 05 核对差错处理补收成功';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.reserver1 is '保留域1';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.last_upd_txn_id is '最后交易ID';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.buss_flag is '报文方向： 01 发送 02 接收 03 通知';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.create_by is '创建人';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.create_time is '创建时间';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.last_upd_opr is '最后更新人';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_htes_buss_msg_log.etl_timestamp is 'ETL处理时间戳';
