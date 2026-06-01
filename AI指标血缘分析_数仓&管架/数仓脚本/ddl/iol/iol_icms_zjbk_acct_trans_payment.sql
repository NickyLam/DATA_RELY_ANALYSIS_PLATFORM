/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_acct_trans_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_acct_trans_payment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_acct_trans_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_acct_trans_payment(
    curdate varchar2(8) -- 账务日期
    ,loanid varchar2(64) -- 借据号
    ,trantime varchar2(14) -- 交易时间
    ,seqno varchar2(64) -- 交易流水号
    ,termno varchar2(2) -- 期数
    ,event varchar2(2) -- 事件
    ,totalamt varchar2(64) -- 交易金额
    ,incomeamt varchar2(64) -- 实收金额
    ,prinamt varchar2(64) -- 本金发生额
    ,intamt varchar2(64) -- 利息发生额
    ,pnltintamt varchar2(64) -- 罚息发生额
    ,prepmtfeerepay varchar2(64) -- 已还提前还款手续费
    ,productno varchar2(32) -- 产品编号
    ,outloanchannelno varchar2(64) -- 平台订单号
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
grant select on ${iol_schema}.icms_zjbk_acct_trans_payment to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_acct_trans_payment to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_acct_trans_payment to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_acct_trans_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_acct_trans_payment is '字节还款信息明细表';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.curdate is '账务日期';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.loanid is '借据号';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.trantime is '交易时间';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.seqno is '交易流水号';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.termno is '期数';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.event is '事件';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.totalamt is '交易金额';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.incomeamt is '实收金额';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.prinamt is '本金发生额';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.intamt is '利息发生额';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.pnltintamt is '罚息发生额';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.productno is '产品编号';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_acct_trans_payment.etl_timestamp is 'ETL处理时间戳';
