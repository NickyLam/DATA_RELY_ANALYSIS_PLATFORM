/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_ecomplex_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_ecomplex_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_ecomplex_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_ecomplex_batch_detail(
    ebd_batchno varchar2(16) -- 批次号,8位日期+8位序号
    ,ebd_seqno number(22) -- 序号，从1开始
    ,ebd_payeracno varchar2(32) -- 付款账号
    ,ebd_payeracname varchar2(128) -- 付款账号名称
    ,ebd_currency varchar2(3) -- 币种
    ,ebd_payeeacno varchar2(40) -- 收款账号
    ,ebd_payeeacname varchar2(128) -- 收款账号名称
    ,ebd_payeeciftype varchar2(1) -- 收款方账号类型:1：企业客户,2：个人客户
    ,ebd_priority varchar2(1) -- 转账方式:2：实时,3：行内
    ,ebd_uniondeptid varchar2(20) -- 收款方联行号
    ,ebd_uniondeptname varchar2(255) -- 收款方银行名称
    ,ebd_amount number(15,2) -- 转账金额
    ,ebd_fee number(15,2) -- 转账手续费
    ,ebd_remark varchar2(128) -- 备注
    ,ebd_transcode varchar2(32) -- 交易码
    ,ebd_parentfee number(15,2) -- 手续费费率
    ,ebd_discountrate number(15,2) -- 折扣率
    ,ebd_errorcode varchar2(64) -- 错误码
    ,ebd_errormsg varchar2(512) -- 错误信息
    ,ebd_detailstate varchar2(2) -- 状态
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
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_detail to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_detail to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_detail to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_ecomplex_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_ecomplex_batch_detail is '批量转账五万以下明细表';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_batchno is '批次号,8位日期+8位序号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_seqno is '序号，从1开始';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_payeracno is '付款账号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_payeracname is '付款账号名称';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_payeeacno is '收款账号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_payeeacname is '收款账号名称';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_payeeciftype is '收款方账号类型:1：企业客户,2：个人客户';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_priority is '转账方式:2：实时,3：行内';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_uniondeptid is '收款方联行号';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_uniondeptname is '收款方银行名称';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_amount is '转账金额';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_fee is '转账手续费';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_remark is '备注';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_transcode is '交易码';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_parentfee is '手续费费率';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_discountrate is '折扣率';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_errorcode is '错误码';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_errormsg is '错误信息';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.ebd_detailstate is '状态';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tbps_cpr_ecomplex_batch_detail.etl_timestamp is 'ETL处理时间戳';
