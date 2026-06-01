/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_txn_batch_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_txn_batch_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_txn_batch_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_batch_detail(
    id number(22) -- 自增主键
    ,global_no varchar2(64) -- 全局流水号
    ,batch_no varchar2(64) -- 平台批次号
    ,sub_batch_no varchar2(64) -- 平台子批次号
    ,detail_no varchar2(64) -- 明细序号
    ,txn_no varchar2(64) -- 平台流水号
    ,txn_date varchar2(8) -- 平台交易日期，格式：yyyyMMdd
    ,txn_time varchar2(6) -- 平台交易时间，格式：HHmmss
    ,corporate varchar2(64) -- 法人标识
    ,mcht_no varchar2(32) -- 商户/支付机构编号
    ,tran_no varchar2(64) -- 商户交易流水号
    ,tran_date varchar2(8) -- 商户流水日期，格式：yyyyMMdd
    ,tran_time varchar2(6) -- 商户流水时间，格式：HHmmss
    ,product_no varchar2(24) -- 产品编号
    ,status varchar2(30) -- 交易处理状态，取值：StatusEnum
    ,trade_type varchar2(24) -- 交易类别，例如：批量代付、批量代收，取值：TradeTypeEnum
    ,biz_type varchar2(24) -- 业务类型，例如：水电气缴费
    ,host_batch_no varchar2(64) -- 核心批次号
    ,amount number(18,2) -- 交易金额，默认：零元-0.00，单位：元
    ,currency varchar2(4) -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,account_number varchar2(40) -- 支付账号
    ,account_name varchar2(192) -- 支付户名
    ,smrycd varchar2(30) -- 摘要码，交易代码
    ,opp_account_number varchar2(40) -- 对手方账号
    ,opp_account_name varchar2(192) -- 对手方账户户名
    ,host_status varchar2(30) -- 交易核心账务状态
    ,host_no varchar2(64) -- 核心交易流水号
    ,pmc_code varchar2(12) -- 请求系统编码
    ,host_req_no varchar2(64) -- 核心请求流水号
    ,purpose varchar2(128) -- 交易附言
    ,ret_code varchar2(24) -- 平台返回码
    ,ret_msg varchar2(600) -- 平台返回码描述
    ,teller_no varchar2(30) -- 交易柜员号
    ,auth_teller_no varchar2(30) -- 授权柜员号
    ,check_teller_no varchar2(30) -- 复核柜员号
    ,trans_org_no varchar2(30) -- 交易机构号
    ,summary_code varchar2(30) -- 交易摘要码
    ,consumer_id varchar2(30) -- 调用方系统ID
    ,route_map_id varchar2(60) -- 明细扩展MAP编号
    ,route_map varchar2(4000) -- 明细扩展MAP的JSON串
    ,host_date varchar2(8) -- 核心响应日期（会计日期）
    ,host_time varchar2(6) -- 核心响应时间（会计时间）
    ,payment_method_type_id varchar2(60) -- 支付工具
    ,depend_tran_no varchar2(64) -- 依赖流水号
    ,real_amount number(18,2) -- 真实交易金额，默认：零元-0.00，单位：元
    ,book_type varchar2(2) -- 记账类型
    ,payment_action varchar2(64) -- 支付动作
    ,log_id varchar2(64) -- 交易日志文件ID
    ,server_id varchar2(64) -- 交易服务器ID
    ,sharding varchar2(64) -- 分库参考值专用字段，无业务含义
    ,remark varchar2(256) -- 备注信息
    ,create_time date -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time date -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,protocol_no varchar2(60) -- 收款方协议号
    ,ghb_fee_amount number(20,2) -- 本行手续费
    ,union_fee_amount number(20,2) -- 银联手续费
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
grant select on ${iol_schema}.ppps_t_txn_batch_detail to ${iml_schema};
grant select on ${iol_schema}.ppps_t_txn_batch_detail to ${icl_schema};
grant select on ${iol_schema}.ppps_t_txn_batch_detail to ${idl_schema};
grant select on ${iol_schema}.ppps_t_txn_batch_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_txn_batch_detail is '批次明细表';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.id is '自增主键';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.global_no is '全局流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.batch_no is '平台批次号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.sub_batch_no is '平台子批次号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.detail_no is '明细序号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.txn_no is '平台流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.txn_date is '平台交易日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.txn_time is '平台交易时间，格式：HHmmss';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.corporate is '法人标识';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.mcht_no is '商户/支付机构编号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.tran_no is '商户交易流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.tran_date is '商户流水日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.tran_time is '商户流水时间，格式：HHmmss';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.product_no is '产品编号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.status is '交易处理状态，取值：StatusEnum';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.trade_type is '交易类别，例如：批量代付、批量代收，取值：TradeTypeEnum';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.biz_type is '业务类型，例如：水电气缴费';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_batch_no is '核心批次号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.amount is '交易金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.currency is '交易币种标识，默认：CNY-人民币，取值：CurrencyEnum';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.account_number is '支付账号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.account_name is '支付户名';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.smrycd is '摘要码，交易代码';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.opp_account_number is '对手方账号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.opp_account_name is '对手方账户户名';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_status is '交易核心账务状态';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_no is '核心交易流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.pmc_code is '请求系统编码';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_req_no is '核心请求流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.purpose is '交易附言';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.ret_code is '平台返回码';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.ret_msg is '平台返回码描述';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.teller_no is '交易柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.auth_teller_no is '授权柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.check_teller_no is '复核柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.trans_org_no is '交易机构号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.summary_code is '交易摘要码';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.consumer_id is '调用方系统ID';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.route_map_id is '明细扩展MAP编号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.route_map is '明细扩展MAP的JSON串';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_date is '核心响应日期（会计日期）';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.host_time is '核心响应时间（会计时间）';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.payment_method_type_id is '支付工具';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.depend_tran_no is '依赖流水号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.real_amount is '真实交易金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.book_type is '记账类型';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.payment_action is '支付动作';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.log_id is '交易日志文件ID';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.server_id is '交易服务器ID';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.sharding is '分库参考值专用字段，无业务含义';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.remark is '备注信息';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.create_time is '流水创建时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.update_time is '流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.protocol_no is '收款方协议号';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.ghb_fee_amount is '本行手续费';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.union_fee_amount is '银联手续费';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_t_txn_batch_detail.etl_timestamp is 'ETL处理时间戳';
