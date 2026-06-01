/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cust_dpc_draft_trans_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.bdms_cust_dpc_draft_trans_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cust_dpc_draft_trans_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info_op purge;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_dpc_draft_trans_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.bdms_cust_dpc_draft_trans_info where 0=1;

create table ${iol_schema}.bdms_cust_dpc_draft_trans_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.bdms_cust_dpc_draft_trans_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.bdms_cust_dpc_draft_trans_info_op(
        id -- ID
        ,draft_id -- 票据表ID
        ,apply_id -- 签收表ID
        ,product_no -- 产品码
        ,draft_attr -- 票据介质： 1 纸票 2 电票
        ,draft_type -- 票据类型： 1 银承 2 商承
        ,busi_type -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
        ,busi_attr_no -- 业务属性号
        ,product_name -- 产品名称
        ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
        ,draft_number -- 票据（包）号
        ,cd_range -- 子票区间
        ,draft_amount -- 票据（包）金额
        ,buss_flag -- 业务方向： 01 申请 02 接收 03 通知
        ,txn_date -- 交易日期
        ,req_buss_type -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,req_name -- 请求方名称
        ,req_cert_no -- 请求方社会信用代码
        ,req_dist_tp -- 请求方识别类型： DT01 票据账户 DT02 银行账户
        ,req_account -- 请求方账号
        ,req_bank_no -- 请求方开户行行号
        ,req_mem_no -- 请求方会员代码
        ,req_brh_no -- 请求方机构代码
        ,req_misc -- 请求方备注
        ,rcv_buss_type -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,rcv_name -- 接收方名称
        ,rcv_cert_no -- 接收方社会信用代码
        ,rcv_dist_tp -- 接收方识别类型： DT01 票据账户 DT02 银行账户
        ,rcv_account -- 接收方账号
        ,rcv_bank_no -- 接收方开户行行号
        ,rcv_mem_no -- 接收方会员代码
        ,rcv_brh_no -- 接收方机构代码
        ,rcv_misc -- 接收方备注
        ,rate -- 贴现利率
        ,pay_amount -- 贴现实付金额
        ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
        ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,back_begin_date -- 贴现赎回开放日
        ,back_end_date -- 贴现赎回截止日
        ,back_rate -- 赎回利率
        ,back_amt -- 赎回金额
        ,trade_conct_no -- 交易合同编号
        ,invc_nb -- 发票号码
        ,btch_nb -- 批次号
        ,aoa_account -- 入账账号
        ,aoa_bank_no -- 入账行号
        ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
        ,sign_date -- 签收日期
        ,refuse_reason_code -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
        ,refuse_remark -- 拒付备注信息
        ,recovery_type -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
        ,pay_type -- 付息方式
        ,pay_interest -- 实付利息
        ,payment_date -- 计息到期日
        ,interest_payer_name -- 付息人名称
        ,interest_payer_account -- 付息人帐号
        ,interest_payer_bank_name -- 付息人开户行行名
        ,charge -- 手续费
        ,expenses -- 工本费
        ,agent_name -- 代理人名称
        ,payer_sale -- 付息比例
        ,buyer_interest -- 买方付息
        ,interest -- 总利息
        ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
        ,stop_pay_rsn -- 止付原因
        ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
        ,relieve_stp_rsn -- 解除止付原因
        ,tenor_days -- 剩余期限
        ,settle_amt -- 结算金额
        ,inner_flag -- 是否系统内： 0 否 1 是
        ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
        ,msg_status -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
        ,process_code -- 报文处理码
        ,process_msg -- 报文处理信息
        ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
        ,settle_date -- 结算日期
        ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
        ,create_opr -- 创建人
        ,create_time -- 创建时间
        ,last_upd_opr -- 最后操作人
        ,last_upd_time -- 最后修改时间
        ,misc -- 备注域
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,req_account_name -- 请求方账号名称
        ,rcv_account_name -- 接收方账号名称
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.id -- ID
    ,n.draft_id -- 票据表ID
    ,n.apply_id -- 签收表ID
    ,n.product_no -- 产品码
    ,n.draft_attr -- 票据介质： 1 纸票 2 电票
    ,n.draft_type -- 票据类型： 1 银承 2 商承
    ,n.busi_type -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
    ,n.busi_attr_no -- 业务属性号
    ,n.product_name -- 产品名称
    ,n.product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,n.draft_number -- 票据（包）号
    ,n.cd_range -- 子票区间
    ,n.draft_amount -- 票据（包）金额
    ,n.buss_flag -- 业务方向： 01 申请 02 接收 03 通知
    ,n.txn_date -- 交易日期
    ,n.req_buss_type -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,n.req_name -- 请求方名称
    ,n.req_cert_no -- 请求方社会信用代码
    ,n.req_dist_tp -- 请求方识别类型： DT01 票据账户 DT02 银行账户
    ,n.req_account -- 请求方账号
    ,n.req_bank_no -- 请求方开户行行号
    ,n.req_mem_no -- 请求方会员代码
    ,n.req_brh_no -- 请求方机构代码
    ,n.req_misc -- 请求方备注
    ,n.rcv_buss_type -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,n.rcv_name -- 接收方名称
    ,n.rcv_cert_no -- 接收方社会信用代码
    ,n.rcv_dist_tp -- 接收方识别类型： DT01 票据账户 DT02 银行账户
    ,n.rcv_account -- 接收方账号
    ,n.rcv_bank_no -- 接收方开户行行号
    ,n.rcv_mem_no -- 接收方会员代码
    ,n.rcv_brh_no -- 接收方机构代码
    ,n.rcv_misc -- 接收方备注
    ,n.rate -- 贴现利率
    ,n.pay_amount -- 贴现实付金额
    ,n.transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,n.sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,n.back_begin_date -- 贴现赎回开放日
    ,n.back_end_date -- 贴现赎回截止日
    ,n.back_rate -- 赎回利率
    ,n.back_amt -- 赎回金额
    ,n.trade_conct_no -- 交易合同编号
    ,n.invc_nb -- 发票号码
    ,n.btch_nb -- 批次号
    ,n.aoa_account -- 入账账号
    ,n.aoa_bank_no -- 入账行号
    ,n.sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,n.sign_date -- 签收日期
    ,n.refuse_reason_code -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
    ,n.refuse_remark -- 拒付备注信息
    ,n.recovery_type -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
    ,n.pay_type -- 付息方式
    ,n.pay_interest -- 实付利息
    ,n.payment_date -- 计息到期日
    ,n.interest_payer_name -- 付息人名称
    ,n.interest_payer_account -- 付息人帐号
    ,n.interest_payer_bank_name -- 付息人开户行行名
    ,n.charge -- 手续费
    ,n.expenses -- 工本费
    ,n.agent_name -- 代理人名称
    ,n.payer_sale -- 付息比例
    ,n.buyer_interest -- 买方付息
    ,n.interest -- 总利息
    ,n.stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,n.stop_pay_rsn -- 止付原因
    ,n.relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,n.relieve_stp_rsn -- 解除止付原因
    ,n.tenor_days -- 剩余期限
    ,n.settle_amt -- 结算金额
    ,n.inner_flag -- 是否系统内： 0 否 1 是
    ,n.trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,n.msg_status -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,n.process_code -- 报文处理码
    ,n.process_msg -- 报文处理信息
    ,n.settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,n.settle_date -- 结算日期
    ,n.settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,n.create_opr -- 创建人
    ,n.create_time -- 创建时间
    ,n.last_upd_opr -- 最后操作人
    ,n.last_upd_time -- 最后修改时间
    ,n.misc -- 备注域
    ,n.reserve1 -- 备用字段1
    ,n.reserve2 -- 备用字段2
    ,n.reserve3 -- 备用字段3
    ,n.req_account_name -- 请求方账号名称
    ,n.rcv_account_name -- 接收方账号名称
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cust_dpc_draft_trans_info_bk o
    right join (select * from ${itl_schema}.bdms_cust_dpc_draft_trans_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        o.draft_id <> n.draft_id
        or o.apply_id <> n.apply_id
        or o.product_no <> n.product_no
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.busi_type <> n.busi_type
        or o.busi_attr_no <> n.busi_attr_no
        or o.product_name <> n.product_name
        or o.product_type <> n.product_type
        or o.draft_number <> n.draft_number
        or o.cd_range <> n.cd_range
        or o.draft_amount <> n.draft_amount
        or o.buss_flag <> n.buss_flag
        or o.txn_date <> n.txn_date
        or o.req_buss_type <> n.req_buss_type
        or o.req_name <> n.req_name
        or o.req_cert_no <> n.req_cert_no
        or o.req_dist_tp <> n.req_dist_tp
        or o.req_account <> n.req_account
        or o.req_bank_no <> n.req_bank_no
        or o.req_mem_no <> n.req_mem_no
        or o.req_brh_no <> n.req_brh_no
        or o.req_misc <> n.req_misc
        or o.rcv_buss_type <> n.rcv_buss_type
        or o.rcv_name <> n.rcv_name
        or o.rcv_cert_no <> n.rcv_cert_no
        or o.rcv_dist_tp <> n.rcv_dist_tp
        or o.rcv_account <> n.rcv_account
        or o.rcv_bank_no <> n.rcv_bank_no
        or o.rcv_mem_no <> n.rcv_mem_no
        or o.rcv_brh_no <> n.rcv_brh_no
        or o.rcv_misc <> n.rcv_misc
        or o.rate <> n.rate
        or o.pay_amount <> n.pay_amount
        or o.transfer_flag <> n.transfer_flag
        or o.sttlm_mk <> n.sttlm_mk
        or o.back_begin_date <> n.back_begin_date
        or o.back_end_date <> n.back_end_date
        or o.back_rate <> n.back_rate
        or o.back_amt <> n.back_amt
        or o.trade_conct_no <> n.trade_conct_no
        or o.invc_nb <> n.invc_nb
        or o.btch_nb <> n.btch_nb
        or o.aoa_account <> n.aoa_account
        or o.aoa_bank_no <> n.aoa_bank_no
        or o.sign_mk <> n.sign_mk
        or o.sign_date <> n.sign_date
        or o.refuse_reason_code <> n.refuse_reason_code
        or o.refuse_remark <> n.refuse_remark
        or o.recovery_type <> n.recovery_type
        or o.pay_type <> n.pay_type
        or o.pay_interest <> n.pay_interest
        or o.payment_date <> n.payment_date
        or o.interest_payer_name <> n.interest_payer_name
        or o.interest_payer_account <> n.interest_payer_account
        or o.interest_payer_bank_name <> n.interest_payer_bank_name
        or o.charge <> n.charge
        or o.expenses <> n.expenses
        or o.agent_name <> n.agent_name
        or o.payer_sale <> n.payer_sale
        or o.buyer_interest <> n.buyer_interest
        or o.interest <> n.interest
        or o.stop_pay_type <> n.stop_pay_type
        or o.stop_pay_rsn <> n.stop_pay_rsn
        or o.relieve_stp_type <> n.relieve_stp_type
        or o.relieve_stp_rsn <> n.relieve_stp_rsn
        or o.tenor_days <> n.tenor_days
        or o.settle_amt <> n.settle_amt
        or o.inner_flag <> n.inner_flag
        or o.trans_status <> n.trans_status
        or o.msg_status <> n.msg_status
        or o.process_code <> n.process_code
        or o.process_msg <> n.process_msg
        or o.settle_result <> n.settle_result
        or o.settle_date <> n.settle_date
        or o.settle_type <> n.settle_type
        or o.create_opr <> n.create_opr
        or o.create_time <> n.create_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.req_account_name <> n.req_account_name
        or o.rcv_account_name <> n.rcv_account_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cust_dpc_draft_trans_info_cl(
            id -- ID
        ,draft_id -- 票据表ID
        ,apply_id -- 签收表ID
        ,product_no -- 产品码
        ,draft_attr -- 票据介质： 1 纸票 2 电票
        ,draft_type -- 票据类型： 1 银承 2 商承
        ,busi_type -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
        ,busi_attr_no -- 业务属性号
        ,product_name -- 产品名称
        ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
        ,draft_number -- 票据（包）号
        ,cd_range -- 子票区间
        ,draft_amount -- 票据（包）金额
        ,buss_flag -- 业务方向： 01 申请 02 接收 03 通知
        ,txn_date -- 交易日期
        ,req_buss_type -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,req_name -- 请求方名称
        ,req_cert_no -- 请求方社会信用代码
        ,req_dist_tp -- 请求方识别类型： DT01 票据账户 DT02 银行账户
        ,req_account -- 请求方账号
        ,req_bank_no -- 请求方开户行行号
        ,req_mem_no -- 请求方会员代码
        ,req_brh_no -- 请求方机构代码
        ,req_misc -- 请求方备注
        ,rcv_buss_type -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,rcv_name -- 接收方名称
        ,rcv_cert_no -- 接收方社会信用代码
        ,rcv_dist_tp -- 接收方识别类型： DT01 票据账户 DT02 银行账户
        ,rcv_account -- 接收方账号
        ,rcv_bank_no -- 接收方开户行行号
        ,rcv_mem_no -- 接收方会员代码
        ,rcv_brh_no -- 接收方机构代码
        ,rcv_misc -- 接收方备注
        ,rate -- 贴现利率
        ,pay_amount -- 贴现实付金额
        ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
        ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,back_begin_date -- 贴现赎回开放日
        ,back_end_date -- 贴现赎回截止日
        ,back_rate -- 赎回利率
        ,back_amt -- 赎回金额
        ,trade_conct_no -- 交易合同编号
        ,invc_nb -- 发票号码
        ,btch_nb -- 批次号
        ,aoa_account -- 入账账号
        ,aoa_bank_no -- 入账行号
        ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
        ,sign_date -- 签收日期
        ,refuse_reason_code -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
        ,refuse_remark -- 拒付备注信息
        ,recovery_type -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
        ,pay_type -- 付息方式
        ,pay_interest -- 实付利息
        ,payment_date -- 计息到期日
        ,interest_payer_name -- 付息人名称
        ,interest_payer_account -- 付息人帐号
        ,interest_payer_bank_name -- 付息人开户行行名
        ,charge -- 手续费
        ,expenses -- 工本费
        ,agent_name -- 代理人名称
        ,payer_sale -- 付息比例
        ,buyer_interest -- 买方付息
        ,interest -- 总利息
        ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
        ,stop_pay_rsn -- 止付原因
        ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
        ,relieve_stp_rsn -- 解除止付原因
        ,tenor_days -- 剩余期限
        ,settle_amt -- 结算金额
        ,inner_flag -- 是否系统内： 0 否 1 是
        ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
        ,msg_status -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
        ,process_code -- 报文处理码
        ,process_msg -- 报文处理信息
        ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
        ,settle_date -- 结算日期
        ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
        ,create_opr -- 创建人
        ,create_time -- 创建时间
        ,last_upd_opr -- 最后操作人
        ,last_upd_time -- 最后修改时间
        ,misc -- 备注域
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,req_account_name -- 请求方账号名称
        ,rcv_account_name -- 接收方账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cust_dpc_draft_trans_info_op(
            id -- ID
        ,draft_id -- 票据表ID
        ,apply_id -- 签收表ID
        ,product_no -- 产品码
        ,draft_attr -- 票据介质： 1 纸票 2 电票
        ,draft_type -- 票据类型： 1 银承 2 商承
        ,busi_type -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
        ,busi_attr_no -- 业务属性号
        ,product_name -- 产品名称
        ,product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
        ,draft_number -- 票据（包）号
        ,cd_range -- 子票区间
        ,draft_amount -- 票据（包）金额
        ,buss_flag -- 业务方向： 01 申请 02 接收 03 通知
        ,txn_date -- 交易日期
        ,req_buss_type -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,req_name -- 请求方名称
        ,req_cert_no -- 请求方社会信用代码
        ,req_dist_tp -- 请求方识别类型： DT01 票据账户 DT02 银行账户
        ,req_account -- 请求方账号
        ,req_bank_no -- 请求方开户行行号
        ,req_mem_no -- 请求方会员代码
        ,req_brh_no -- 请求方机构代码
        ,req_misc -- 请求方备注
        ,rcv_buss_type -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
        ,rcv_name -- 接收方名称
        ,rcv_cert_no -- 接收方社会信用代码
        ,rcv_dist_tp -- 接收方识别类型： DT01 票据账户 DT02 银行账户
        ,rcv_account -- 接收方账号
        ,rcv_bank_no -- 接收方开户行行号
        ,rcv_mem_no -- 接收方会员代码
        ,rcv_brh_no -- 接收方机构代码
        ,rcv_misc -- 接收方备注
        ,rate -- 贴现利率
        ,pay_amount -- 贴现实付金额
        ,transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
        ,sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
        ,back_begin_date -- 贴现赎回开放日
        ,back_end_date -- 贴现赎回截止日
        ,back_rate -- 赎回利率
        ,back_amt -- 赎回金额
        ,trade_conct_no -- 交易合同编号
        ,invc_nb -- 发票号码
        ,btch_nb -- 批次号
        ,aoa_account -- 入账账号
        ,aoa_bank_no -- 入账行号
        ,sign_mk -- 应答标识： SU00 同意 SU01 拒绝
        ,sign_date -- 签收日期
        ,refuse_reason_code -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
        ,refuse_remark -- 拒付备注信息
        ,recovery_type -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
        ,pay_type -- 付息方式
        ,pay_interest -- 实付利息
        ,payment_date -- 计息到期日
        ,interest_payer_name -- 付息人名称
        ,interest_payer_account -- 付息人帐号
        ,interest_payer_bank_name -- 付息人开户行行名
        ,charge -- 手续费
        ,expenses -- 工本费
        ,agent_name -- 代理人名称
        ,payer_sale -- 付息比例
        ,buyer_interest -- 买方付息
        ,interest -- 总利息
        ,stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
        ,stop_pay_rsn -- 止付原因
        ,relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
        ,relieve_stp_rsn -- 解除止付原因
        ,tenor_days -- 剩余期限
        ,settle_amt -- 结算金额
        ,inner_flag -- 是否系统内： 0 否 1 是
        ,trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
        ,msg_status -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
        ,process_code -- 报文处理码
        ,process_msg -- 报文处理信息
        ,settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
        ,settle_date -- 结算日期
        ,settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
        ,create_opr -- 创建人
        ,create_time -- 创建时间
        ,last_upd_opr -- 最后操作人
        ,last_upd_time -- 最后修改时间
        ,misc -- 备注域
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,req_account_name -- 请求方账号名称
        ,rcv_account_name -- 接收方账号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_id -- 票据表ID
    ,o.apply_id -- 签收表ID
    ,o.product_no -- 产品码
    ,o.draft_attr -- 票据介质： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银承 2 商承
    ,o.busi_type -- 交易种类： 500 出票登记 501 提示承兑 502 撤票 503 提示收票 504 背书 505 承兑签收 506 贴现申请 511 贴现赎回签收
    ,o.busi_attr_no -- 业务属性号
    ,o.product_name -- 产品名称
    ,o.product_type -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,o.draft_number -- 票据（包）号
    ,o.cd_range -- 子票区间
    ,o.draft_amount -- 票据（包）金额
    ,o.buss_flag -- 业务方向： 01 申请 02 接收 03 通知
    ,o.txn_date -- 交易日期
    ,o.req_buss_type -- 请求方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,o.req_name -- 请求方名称
    ,o.req_cert_no -- 请求方社会信用代码
    ,o.req_dist_tp -- 请求方识别类型： DT01 票据账户 DT02 银行账户
    ,o.req_account -- 请求方账号
    ,o.req_bank_no -- 请求方开户行行号
    ,o.req_mem_no -- 请求方会员代码
    ,o.req_brh_no -- 请求方机构代码
    ,o.req_misc -- 请求方备注
    ,o.rcv_buss_type -- 接收方业务主体类别： ZT01-银行、金融机构 ZT02-企业平台 ZT03-企业非平台
    ,o.rcv_name -- 接收方名称
    ,o.rcv_cert_no -- 接收方社会信用代码
    ,o.rcv_dist_tp -- 接收方识别类型： DT01 票据账户 DT02 银行账户
    ,o.rcv_account -- 接收方账号
    ,o.rcv_bank_no -- 接收方开户行行号
    ,o.rcv_mem_no -- 接收方会员代码
    ,o.rcv_brh_no -- 接收方机构代码
    ,o.rcv_misc -- 接收方备注
    ,o.rate -- 贴现利率
    ,o.pay_amount -- 贴现实付金额
    ,o.transfer_flag -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,o.sttlm_mk -- 线上清算标记： SM00 线上清算 SM01 线下清算
    ,o.back_begin_date -- 贴现赎回开放日
    ,o.back_end_date -- 贴现赎回截止日
    ,o.back_rate -- 赎回利率
    ,o.back_amt -- 赎回金额
    ,o.trade_conct_no -- 交易合同编号
    ,o.invc_nb -- 发票号码
    ,o.btch_nb -- 批次号
    ,o.aoa_account -- 入账账号
    ,o.aoa_bank_no -- 入账行号
    ,o.sign_mk -- 应答标识： SU00 同意 SU01 拒绝
    ,o.sign_date -- 签收日期
    ,o.refuse_reason_code -- 拒付理由代码： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付 CP08 与自己有直接债权债务关系的持票人未履行约定义务 CP09 持票人以欺诈、偷到或者胁迫等手段取得票据 CP10 持票人明知有欺诈、偷到或者胁迫等情形，出于恶意取得票据 CP11 持票人明知债务人与出票人或者持票人的前手之间存在抗辩事由而取得票据 CP12 持票人因重大过失取得不符合《票据法》规定的票据 CP13 被法院冻结或受到法院止付通知书 CP14 票据未到期 CP15 商业承兑汇票承兑人账户余额不足
    ,o.refuse_remark -- 拒付备注信息
    ,o.recovery_type -- 追偿类型： BC14 拒付追索 BC15 非拒付追索
    ,o.pay_type -- 付息方式
    ,o.pay_interest -- 实付利息
    ,o.payment_date -- 计息到期日
    ,o.interest_payer_name -- 付息人名称
    ,o.interest_payer_account -- 付息人帐号
    ,o.interest_payer_bank_name -- 付息人开户行行名
    ,o.charge -- 手续费
    ,o.expenses -- 工本费
    ,o.agent_name -- 代理人名称
    ,o.payer_sale -- 付息比例
    ,o.buyer_interest -- 买方付息
    ,o.interest -- 总利息
    ,o.stop_pay_type -- 止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
    ,o.stop_pay_rsn -- 止付原因
    ,o.relieve_stp_type -- 解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
    ,o.relieve_stp_rsn -- 解除止付原因
    ,o.tenor_days -- 剩余期限
    ,o.settle_amt -- 结算金额
    ,o.inner_flag -- 是否系统内： 0 否 1 是
    ,o.trans_status -- 交易状态： TS0000 无效 TS0001 有效 TS0002 完成
    ,o.msg_status -- 报文状态： 00 已发送申请报文 01 已发送申请报文，收到票交所确认成功 02 已发送申请报文，收到票交所确认失败 03 已发送申请报文，收到票交所确认，对方已同意签收 04 已发送申请报文，收到票交所确认，对方已拒绝签收 05 已发送申请报文，收到票交所确认，已发撤回报文 06 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认成功 07 已发送申请报文，收到票交所确认，已发撤回报文，收到票交所确认失败 11 已发送同意签收报文 12 已发送同意签收报文，收到票交所确认成功 13 已发送同意签收报文，收到票交所确认失败 14 已发送拒绝签收报文 15 已发送拒绝签收报文，收到票交所确认成功 16 已发送拒绝签收报文，收到票交所确认失败 20 对方已撤回 21 收到人行线上清退
    ,o.process_code -- 报文处理码
    ,o.process_msg -- 报文处理信息
    ,o.settle_result -- 结算结果： R20 结算成功 R21 结算失败 R23 已撤销
    ,o.settle_date -- 结算日期
    ,o.settle_type -- 结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
    ,o.create_opr -- 创建人
    ,o.create_time -- 创建时间
    ,o.last_upd_opr -- 最后操作人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注域
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.req_account_name -- 请求方账号名称
    ,o.rcv_account_name -- 接收方账号名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cust_dpc_draft_trans_info_bk o
    left join ${iol_schema}.bdms_cust_dpc_draft_trans_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cust_dpc_draft_trans_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cust_dpc_draft_trans_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cust_dpc_draft_trans_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cust_dpc_draft_trans_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cust_dpc_draft_trans_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_cust_dpc_draft_trans_info_cl;
alter table ${iol_schema}.bdms_cust_dpc_draft_trans_info exchange partition p_20991231 with table ${iol_schema}.bdms_cust_dpc_draft_trans_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cust_dpc_draft_trans_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info_op purge;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cust_dpc_draft_trans_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cust_dpc_draft_trans_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
