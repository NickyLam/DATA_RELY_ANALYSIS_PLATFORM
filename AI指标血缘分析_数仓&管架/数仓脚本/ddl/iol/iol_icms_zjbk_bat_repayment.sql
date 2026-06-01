/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_bat_repayment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_bat_repayment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_bat_repayment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_bat_repayment(
    serialno varchar2(200) -- 流水号
    ,curdate varchar2(8) -- 账务日期
    ,loanid varchar2(64) -- 借据号
    ,trantime varchar2(14) -- 交易时间
    ,seqno varchar2(64) -- 交易流水号
    ,totalamt varchar2(64) -- 交易金额
    ,incomeamt varchar2(64) -- 实收金额
    ,prinamt varchar2(64) -- 本金发生额
    ,intamt varchar2(64) -- 利息发生额
    ,pnltintamt varchar2(64) -- 罚息发生额
    ,prepmtfeerepay varchar2(64) -- 已还提前还款手续费
    ,productno varchar2(32) -- 产品编号
    ,outloanchannelno varchar2(64) -- 平台订单号
    ,interesttransferstatus varchar2(1) -- 非应计状态
    ,repayaccounttype varchar2(2) -- 还款账户类型
    ,repayaccountname varchar2(64) -- 还款账户开户机构名称
    ,repayaccountno varchar2(64) -- 还款账户编号
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
grant select on ${iol_schema}.icms_zjbk_bat_repayment to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_bat_repayment to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_bat_repayment to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_bat_repayment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_bat_repayment is '字节还款信息表';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.curdate is '账务日期';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.loanid is '借据号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.trantime is '交易时间';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.seqno is '交易流水号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.totalamt is '交易金额';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.incomeamt is '实收金额';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.prinamt is '本金发生额';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.intamt is '利息发生额';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.pnltintamt is '罚息发生额';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.productno is '产品编号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.interesttransferstatus is '非应计状态';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.repayaccounttype is '还款账户类型';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.repayaccountname is '还款账户开户机构名称';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.repayaccountno is '还款账户编号';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_bat_repayment.etl_timestamp is 'ETL处理时间戳';
