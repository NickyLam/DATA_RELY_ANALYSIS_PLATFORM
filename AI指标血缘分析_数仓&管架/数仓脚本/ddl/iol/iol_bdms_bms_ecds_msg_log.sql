/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_ecds_msg_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_ecds_msg_log
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_ecds_msg_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_ecds_msg_log(
    id varchar2(60) -- 主键ID
    ,cre_dt varchar2(12) -- 报文日期
    ,cre_tm varchar2(9) -- 报文时间
    ,idnb varchar2(45) -- 电子票据号码
    ,deal_mk varchar2(15) -- 是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中
    ,draft_content varchar2(4000) -- 报文内容
    ,sendorrecv_mk varchar2(15) -- 是否发送/接收： 0 报文接收 1 报文发出
    ,orgnl_id varchar2(53) -- 源报文id
    ,orgnl_draft_no varchar2(15) -- 原报文号
    ,sender varchar2(18) -- 报文发送方
    ,receiver varchar2(18) -- 报文接受方
    ,msg_id varchar2(45) -- 报文标识号
    ,draft_no varchar2(15) -- 报文编号
    ,process_result varchar2(768) -- 处理结果
    ,update_date timestamp -- 更新日期
    ,trans_id varchar2(60) -- 交易id
    ,exec_status varchar2(3) -- 业务处理状态： 0 待处理 1 处理中 2 已完成
    ,ip varchar2(96) -- 处理机器ip
    ,his_orgnl_id varchar2(96) -- 修正前orgnl_id
    ,txn_status varchar2(3) -- 交易状态对于发送方
    ,buss_flag varchar2(3) -- 业务标记
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
grant select on ${iol_schema}.bdms_bms_ecds_msg_log to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_ecds_msg_log to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_ecds_msg_log to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_ecds_msg_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_ecds_msg_log is 'ECDS报文日志信息表';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.id is '主键ID';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.cre_dt is '报文日期';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.cre_tm is '报文时间';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.idnb is '电子票据号码';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.deal_mk is '是否处理成功： 0 报文处理失败 1 报文处理成功 2 报文处理中';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.draft_content is '报文内容';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.sendorrecv_mk is '是否发送/接收： 0 报文接收 1 报文发出';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.orgnl_id is '源报文id';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.orgnl_draft_no is '原报文号';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.sender is '报文发送方';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.receiver is '报文接受方';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.msg_id is '报文标识号';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.draft_no is '报文编号';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.process_result is '处理结果';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.update_date is '更新日期';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.trans_id is '交易id';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.exec_status is '业务处理状态： 0 待处理 1 处理中 2 已完成';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.ip is '处理机器ip';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.his_orgnl_id is '修正前orgnl_id';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.txn_status is '交易状态对于发送方';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.buss_flag is '业务标记';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_ecds_msg_log.etl_timestamp is 'ETL处理时间戳';
