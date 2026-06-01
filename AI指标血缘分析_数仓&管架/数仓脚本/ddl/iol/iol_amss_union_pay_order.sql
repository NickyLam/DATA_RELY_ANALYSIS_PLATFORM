/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_union_pay_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_union_pay_order
whenever sqlerror continue none;
drop table ${iol_schema}.amss_union_pay_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_order(
    union_pay_order_id varchar2(128) -- 银联代付订单表主键
    ,fund_id varchar2(128) -- 基金公司编号
    ,merchant_id varchar2(128) -- 银联商户编号
    ,channel_id varchar2(128) -- 所属机构
    ,org_id varchar2(128) -- 银行编号
    ,order_num varchar2(128) -- 订单号
    ,mgmt_platf_chn varchar2(128) -- 渠道号
    ,txn_amt number(20,2) -- 交易金额
    ,txn_status number(1,0) -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
    ,txn_date timestamp -- 交易时间
    ,rcv_acct varchar2(32) -- 收款方银行账号
    ,rcv_acct_name varchar2(256) -- 收款方账户名称
    ,rcv_acct_typ varchar2(32) -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,rcv_bank_categ number(1,0) -- 银行归属1：行内 2：行外
    ,rcv_bank_id varchar2(32) -- 收款方银行提供行号
    ,rcv_bank_name varchar2(256) -- 收款银行名称
    ,rcv_acct_bcs_typ varchar2(32) -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,iden_type_cd varchar2(32) -- 证件类型代码
    ,cert_num varchar2(32) -- 证件号码
    ,payer_acct varchar2(32) -- 支付，付款人账号）
    ,payer_name varchar2(256) -- 支付，付款人名称）
    ,payer_acct_typ varchar2(32) -- 支付，付款人账户类型（DEBIT个人银行借记账户
    ,payer_acct_bcs_typ varchar2(32) -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,ori_trx_dt varchar2(128) -- 原交易时间
    ,ori_trx_seq varchar2(128) -- 原交易编号
    ,resp_msg varchar2(512) -- 失败原因
    ,physics_flag number -- 物理标识，默认1正常，2删除
    ,create_time timestamp -- 创建时间
    ,create_emp varchar2(128) -- 创建者
    ,update_time timestamp -- 更新时间
    ,update_emp varchar2(128) -- 更新者
    ,ceph_num varchar2(128) -- 手机号
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
grant select on ${iol_schema}.amss_union_pay_order to ${iml_schema};
grant select on ${iol_schema}.amss_union_pay_order to ${icl_schema};
grant select on ${iol_schema}.amss_union_pay_order to ${idl_schema};
grant select on ${iol_schema}.amss_union_pay_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_union_pay_order is '';
comment on column ${iol_schema}.amss_union_pay_order.union_pay_order_id is '银联代付订单表主键';
comment on column ${iol_schema}.amss_union_pay_order.fund_id is '基金公司编号';
comment on column ${iol_schema}.amss_union_pay_order.merchant_id is '银联商户编号';
comment on column ${iol_schema}.amss_union_pay_order.channel_id is '所属机构';
comment on column ${iol_schema}.amss_union_pay_order.org_id is '银行编号';
comment on column ${iol_schema}.amss_union_pay_order.order_num is '订单号';
comment on column ${iol_schema}.amss_union_pay_order.mgmt_platf_chn is '渠道号';
comment on column ${iol_schema}.amss_union_pay_order.txn_amt is '交易金额';
comment on column ${iol_schema}.amss_union_pay_order.txn_status is '交易状态（0交易失败，1交易成功，2交易未明，3未支付）';
comment on column ${iol_schema}.amss_union_pay_order.txn_date is '交易时间';
comment on column ${iol_schema}.amss_union_pay_order.rcv_acct is '收款方银行账号';
comment on column ${iol_schema}.amss_union_pay_order.rcv_acct_name is '收款方账户名称';
comment on column ${iol_schema}.amss_union_pay_order.rcv_acct_typ is '收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）';
comment on column ${iol_schema}.amss_union_pay_order.rcv_bank_categ is '银行归属1：行内 2：行外';
comment on column ${iol_schema}.amss_union_pay_order.rcv_bank_id is '收款方银行提供行号';
comment on column ${iol_schema}.amss_union_pay_order.rcv_bank_name is '收款银行名称';
comment on column ${iol_schema}.amss_union_pay_order.rcv_acct_bcs_typ is '收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)';
comment on column ${iol_schema}.amss_union_pay_order.iden_type_cd is '证件类型代码';
comment on column ${iol_schema}.amss_union_pay_order.cert_num is '证件号码';
comment on column ${iol_schema}.amss_union_pay_order.payer_acct is '支付，付款人账号）';
comment on column ${iol_schema}.amss_union_pay_order.payer_name is '支付，付款人名称）';
comment on column ${iol_schema}.amss_union_pay_order.payer_acct_typ is '支付，付款人账户类型（DEBIT个人银行借记账户';
comment on column ${iol_schema}.amss_union_pay_order.payer_acct_bcs_typ is '支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)';
comment on column ${iol_schema}.amss_union_pay_order.ori_trx_dt is '原交易时间';
comment on column ${iol_schema}.amss_union_pay_order.ori_trx_seq is '原交易编号';
comment on column ${iol_schema}.amss_union_pay_order.resp_msg is '失败原因';
comment on column ${iol_schema}.amss_union_pay_order.physics_flag is '物理标识，默认1正常，2删除';
comment on column ${iol_schema}.amss_union_pay_order.create_time is '创建时间';
comment on column ${iol_schema}.amss_union_pay_order.create_emp is '创建者';
comment on column ${iol_schema}.amss_union_pay_order.update_time is '更新时间';
comment on column ${iol_schema}.amss_union_pay_order.update_emp is '更新者';
comment on column ${iol_schema}.amss_union_pay_order.ceph_num is '手机号';
comment on column ${iol_schema}.amss_union_pay_order.start_dt is '开始时间';
comment on column ${iol_schema}.amss_union_pay_order.end_dt is '结束时间';
comment on column ${iol_schema}.amss_union_pay_order.id_mark is '增删标志';
comment on column ${iol_schema}.amss_union_pay_order.etl_timestamp is 'ETL处理时间戳';
