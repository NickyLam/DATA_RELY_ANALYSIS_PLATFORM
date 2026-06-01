/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_account_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_account_log
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_account_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_account_log(
    id number(22) -- 
    ,traceno varchar2(96) -- 
    ,subno varchar2(21) -- 
    ,txdate varchar2(12) -- 
    ,txnto varchar2(2) -- 
    ,txno varchar2(12) -- 
    ,branch_no varchar2(18) -- 
    ,operator_id number(22) -- 
    ,trmid varchar2(12) -- 
    ,bsseq varchar2(45) -- 
    ,trmtype varchar2(5) -- 
    ,svcnm varchar2(96) -- 
    ,hcode varchar2(2) -- 
    ,seqno varchar2(96) -- 
    ,origtxno varchar2(12) -- 
    ,isagnstat varchar2(2) -- 
    ,sndstat varchar2(2) -- 
    ,sndcnt number(22) -- 
    ,errcd varchar2(23) -- 
    ,errrsn varchar2(384) -- 
    ,biz_type varchar2(3) -- 
    ,detail_id number(22) -- 
    ,act_dtl_id number(22) -- 
    ,draft_id number(22) -- 
    ,contract_id number(22) -- 
    ,prodprop varchar2(15) -- 
    ,misc varchar2(192) -- 
    ,auth_id number(22) -- 
    ,account_mode varchar2(2) -- 
    ,last_upd_oper_id number(22) -- 
    ,last_upd_time varchar2(21) -- 
    ,rcv_seqno varchar2(12) -- 
    ,stmt_flg varchar2(3) -- 
    ,dataid varchar2(30) -- 第三方系统标识号
    ,hostdate varchar2(12) -- 核心返回交易日期
    ,tran_amount number(18,2) -- 交易金额
    ,tglsstat varchar2(3) -- 核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账
    ,tglscnt number(22,0) -- 核算中台重发次数
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
grant select on ${iol_schema}.bdps_account_log to ${iml_schema};
grant select on ${iol_schema}.bdps_account_log to ${icl_schema};
grant select on ${iol_schema}.bdps_account_log to ${idl_schema};
grant select on ${iol_schema}.bdps_account_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_account_log is '核心记账流水表';
comment on column ${iol_schema}.bdps_account_log.id is '';
comment on column ${iol_schema}.bdps_account_log.traceno is '';
comment on column ${iol_schema}.bdps_account_log.subno is '';
comment on column ${iol_schema}.bdps_account_log.txdate is '';
comment on column ${iol_schema}.bdps_account_log.txnto is '';
comment on column ${iol_schema}.bdps_account_log.txno is '';
comment on column ${iol_schema}.bdps_account_log.branch_no is '';
comment on column ${iol_schema}.bdps_account_log.operator_id is '';
comment on column ${iol_schema}.bdps_account_log.trmid is '';
comment on column ${iol_schema}.bdps_account_log.bsseq is '';
comment on column ${iol_schema}.bdps_account_log.trmtype is '';
comment on column ${iol_schema}.bdps_account_log.svcnm is '';
comment on column ${iol_schema}.bdps_account_log.hcode is '';
comment on column ${iol_schema}.bdps_account_log.seqno is '';
comment on column ${iol_schema}.bdps_account_log.origtxno is '';
comment on column ${iol_schema}.bdps_account_log.isagnstat is '';
comment on column ${iol_schema}.bdps_account_log.sndstat is '';
comment on column ${iol_schema}.bdps_account_log.sndcnt is '';
comment on column ${iol_schema}.bdps_account_log.errcd is '';
comment on column ${iol_schema}.bdps_account_log.errrsn is '';
comment on column ${iol_schema}.bdps_account_log.biz_type is '';
comment on column ${iol_schema}.bdps_account_log.detail_id is '';
comment on column ${iol_schema}.bdps_account_log.act_dtl_id is '';
comment on column ${iol_schema}.bdps_account_log.draft_id is '';
comment on column ${iol_schema}.bdps_account_log.contract_id is '';
comment on column ${iol_schema}.bdps_account_log.prodprop is '';
comment on column ${iol_schema}.bdps_account_log.misc is '';
comment on column ${iol_schema}.bdps_account_log.auth_id is '';
comment on column ${iol_schema}.bdps_account_log.account_mode is '';
comment on column ${iol_schema}.bdps_account_log.last_upd_oper_id is '';
comment on column ${iol_schema}.bdps_account_log.last_upd_time is '';
comment on column ${iol_schema}.bdps_account_log.rcv_seqno is '';
comment on column ${iol_schema}.bdps_account_log.stmt_flg is '';
comment on column ${iol_schema}.bdps_account_log.dataid is '第三方系统标识号';
comment on column ${iol_schema}.bdps_account_log.hostdate is '核心返回交易日期';
comment on column ${iol_schema}.bdps_account_log.tran_amount is '交易金额';
comment on column ${iol_schema}.bdps_account_log.tglsstat is '核算中台记账状态00-未记账01-记账中02-记账成功03-已抹账';
comment on column ${iol_schema}.bdps_account_log.tglscnt is '核算中台重发次数';
comment on column ${iol_schema}.bdps_account_log.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_account_log.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_account_log.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_account_log.etl_timestamp is 'ETL处理时间戳';
