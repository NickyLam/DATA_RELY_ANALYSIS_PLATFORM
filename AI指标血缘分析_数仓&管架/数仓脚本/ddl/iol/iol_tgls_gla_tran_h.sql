/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gla_tran_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gla_tran_h
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gla_tran_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_tran_h(
    stacid number(19) -- 账套标记
    ,trandt varchar2(8) -- 交易日期
    ,transq varchar2(20) -- 交易流水
    ,tranti timestamp -- 交易时间
    ,tranbr varchar2(16) -- 交易机构
    ,usercd varchar2(20) -- 用户代码
    ,acctbr varchar2(16) -- 账务机构
    ,sourdt varchar2(8) -- 源系统日期
    ,soursq varchar2(30) -- 源系统流水
    ,trantp varchar2(9) -- 交易类型
    ,dcmtno varchar2(30) -- 凭证号码
    ,dcmttp varchar2(10) -- 凭证类型
    ,prcscd varchar2(12) -- 处理码
    ,tranam number(20,2) -- 交易金额
    ,itemcd varchar2(20) -- 科目代码（交易主科目）
    ,psauus varchar2(20) -- 复核用户
    ,strkst varchar2(1) -- 冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）
    ,odtrdt varchar2(8) -- 原交易日期（被冲正交易日期）
    ,odtrsq varchar2(20) -- 原交易流水（被冲正交流流水）
    ,acsrnm number -- 附件张数
    ,sourst varchar2(4) -- 源系统标识（ltts-综合业务acct-财务）
    ,remark varchar2(255) -- 备注
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
grant select on ${iol_schema}.tgls_gla_tran_h to ${iml_schema};
grant select on ${iol_schema}.tgls_gla_tran_h to ${icl_schema};
grant select on ${iol_schema}.tgls_gla_tran_h to ${idl_schema};
grant select on ${iol_schema}.tgls_gla_tran_h to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gla_tran_h is '交易流水历史表';
comment on column ${iol_schema}.tgls_gla_tran_h.stacid is '账套标记';
comment on column ${iol_schema}.tgls_gla_tran_h.trandt is '交易日期';
comment on column ${iol_schema}.tgls_gla_tran_h.transq is '交易流水';
comment on column ${iol_schema}.tgls_gla_tran_h.tranti is '交易时间';
comment on column ${iol_schema}.tgls_gla_tran_h.tranbr is '交易机构';
comment on column ${iol_schema}.tgls_gla_tran_h.usercd is '用户代码';
comment on column ${iol_schema}.tgls_gla_tran_h.acctbr is '账务机构';
comment on column ${iol_schema}.tgls_gla_tran_h.sourdt is '源系统日期';
comment on column ${iol_schema}.tgls_gla_tran_h.soursq is '源系统流水';
comment on column ${iol_schema}.tgls_gla_tran_h.trantp is '交易类型';
comment on column ${iol_schema}.tgls_gla_tran_h.dcmtno is '凭证号码';
comment on column ${iol_schema}.tgls_gla_tran_h.dcmttp is '凭证类型';
comment on column ${iol_schema}.tgls_gla_tran_h.prcscd is '处理码';
comment on column ${iol_schema}.tgls_gla_tran_h.tranam is '交易金额';
comment on column ${iol_schema}.tgls_gla_tran_h.itemcd is '科目代码（交易主科目）';
comment on column ${iol_schema}.tgls_gla_tran_h.psauus is '复核用户';
comment on column ${iol_schema}.tgls_gla_tran_h.strkst is '冲正状态（0、正常1、该交易已被冲正9、该交易为冲正交易）';
comment on column ${iol_schema}.tgls_gla_tran_h.odtrdt is '原交易日期（被冲正交易日期）';
comment on column ${iol_schema}.tgls_gla_tran_h.odtrsq is '原交易流水（被冲正交流流水）';
comment on column ${iol_schema}.tgls_gla_tran_h.acsrnm is '附件张数';
comment on column ${iol_schema}.tgls_gla_tran_h.sourst is '源系统标识（ltts-综合业务acct-财务）';
comment on column ${iol_schema}.tgls_gla_tran_h.remark is '备注';
comment on column ${iol_schema}.tgls_gla_tran_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_gla_tran_h.etl_timestamp is 'ETL处理时间戳';
