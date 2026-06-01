/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_acct_cntrpty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_acct_cntrpty
whenever sqlerror continue none;
drop table ${iol_schema}.icms_acct_cntrpty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_acct_cntrpty(
    serialno varchar2(64) -- 流水号
    ,relativeobjecttype varchar2(64) -- 关联对象类型
    ,relativeobjectno varchar2(64) -- 关联对象编号
    ,hangseqno varchar2(50) -- 挂账编号
    ,cntrptyname varchar2(200) -- 交易对手名称
    ,othrealbaseacctno varchar2(50) -- 交易对手账号
    ,contrabankcode varchar2(50) -- 交易对手行号
    ,contrabankname varchar2(200) -- 交易对手行名称
    ,tranamt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.icms_acct_cntrpty to ${iml_schema};
grant select on ${iol_schema}.icms_acct_cntrpty to ${icl_schema};
grant select on ${iol_schema}.icms_acct_cntrpty to ${idl_schema};
grant select on ${iol_schema}.icms_acct_cntrpty to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_acct_cntrpty is '信贷系统帐务-贷后变更交易对手信息';
comment on column ${iol_schema}.icms_acct_cntrpty.serialno is '流水号';
comment on column ${iol_schema}.icms_acct_cntrpty.relativeobjecttype is '关联对象类型';
comment on column ${iol_schema}.icms_acct_cntrpty.relativeobjectno is '关联对象编号';
comment on column ${iol_schema}.icms_acct_cntrpty.hangseqno is '挂账编号';
comment on column ${iol_schema}.icms_acct_cntrpty.cntrptyname is '交易对手名称';
comment on column ${iol_schema}.icms_acct_cntrpty.othrealbaseacctno is '交易对手账号';
comment on column ${iol_schema}.icms_acct_cntrpty.contrabankcode is '交易对手行号';
comment on column ${iol_schema}.icms_acct_cntrpty.contrabankname is '交易对手行名称';
comment on column ${iol_schema}.icms_acct_cntrpty.tranamt is '交易金额';
comment on column ${iol_schema}.icms_acct_cntrpty.start_dt is '开始时间';
comment on column ${iol_schema}.icms_acct_cntrpty.end_dt is '结束时间';
comment on column ${iol_schema}.icms_acct_cntrpty.id_mark is '增删标志';
comment on column ${iol_schema}.icms_acct_cntrpty.etl_timestamp is 'ETL处理时间戳';
