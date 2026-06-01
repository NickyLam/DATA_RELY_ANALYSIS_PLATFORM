/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_account_log_xydbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_account_log_xydbk
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_account_log_xydbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_account_log_xydbk(
    id number(22) -- 
    ,traceno varchar2(22) -- 
    ,subno varchar2(14) -- 
    ,txdate varchar2(8) -- 
    ,txnto varchar2(1) -- 
    ,txno varchar2(8) -- 
    ,branch_no varchar2(12) -- 
    ,operator_id number(22) -- 
    ,trmid varchar2(8) -- 
    ,bsseq varchar2(30) -- 
    ,trmtype varchar2(3) -- 
    ,svcnm varchar2(64) -- 
    ,hcode varchar2(1) -- 
    ,seqno varchar2(22) -- 
    ,origtxno varchar2(8) -- 
    ,isagnstat varchar2(1) -- 
    ,sndstat varchar2(1) -- 
    ,sndcnt number(22) -- 
    ,errcd varchar2(7) -- 
    ,errrsn varchar2(256) -- 
    ,biz_type varchar2(2) -- 
    ,detail_id number(22) -- 
    ,act_dtl_id number(22) -- 
    ,draft_id number(22) -- 
    ,contract_id number(22) -- 
    ,prodprop varchar2(10) -- 
    ,misc varchar2(128) -- 
    ,auth_id number(22) -- 
    ,account_mode varchar2(1) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(14) -- 
    ,rcv_seqno varchar2(8) -- 
    ,stmt_flg varchar2(2) -- 
    ,dataid varchar2(20) -- 第三方系统标识号
    ,hostdate varchar2(8) -- 核心返回交易日期
    ,tran_amount number(18,2) -- 交易金额
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
grant select on ${iol_schema}.bdps_account_log_xydbk to ${iml_schema};
grant select on ${iol_schema}.bdps_account_log_xydbk to ${icl_schema};
grant select on ${iol_schema}.bdps_account_log_xydbk to ${idl_schema};
grant select on ${iol_schema}.bdps_account_log_xydbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_account_log_xydbk is '核心记账流水表';
comment on column ${iol_schema}.bdps_account_log_xydbk.id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.traceno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.subno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.txdate is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.txnto is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.txno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.branch_no is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.operator_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.trmid is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.bsseq is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.trmtype is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.svcnm is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.hcode is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.seqno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.origtxno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.isagnstat is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.sndstat is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.sndcnt is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.errcd is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.errrsn is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.biz_type is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.detail_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.act_dtl_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.draft_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.contract_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.prodprop is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.misc is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.auth_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.account_mode is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.last_upd_time is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.rcv_seqno is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.stmt_flg is '';
comment on column ${iol_schema}.bdps_account_log_xydbk.dataid is '第三方系统标识号';
comment on column ${iol_schema}.bdps_account_log_xydbk.hostdate is '核心返回交易日期';
comment on column ${iol_schema}.bdps_account_log_xydbk.tran_amount is '交易金额';
comment on column ${iol_schema}.bdps_account_log_xydbk.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_account_log_xydbk.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_account_log_xydbk.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_account_log_xydbk.etl_timestamp is 'ETL处理时间戳';
