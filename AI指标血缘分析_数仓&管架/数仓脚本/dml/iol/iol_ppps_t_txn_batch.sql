/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ppps_t_txn_batch
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ppps_t_txn_batch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ppps_t_txn_batch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_txn_batch_op purge;
drop table ${iol_schema}.ppps_t_txn_batch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_batch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_txn_batch where 0=1;

create table ${iol_schema}.ppps_t_txn_batch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ppps_t_txn_batch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_txn_batch_cl(
            id -- 自增主键
            ,global_no -- 全局流水号
            ,batch_no -- 平台批次号
            ,batch_date -- 平台交易日期，格式：yyyyMMdd
            ,batch_time -- 平台交易时间，格式：HHmmss
            ,sys_id -- 系统编号
            ,mcht_no -- 商户/支付机构编号
            ,tran_no -- 商户交易流水号，即请求的批次号
            ,tran_date -- 商户流水日期，格式：yyyyMMdd
            ,tran_time -- 产品编号
            ,action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,switch_type -- 转接类型（B2B-批转批；B2O-批转联）
            ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
            ,total_amount -- 总交易金额，默认：零元-0.00，单位：元
            ,total_count -- 总交易笔数
            ,fail_amount -- 失败金额，默认：零元-0.00，单位：元
            ,fail_count -- 失败笔数
            ,success_amount -- 成功金额，默认：零元-0.00，单位：元
            ,success_count -- 成功笔数
            ,batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
            ,ret_code -- 平台返回码
            ,ret_msg -- 平台返回码描述
            ,req_file_name -- 请求文件名称
            ,rsp_file_name -- 回盘文件名称
            ,teller_no -- 交易柜员号
            ,auth_teller_no -- 授权柜员号
            ,check_teller_no -- 复核柜员号
            ,trans_org_no -- 交易机构号
            ,consumer_id -- 调用方系统ID
            ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
            ,notify_addr -- 异步通知地址
            ,notify_service_name -- 异步通知服务名称
            ,log_id -- 交易日志文件ID
            ,server_id -- 交易服务器ID
            ,sharding -- 分库参考值专用字段，无业务含义
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,protocol_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 户名
            ,mer_id -- 商户号
            ,bill_code -- 费项代码
            ,bill_info -- 费项名称
            ,intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
            ,corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
            ,inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
            ,sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_txn_batch_op(
            id -- 自增主键
            ,global_no -- 全局流水号
            ,batch_no -- 平台批次号
            ,batch_date -- 平台交易日期，格式：yyyyMMdd
            ,batch_time -- 平台交易时间，格式：HHmmss
            ,sys_id -- 系统编号
            ,mcht_no -- 商户/支付机构编号
            ,tran_no -- 商户交易流水号，即请求的批次号
            ,tran_date -- 商户流水日期，格式：yyyyMMdd
            ,tran_time -- 产品编号
            ,action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,switch_type -- 转接类型（B2B-批转批；B2O-批转联）
            ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
            ,total_amount -- 总交易金额，默认：零元-0.00，单位：元
            ,total_count -- 总交易笔数
            ,fail_amount -- 失败金额，默认：零元-0.00，单位：元
            ,fail_count -- 失败笔数
            ,success_amount -- 成功金额，默认：零元-0.00，单位：元
            ,success_count -- 成功笔数
            ,batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
            ,ret_code -- 平台返回码
            ,ret_msg -- 平台返回码描述
            ,req_file_name -- 请求文件名称
            ,rsp_file_name -- 回盘文件名称
            ,teller_no -- 交易柜员号
            ,auth_teller_no -- 授权柜员号
            ,check_teller_no -- 复核柜员号
            ,trans_org_no -- 交易机构号
            ,consumer_id -- 调用方系统ID
            ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
            ,notify_addr -- 异步通知地址
            ,notify_service_name -- 异步通知服务名称
            ,log_id -- 交易日志文件ID
            ,server_id -- 交易服务器ID
            ,sharding -- 分库参考值专用字段，无业务含义
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,protocol_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 户名
            ,mer_id -- 商户号
            ,bill_code -- 费项代码
            ,bill_info -- 费项名称
            ,intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
            ,corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
            ,inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
            ,sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 自增主键
    ,nvl(n.global_no, o.global_no) as global_no -- 全局流水号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 平台批次号
    ,nvl(n.batch_date, o.batch_date) as batch_date -- 平台交易日期，格式：yyyyMMdd
    ,nvl(n.batch_time, o.batch_time) as batch_time -- 平台交易时间，格式：HHmmss
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户/支付机构编号
    ,nvl(n.tran_no, o.tran_no) as tran_no -- 商户交易流水号，即请求的批次号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 商户流水日期，格式：yyyyMMdd
    ,nvl(n.tran_time, o.tran_time) as tran_time -- 产品编号
    ,nvl(n.action_type, o.action_type) as action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,nvl(n.switch_type, o.switch_type) as switch_type -- 转接类型（B2B-批转批；B2O-批转联）
    ,nvl(n.currency, o.currency) as currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,nvl(n.total_amount, o.total_amount) as total_amount -- 总交易金额，默认：零元-0.00，单位：元
    ,nvl(n.total_count, o.total_count) as total_count -- 总交易笔数
    ,nvl(n.fail_amount, o.fail_amount) as fail_amount -- 失败金额，默认：零元-0.00，单位：元
    ,nvl(n.fail_count, o.fail_count) as fail_count -- 失败笔数
    ,nvl(n.success_amount, o.success_amount) as success_amount -- 成功金额，默认：零元-0.00，单位：元
    ,nvl(n.success_count, o.success_count) as success_count -- 成功笔数
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
    ,nvl(n.ret_code, o.ret_code) as ret_code -- 平台返回码
    ,nvl(n.ret_msg, o.ret_msg) as ret_msg -- 平台返回码描述
    ,nvl(n.req_file_name, o.req_file_name) as req_file_name -- 请求文件名称
    ,nvl(n.rsp_file_name, o.rsp_file_name) as rsp_file_name -- 回盘文件名称
    ,nvl(n.teller_no, o.teller_no) as teller_no -- 交易柜员号
    ,nvl(n.auth_teller_no, o.auth_teller_no) as auth_teller_no -- 授权柜员号
    ,nvl(n.check_teller_no, o.check_teller_no) as check_teller_no -- 复核柜员号
    ,nvl(n.trans_org_no, o.trans_org_no) as trans_org_no -- 交易机构号
    ,nvl(n.consumer_id, o.consumer_id) as consumer_id -- 调用方系统ID
    ,nvl(n.is_notify, o.is_notify) as is_notify -- 是否需要异步通知（Y：接受；N：不接受）
    ,nvl(n.notify_addr, o.notify_addr) as notify_addr -- 异步通知地址
    ,nvl(n.notify_service_name, o.notify_service_name) as notify_service_name -- 异步通知服务名称
    ,nvl(n.log_id, o.log_id) as log_id -- 交易日志文件ID
    ,nvl(n.server_id, o.server_id) as server_id -- 交易服务器ID
    ,nvl(n.sharding, o.sharding) as sharding -- 分库参考值专用字段，无业务含义
    ,nvl(n.remark, o.remark) as remark -- 备注信息
    ,nvl(n.create_time, o.create_time) as create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(n.update_time, o.update_time) as update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 协议号
    ,nvl(n.payee_acct_no, o.payee_acct_no) as payee_acct_no -- 收款账号
    ,nvl(n.payee_acct_name, o.payee_acct_name) as payee_acct_name -- 户名
    ,nvl(n.mer_id, o.mer_id) as mer_id -- 商户号
    ,nvl(n.bill_code, o.bill_code) as bill_code -- 费项代码
    ,nvl(n.bill_info, o.bill_info) as bill_info -- 费项名称
    ,nvl(n.intra_acct_no, o.intra_acct_no) as intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,nvl(n.intra_acct_name, o.intra_acct_name) as intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,nvl(n.corp_acct_num, o.corp_acct_num) as corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
    ,nvl(n.corp_acct_name, o.corp_acct_name) as corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
    ,nvl(n.inter_acct_flag, o.inter_acct_flag) as inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
    ,nvl(n.sign_flag, o.sign_flag) as sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
    ,case when
            n.mcht_no is null
            and n.tran_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_no is null
            and n.tran_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_no is null
            and n.tran_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ppps_t_txn_batch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ppps_t_txn_batch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_no = n.mcht_no
            and o.tran_no = n.tran_no
where (
        o.mcht_no is null
        and o.tran_no is null
    )
    or (
        n.mcht_no is null
        and n.tran_no is null
    )
    or (
        o.id <> n.id
        or o.global_no <> n.global_no
        or o.batch_no <> n.batch_no
        or o.batch_date <> n.batch_date
        or o.batch_time <> n.batch_time
        or o.sys_id <> n.sys_id
        or o.tran_date <> n.tran_date
        or o.tran_time <> n.tran_time
        or o.action_type <> n.action_type
        or o.trade_type <> n.trade_type
        or o.switch_type <> n.switch_type
        or o.currency <> n.currency
        or o.total_amount <> n.total_amount
        or o.total_count <> n.total_count
        or o.fail_amount <> n.fail_amount
        or o.fail_count <> n.fail_count
        or o.success_amount <> n.success_amount
        or o.success_count <> n.success_count
        or o.batch_status <> n.batch_status
        or o.ret_code <> n.ret_code
        or o.ret_msg <> n.ret_msg
        or o.req_file_name <> n.req_file_name
        or o.rsp_file_name <> n.rsp_file_name
        or o.teller_no <> n.teller_no
        or o.auth_teller_no <> n.auth_teller_no
        or o.check_teller_no <> n.check_teller_no
        or o.trans_org_no <> n.trans_org_no
        or o.consumer_id <> n.consumer_id
        or o.is_notify <> n.is_notify
        or o.notify_addr <> n.notify_addr
        or o.notify_service_name <> n.notify_service_name
        or o.log_id <> n.log_id
        or o.server_id <> n.server_id
        or o.sharding <> n.sharding
        or o.remark <> n.remark
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.protocol_no <> n.protocol_no
        or o.payee_acct_no <> n.payee_acct_no
        or o.payee_acct_name <> n.payee_acct_name
        or o.mer_id <> n.mer_id
        or o.bill_code <> n.bill_code
        or o.bill_info <> n.bill_info
        or o.intra_acct_no <> n.intra_acct_no
        or o.intra_acct_name <> n.intra_acct_name
        or o.corp_acct_num <> n.corp_acct_num
        or o.corp_acct_name <> n.corp_acct_name
        or o.inter_acct_flag <> n.inter_acct_flag
        or o.sign_flag <> n.sign_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ppps_t_txn_batch_cl(
            id -- 自增主键
            ,global_no -- 全局流水号
            ,batch_no -- 平台批次号
            ,batch_date -- 平台交易日期，格式：yyyyMMdd
            ,batch_time -- 平台交易时间，格式：HHmmss
            ,sys_id -- 系统编号
            ,mcht_no -- 商户/支付机构编号
            ,tran_no -- 商户交易流水号，即请求的批次号
            ,tran_date -- 商户流水日期，格式：yyyyMMdd
            ,tran_time -- 产品编号
            ,action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,switch_type -- 转接类型（B2B-批转批；B2O-批转联）
            ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
            ,total_amount -- 总交易金额，默认：零元-0.00，单位：元
            ,total_count -- 总交易笔数
            ,fail_amount -- 失败金额，默认：零元-0.00，单位：元
            ,fail_count -- 失败笔数
            ,success_amount -- 成功金额，默认：零元-0.00，单位：元
            ,success_count -- 成功笔数
            ,batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
            ,ret_code -- 平台返回码
            ,ret_msg -- 平台返回码描述
            ,req_file_name -- 请求文件名称
            ,rsp_file_name -- 回盘文件名称
            ,teller_no -- 交易柜员号
            ,auth_teller_no -- 授权柜员号
            ,check_teller_no -- 复核柜员号
            ,trans_org_no -- 交易机构号
            ,consumer_id -- 调用方系统ID
            ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
            ,notify_addr -- 异步通知地址
            ,notify_service_name -- 异步通知服务名称
            ,log_id -- 交易日志文件ID
            ,server_id -- 交易服务器ID
            ,sharding -- 分库参考值专用字段，无业务含义
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,protocol_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 户名
            ,mer_id -- 商户号
            ,bill_code -- 费项代码
            ,bill_info -- 费项名称
            ,intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
            ,corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
            ,inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
            ,sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ppps_t_txn_batch_op(
            id -- 自增主键
            ,global_no -- 全局流水号
            ,batch_no -- 平台批次号
            ,batch_date -- 平台交易日期，格式：yyyyMMdd
            ,batch_time -- 平台交易时间，格式：HHmmss
            ,sys_id -- 系统编号
            ,mcht_no -- 商户/支付机构编号
            ,tran_no -- 商户交易流水号，即请求的批次号
            ,tran_date -- 商户流水日期，格式：yyyyMMdd
            ,tran_time -- 产品编号
            ,action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
            ,switch_type -- 转接类型（B2B-批转批；B2O-批转联）
            ,currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
            ,total_amount -- 总交易金额，默认：零元-0.00，单位：元
            ,total_count -- 总交易笔数
            ,fail_amount -- 失败金额，默认：零元-0.00，单位：元
            ,fail_count -- 失败笔数
            ,success_amount -- 成功金额，默认：零元-0.00，单位：元
            ,success_count -- 成功笔数
            ,batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
            ,ret_code -- 平台返回码
            ,ret_msg -- 平台返回码描述
            ,req_file_name -- 请求文件名称
            ,rsp_file_name -- 回盘文件名称
            ,teller_no -- 交易柜员号
            ,auth_teller_no -- 授权柜员号
            ,check_teller_no -- 复核柜员号
            ,trans_org_no -- 交易机构号
            ,consumer_id -- 调用方系统ID
            ,is_notify -- 是否需要异步通知（Y：接受；N：不接受）
            ,notify_addr -- 异步通知地址
            ,notify_service_name -- 异步通知服务名称
            ,log_id -- 交易日志文件ID
            ,server_id -- 交易服务器ID
            ,sharding -- 分库参考值专用字段，无业务含义
            ,remark -- 备注信息
            ,create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
            ,update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
            ,protocol_no -- 协议号
            ,payee_acct_no -- 收款账号
            ,payee_acct_name -- 户名
            ,mer_id -- 商户号
            ,bill_code -- 费项代码
            ,bill_info -- 费项名称
            ,intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
            ,corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
            ,corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
            ,inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
            ,sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 自增主键
    ,o.global_no -- 全局流水号
    ,o.batch_no -- 平台批次号
    ,o.batch_date -- 平台交易日期，格式：yyyyMMdd
    ,o.batch_time -- 平台交易时间，格式：HHmmss
    ,o.sys_id -- 系统编号
    ,o.mcht_no -- 商户/支付机构编号
    ,o.tran_no -- 商户交易流水号，即请求的批次号
    ,o.tran_date -- 商户流水日期，格式：yyyyMMdd
    ,o.tran_time -- 产品编号
    ,o.action_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,o.trade_type -- 交易类别（PAYMENTS-批量代付；COLLECTIONS-批量代收；ONLINEPAYS-批量联机支付）
    ,o.switch_type -- 转接类型（B2B-批转批；B2O-批转联）
    ,o.currency -- 交易币种标识，默认：CNY-人民币，取值：CurrencyEnum
    ,o.total_amount -- 总交易金额，默认：零元-0.00，单位：元
    ,o.total_count -- 总交易笔数
    ,o.fail_amount -- 失败金额，默认：零元-0.00，单位：元
    ,o.fail_count -- 失败笔数
    ,o.success_amount -- 成功金额，默认：零元-0.00，单位：元
    ,o.success_count -- 成功笔数
    ,o.batch_status -- 批次状态（TRANS_INIT-初始；ACCEPTED-已受理等待处理；PROCESSING-正在处理中；PROCESSED-已处理；WAIT_RETURN-等待回盘；RETURNING-回盘中；RETURNED-已回盘）
    ,o.ret_code -- 平台返回码
    ,o.ret_msg -- 平台返回码描述
    ,o.req_file_name -- 请求文件名称
    ,o.rsp_file_name -- 回盘文件名称
    ,o.teller_no -- 交易柜员号
    ,o.auth_teller_no -- 授权柜员号
    ,o.check_teller_no -- 复核柜员号
    ,o.trans_org_no -- 交易机构号
    ,o.consumer_id -- 调用方系统ID
    ,o.is_notify -- 是否需要异步通知（Y：接受；N：不接受）
    ,o.notify_addr -- 异步通知地址
    ,o.notify_service_name -- 异步通知服务名称
    ,o.log_id -- 交易日志文件ID
    ,o.server_id -- 交易服务器ID
    ,o.sharding -- 分库参考值专用字段，无业务含义
    ,o.remark -- 备注信息
    ,o.create_time -- 流水创建时间，格式：yyyy-MM-dd HH:mm:ss
    ,o.update_time -- 流水最后更新时间，格式：yyyy-MM-dd HH:mm:ss
    ,o.protocol_no -- 协议号
    ,o.payee_acct_no -- 收款账号
    ,o.payee_acct_name -- 户名
    ,o.mer_id -- 商户号
    ,o.bill_code -- 费项代码
    ,o.bill_info -- 费项名称
    ,o.intra_acct_no -- 内部户账号（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,o.intra_acct_name -- 内部户名称（批转联交易：内部户标志为Y时必输;批转批交易：签约标志为N时必输）
    ,o.corp_acct_num -- 对公户账号（批转联交易：内部户标志为Y时必输）
    ,o.corp_acct_name -- 对公户户名（批转联交易：内部户标志为Y时必输）
    ,o.inter_acct_flag -- 内部户标志(Y-有 N-无 默认：N）
    ,o.sign_flag -- 签约标志(Y-已签约 N-未签约 默认：Y）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ppps_t_txn_batch_bk o
    left join ${iol_schema}.ppps_t_txn_batch_op n
        on
            o.mcht_no = n.mcht_no
            and o.tran_no = n.tran_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ppps_t_txn_batch_cl d
        on
            o.mcht_no = d.mcht_no
            and o.tran_no = d.tran_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ppps_t_txn_batch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ppps_t_txn_batch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ppps_t_txn_batch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ppps_t_txn_batch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ppps_t_txn_batch exchange partition p_${batch_date} with table ${iol_schema}.ppps_t_txn_batch_cl;
alter table ${iol_schema}.ppps_t_txn_batch exchange partition p_20991231 with table ${iol_schema}.ppps_t_txn_batch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ppps_t_txn_batch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ppps_t_txn_batch_op purge;
drop table ${iol_schema}.ppps_t_txn_batch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ppps_t_txn_batch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ppps_t_txn_batch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
