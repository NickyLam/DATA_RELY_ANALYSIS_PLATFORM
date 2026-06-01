/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_transfer_order_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_transfer_order_detail
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_transfer_order_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transfer_order_detail(
    tod_orderno varchar2(15) -- 预约号
    ,tod_trade_flowno varchar2(32) -- 流水号
    ,tod_transcode varchar2(64) -- 交易编码
    ,tod_payeracno varchar2(32) -- 转出帐号
    ,tod_payeracname varchar2(128) -- 转出帐号户名
    ,tod_payerdeptid varchar2(16) -- 付款账号机构号
    ,tod_payerbankactype varchar2(4) -- 付款账号账户类型
    ,tod_currency varchar2(3) -- 币种
    ,tod_payeeacno varchar2(40) -- 收款账号
    ,tod_payeeacname varchar2(128) -- 收款账号户名
    ,tod_payeebankactype varchar2(4) -- 转入账号账户类型
    ,tod_amount number(15,2) -- 交易金额
    ,tod_remark varchar2(150) -- 附言
    ,tod_fee number(15,2) -- 费用
    ,tod_executeday varchar2(2) -- 执行日期
    ,tod_isnormal varchar2(1) -- 是否加急
    ,tod_hold_fund_id varchar2(38) -- 止付编号
    ,tod_txn_narrative varchar2(80) -- 止付原因
    ,tod_release_ref_nbr varchar2(20) -- 解付备考号
    ,tod_valuedate varchar2(14) -- 转账日期
    ,tod_intrate varchar2(20) -- 费率
    ,tod_rflag varchar2(1) -- 钞汇标志
    ,tod_payeecurrency varchar2(3) -- 收款人币种
    ,tod_payeebankid varchar2(16) -- 收款行行号
    ,tod_payeebankname varchar2(64) -- 收款行名
    ,tod_provincecode varchar2(16) -- 收款行省号
    ,tod_provincename varchar2(64) -- 收款行省名
    ,tod_citycode varchar2(16) -- 收款行城市号
    ,tod_cityname varchar2(128) -- 收款行城市名
    ,tod_bankcode varchar2(20) -- 交换号/联行号
    ,tod_lname varchar2(255) -- 收款人网点名称
    ,tod_dreccode varchar2(12) -- 收款人清算行号
    ,tod_payeemobile varchar2(16) -- 收款人手机号
    ,tod_payeesms varchar2(16) -- 收款人短信
    ,tod_notecode varchar2(64) -- 付款用途
    ,tod_finalfee number(15,2) -- 最终手续费
    ,tod_discount varchar2(16) -- 折扣
    ,tod_trspassword varchar2(256) -- 交易密码
    ,tod_notifypayeeflag varchar2(1) -- 是否通知收款人
    ,tod_savepayeeflag varchar2(1) -- 是否保存收款人
    ,tod_payeeciftype varchar2(1) -- 收款人客户类型
    ,tod_groundflag varchar2(1) -- 落地标志
    ,tod_validatemsg varchar2(256) -- 验证信息
    ,tod_discountrate number(15,2) -- 手续费折扣率
    ,tod_parentfee number(15,2) -- 实收手续费
    ,tod_sysflag varchar2(1) -- 标识行内行外
    ,tod_parentaccno varchar2(32) -- 父流水号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_transfer_order_detail to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_detail to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_detail to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_transfer_order_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_transfer_order_detail is '预约转账明细表';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_orderno is '预约号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_trade_flowno is '流水号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_transcode is '交易编码';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeracno is '转出帐号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeracname is '转出帐号户名';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payerdeptid is '付款账号机构号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payerbankactype is '付款账号账户类型';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_currency is '币种';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeeacno is '收款账号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeeacname is '收款账号户名';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeebankactype is '转入账号账户类型';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_amount is '交易金额';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_remark is '附言';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_fee is '费用';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_executeday is '执行日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_isnormal is '是否加急';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_hold_fund_id is '止付编号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_txn_narrative is '止付原因';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_release_ref_nbr is '解付备考号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_valuedate is '转账日期';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_intrate is '费率';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_rflag is '钞汇标志';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeecurrency is '收款人币种';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeebankid is '收款行行号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeebankname is '收款行名';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_provincecode is '收款行省号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_provincename is '收款行省名';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_citycode is '收款行城市号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_cityname is '收款行城市名';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_bankcode is '交换号/联行号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_lname is '收款人网点名称';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_dreccode is '收款人清算行号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeemobile is '收款人手机号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeesms is '收款人短信';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_notecode is '付款用途';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_finalfee is '最终手续费';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_discount is '折扣';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_trspassword is '交易密码';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_notifypayeeflag is '是否通知收款人';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_savepayeeflag is '是否保存收款人';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_payeeciftype is '收款人客户类型';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_groundflag is '落地标志';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_validatemsg is '验证信息';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_discountrate is '手续费折扣率';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_parentfee is '实收手续费';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_sysflag is '标识行内行外';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.tod_parentaccno is '父流水号';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_transfer_order_detail.etl_timestamp is 'ETL处理时间戳';
