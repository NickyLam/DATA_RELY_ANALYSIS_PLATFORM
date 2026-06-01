/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_buy_details
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
create table ${iol_schema}.bdms_cpes_buy_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_buy_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_details_op purge;
drop table ${iol_schema}.bdms_cpes_buy_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_details where 0=1;

create table ${iol_schema}.bdms_cpes_buy_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_buy_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_details_cl(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,repurchase_interest -- 赎回利息
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,prom_note_no -- 借票号
            ,repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payment_date -- 计息到期日
            ,postpone_days -- 顺延天数
            ,adjust_postpone_days -- 调整后顺延天数
            ,payment_days -- 计息天数
            ,previous_hand -- 直接前手
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,inner_accept_flag -- 是否我行承兑： 0 否 1 是
            ,same_city_flag -- 是否同城： 0 否 1 是
            ,pay_amount -- 实付金额
            ,important_hand -- 重要背书人
            ,payer_amount -- 买方付息金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 批次号
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,accont_date -- 记账日期
            ,credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
            ,credit_id -- 额度分析ID
            ,query_check_id -- 查询查复ID
            ,draft_number -- 票据(包)号
            ,remitter_name -- 出票人全称
            ,remitter_account -- 出票人账号
            ,remitter_bank_name -- 出票人开户银行
            ,remitter_bank_no -- 出票人开户银行行号
            ,payee_name -- 收票人全称
            ,payee_account -- 收票人账号
            ,payee_bank_name -- 收票人开户银行
            ,payee_bank_no -- 收票人开户银行行号
            ,acceptor_name -- 承兑人全称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,remit_date -- 出票日期
            ,maturity_date -- 汇票到期日
            ,draft_amount -- 票据(包)金额
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,endorse_times -- 背书次数
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,df_drwr_cdtratgsagcy -- 出票人评级主体
            ,df_drwr_cdtratgduedt -- 出票人评级到期日
            ,df_drwr_cdtratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,draft_remark -- 票面备注
            ,reason -- 原因
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
            ,top_branch_no -- 总行机构号
            ,aoa_account -- 入账账号
            ,aoa_bank_id -- 入账机构参与者代码
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,aoa_account_name -- 入账账户名称
            ,flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
            ,flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
            ,run_code -- 唯一标识号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_details_op(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,repurchase_interest -- 赎回利息
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,prom_note_no -- 借票号
            ,repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payment_date -- 计息到期日
            ,postpone_days -- 顺延天数
            ,adjust_postpone_days -- 调整后顺延天数
            ,payment_days -- 计息天数
            ,previous_hand -- 直接前手
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,inner_accept_flag -- 是否我行承兑： 0 否 1 是
            ,same_city_flag -- 是否同城： 0 否 1 是
            ,pay_amount -- 实付金额
            ,important_hand -- 重要背书人
            ,payer_amount -- 买方付息金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 批次号
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,accont_date -- 记账日期
            ,credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
            ,credit_id -- 额度分析ID
            ,query_check_id -- 查询查复ID
            ,draft_number -- 票据(包)号
            ,remitter_name -- 出票人全称
            ,remitter_account -- 出票人账号
            ,remitter_bank_name -- 出票人开户银行
            ,remitter_bank_no -- 出票人开户银行行号
            ,payee_name -- 收票人全称
            ,payee_account -- 收票人账号
            ,payee_bank_name -- 收票人开户银行
            ,payee_bank_no -- 收票人开户银行行号
            ,acceptor_name -- 承兑人全称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,remit_date -- 出票日期
            ,maturity_date -- 汇票到期日
            ,draft_amount -- 票据(包)金额
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,endorse_times -- 背书次数
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,df_drwr_cdtratgsagcy -- 出票人评级主体
            ,df_drwr_cdtratgduedt -- 出票人评级到期日
            ,df_drwr_cdtratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,draft_remark -- 票面备注
            ,reason -- 原因
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
            ,top_branch_no -- 总行机构号
            ,aoa_account -- 入账账号
            ,aoa_bank_id -- 入账机构参与者代码
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,aoa_account_name -- 入账账户名称
            ,flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
            ,flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
            ,run_code -- 唯一标识号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 解析表ID
    ,nvl(n.draft_category, o.draft_category) as draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,nvl(n.cd_range, o.cd_range) as cd_range -- 子票区间
    ,nvl(n.repurchase_interest, o.repurchase_interest) as repurchase_interest -- 赎回利息
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结算日期
    ,nvl(n.rate_type, o.rate_type) as rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.prom_note_no, o.prom_note_no) as prom_note_no -- 借票号
    ,nvl(n.repurchase_rate_type, o.repurchase_rate_type) as repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,nvl(n.repurchase_rate, o.repurchase_rate) as repurchase_rate -- 赎回利率
    ,nvl(n.repurchase_begin_date, o.repurchase_begin_date) as repurchase_begin_date -- 赎回开放日
    ,nvl(n.repurchase_end_date, o.repurchase_end_date) as repurchase_end_date -- 赎回截止日
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 计息到期日
    ,nvl(n.postpone_days, o.postpone_days) as postpone_days -- 顺延天数
    ,nvl(n.adjust_postpone_days, o.adjust_postpone_days) as adjust_postpone_days -- 调整后顺延天数
    ,nvl(n.payment_days, o.payment_days) as payment_days -- 计息天数
    ,nvl(n.previous_hand, o.previous_hand) as previous_hand -- 直接前手
    ,nvl(n.interest, o.interest) as interest -- 利息
    ,nvl(n.adjust_interest, o.adjust_interest) as adjust_interest -- 调整后利息
    ,nvl(n.inner_accept_flag, o.inner_accept_flag) as inner_accept_flag -- 是否我行承兑： 0 否 1 是
    ,nvl(n.same_city_flag, o.same_city_flag) as same_city_flag -- 是否同城： 0 否 1 是
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 实付金额
    ,nvl(n.important_hand, o.important_hand) as important_hand -- 重要背书人
    ,nvl(n.payer_amount, o.payer_amount) as payer_amount -- 买方付息金额
    ,nvl(n.txl_ctrct_nb, o.txl_ctrct_nb) as txl_ctrct_nb -- 交易合同编号
    ,nvl(n.invc_nb, o.invc_nb) as invc_nb -- 发票号码
    ,nvl(n.btch_nb, o.btch_nb) as btch_nb -- 批次号
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.buy_status, o.buy_status) as buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,nvl(n.accont_date, o.accont_date) as accont_date -- 记账日期
    ,nvl(n.credit_result, o.credit_result) as credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
    ,nvl(n.credit_id, o.credit_id) as credit_id -- 额度分析ID
    ,nvl(n.query_check_id, o.query_check_id) as query_check_id -- 查询查复ID
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据(包)号
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人全称
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户银行
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户银行行号
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收票人全称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 收票人账号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收票人开户银行
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收票人开户银行行号
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人全称
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行行号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行名称
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 汇票到期日
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据(包)金额
    ,nvl(n.end_smt_flag, o.end_smt_flag) as end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,nvl(n.endorse_times, o.endorse_times) as endorse_times -- 背书次数
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： 1 纸票 2 电票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： 1 银票 2 商票
    ,nvl(n.drawee_bank_name, o.drawee_bank_name) as drawee_bank_name -- 付款行全称
    ,nvl(n.drawee_bank_no, o.drawee_bank_no) as drawee_bank_no -- 付款行行号
    ,nvl(n.drawee_address, o.drawee_address) as drawee_address -- 付款行地址
    ,nvl(n.df_drwr_cdtratgsagcy, o.df_drwr_cdtratgsagcy) as df_drwr_cdtratgsagcy -- 出票人评级主体
    ,nvl(n.df_drwr_cdtratgduedt, o.df_drwr_cdtratgduedt) as df_drwr_cdtratgduedt -- 出票人评级到期日
    ,nvl(n.df_drwr_cdtratgs, o.df_drwr_cdtratgs) as df_drwr_cdtratgs -- 出票人信用等级
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人评级主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.accept_date, o.accept_date) as accept_date -- 承兑日期
    ,nvl(n.draft_remark, o.draft_remark) as draft_remark -- 票面备注
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.aoa_account, o.aoa_account) as aoa_account -- 入账账号
    ,nvl(n.aoa_bank_id, o.aoa_bank_id) as aoa_bank_id -- 入账机构参与者代码
    ,nvl(n.register_status, o.register_status) as register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.err_code, o.err_code) as err_code -- 错误码
    ,nvl(n.err_msg, o.err_msg) as err_msg -- 错误信息
    ,nvl(n.aoa_account_name, o.aoa_account_name) as aoa_account_name -- 入账账户名称
    ,nvl(n.flash_discnt_status, o.flash_discnt_status) as flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
    ,nvl(n.flash_discnt_flag, o.flash_discnt_flag) as flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
    ,nvl(n.run_code, o.run_code) as run_code -- 唯一标识号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_buy_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_buy_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.contract_id <> n.contract_id
        or o.draft_id <> n.draft_id
        or o.apply_id <> n.apply_id
        or o.draft_category <> n.draft_category
        or o.cd_range <> n.cd_range
        or o.repurchase_interest <> n.repurchase_interest
        or o.settle_type <> n.settle_type
        or o.clear_type <> n.clear_type
        or o.settle_date <> n.settle_date
        or o.rate_type <> n.rate_type
        or o.rate <> n.rate
        or o.prom_note_no <> n.prom_note_no
        or o.repurchase_rate_type <> n.repurchase_rate_type
        or o.repurchase_rate <> n.repurchase_rate
        or o.repurchase_begin_date <> n.repurchase_begin_date
        or o.repurchase_end_date <> n.repurchase_end_date
        or o.payment_date <> n.payment_date
        or o.postpone_days <> n.postpone_days
        or o.adjust_postpone_days <> n.adjust_postpone_days
        or o.payment_days <> n.payment_days
        or o.previous_hand <> n.previous_hand
        or o.interest <> n.interest
        or o.adjust_interest <> n.adjust_interest
        or o.inner_accept_flag <> n.inner_accept_flag
        or o.same_city_flag <> n.same_city_flag
        or o.pay_amount <> n.pay_amount
        or o.important_hand <> n.important_hand
        or o.payer_amount <> n.payer_amount
        or o.txl_ctrct_nb <> n.txl_ctrct_nb
        or o.invc_nb <> n.invc_nb
        or o.btch_nb <> n.btch_nb
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.buy_status <> n.buy_status
        or o.account_status <> n.account_status
        or o.accont_date <> n.accont_date
        or o.credit_result <> n.credit_result
        or o.credit_id <> n.credit_id
        or o.query_check_id <> n.query_check_id
        or o.draft_number <> n.draft_number
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_bank_no <> n.payee_bank_no
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.draft_amount <> n.draft_amount
        or o.end_smt_flag <> n.end_smt_flag
        or o.endorse_times <> n.endorse_times
        or o.draft_attr <> n.draft_attr
        or o.draft_type <> n.draft_type
        or o.drawee_bank_name <> n.drawee_bank_name
        or o.drawee_bank_no <> n.drawee_bank_no
        or o.drawee_address <> n.drawee_address
        or o.df_drwr_cdtratgsagcy <> n.df_drwr_cdtratgsagcy
        or o.df_drwr_cdtratgduedt <> n.df_drwr_cdtratgduedt
        or o.df_drwr_cdtratgs <> n.df_drwr_cdtratgs
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.accept_date <> n.accept_date
        or o.draft_remark <> n.draft_remark
        or o.reason <> n.reason
        or o.message_status <> n.message_status
        or o.top_branch_no <> n.top_branch_no
        or o.aoa_account <> n.aoa_account
        or o.aoa_bank_id <> n.aoa_bank_id
        or o.register_status <> n.register_status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.err_code <> n.err_code
        or o.err_msg <> n.err_msg
        or o.aoa_account_name <> n.aoa_account_name
        or o.flash_discnt_status <> n.flash_discnt_status
        or o.flash_discnt_flag <> n.flash_discnt_flag
        or o.run_code <> n.run_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_buy_details_cl(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,repurchase_interest -- 赎回利息
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,prom_note_no -- 借票号
            ,repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payment_date -- 计息到期日
            ,postpone_days -- 顺延天数
            ,adjust_postpone_days -- 调整后顺延天数
            ,payment_days -- 计息天数
            ,previous_hand -- 直接前手
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,inner_accept_flag -- 是否我行承兑： 0 否 1 是
            ,same_city_flag -- 是否同城： 0 否 1 是
            ,pay_amount -- 实付金额
            ,important_hand -- 重要背书人
            ,payer_amount -- 买方付息金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 批次号
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,accont_date -- 记账日期
            ,credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
            ,credit_id -- 额度分析ID
            ,query_check_id -- 查询查复ID
            ,draft_number -- 票据(包)号
            ,remitter_name -- 出票人全称
            ,remitter_account -- 出票人账号
            ,remitter_bank_name -- 出票人开户银行
            ,remitter_bank_no -- 出票人开户银行行号
            ,payee_name -- 收票人全称
            ,payee_account -- 收票人账号
            ,payee_bank_name -- 收票人开户银行
            ,payee_bank_no -- 收票人开户银行行号
            ,acceptor_name -- 承兑人全称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,remit_date -- 出票日期
            ,maturity_date -- 汇票到期日
            ,draft_amount -- 票据(包)金额
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,endorse_times -- 背书次数
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,df_drwr_cdtratgsagcy -- 出票人评级主体
            ,df_drwr_cdtratgduedt -- 出票人评级到期日
            ,df_drwr_cdtratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,draft_remark -- 票面备注
            ,reason -- 原因
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
            ,top_branch_no -- 总行机构号
            ,aoa_account -- 入账账号
            ,aoa_bank_id -- 入账机构参与者代码
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,aoa_account_name -- 入账账户名称
            ,flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
            ,flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
            ,run_code -- 唯一标识号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_buy_details_op(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据表ID
            ,apply_id -- 解析表ID
            ,draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
            ,cd_range -- 子票区间
            ,repurchase_interest -- 赎回利息
            ,settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
            ,clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
            ,settle_date -- 结算日期
            ,rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,rate -- 利率
            ,prom_note_no -- 借票号
            ,repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,repurchase_end_date -- 赎回截止日
            ,payment_date -- 计息到期日
            ,postpone_days -- 顺延天数
            ,adjust_postpone_days -- 调整后顺延天数
            ,payment_days -- 计息天数
            ,previous_hand -- 直接前手
            ,interest -- 利息
            ,adjust_interest -- 调整后利息
            ,inner_accept_flag -- 是否我行承兑： 0 否 1 是
            ,same_city_flag -- 是否同城： 0 否 1 是
            ,pay_amount -- 实付金额
            ,important_hand -- 重要背书人
            ,payer_amount -- 买方付息金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 批次号
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,accont_date -- 记账日期
            ,credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
            ,credit_id -- 额度分析ID
            ,query_check_id -- 查询查复ID
            ,draft_number -- 票据(包)号
            ,remitter_name -- 出票人全称
            ,remitter_account -- 出票人账号
            ,remitter_bank_name -- 出票人开户银行
            ,remitter_bank_no -- 出票人开户银行行号
            ,payee_name -- 收票人全称
            ,payee_account -- 收票人账号
            ,payee_bank_name -- 收票人开户银行
            ,payee_bank_no -- 收票人开户银行行号
            ,acceptor_name -- 承兑人全称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,remit_date -- 出票日期
            ,maturity_date -- 汇票到期日
            ,draft_amount -- 票据(包)金额
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,endorse_times -- 背书次数
            ,draft_attr -- 票据属性： 1 纸票 2 电票
            ,draft_type -- 票据类型： 1 银票 2 商票
            ,drawee_bank_name -- 付款行全称
            ,drawee_bank_no -- 付款行行号
            ,drawee_address -- 付款行地址
            ,df_drwr_cdtratgsagcy -- 出票人评级主体
            ,df_drwr_cdtratgduedt -- 出票人评级到期日
            ,df_drwr_cdtratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,draft_remark -- 票面备注
            ,reason -- 原因
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
            ,top_branch_no -- 总行机构号
            ,aoa_account -- 入账账号
            ,aoa_bank_id -- 入账机构参与者代码
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,err_code -- 错误码
            ,err_msg -- 错误信息
            ,aoa_account_name -- 入账账户名称
            ,flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
            ,flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
            ,run_code -- 唯一标识号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 协议ID
    ,o.draft_id -- 票据表ID
    ,o.apply_id -- 解析表ID
    ,o.draft_category -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,o.cd_range -- 子票区间
    ,o.repurchase_interest -- 赎回利息
    ,o.settle_type -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,o.clear_type -- 清算类型:CT01 全额清算;CT02 净额清算
    ,o.settle_date -- 结算日期
    ,o.rate_type -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,o.rate -- 利率
    ,o.prom_note_no -- 借票号
    ,o.repurchase_rate_type -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,o.repurchase_rate -- 赎回利率
    ,o.repurchase_begin_date -- 赎回开放日
    ,o.repurchase_end_date -- 赎回截止日
    ,o.payment_date -- 计息到期日
    ,o.postpone_days -- 顺延天数
    ,o.adjust_postpone_days -- 调整后顺延天数
    ,o.payment_days -- 计息天数
    ,o.previous_hand -- 直接前手
    ,o.interest -- 利息
    ,o.adjust_interest -- 调整后利息
    ,o.inner_accept_flag -- 是否我行承兑： 0 否 1 是
    ,o.same_city_flag -- 是否同城： 0 否 1 是
    ,o.pay_amount -- 实付金额
    ,o.important_hand -- 重要背书人
    ,o.payer_amount -- 买方付息金额
    ,o.txl_ctrct_nb -- 交易合同编号
    ,o.invc_nb -- 发票号码
    ,o.btch_nb -- 批次号
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.buy_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,o.account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,o.accont_date -- 记账日期
    ,o.credit_result -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
    ,o.credit_id -- 额度分析ID
    ,o.query_check_id -- 查询查复ID
    ,o.draft_number -- 票据(包)号
    ,o.remitter_name -- 出票人全称
    ,o.remitter_account -- 出票人账号
    ,o.remitter_bank_name -- 出票人开户银行
    ,o.remitter_bank_no -- 出票人开户银行行号
    ,o.payee_name -- 收票人全称
    ,o.payee_account -- 收票人账号
    ,o.payee_bank_name -- 收票人开户银行
    ,o.payee_bank_no -- 收票人开户银行行号
    ,o.acceptor_name -- 承兑人全称
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_bank_no -- 承兑人开户行行号
    ,o.acceptor_bank_name -- 承兑人开户行名称
    ,o.remit_date -- 出票日期
    ,o.maturity_date -- 汇票到期日
    ,o.draft_amount -- 票据(包)金额
    ,o.end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,o.endorse_times -- 背书次数
    ,o.draft_attr -- 票据属性： 1 纸票 2 电票
    ,o.draft_type -- 票据类型： 1 银票 2 商票
    ,o.drawee_bank_name -- 付款行全称
    ,o.drawee_bank_no -- 付款行行号
    ,o.drawee_address -- 付款行地址
    ,o.df_drwr_cdtratgsagcy -- 出票人评级主体
    ,o.df_drwr_cdtratgduedt -- 出票人评级到期日
    ,o.df_drwr_cdtratgs -- 出票人信用等级
    ,o.acceptor_ratg_agcy -- 承兑人评级主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.accept_date -- 承兑日期
    ,o.draft_remark -- 票面备注
    ,o.reason -- 原因
    ,o.message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
    ,o.top_branch_no -- 总行机构号
    ,o.aoa_account -- 入账账号
    ,o.aoa_bank_id -- 入账机构参与者代码
    ,o.register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.err_code -- 错误码
    ,o.err_msg -- 错误信息
    ,o.aoa_account_name -- 入账账户名称
    ,o.flash_discnt_status -- 秒贴状态（1-已完成，0-未完成。）
    ,o.flash_discnt_flag -- 是否秒贴标识（1-是，0-否，空字段也是否。）
    ,o.run_code -- 唯一标识号
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
from ${iol_schema}.bdms_cpes_buy_details_bk o
    left join ${iol_schema}.bdms_cpes_buy_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_buy_details_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cpes_buy_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_buy_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_buy_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_buy_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_buy_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_buy_details_cl;
alter table ${iol_schema}.bdms_cpes_buy_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_buy_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_buy_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_buy_details_op purge;
drop table ${iol_schema}.bdms_cpes_buy_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_buy_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_buy_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
