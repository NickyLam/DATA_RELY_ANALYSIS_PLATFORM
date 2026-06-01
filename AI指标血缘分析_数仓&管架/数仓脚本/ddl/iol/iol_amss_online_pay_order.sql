/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_online_pay_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_online_pay_order
whenever sqlerror continue none;
drop table ${iol_schema}.amss_online_pay_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_online_pay_order(
    online_pay_order_id varchar2(256) -- 网联代付订单表主键
    ,ori_trx_seq varchar2(256) -- PPP交易流水号
    ,order_num varchar2(256) -- 订单号
    ,mgmt_platf_chn varchar2(120) -- 平台渠道号
    ,sign_num varchar2(120) -- 协议编号
    ,txn_amt number(24,2) -- 订单金额
    ,txn_status varchar2(10) -- 交易状态（0交易失败，1交易成功，2交易未明，3未支付）
    ,txn_time timestamp -- 交易时间
    ,payer_acct varchar2(120) -- 支付，付款人账号）
    ,payer_name varchar2(120) -- 支付，付款人名称）
    ,payer_acct_typ varchar2(100) -- 支付，付款人账户类型（DEBIT个人银行借记账户
    ,payer_acct_bcs_typ varchar2(50) -- 支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,rcv_acct varchar2(120) -- 收款方银行账号
    ,rcv_acct_name varchar2(120) -- 收款方账户名称
    ,rcv_acct_typ varchar2(100) -- 收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）
    ,rcv_acct_bcs_typ varchar2(50) -- 收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)
    ,create_time timestamp -- 创建时间
    ,create_emp varchar2(100) -- 创建者
    ,create_user number(22,0) -- 创建人id
    ,update_time timestamp -- 更新时间
    ,update_user number(22,0) -- 更新者id
    ,update_emp varchar2(100) -- 更新者
    ,physics_flag number(1,0) -- 物理标识，默认1正常，2删除
    ,resp_msg varchar2(512) -- PPP返回信息
    ,ori_trx_dt varchar2(256) -- 
    ,post_msg varchar2(512) -- 附言
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
grant select on ${iol_schema}.amss_online_pay_order to ${iml_schema};
grant select on ${iol_schema}.amss_online_pay_order to ${icl_schema};
grant select on ${iol_schema}.amss_online_pay_order to ${idl_schema};
grant select on ${iol_schema}.amss_online_pay_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_online_pay_order is '网联代付交易表';
comment on column ${iol_schema}.amss_online_pay_order.online_pay_order_id is '网联代付订单表主键';
comment on column ${iol_schema}.amss_online_pay_order.ori_trx_seq is 'PPP交易流水号';
comment on column ${iol_schema}.amss_online_pay_order.order_num is '订单号';
comment on column ${iol_schema}.amss_online_pay_order.mgmt_platf_chn is '平台渠道号';
comment on column ${iol_schema}.amss_online_pay_order.sign_num is '协议编号';
comment on column ${iol_schema}.amss_online_pay_order.txn_amt is '订单金额';
comment on column ${iol_schema}.amss_online_pay_order.txn_status is '交易状态（0交易失败，1交易成功，2交易未明，3未支付）';
comment on column ${iol_schema}.amss_online_pay_order.txn_time is '交易时间';
comment on column ${iol_schema}.amss_online_pay_order.payer_acct is '支付，付款人账号）';
comment on column ${iol_schema}.amss_online_pay_order.payer_name is '支付，付款人名称）';
comment on column ${iol_schema}.amss_online_pay_order.payer_acct_typ is '支付，付款人账户类型（DEBIT个人银行借记账户';
comment on column ${iol_schema}.amss_online_pay_order.payer_acct_bcs_typ is '支付，付款人账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)';
comment on column ${iol_schema}.amss_online_pay_order.rcv_acct is '收款方银行账号';
comment on column ${iol_schema}.amss_online_pay_order.rcv_acct_name is '收款方账户名称';
comment on column ${iol_schema}.amss_online_pay_order.rcv_acct_typ is '收款方账户类型（DEBIT个人银行借记账户,CREDIT个人银行贷记账户，PUBLIC对公银行账户）';
comment on column ${iol_schema}.amss_online_pay_order.rcv_acct_bcs_typ is '收款方账户核心类型(DEBIT_HOST借记卡核心，EAS_HOST个人电子账户核心，EEA_HOST企业电子账户核心)';
comment on column ${iol_schema}.amss_online_pay_order.create_time is '创建时间';
comment on column ${iol_schema}.amss_online_pay_order.create_emp is '创建者';
comment on column ${iol_schema}.amss_online_pay_order.create_user is '创建人id';
comment on column ${iol_schema}.amss_online_pay_order.update_time is '更新时间';
comment on column ${iol_schema}.amss_online_pay_order.update_user is '更新者id';
comment on column ${iol_schema}.amss_online_pay_order.update_emp is '更新者';
comment on column ${iol_schema}.amss_online_pay_order.physics_flag is '物理标识，默认1正常，2删除';
comment on column ${iol_schema}.amss_online_pay_order.resp_msg is 'PPP返回信息';
comment on column ${iol_schema}.amss_online_pay_order.ori_trx_dt is '';
comment on column ${iol_schema}.amss_online_pay_order.post_msg is '附言';
comment on column ${iol_schema}.amss_online_pay_order.start_dt is '开始时间';
comment on column ${iol_schema}.amss_online_pay_order.end_dt is '结束时间';
comment on column ${iol_schema}.amss_online_pay_order.id_mark is '增删标志';
comment on column ${iol_schema}.amss_online_pay_order.etl_timestamp is 'ETL处理时间戳';
