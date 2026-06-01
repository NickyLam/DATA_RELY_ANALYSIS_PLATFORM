/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_txn_batch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_txn_batch
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_txn_batch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_batch(
    id number(22) -- 自增主键
    ,global_no varchar2(64) -- 全局流水号
    ,batch_no varchar2(64) -- 平台批次号
    ,batch_date varchar2(8) -- 平台交易日期，格式：yyyyMMdd
    ,batch_time varchar2(6) -- 平台交易时间，格式：HHmmss
    ,sys_id varchar2(10) -- 系统编号
    ,mcht_no varchar2(32) -- 商户/支付机构编号
    ,tran_no varchar2(64) -- 商户交易流水号，即请求的批次号
    ,tran_date varchar2(8) -- 商户流水日期，格式：yyyyMMdd
    ,tran_time varchar2(6) -- 产品编号
    ,action_type varchar2(24) -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,trade_type varchar2(24) -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,switch_type varchar2(24) -- 转接类型（B2B-批转批；B2O-批转联）
    ,currency varchar2(4) -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,total_amount number(18,2) -- 总交易金额，默认：零元-0.00，单位：元
    ,total_count number(22) -- 总交易笔数
    ,fail_amount number(18,2) -- 失败金额，默认：零元-0.00，单位：元
    ,fail_count number(22) -- 失败笔数
    ,success_amount number(18,2) -- 成功金额，默认：零元-0.00，单位：元
    ,success_count number(22) -- 成功笔数
    ,batch_status varchar2(30) -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
    ,ret_code varchar2(24) -- 平台返回码
    ,ret_msg varchar2(256) -- 平台返回码描述
    ,req_file_name varchar2(256) -- 请求文件名称
    ,rsp_file_name varchar2(256) -- 回盘文件名称
    ,teller_no varchar2(30) -- 交易柜员号
    ,auth_teller_no varchar2(30) -- 授权柜员号
    ,check_teller_no varchar2(30) -- 复核柜员号
    ,trans_org_no varchar2(30) -- 交易机构号
    ,consumer_id varchar2(30) -- 调用方系统ID
    ,is_notify varchar2(1) -- 是否需要异步通知（Y：接受；N：不接受）
    ,notify_addr varchar2(60) -- 异步通知地址
    ,notify_service_name varchar2(30) -- 异步通知服务名称
    ,log_id varchar2(64) -- 交易日志文件ID
    ,server_id varchar2(64) -- 交易服务器ID
    ,sharding varchar2(64) -- 分库参考值专用字段，无业务含义
    ,remark varchar2(256) -- 备注信息
    ,create_time date -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,update_time date -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,protocol_no varchar2(40) -- 协议号
    ,payee_acct_no varchar2(40) -- 收款账号
    ,payee_acct_name varchar2(150) -- 户名
    ,mer_id varchar2(20) -- 商户号
    ,bill_code varchar2(2) -- 费项代码
    ,bill_info varchar2(100) -- 费项名称
    ,intra_acct_no varchar2(64) -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,intra_acct_name varchar2(150) -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,corp_acct_num varchar2(64) -- 对公户账号（批转联交易：内部户标志为Y时必输）
    ,corp_acct_name varchar2(150) -- 对公户户名（批转联交易：内部户标志为Y时必输）
    ,inter_acct_flag varchar2(2) -- 内部户标志(Y-有 N-无 默认：N）
    ,sign_flag varchar2(2) -- 签约标志(Y-已签约 N-未签约 默认：Y）
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
grant select on ${iol_schema}.ppps_t_txn_batch to ${iml_schema};
grant select on ${iol_schema}.ppps_t_txn_batch to ${icl_schema};
grant select on ${iol_schema}.ppps_t_txn_batch to ${idl_schema};
grant select on ${iol_schema}.ppps_t_txn_batch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_txn_batch is '批量表';
comment on column ${iol_schema}.ppps_t_txn_batch.id is '自增主键';
comment on column ${iol_schema}.ppps_t_txn_batch.global_no is '全局流水号';
comment on column ${iol_schema}.ppps_t_txn_batch.batch_no is '平台批次号';
comment on column ${iol_schema}.ppps_t_txn_batch.batch_date is '平台交易日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_batch.batch_time is '平台交易时间，格式：HHmmss';
comment on column ${iol_schema}.ppps_t_txn_batch.sys_id is '系统编号';
comment on column ${iol_schema}.ppps_t_txn_batch.mcht_no is '商户/支付机构编号';
comment on column ${iol_schema}.ppps_t_txn_batch.tran_no is '商户交易流水号，即请求的批次号';
comment on column ${iol_schema}.ppps_t_txn_batch.tran_date is '商户流水日期，格式：yyyyMMdd';
comment on column ${iol_schema}.ppps_t_txn_batch.tran_time is '产品编号';
comment on column ${iol_schema}.ppps_t_txn_batch.action_type is '交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）';
comment on column ${iol_schema}.ppps_t_txn_batch.trade_type is '交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）';
comment on column ${iol_schema}.ppps_t_txn_batch.switch_type is '转接类型（B2B-批转批；B2O-批转联）';
comment on column ${iol_schema}.ppps_t_txn_batch.currency is '交易币种标识，默认：CNY-人民币，取值：CurrencyEnum';
comment on column ${iol_schema}.ppps_t_txn_batch.total_amount is '总交易金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_batch.total_count is '总交易笔数';
comment on column ${iol_schema}.ppps_t_txn_batch.fail_amount is '失败金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_batch.fail_count is '失败笔数';
comment on column ${iol_schema}.ppps_t_txn_batch.success_amount is '成功金额，默认：零元-0.00，单位：元';
comment on column ${iol_schema}.ppps_t_txn_batch.success_count is '成功笔数';
comment on column ${iol_schema}.ppps_t_txn_batch.batch_status is '批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）';
comment on column ${iol_schema}.ppps_t_txn_batch.ret_code is '平台返回码';
comment on column ${iol_schema}.ppps_t_txn_batch.ret_msg is '平台返回码描述';
comment on column ${iol_schema}.ppps_t_txn_batch.req_file_name is '请求文件名称';
comment on column ${iol_schema}.ppps_t_txn_batch.rsp_file_name is '回盘文件名称';
comment on column ${iol_schema}.ppps_t_txn_batch.teller_no is '交易柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch.auth_teller_no is '授权柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch.check_teller_no is '复核柜员号';
comment on column ${iol_schema}.ppps_t_txn_batch.trans_org_no is '交易机构号';
comment on column ${iol_schema}.ppps_t_txn_batch.consumer_id is '调用方系统ID';
comment on column ${iol_schema}.ppps_t_txn_batch.is_notify is '是否需要异步通知（Y：接受；N：不接受）';
comment on column ${iol_schema}.ppps_t_txn_batch.notify_addr is '异步通知地址';
comment on column ${iol_schema}.ppps_t_txn_batch.notify_service_name is '异步通知服务名称';
comment on column ${iol_schema}.ppps_t_txn_batch.log_id is '交易日志文件ID';
comment on column ${iol_schema}.ppps_t_txn_batch.server_id is '交易服务器ID';
comment on column ${iol_schema}.ppps_t_txn_batch.sharding is '分库参考值专用字段，无业务含义';
comment on column ${iol_schema}.ppps_t_txn_batch.remark is '备注信息';
comment on column ${iol_schema}.ppps_t_txn_batch.create_time is '流水创建时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_batch.update_time is '流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_batch.protocol_no is '协议号';
comment on column ${iol_schema}.ppps_t_txn_batch.payee_acct_no is '收款账号';
comment on column ${iol_schema}.ppps_t_txn_batch.payee_acct_name is '户名';
comment on column ${iol_schema}.ppps_t_txn_batch.mer_id is '商户号';
comment on column ${iol_schema}.ppps_t_txn_batch.bill_code is '费项代码';
comment on column ${iol_schema}.ppps_t_txn_batch.bill_info is '费项名称';
comment on column ${iol_schema}.ppps_t_txn_batch.intra_acct_no is '内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）';
comment on column ${iol_schema}.ppps_t_txn_batch.intra_acct_name is '内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）';
comment on column ${iol_schema}.ppps_t_txn_batch.corp_acct_num is '对公户账号（批转联交易：内部户标志为Y时必输）';
comment on column ${iol_schema}.ppps_t_txn_batch.corp_acct_name is '对公户户名（批转联交易：内部户标志为Y时必输）';
comment on column ${iol_schema}.ppps_t_txn_batch.inter_acct_flag is '内部户标志(Y-有 N-无 默认：N）';
comment on column ${iol_schema}.ppps_t_txn_batch.sign_flag is '签约标志(Y-已签约 N-未签约 默认：Y）';
comment on column ${iol_schema}.ppps_t_txn_batch.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_t_txn_batch.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_t_txn_batch.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_t_txn_batch.etl_timestamp is 'ETL处理时间戳';
