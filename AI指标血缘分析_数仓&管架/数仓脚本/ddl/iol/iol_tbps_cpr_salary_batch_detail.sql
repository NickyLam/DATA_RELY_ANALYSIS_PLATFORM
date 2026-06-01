/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_salary_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_salary_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_salary_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_salary_batch_detail(
    sbd_batchno varchar2(20) -- 批次号
    ,sbd_seqno number(22) -- 序号
    ,sbd_staffno varchar2(32) -- 员工号
    ,sbd_payeracno varchar2(32) -- 付款账号
    ,sbd_payeracname varchar2(180) -- 付款账号户名
    ,sbd_payeeacno varchar2(40) -- 收款账号
    ,sbd_payeeacname varchar2(128) -- 收款账号户名
    ,sbd_amount number(15,2) -- 金额
    ,sbd_currency varchar2(3) -- 币种
    ,sbd_notecode varchar2(256) -- 付款用途
    ,sbd_remark varchar2(128) -- 返回码
    ,sbd_salarydate varchar2(8) -- 返回信息
    ,sbd_salarytime varchar2(14) -- 交易时间
    ,sbd_detailstate varchar2(1) -- 处理状态
    ,sbd_returncode varchar2(128) -- 返回码
    ,sbd_returnmsg varchar2(512) -- 返回信息
    ,sbd_hostjnldate varchar2(8) -- 核心日期
    ,sbd_hostjnlno varchar2(64) -- 核心流水号
    ,sbd_hostbatchno varchar2(8) -- 核心批次号
    ,sbd_errormsg varchar2(128) -- 错误信息
    ,sbd_userno varchar2(32) -- 用户顺序号
    ,sbd_ecifno varchar2(32) -- 全行统一客户号
    ,sbd_uniondeptid varchar2(32) -- 收款方联行号
    ,sbd_uniondeptname varchar2(256) -- 收款方开户网点
    ,sbd_mobilephone varchar2(32) -- 手机号
    ,sbd_sysflag varchar2(1) -- 0：行内；1：行外
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
grant select on ${iol_schema}.tbps_cpr_salary_batch_detail to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_detail to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_detail to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_salary_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_salary_batch_detail is '代发工资交易明细表';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_batchno is '批次号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_seqno is '序号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_staffno is '员工号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_payeracno is '付款账号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_payeracname is '付款账号户名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_payeeacno is '收款账号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_payeeacname is '收款账号户名';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_amount is '金额';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_notecode is '付款用途';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_remark is '返回码';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_salarydate is '返回信息';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_salarytime is '交易时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_detailstate is '处理状态';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_returncode is '返回码';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_returnmsg is '返回信息';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_hostjnldate is '核心日期';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_hostjnlno is '核心流水号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_hostbatchno is '核心批次号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_errormsg is '错误信息';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_userno is '用户顺序号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_ecifno is '全行统一客户号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_uniondeptid is '收款方联行号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_uniondeptname is '收款方开户网点';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_mobilephone is '手机号';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.sbd_sysflag is '0：行内；1：行外';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_salary_batch_detail.etl_timestamp is 'ETL处理时间戳';
