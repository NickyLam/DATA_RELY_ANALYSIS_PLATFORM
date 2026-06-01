/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_tbl_df_order_txn
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
create table ${iol_schema}.amss_tbl_df_order_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_tbl_df_order_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tbl_df_order_txn_op purge;
drop table ${iol_schema}.amss_tbl_df_order_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tbl_df_order_txn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tbl_df_order_txn where 0=1;

create table ${iol_schema}.amss_tbl_df_order_txn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_tbl_df_order_txn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tbl_df_order_txn_cl(
            key_rsp -- 流水号
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,tran_channel -- 渠道号
            ,txn_num -- 交易码:1001 单笔代付 1002 批量代付
            ,access_type -- 接入类型
            ,txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
            ,trade_money -- 交易金额
            ,sum_count -- 总笔数
            ,batch_no -- 批次号
            ,file_name -- 文件名
            ,up_file_name -- 上传中台文件名
            ,succee_trade_money -- 成功交易金额
            ,succee_count -- 成功交易笔数
            ,fail_trade_money -- 失败交易金额
            ,fail_count -- 失败交易笔数
            ,out_order_no -- 渠道订单号
            ,res_code -- 响应码 0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,mcht_no -- 商户号
            ,accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
            ,accountnumber -- 支付账户
            ,accountname -- 支付账户户名
            ,channel_acct_no -- 内部户账号
            ,channel_acct_name -- 内部户账号名称
            ,cny -- 币种：默认值’人民币：156’
            ,bank_account_no -- 银行账号（收款）
            ,bank_account_name -- 账号名称（收款）
            ,bank_account_type -- 账户类型（收款）
            ,bank_belong_type -- 银行归属（收款）
            ,bank_account_lineno -- 收款银行联行号（收款）
            ,bank_name -- 收款银行名称（收款）
            ,cert_type_id -- 证件类型
            ,cert_no -- 证件号码
            ,cert_grantorg -- 证件授权机构
            ,phone -- 手机号
            ,public_note -- 附言
            ,tran_seq_no_ih -- 全局流水号
            ,host_key_ih -- 核心流水号
            ,tran_seq_no_up -- 银联商户订单号
            ,host_key_up -- 银联核心流水号(保留)
            ,tran_seq_no_ihc -- 业务全局流水号
            ,host_key_ihc -- 冲正核心流水号(保留)
            ,checking_date -- 检查时间
            ,trace_no -- 银联交易流水号
            ,settle_date -- 银联清算日期
            ,trace_time -- 银联交易时间
            ,mercht_flag -- 商户代付标识
            ,notice_thread_id -- 服务器ip
            ,bak_req -- 请求保留域
            ,bak_rsp -- 返回保留域
            ,bacth_sta -- 批次登记状态 00新建 01登记成功
            ,product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
            ,agent_no -- 代理商号
            ,agree_unit_no -- 协议单位编号
            ,agree_unit_name -- 协议单位名称
            ,api_id -- Api系统标识
            ,notify_url -- 异步通知地址
            ,opr_id -- 柜员编号
            ,current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
            ,df_file_path -- 代扣文件上传路径
            ,settle_file_path -- PPP回盘文件
            ,settle_no -- 结清批次编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tbl_df_order_txn_op(
            key_rsp -- 流水号
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,tran_channel -- 渠道号
            ,txn_num -- 交易码:1001 单笔代付 1002 批量代付
            ,access_type -- 接入类型
            ,txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
            ,trade_money -- 交易金额
            ,sum_count -- 总笔数
            ,batch_no -- 批次号
            ,file_name -- 文件名
            ,up_file_name -- 上传中台文件名
            ,succee_trade_money -- 成功交易金额
            ,succee_count -- 成功交易笔数
            ,fail_trade_money -- 失败交易金额
            ,fail_count -- 失败交易笔数
            ,out_order_no -- 渠道订单号
            ,res_code -- 响应码 0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,mcht_no -- 商户号
            ,accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
            ,accountnumber -- 支付账户
            ,accountname -- 支付账户户名
            ,channel_acct_no -- 内部户账号
            ,channel_acct_name -- 内部户账号名称
            ,cny -- 币种：默认值’人民币：156’
            ,bank_account_no -- 银行账号（收款）
            ,bank_account_name -- 账号名称（收款）
            ,bank_account_type -- 账户类型（收款）
            ,bank_belong_type -- 银行归属（收款）
            ,bank_account_lineno -- 收款银行联行号（收款）
            ,bank_name -- 收款银行名称（收款）
            ,cert_type_id -- 证件类型
            ,cert_no -- 证件号码
            ,cert_grantorg -- 证件授权机构
            ,phone -- 手机号
            ,public_note -- 附言
            ,tran_seq_no_ih -- 全局流水号
            ,host_key_ih -- 核心流水号
            ,tran_seq_no_up -- 银联商户订单号
            ,host_key_up -- 银联核心流水号(保留)
            ,tran_seq_no_ihc -- 业务全局流水号
            ,host_key_ihc -- 冲正核心流水号(保留)
            ,checking_date -- 检查时间
            ,trace_no -- 银联交易流水号
            ,settle_date -- 银联清算日期
            ,trace_time -- 银联交易时间
            ,mercht_flag -- 商户代付标识
            ,notice_thread_id -- 服务器ip
            ,bak_req -- 请求保留域
            ,bak_rsp -- 返回保留域
            ,bacth_sta -- 批次登记状态 00新建 01登记成功
            ,product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
            ,agent_no -- 代理商号
            ,agree_unit_no -- 协议单位编号
            ,agree_unit_name -- 协议单位名称
            ,api_id -- Api系统标识
            ,notify_url -- 异步通知地址
            ,opr_id -- 柜员编号
            ,current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
            ,df_file_path -- 代扣文件上传路径
            ,settle_file_path -- PPP回盘文件
            ,settle_no -- 结清批次编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_rsp, o.key_rsp) as key_rsp -- 流水号
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_time, o.tran_time) as tran_time -- 交易时间
    ,nvl(n.tran_channel, o.tran_channel) as tran_channel -- 渠道号
    ,nvl(n.txn_num, o.txn_num) as txn_num -- 交易码:1001 单笔代付 1002 批量代付
    ,nvl(n.access_type, o.access_type) as access_type -- 接入类型
    ,nvl(n.txn_sta, o.txn_sta) as txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
    ,nvl(n.trade_money, o.trade_money) as trade_money -- 交易金额
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 总笔数
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.file_name, o.file_name) as file_name -- 文件名
    ,nvl(n.up_file_name, o.up_file_name) as up_file_name -- 上传中台文件名
    ,nvl(n.succee_trade_money, o.succee_trade_money) as succee_trade_money -- 成功交易金额
    ,nvl(n.succee_count, o.succee_count) as succee_count -- 成功交易笔数
    ,nvl(n.fail_trade_money, o.fail_trade_money) as fail_trade_money -- 失败交易金额
    ,nvl(n.fail_count, o.fail_count) as fail_count -- 失败交易笔数
    ,nvl(n.out_order_no, o.out_order_no) as out_order_no -- 渠道订单号
    ,nvl(n.res_code, o.res_code) as res_code -- 响应码 0000：交易成功0001：交易失败
    ,nvl(n.res_desc, o.res_desc) as res_desc -- 响应码描述
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 支付账户
    ,nvl(n.accountname, o.accountname) as accountname -- 支付账户户名
    ,nvl(n.channel_acct_no, o.channel_acct_no) as channel_acct_no -- 内部户账号
    ,nvl(n.channel_acct_name, o.channel_acct_name) as channel_acct_name -- 内部户账号名称
    ,nvl(n.cny, o.cny) as cny -- 币种：默认值’人民币：156’
    ,nvl(n.bank_account_no, o.bank_account_no) as bank_account_no -- 银行账号（收款）
    ,nvl(n.bank_account_name, o.bank_account_name) as bank_account_name -- 账号名称（收款）
    ,nvl(n.bank_account_type, o.bank_account_type) as bank_account_type -- 账户类型（收款）
    ,nvl(n.bank_belong_type, o.bank_belong_type) as bank_belong_type -- 银行归属（收款）
    ,nvl(n.bank_account_lineno, o.bank_account_lineno) as bank_account_lineno -- 收款银行联行号（收款）
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 收款银行名称（收款）
    ,nvl(n.cert_type_id, o.cert_type_id) as cert_type_id -- 证件类型
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_grantorg, o.cert_grantorg) as cert_grantorg -- 证件授权机构
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.public_note, o.public_note) as public_note -- 附言
    ,nvl(n.tran_seq_no_ih, o.tran_seq_no_ih) as tran_seq_no_ih -- 全局流水号
    ,nvl(n.host_key_ih, o.host_key_ih) as host_key_ih -- 核心流水号
    ,nvl(n.tran_seq_no_up, o.tran_seq_no_up) as tran_seq_no_up -- 银联商户订单号
    ,nvl(n.host_key_up, o.host_key_up) as host_key_up -- 银联核心流水号(保留)
    ,nvl(n.tran_seq_no_ihc, o.tran_seq_no_ihc) as tran_seq_no_ihc -- 业务全局流水号
    ,nvl(n.host_key_ihc, o.host_key_ihc) as host_key_ihc -- 冲正核心流水号(保留)
    ,nvl(n.checking_date, o.checking_date) as checking_date -- 检查时间
    ,nvl(n.trace_no, o.trace_no) as trace_no -- 银联交易流水号
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 银联清算日期
    ,nvl(n.trace_time, o.trace_time) as trace_time -- 银联交易时间
    ,nvl(n.mercht_flag, o.mercht_flag) as mercht_flag -- 商户代付标识
    ,nvl(n.notice_thread_id, o.notice_thread_id) as notice_thread_id -- 服务器ip
    ,nvl(n.bak_req, o.bak_req) as bak_req -- 请求保留域
    ,nvl(n.bak_rsp, o.bak_rsp) as bak_rsp -- 返回保留域
    ,nvl(n.bacth_sta, o.bacth_sta) as bacth_sta -- 批次登记状态 00新建 01登记成功
    ,nvl(n.product_categories, o.product_categories) as product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
    ,nvl(n.agent_no, o.agent_no) as agent_no -- 代理商号
    ,nvl(n.agree_unit_no, o.agree_unit_no) as agree_unit_no -- 协议单位编号
    ,nvl(n.agree_unit_name, o.agree_unit_name) as agree_unit_name -- 协议单位名称
    ,nvl(n.api_id, o.api_id) as api_id -- Api系统标识
    ,nvl(n.notify_url, o.notify_url) as notify_url -- 异步通知地址
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 柜员编号
    ,nvl(n.current_sta, o.current_sta) as current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
    ,nvl(n.df_file_path, o.df_file_path) as df_file_path -- 代扣文件上传路径
    ,nvl(n.settle_file_path, o.settle_file_path) as settle_file_path -- PPP回盘文件
    ,nvl(n.settle_no, o.settle_no) as settle_no -- 结清批次编号
    ,case when
            n.key_rsp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_rsp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_rsp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_tbl_df_order_txn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_tbl_df_order_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_rsp = n.key_rsp
