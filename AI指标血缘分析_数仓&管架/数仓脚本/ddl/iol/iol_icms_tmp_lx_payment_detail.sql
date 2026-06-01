/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_tmp_lx_payment_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_tmp_lx_payment_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_tmp_lx_payment_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tmp_lx_payment_detail(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,paydate varchar2(20) -- 付款时间
    ,paymentamount varchar2(200) -- 付款金额
    ,paymentterms varchar2(100) -- 付款期数
    ,paymentstatus varchar2(20) -- 付款状态
    ,attribute1 varchar2(64) -- 备用字段
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
grant select on ${iol_schema}.icms_tmp_lx_payment_detail to ${iml_schema};
grant select on ${iol_schema}.icms_tmp_lx_payment_detail to ${icl_schema};
grant select on ${iol_schema}.icms_tmp_lx_payment_detail to ${idl_schema};
grant select on ${iol_schema}.icms_tmp_lx_payment_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_tmp_lx_payment_detail is '乐信放款明细中间表';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.assetid is '资产号';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.paydate is '付款时间';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.paymentamount is '付款金额';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.paymentterms is '付款期数';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.paymentstatus is '付款状态';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.attribute1 is '备用字段';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_tmp_lx_payment_detail.etl_timestamp is 'ETL处理时间戳';
