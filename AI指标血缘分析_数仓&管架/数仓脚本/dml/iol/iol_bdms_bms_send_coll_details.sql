/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_send_coll_details
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
create table ${iol_schema}.bdms_bms_send_coll_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_send_coll_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_send_coll_details_op purge;
drop table ${iol_schema}.bdms_bms_send_coll_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_send_coll_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_send_coll_details where 0=1;

create table ${iol_schema}.bdms_bms_send_coll_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_send_coll_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_send_coll_details_cl(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据ID
            ,send_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,fee -- 费用
            ,adjust_fee -- 调整后费用
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
            ,drft_hldr_no -- （发托）提示付款人客户号
            ,drft_hldr_name -- （发托）提示入款人全称
            ,drft_hldr_account -- （发托）提示付款人入账帐号
            ,drft_hldr_bank_no -- （发托）提示付款人开户行行号
            ,drft_hldr_bank_name -- （发托）提示付款人开户行名称
            ,drft_hldr_address -- （发托）提示付款人地址
            ,apply_date -- 托收申请日
            ,receiver_name -- 付款人全称
            ,receiver_account -- 付款人账号
            ,receiver_bank_name -- 付款人开户行
            ,receiver_address -- 付款人地址
            ,send_print_name -- 托收凭据名称
            ,send_content -- 委托内容
            ,send_count -- 附寄单证张数
            ,contract_name_num -- 合同名称号码
            ,send_situation -- 商品运发情况
            ,mic -- 备注
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,drft_hldr_agcy_ubank -- 提示付款人承接行行号
            ,req_remark -- 提示付款人备注
            ,req_prxy_prop_stn -- 提示付款代理申请标识
            ,rcv_remark -- 承兑人备注
            ,rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
            ,operator_no -- 业务发起人编号
            ,txn_date -- 记账日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,draft_number -- 票据号码
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
            ,draft_amount -- 票据金额
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
            ,reason -- 原因
            ,draft_remark -- 票面备注
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,if_over_flag -- IF_OVER_FLAG
            ,top_branch_no -- 总行机构号
            ,core_account -- 核心记账账号
            ,paymsgsrc -- 来账信息来源
            ,trandate -- 来账日期
            ,trannumber -- 来账查询流水号
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_send_coll_details_op(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据ID
            ,send_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,fee -- 费用
            ,adjust_fee -- 调整后费用
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
            ,drft_hldr_no -- （发托）提示付款人客户号
            ,drft_hldr_name -- （发托）提示入款人全称
            ,drft_hldr_account -- （发托）提示付款人入账帐号
            ,drft_hldr_bank_no -- （发托）提示付款人开户行行号
            ,drft_hldr_bank_name -- （发托）提示付款人开户行名称
            ,drft_hldr_address -- （发托）提示付款人地址
            ,apply_date -- 托收申请日
            ,receiver_name -- 付款人全称
            ,receiver_account -- 付款人账号
            ,receiver_bank_name -- 付款人开户行
            ,receiver_address -- 付款人地址
            ,send_print_name -- 托收凭据名称
            ,send_content -- 委托内容
            ,send_count -- 附寄单证张数
            ,contract_name_num -- 合同名称号码
            ,send_situation -- 商品运发情况
            ,mic -- 备注
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,drft_hldr_agcy_ubank -- 提示付款人承接行行号
            ,req_remark -- 提示付款人备注
            ,req_prxy_prop_stn -- 提示付款代理申请标识
            ,rcv_remark -- 承兑人备注
            ,rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
            ,operator_no -- 业务发起人编号
            ,txn_date -- 记账日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,draft_number -- 票据号码
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
            ,draft_amount -- 票据金额
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
            ,reason -- 原因
            ,draft_remark -- 票面备注
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,if_over_flag -- IF_OVER_FLAG
            ,top_branch_no -- 总行机构号
            ,core_account -- 核心记账账号
            ,paymsgsrc -- 来账信息来源
            ,trandate -- 来账日期
            ,trannumber -- 来账查询流水号
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据ID
    ,nvl(n.send_state, o.send_state) as send_state -- 发托状态： 1 发托 2 款到 3 托收退票
    ,nvl(n.fee_mode, o.fee_mode) as fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,nvl(n.fee, o.fee) as fee -- 费用
    ,nvl(n.adjust_fee, o.adjust_fee) as adjust_fee -- 调整后费用
    ,nvl(n.valet_flag, o.valet_flag) as valet_flag -- 是否代客托收： 0 否 1 是
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
    ,nvl(n.drft_hldr_no, o.drft_hldr_no) as drft_hldr_no -- （发托）提示付款人客户号
    ,nvl(n.drft_hldr_name, o.drft_hldr_name) as drft_hldr_name -- （发托）提示入款人全称
    ,nvl(n.drft_hldr_account, o.drft_hldr_account) as drft_hldr_account -- （发托）提示付款人入账帐号
    ,nvl(n.drft_hldr_bank_no, o.drft_hldr_bank_no) as drft_hldr_bank_no -- （发托）提示付款人开户行行号
    ,nvl(n.drft_hldr_bank_name, o.drft_hldr_bank_name) as drft_hldr_bank_name -- （发托）提示付款人开户行名称
    ,nvl(n.drft_hldr_address, o.drft_hldr_address) as drft_hldr_address -- （发托）提示付款人地址
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 托收申请日
    ,nvl(n.receiver_name, o.receiver_name) as receiver_name -- 付款人全称
    ,nvl(n.receiver_account, o.receiver_account) as receiver_account -- 付款人账号
    ,nvl(n.receiver_bank_name, o.receiver_bank_name) as receiver_bank_name -- 付款人开户行
    ,nvl(n.receiver_address, o.receiver_address) as receiver_address -- 付款人地址
    ,nvl(n.send_print_name, o.send_print_name) as send_print_name -- 托收凭据名称
    ,nvl(n.send_content, o.send_content) as send_content -- 委托内容
    ,nvl(n.send_count, o.send_count) as send_count -- 附寄单证张数
    ,nvl(n.contract_name_num, o.contract_name_num) as contract_name_num -- 合同名称号码
    ,nvl(n.send_situation, o.send_situation) as send_situation -- 商品运发情况
    ,nvl(n.mic, o.mic) as mic -- 备注
    ,nvl(n.ovrdue_rsn, o.ovrdue_rsn) as ovrdue_rsn -- 逾期原因说明
    ,nvl(n.apply_curcd, o.apply_curcd) as apply_curcd -- 提示付款币种： CNY 人民币
    ,nvl(n.drft_hldr_agcy_ubank, o.drft_hldr_agcy_ubank) as drft_hldr_agcy_ubank -- 提示付款人承接行行号
    ,nvl(n.req_remark, o.req_remark) as req_remark -- 提示付款人备注
    ,nvl(n.req_prxy_prop_stn, o.req_prxy_prop_stn) as req_prxy_prop_stn -- 提示付款代理申请标识
    ,nvl(n.rcv_remark, o.rcv_remark) as rcv_remark -- 承兑人备注
    ,nvl(n.rcv_prxy_sgntr, o.rcv_prxy_sgntr) as rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,nvl(n.operator_no, o.operator_no) as operator_no -- 业务发起人编号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 记账日期
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后操作员编号
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后操作日期
    ,nvl(n.send_coll_status, o.send_coll_status) as send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
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
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
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
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.draft_remark, o.draft_remark) as draft_remark -- 票面备注
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人评级主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.accept_date, o.accept_date) as accept_date -- 承兑日期
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- BUSI_BRANCH_NO
    ,nvl(n.if_over_flag, o.if_over_flag) as if_over_flag -- IF_OVER_FLAG
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.core_account, o.core_account) as core_account -- 核心记账账号
    ,nvl(n.paymsgsrc, o.paymsgsrc) as paymsgsrc -- 来账信息来源
    ,nvl(n.trandate, o.trandate) as trandate -- 来账日期
    ,nvl(n.trannumber, o.trannumber) as trannumber -- 来账查询流水号
    ,nvl(n.account_date, o.account_date) as account_date -- 
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
from (select * from ${iol_schema}.bdms_bms_send_coll_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_send_coll_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.send_state <> n.send_state
        or o.fee_mode <> n.fee_mode
        or o.fee <> n.fee
        or o.adjust_fee <> n.adjust_fee
        or o.valet_flag <> n.valet_flag
        or o.sttlm_mk <> n.sttlm_mk
        or o.drft_hldr_no <> n.drft_hldr_no
        or o.drft_hldr_name <> n.drft_hldr_name
        or o.drft_hldr_account <> n.drft_hldr_account
        or o.drft_hldr_bank_no <> n.drft_hldr_bank_no
        or o.drft_hldr_bank_name <> n.drft_hldr_bank_name
        or o.drft_hldr_address <> n.drft_hldr_address
        or o.apply_date <> n.apply_date
        or o.receiver_name <> n.receiver_name
        or o.receiver_account <> n.receiver_account
        or o.receiver_bank_name <> n.receiver_bank_name
        or o.receiver_address <> n.receiver_address
        or o.send_print_name <> n.send_print_name
        or o.send_content <> n.send_content
        or o.send_count <> n.send_count
        or o.contract_name_num <> n.contract_name_num
        or o.send_situation <> n.send_situation
        or o.mic <> n.mic
        or o.ovrdue_rsn <> n.ovrdue_rsn
        or o.apply_curcd <> n.apply_curcd
        or o.drft_hldr_agcy_ubank <> n.drft_hldr_agcy_ubank
        or o.req_remark <> n.req_remark
        or o.req_prxy_prop_stn <> n.req_prxy_prop_stn
        or o.rcv_remark <> n.rcv_remark
        or o.rcv_prxy_sgntr <> n.rcv_prxy_sgntr
        or o.operator_no <> n.operator_no
        or o.txn_date <> n.txn_date
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.send_coll_status <> n.send_coll_status
        or o.account_status <> n.account_status
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
        or o.reason <> n.reason
        or o.draft_remark <> n.draft_remark
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.accept_date <> n.accept_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.message_status <> n.message_status
        or o.busi_branch_no <> n.busi_branch_no
        or o.if_over_flag <> n.if_over_flag
        or o.top_branch_no <> n.top_branch_no
        or o.core_account <> n.core_account
        or o.paymsgsrc <> n.paymsgsrc
        or o.trandate <> n.trandate
        or o.trannumber <> n.trannumber
        or o.account_date <> n.account_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_send_coll_details_cl(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据ID
            ,send_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,fee -- 费用
            ,adjust_fee -- 调整后费用
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
            ,drft_hldr_no -- （发托）提示付款人客户号
            ,drft_hldr_name -- （发托）提示入款人全称
            ,drft_hldr_account -- （发托）提示付款人入账帐号
            ,drft_hldr_bank_no -- （发托）提示付款人开户行行号
            ,drft_hldr_bank_name -- （发托）提示付款人开户行名称
            ,drft_hldr_address -- （发托）提示付款人地址
            ,apply_date -- 托收申请日
            ,receiver_name -- 付款人全称
            ,receiver_account -- 付款人账号
            ,receiver_bank_name -- 付款人开户行
            ,receiver_address -- 付款人地址
            ,send_print_name -- 托收凭据名称
            ,send_content -- 委托内容
            ,send_count -- 附寄单证张数
            ,contract_name_num -- 合同名称号码
            ,send_situation -- 商品运发情况
            ,mic -- 备注
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,drft_hldr_agcy_ubank -- 提示付款人承接行行号
            ,req_remark -- 提示付款人备注
            ,req_prxy_prop_stn -- 提示付款代理申请标识
            ,rcv_remark -- 承兑人备注
            ,rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
            ,operator_no -- 业务发起人编号
            ,txn_date -- 记账日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,draft_number -- 票据号码
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
            ,draft_amount -- 票据金额
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
            ,reason -- 原因
            ,draft_remark -- 票面备注
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,if_over_flag -- IF_OVER_FLAG
            ,top_branch_no -- 总行机构号
            ,core_account -- 核心记账账号
            ,paymsgsrc -- 来账信息来源
            ,trandate -- 来账日期
            ,trannumber -- 来账查询流水号
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_send_coll_details_op(
            id -- ID
            ,contract_id -- 协议ID
            ,draft_id -- 票据ID
            ,send_state -- 发托状态： 1 发托 2 款到 3 托收退票
            ,fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
            ,fee -- 费用
            ,adjust_fee -- 调整后费用
            ,valet_flag -- 是否代客托收： 0 否 1 是
            ,sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
            ,drft_hldr_no -- （发托）提示付款人客户号
            ,drft_hldr_name -- （发托）提示入款人全称
            ,drft_hldr_account -- （发托）提示付款人入账帐号
            ,drft_hldr_bank_no -- （发托）提示付款人开户行行号
            ,drft_hldr_bank_name -- （发托）提示付款人开户行名称
            ,drft_hldr_address -- （发托）提示付款人地址
            ,apply_date -- 托收申请日
            ,receiver_name -- 付款人全称
            ,receiver_account -- 付款人账号
            ,receiver_bank_name -- 付款人开户行
            ,receiver_address -- 付款人地址
            ,send_print_name -- 托收凭据名称
            ,send_content -- 委托内容
            ,send_count -- 附寄单证张数
            ,contract_name_num -- 合同名称号码
            ,send_situation -- 商品运发情况
            ,mic -- 备注
            ,ovrdue_rsn -- 逾期原因说明
            ,apply_curcd -- 提示付款币种： CNY 人民币
            ,drft_hldr_agcy_ubank -- 提示付款人承接行行号
            ,req_remark -- 提示付款人备注
            ,req_prxy_prop_stn -- 提示付款代理申请标识
            ,rcv_remark -- 承兑人备注
            ,rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
            ,operator_no -- 业务发起人编号
            ,txn_date -- 记账日期
            ,last_operator_no -- 最后操作员编号
            ,last_txn_date -- 最后操作日期
            ,send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
            ,account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
            ,draft_number -- 票据号码
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
            ,draft_amount -- 票据金额
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
            ,reason -- 原因
            ,draft_remark -- 票面备注
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,busi_branch_no -- BUSI_BRANCH_NO
            ,if_over_flag -- IF_OVER_FLAG
            ,top_branch_no -- 总行机构号
            ,core_account -- 核心记账账号
            ,paymsgsrc -- 来账信息来源
            ,trandate -- 来账日期
            ,trannumber -- 来账查询流水号
            ,account_date -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 协议ID
    ,o.draft_id -- 票据ID
    ,o.send_state -- 发托状态： 1 发托 2 款到 3 托收退票
    ,o.fee_mode -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,o.fee -- 费用
    ,o.adjust_fee -- 调整后费用
    ,o.valet_flag -- 是否代客托收： 0 否 1 是
    ,o.sttlm_mk -- 清算方式： SM00 线上清算 SM01 线下清算
    ,o.drft_hldr_no -- （发托）提示付款人客户号
    ,o.drft_hldr_name -- （发托）提示入款人全称
    ,o.drft_hldr_account -- （发托）提示付款人入账帐号
    ,o.drft_hldr_bank_no -- （发托）提示付款人开户行行号
    ,o.drft_hldr_bank_name -- （发托）提示付款人开户行名称
    ,o.drft_hldr_address -- （发托）提示付款人地址
    ,o.apply_date -- 托收申请日
    ,o.receiver_name -- 付款人全称
    ,o.receiver_account -- 付款人账号
    ,o.receiver_bank_name -- 付款人开户行
    ,o.receiver_address -- 付款人地址
    ,o.send_print_name -- 托收凭据名称
    ,o.send_content -- 委托内容
    ,o.send_count -- 附寄单证张数
    ,o.contract_name_num -- 合同名称号码
    ,o.send_situation -- 商品运发情况
    ,o.mic -- 备注
    ,o.ovrdue_rsn -- 逾期原因说明
    ,o.apply_curcd -- 提示付款币种： CNY 人民币
    ,o.drft_hldr_agcy_ubank -- 提示付款人承接行行号
    ,o.req_remark -- 提示付款人备注
    ,o.req_prxy_prop_stn -- 提示付款代理申请标识
    ,o.rcv_remark -- 承兑人备注
    ,o.rcv_prxy_sgntr -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,o.operator_no -- 业务发起人编号
    ,o.txn_date -- 记账日期
    ,o.last_operator_no -- 最后操作员编号
    ,o.last_txn_date -- 最后操作日期
    ,o.send_coll_status -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
    ,o.account_status -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,o.draft_number -- 票据号码
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
    ,o.draft_amount -- 票据金额
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
    ,o.reason -- 原因
    ,o.draft_remark -- 票面备注
    ,o.acceptor_ratg_agcy -- 承兑人评级主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.accept_date -- 承兑日期
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,o.busi_branch_no -- BUSI_BRANCH_NO
    ,o.if_over_flag -- IF_OVER_FLAG
    ,o.top_branch_no -- 总行机构号
    ,o.core_account -- 核心记账账号
    ,o.paymsgsrc -- 来账信息来源
    ,o.trandate -- 来账日期
    ,o.trannumber -- 来账查询流水号
    ,o.account_date -- 
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
from ${iol_schema}.bdms_bms_send_coll_details_bk o
    left join ${iol_schema}.bdms_bms_send_coll_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_send_coll_details_cl d
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
--truncate table ${iol_schema}.bdms_bms_send_coll_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_send_coll_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_send_coll_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_send_coll_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_send_coll_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_send_coll_details_cl;
alter table ${iol_schema}.bdms_bms_send_coll_details exchange partition p_20991231 with table ${iol_schema}.bdms_bms_send_coll_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_send_coll_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_send_coll_details_op purge;
drop table ${iol_schema}.bdms_bms_send_coll_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_send_coll_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_send_coll_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
