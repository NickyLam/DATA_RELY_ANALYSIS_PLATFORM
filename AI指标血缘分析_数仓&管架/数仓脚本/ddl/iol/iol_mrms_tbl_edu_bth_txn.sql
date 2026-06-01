/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_edu_bth_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_edu_bth_txn
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_edu_bth_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_edu_bth_txn(
    order_num varchar2(60) -- 第三方订单号
    ,merch_num varchar2(30) -- 商户号
    ,merch_name varchar2(192) -- 商户名称
    ,tran_date varchar2(12) -- 交易日期
    ,tran_time varchar2(9) -- 交易时间
    ,pay_acct varchar2(48) -- 付款账号
    ,pay_acct_name varchar2(192) -- 付款账户名称
    ,rcv_acct varchar2(48) -- 收款账号
    ,recv_acct_name varchar2(192) -- 收款账号名称
    ,order_amt number(20,2) -- 订单金额
    ,fee_amt number(20,2) -- 手续费金额
    ,tran_type varchar2(5) -- 交易类型 1手续费垫资、2批量代付
    ,post varchar2(383) -- 附言
    ,bank_id varchar2(12) -- 银行标识
    ,ret_code varchar2(48) -- 响应码
    ,ret_msg varchar2(383) -- 响应信息
    ,platf_seq_num varchar2(96) -- 银行业务流水号
    ,txn_status varchar2(5) -- 交易状态 100-支付成功，102-支付失败，103-订单处理中
    ,created_time varchar2(21) -- 创建时间
    ,updated_time varchar2(21) -- 修改时间
    ,reserved1 varchar2(383) -- 保留字段
    ,reserved2 varchar2(383) -- 保留字段
    ,reserved3 varchar2(383) -- 保留字段
    ,reserved4 varchar2(383) -- 保留字段
    ,reserved5 varchar2(383) -- 保留字段
    ,chn_bat_seq_num varchar2(48) -- 第三方批次流水号
    ,seq varchar2(60) -- 银行流水号（批次号）
    ,pay_seq_num varchar2(60) -- 支付流水号
    ,core_seq_num varchar2(60) -- 核心流水号
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
grant select on ${iol_schema}.mrms_tbl_edu_bth_txn to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_edu_bth_txn to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_edu_bth_txn to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_edu_bth_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_edu_bth_txn is '教育金批量交易（销课出金和退款）';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.order_num is '第三方订单号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.merch_num is '商户号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.merch_name is '商户名称';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.tran_date is '交易日期';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.tran_time is '交易时间';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.pay_acct is '付款账号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.pay_acct_name is '付款账户名称';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.rcv_acct is '收款账号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.recv_acct_name is '收款账号名称';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.order_amt is '订单金额';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.fee_amt is '手续费金额';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.tran_type is '交易类型 1手续费垫资、2批量代付';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.post is '附言';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.bank_id is '银行标识';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.ret_code is '响应码';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.ret_msg is '响应信息';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.platf_seq_num is '银行业务流水号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.txn_status is '交易状态 100-支付成功，102-支付失败，103-订单处理中';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.created_time is '创建时间';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.updated_time is '修改时间';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.reserved1 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.reserved2 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.reserved3 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.reserved4 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.reserved5 is '保留字段';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.chn_bat_seq_num is '第三方批次流水号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.seq is '银行流水号（批次号）';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.pay_seq_num is '支付流水号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.core_seq_num is '核心流水号';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_edu_bth_txn.etl_timestamp is 'ETL处理时间戳';