where (
        o.key_rsp is null
    )
    or (
        n.key_rsp is null
    )
    or (
        o.tran_date <> n.tran_date
        or o.tran_time <> n.tran_time
        or o.tran_channel <> n.tran_channel
        or o.txn_num <> n.txn_num
        or o.access_type <> n.access_type
        or o.txn_sta <> n.txn_sta
        or o.trade_money <> n.trade_money
        or o.sum_count <> n.sum_count
        or o.batch_no <> n.batch_no
        or o.file_name <> n.file_name
        or o.up_file_name <> n.up_file_name
        or o.succee_trade_money <> n.succee_trade_money
        or o.succee_count <> n.succee_count
        or o.fail_trade_money <> n.fail_trade_money
        or o.fail_count <> n.fail_count
        or o.out_order_no <> n.out_order_no
        or o.res_code <> n.res_code
        or o.res_desc <> n.res_desc
        or o.mcht_no <> n.mcht_no
        or o.accounttype <> n.accounttype
        or o.accountnumber <> n.accountnumber
        or o.accountname <> n.accountname
        or o.channel_acct_no <> n.channel_acct_no
        or o.channel_acct_name <> n.channel_acct_name
        or o.cny <> n.cny
        or o.bank_account_no <> n.bank_account_no
        or o.bank_account_name <> n.bank_account_name
        or o.bank_account_type <> n.bank_account_type
        or o.bank_belong_type <> n.bank_belong_type
        or o.bank_account_lineno <> n.bank_account_lineno
        or o.bank_name <> n.bank_name
        or o.cert_type_id <> n.cert_type_id
        or o.cert_no <> n.cert_no
        or o.cert_grantorg <> n.cert_grantorg
        or o.phone <> n.phone
        or o.public_note <> n.public_note
        or o.tran_seq_no_ih <> n.tran_seq_no_ih
        or o.host_key_ih <> n.host_key_ih
        or o.tran_seq_no_up <> n.tran_seq_no_up
        or o.host_key_up <> n.host_key_up
        or o.tran_seq_no_ihc <> n.tran_seq_no_ihc
        or o.host_key_ihc <> n.host_key_ihc
        or o.checking_date <> n.checking_date
        or o.trace_no <> n.trace_no
        or o.settle_date <> n.settle_date
        or o.trace_time <> n.trace_time
        or o.mercht_flag <> n.mercht_flag
        or o.notice_thread_id <> n.notice_thread_id
        or o.bak_req <> n.bak_req
        or o.bak_rsp <> n.bak_rsp
        or o.bacth_sta <> n.bacth_sta
        or o.product_categories <> n.product_categories
        or o.agent_no <> n.agent_no
        or o.agree_unit_no <> n.agree_unit_no
        or o.agree_unit_name <> n.agree_unit_name
        or o.api_id <> n.api_id
        or o.notify_url <> n.notify_url
        or o.opr_id <> n.opr_id
        or o.current_sta <> n.current_sta
        or o.df_file_path <> n.df_file_path
        or o.settle_file_path <> n.settle_file_path
        or o.settle_no <> n.settle_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_tbl_df_order_txn_cl(
            key_rsp -- 流水号
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,tran_channel -- 渠道号
            ,txn_num -- 交易码:1001 单笔代付 1002 批量代付
            ,access_type -- 接入类型
            ,txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
            ,trade_money -- 交易金额
            ,sum_count -- 总笔数
            ,batch_no -- 批次号
            ,file_name -- 文件名
            ,up_file_name -- 上传中台文件名
            ,succee_trade_money -- 成功交易金额
            ,succee_count -- 成功交易笔数
            ,fail_trade_money -- 失败交易金额
            ,fail_count -- 失败交易笔数
            ,out_order_no -- 渠道订单号
            ,res_code -- 响应码 0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,mcht_no -- 商户号
            ,accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
            ,accountnumber -- 支付账户
            ,accountname -- 支付账户户名
            ,channel_acct_no -- 内部户账号
            ,channel_acct_name -- 内部户账号名称
            ,cny -- 币种：默认值’人民币：156’
            ,bank_account_no -- 银行账号（收款）
            ,bank_account_name -- 账号名称（收款）
            ,bank_account_type -- 账户类型（收款）
            ,bank_belong_type -- 银行归属（收款）
            ,bank_account_lineno -- 收款银行联行号（收款）
            ,bank_name -- 收款银行名称（收款）
            ,cert_type_id -- 证件类型
            ,cert_no -- 证件号码
            ,cert_grantorg -- 证件授权机构
            ,phone -- 手机号
            ,public_note -- 附言
            ,tran_seq_no_ih -- 全局流水号
            ,host_key_ih -- 核心流水号
            ,tran_seq_no_up -- 银联商户订单号
            ,host_key_up -- 银联核心流水号(保留)
            ,tran_seq_no_ihc -- 业务全局流水号
            ,host_key_ihc -- 冲正核心流水号(保留)
            ,checking_date -- 检查时间
            ,trace_no -- 银联交易流水号
            ,settle_date -- 银联清算日期
            ,trace_time -- 银联交易时间
            ,mercht_flag -- 商户代付标识
            ,notice_thread_id -- 服务器ip
            ,bak_req -- 请求保留域
            ,bak_rsp -- 返回保留域
            ,bacth_sta -- 批次登记状态 00新建 01登记成功
            ,product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
            ,agent_no -- 代理商号
            ,agree_unit_no -- 协议单位编号
            ,agree_unit_name -- 协议单位名称
            ,api_id -- Api系统标识
            ,notify_url -- 异步通知地址
            ,opr_id -- 柜员编号
            ,current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
            ,df_file_path -- 代扣文件上传路径
            ,settle_file_path -- PPP回盘文件
            ,settle_no -- 结清批次编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_tbl_df_order_txn_op(
            key_rsp -- 流水号
            ,tran_date -- 交易日期
            ,tran_time -- 交易时间
            ,tran_channel -- 渠道号
            ,txn_num -- 交易码:1001 单笔代付 1002 批量代付
            ,access_type -- 接入类型
            ,txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
            ,trade_money -- 交易金额
            ,sum_count -- 总笔数
            ,batch_no -- 批次号
            ,file_name -- 文件名
            ,up_file_name -- 上传中台文件名
            ,succee_trade_money -- 成功交易金额
            ,succee_count -- 成功交易笔数
            ,fail_trade_money -- 失败交易金额
            ,fail_count -- 失败交易笔数
            ,out_order_no -- 渠道订单号
            ,res_code -- 响应码 0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,mcht_no -- 商户号
            ,accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
            ,accountnumber -- 支付账户
            ,accountname -- 支付账户户名
            ,channel_acct_no -- 内部户账号
            ,channel_acct_name -- 内部户账号名称
            ,cny -- 币种：默认值’人民币：156’
            ,bank_account_no -- 银行账号（收款）
            ,bank_account_name -- 账号名称（收款）
            ,bank_account_type -- 账户类型（收款）
            ,bank_belong_type -- 银行归属（收款）
            ,bank_account_lineno -- 收款银行联行号（收款）
            ,bank_name -- 收款银行名称（收款）
            ,cert_type_id -- 证件类型
            ,cert_no -- 证件号码
            ,cert_grantorg -- 证件授权机构
            ,phone -- 手机号
            ,public_note -- 附言
            ,tran_seq_no_ih -- 全局流水号
            ,host_key_ih -- 核心流水号
            ,tran_seq_no_up -- 银联商户订单号
            ,host_key_up -- 银联核心流水号(保留)
            ,tran_seq_no_ihc -- 业务全局流水号
            ,host_key_ihc -- 冲正核心流水号(保留)
            ,checking_date -- 检查时间
            ,trace_no -- 银联交易流水号
            ,settle_date -- 银联清算日期
            ,trace_time -- 银联交易时间
            ,mercht_flag -- 商户代付标识
            ,notice_thread_id -- 服务器ip
            ,bak_req -- 请求保留域
            ,bak_rsp -- 返回保留域
            ,bacth_sta -- 批次登记状态 00新建 01登记成功
            ,product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
            ,agent_no -- 代理商号
            ,agree_unit_no -- 协议单位编号
            ,agree_unit_name -- 协议单位名称
            ,api_id -- Api系统标识
            ,notify_url -- 异步通知地址
            ,opr_id -- 柜员编号
            ,current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
            ,df_file_path -- 代扣文件上传路径
            ,settle_file_path -- PPP回盘文件
            ,settle_no -- 结清批次编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_rsp -- 流水号
    ,o.tran_date -- 交易日期
    ,o.tran_time -- 交易时间
    ,o.tran_channel -- 渠道号
    ,o.txn_num -- 交易码:1001 单笔代付 1002 批量代付
    ,o.access_type -- 接入类型
    ,o.txn_sta -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
    ,o.trade_money -- 交易金额
    ,o.sum_count -- 总笔数
    ,o.batch_no -- 批次号
    ,o.file_name -- 文件名
    ,o.up_file_name -- 上传中台文件名
    ,o.succee_trade_money -- 成功交易金额
    ,o.succee_count -- 成功交易笔数
    ,o.fail_trade_money -- 失败交易金额
    ,o.fail_count -- 失败交易笔数
    ,o.out_order_no -- 渠道订单号
    ,o.res_code -- 响应码 0000：交易成功0001：交易失败
    ,o.res_desc -- 响应码描述
    ,o.mcht_no -- 商户号
    ,o.accounttype -- 支付账号类型 0:内部账号 1一类账号 2二类账号
    ,o.accountnumber -- 支付账户
    ,o.accountname -- 支付账户户名
    ,o.channel_acct_no -- 内部户账号
    ,o.channel_acct_name -- 内部户账号名称
    ,o.cny -- 币种：默认值’人民币：156’
    ,o.bank_account_no -- 银行账号（收款）
    ,o.bank_account_name -- 账号名称（收款）
    ,o.bank_account_type -- 账户类型（收款）
    ,o.bank_belong_type -- 银行归属（收款）
    ,o.bank_account_lineno -- 收款银行联行号（收款）
    ,o.bank_name -- 收款银行名称（收款）
    ,o.cert_type_id -- 证件类型
    ,o.cert_no -- 证件号码
    ,o.cert_grantorg -- 证件授权机构
    ,o.phone -- 手机号
    ,o.public_note -- 附言
    ,o.tran_seq_no_ih -- 全局流水号
    ,o.host_key_ih -- 核心流水号
    ,o.tran_seq_no_up -- 银联商户订单号
    ,o.host_key_up -- 银联核心流水号(保留)
    ,o.tran_seq_no_ihc -- 业务全局流水号
    ,o.host_key_ihc -- 冲正核心流水号(保留)
    ,o.checking_date -- 检查时间
    ,o.trace_no -- 银联交易流水号
    ,o.settle_date -- 银联清算日期
    ,o.trace_time -- 银联交易时间
    ,o.mercht_flag -- 商户代付标识
    ,o.notice_thread_id -- 服务器ip
    ,o.bak_req -- 请求保留域
    ,o.bak_rsp -- 返回保留域
    ,o.bacth_sta -- 批次登记状态 00新建 01登记成功
    ,o.product_categories -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
    ,o.agent_no -- 代理商号
    ,o.agree_unit_no -- 协议单位编号
    ,o.agree_unit_name -- 协议单位名称
    ,o.api_id -- Api系统标识
    ,o.notify_url -- 异步通知地址
    ,o.opr_id -- 柜员编号
    ,o.current_sta -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
    ,o.df_file_path -- 代扣文件上传路径
    ,o.settle_file_path -- PPP回盘文件
    ,o.settle_no -- 结清批次编号
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
from ${iol_schema}.amss_tbl_df_order_txn_bk o
    left join ${iol_schema}.amss_tbl_df_order_txn_op n
        on
            o.key_rsp = n.key_rsp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_tbl_df_order_txn_cl d
        on
            o.key_rsp = d.key_rsp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_tbl_df_order_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_tbl_df_order_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_tbl_df_order_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_tbl_df_order_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_tbl_df_order_txn exchange partition p_${batch_date} with table ${iol_schema}.amss_tbl_df_order_txn_cl;
alter table ${iol_schema}.amss_tbl_df_order_txn exchange partition p_20991231 with table ${iol_schema}.amss_tbl_df_order_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_tbl_df_order_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_tbl_df_order_txn_op purge;
drop table ${iol_schema}.amss_tbl_df_order_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_tbl_df_order_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_tbl_df_order_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
