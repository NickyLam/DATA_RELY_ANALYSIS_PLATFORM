/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_accept_details
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
create table ${iol_schema}.bdms_bms_accept_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_accept_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_details_op purge;
drop table ${iol_schema}.bdms_bms_accept_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_details where 0=1;

create table ${iol_schema}.bdms_bms_accept_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_accept_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_details_cl(
            id -- ID
            ,contract_id -- 承兑协议ID
            ,draft_id -- 票据表ID
            ,charge -- 手续费
            ,expenses -- 工本费
            ,contractno -- 交易合同编号
            ,invc_no -- 发票号码
            ,btch_no -- 人行承兑批次号
            ,remitter_remark -- 出票人备注
            ,acceptor_remark -- 承兑人备注
            ,credit_line_no -- 额度占用记录
            ,credit_line -- 额度扣减金额
            ,credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,endst_date -- 签收日期
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,print_status -- 出票状态： 0 未打印 1 已打印
            ,deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,print_cnt -- 凭证打印次数
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
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
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,adjust_charge -- 调整后手续费
            ,guarantee_amount -- 保证金额
            ,adjust_guarantee_amount -- 调整后保证金额
            ,freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员号
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,settle_flag -- 结清登记
            ,task_type -- 任务类型
            ,seq_no -- 序号
            ,ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
            ,sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
            ,misc -- 信息域
            ,ecds_prc_msg -- 人行应答消息
            ,rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
            ,actlog_id -- 记账流水ID
            ,accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
            ,run_code -- 记账唯一标识
            ,accp_detail_remark -- 
            ,record_logno -- 中间表对应的唯一标志
            ,billseq -- 备款标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_details_op(
            id -- ID
            ,contract_id -- 承兑协议ID
            ,draft_id -- 票据表ID
            ,charge -- 手续费
            ,expenses -- 工本费
            ,contractno -- 交易合同编号
            ,invc_no -- 发票号码
            ,btch_no -- 人行承兑批次号
            ,remitter_remark -- 出票人备注
            ,acceptor_remark -- 承兑人备注
            ,credit_line_no -- 额度占用记录
            ,credit_line -- 额度扣减金额
            ,credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,endst_date -- 签收日期
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,print_status -- 出票状态： 0 未打印 1 已打印
            ,deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,print_cnt -- 凭证打印次数
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
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
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,adjust_charge -- 调整后手续费
            ,guarantee_amount -- 保证金额
            ,adjust_guarantee_amount -- 调整后保证金额
            ,freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员号
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,settle_flag -- 结清登记
            ,task_type -- 任务类型
            ,seq_no -- 序号
            ,ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
            ,sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
            ,misc -- 信息域
            ,ecds_prc_msg -- 人行应答消息
            ,rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
            ,actlog_id -- 记账流水ID
            ,accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
            ,run_code -- 记账唯一标识
            ,accp_detail_remark -- 
            ,record_logno -- 中间表对应的唯一标志
            ,billseq -- 备款标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 承兑协议ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据表ID
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.expenses, o.expenses) as expenses -- 工本费
    ,nvl(n.contractno, o.contractno) as contractno -- 交易合同编号
    ,nvl(n.invc_no, o.invc_no) as invc_no -- 发票号码
    ,nvl(n.btch_no, o.btch_no) as btch_no -- 人行承兑批次号
    ,nvl(n.remitter_remark, o.remitter_remark) as remitter_remark -- 出票人备注
    ,nvl(n.acceptor_remark, o.acceptor_remark) as acceptor_remark -- 承兑人备注
    ,nvl(n.credit_line_no, o.credit_line_no) as credit_line_no -- 额度占用记录
    ,nvl(n.credit_line, o.credit_line) as credit_line -- 额度扣减金额
    ,nvl(n.credit_line_status, o.credit_line_status) as credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
    ,nvl(n.accept_status, o.accept_status) as accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,nvl(n.endst_date, o.endst_date) as endst_date -- 签收日期
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 撤销日期
    ,nvl(n.account_date, o.account_date) as account_date -- 记账日期
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,nvl(n.print_status, o.print_status) as print_status -- 出票状态： 0 未打印 1 已打印
    ,nvl(n.deduct_status, o.deduct_status) as deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
    ,nvl(n.payment_status, o.payment_status) as payment_status -- 付款状态（是否付款）： 0 否 1 是
    ,nvl(n.advance_status, o.advance_status) as advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,nvl(n.print_cnt, o.print_cnt) as print_cnt -- 凭证打印次数
    ,nvl(n.print_flag, o.print_flag) as print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
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
    ,nvl(n.remitter_ratg_agcy, o.remitter_ratg_agcy) as remitter_ratg_agcy -- 出票人评级主体
    ,nvl(n.remitter_ratg_duedt, o.remitter_ratg_duedt) as remitter_ratg_duedt -- 出票人评级到期日
    ,nvl(n.remitter_credit_ratgs, o.remitter_credit_ratgs) as remitter_credit_ratgs -- 出票人信用等级
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人评级主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.accept_date, o.accept_date) as accept_date -- 承兑日期
    ,nvl(n.adjust_charge, o.adjust_charge) as adjust_charge -- 调整后手续费
    ,nvl(n.guarantee_amount, o.guarantee_amount) as guarantee_amount -- 保证金额
    ,nvl(n.adjust_guarantee_amount, o.adjust_guarantee_amount) as adjust_guarantee_amount -- 调整后保证金额
    ,nvl(n.freece_flag, o.freece_flag) as freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后修改时间
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后修改操作员号
    ,nvl(n.register_status, o.register_status) as register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,nvl(n.settle_flag, o.settle_flag) as settle_flag -- 结清登记
    ,nvl(n.task_type, o.task_type) as task_type -- 任务类型
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.ucondl_consgntmrk, o.ucondl_consgntmrk) as ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
    ,nvl(n.sig_mk, o.sig_mk) as sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
    ,nvl(n.misc, o.misc) as misc -- 信息域
    ,nvl(n.ecds_prc_msg, o.ecds_prc_msg) as ecds_prc_msg -- 人行应答消息
    ,nvl(n.rcv_prxy_sgntr, o.rcv_prxy_sgntr) as rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
    ,nvl(n.actlog_id, o.actlog_id) as actlog_id -- 记账流水ID
    ,nvl(n.accptnc_agrmtnb, o.accptnc_agrmtnb) as accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
    ,nvl(n.run_code, o.run_code) as run_code -- 记账唯一标识
    ,nvl(n.accp_detail_remark, o.accp_detail_remark) as accp_detail_remark -- 
    ,nvl(n.record_logno, o.record_logno) as record_logno -- 中间表对应的唯一标志
    ,nvl(n.billseq, o.billseq) as billseq -- 备款标志
    ,nvl(n.sign, o.sign) as sign -- 0签收状态没同步  1签收状态已同步
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
from (select * from ${iol_schema}.bdms_bms_accept_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_accept_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.charge <> n.charge
        or o.expenses <> n.expenses
        or o.contractno <> n.contractno
        or o.invc_no <> n.invc_no
        or o.btch_no <> n.btch_no
        or o.remitter_remark <> n.remitter_remark
        or o.acceptor_remark <> n.acceptor_remark
        or o.credit_line_no <> n.credit_line_no
        or o.credit_line <> n.credit_line
        or o.credit_line_status <> n.credit_line_status
        or o.accept_status <> n.accept_status
        or o.endst_date <> n.endst_date
        or o.cancel_date <> n.cancel_date
        or o.account_date <> n.account_date
        or o.account_flag <> n.account_flag
        or o.print_status <> n.print_status
        or o.deduct_status <> n.deduct_status
        or o.payment_status <> n.payment_status
        or o.advance_status <> n.advance_status
        or o.print_cnt <> n.print_cnt
        or o.print_flag <> n.print_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
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
        or o.remitter_ratg_agcy <> n.remitter_ratg_agcy
        or o.remitter_ratg_duedt <> n.remitter_ratg_duedt
        or o.remitter_credit_ratgs <> n.remitter_credit_ratgs
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.accept_date <> n.accept_date
        or o.adjust_charge <> n.adjust_charge
        or o.guarantee_amount <> n.guarantee_amount
        or o.adjust_guarantee_amount <> n.adjust_guarantee_amount
        or o.freece_flag <> n.freece_flag
        or o.last_txn_date <> n.last_txn_date
        or o.last_operator_no <> n.last_operator_no
        or o.register_status <> n.register_status
        or o.settle_flag <> n.settle_flag
        or o.task_type <> n.task_type
        or o.seq_no <> n.seq_no
        or o.ucondl_consgntmrk <> n.ucondl_consgntmrk
        or o.sig_mk <> n.sig_mk
        or o.misc <> n.misc
        or o.ecds_prc_msg <> n.ecds_prc_msg
        or o.rcv_prxy_sgntr <> n.rcv_prxy_sgntr
        or o.actlog_id <> n.actlog_id
        or o.accptnc_agrmtnb <> n.accptnc_agrmtnb
        or o.run_code <> n.run_code
        or o.accp_detail_remark <> n.accp_detail_remark
        or o.record_logno <> n.record_logno
        or o.billseq <> n.billseq
        or o.sign <> n.sign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_accept_details_cl(
            id -- ID
            ,contract_id -- 承兑协议ID
            ,draft_id -- 票据表ID
            ,charge -- 手续费
            ,expenses -- 工本费
            ,contractno -- 交易合同编号
            ,invc_no -- 发票号码
            ,btch_no -- 人行承兑批次号
            ,remitter_remark -- 出票人备注
            ,acceptor_remark -- 承兑人备注
            ,credit_line_no -- 额度占用记录
            ,credit_line -- 额度扣减金额
            ,credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,endst_date -- 签收日期
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,print_status -- 出票状态： 0 未打印 1 已打印
            ,deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,print_cnt -- 凭证打印次数
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
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
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,adjust_charge -- 调整后手续费
            ,guarantee_amount -- 保证金额
            ,adjust_guarantee_amount -- 调整后保证金额
            ,freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员号
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,settle_flag -- 结清登记
            ,task_type -- 任务类型
            ,seq_no -- 序号
            ,ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
            ,sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
            ,misc -- 信息域
            ,ecds_prc_msg -- 人行应答消息
            ,rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
            ,actlog_id -- 记账流水ID
            ,accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
            ,run_code -- 记账唯一标识
            ,accp_detail_remark -- 
            ,record_logno -- 中间表对应的唯一标志
            ,billseq -- 备款标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_accept_details_op(
            id -- ID
            ,contract_id -- 承兑协议ID
            ,draft_id -- 票据表ID
            ,charge -- 手续费
            ,expenses -- 工本费
            ,contractno -- 交易合同编号
            ,invc_no -- 发票号码
            ,btch_no -- 人行承兑批次号
            ,remitter_remark -- 出票人备注
            ,acceptor_remark -- 承兑人备注
            ,credit_line_no -- 额度占用记录
            ,credit_line -- 额度扣减金额
            ,credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,endst_date -- 签收日期
            ,cancel_date -- 撤销日期
            ,account_date -- 记账日期
            ,account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
            ,print_status -- 出票状态： 0 未打印 1 已打印
            ,deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
            ,payment_status -- 付款状态（是否付款）： 0 否 1 是
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,print_cnt -- 凭证打印次数
            ,print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
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
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人评级主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,accept_date -- 承兑日期
            ,adjust_charge -- 调整后手续费
            ,guarantee_amount -- 保证金额
            ,adjust_guarantee_amount -- 调整后保证金额
            ,freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,last_txn_date -- 最后修改时间
            ,last_operator_no -- 最后修改操作员号
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,settle_flag -- 结清登记
            ,task_type -- 任务类型
            ,seq_no -- 序号
            ,ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
            ,sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
            ,misc -- 信息域
            ,ecds_prc_msg -- 人行应答消息
            ,rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
            ,actlog_id -- 记账流水ID
            ,accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
            ,run_code -- 记账唯一标识
            ,accp_detail_remark -- 
            ,record_logno -- 中间表对应的唯一标志
            ,billseq -- 备款标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.contract_id -- 承兑协议ID
    ,o.draft_id -- 票据表ID
    ,o.charge -- 手续费
    ,o.expenses -- 工本费
    ,o.contractno -- 交易合同编号
    ,o.invc_no -- 发票号码
    ,o.btch_no -- 人行承兑批次号
    ,o.remitter_remark -- 出票人备注
    ,o.acceptor_remark -- 承兑人备注
    ,o.credit_line_no -- 额度占用记录
    ,o.credit_line -- 额度扣减金额
    ,o.credit_line_status -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
    ,o.accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,o.endst_date -- 签收日期
    ,o.cancel_date -- 撤销日期
    ,o.account_date -- 记账日期
    ,o.account_flag -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,o.print_status -- 出票状态： 0 未打印 1 已打印
    ,o.deduct_status -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
    ,o.payment_status -- 付款状态（是否付款）： 0 否 1 是
    ,o.advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,o.print_cnt -- 凭证打印次数
    ,o.print_flag -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
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
    ,o.remitter_ratg_agcy -- 出票人评级主体
    ,o.remitter_ratg_duedt -- 出票人评级到期日
    ,o.remitter_credit_ratgs -- 出票人信用等级
    ,o.acceptor_ratg_agcy -- 承兑人评级主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.accept_date -- 承兑日期
    ,o.adjust_charge -- 调整后手续费
    ,o.guarantee_amount -- 保证金额
    ,o.adjust_guarantee_amount -- 调整后保证金额
    ,o.freece_flag -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,o.last_txn_date -- 最后修改时间
    ,o.last_operator_no -- 最后修改操作员号
    ,o.register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,o.settle_flag -- 结清登记
    ,o.task_type -- 任务类型
    ,o.seq_no -- 序号
    ,o.ucondl_consgntmrk -- 到期无条件支付委托只能填写CC00
    ,o.sig_mk -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
    ,o.misc -- 信息域
    ,o.ecds_prc_msg -- 人行应答消息
    ,o.rcv_prxy_sgntr -- 承兑人代理回复标识-通用回复用PS01客户自己签章
    ,o.actlog_id -- 记账流水ID
    ,o.accptnc_agrmtnb -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
    ,o.run_code -- 记账唯一标识
    ,o.accp_detail_remark -- 
    ,o.record_logno -- 中间表对应的唯一标志
    ,o.billseq -- 备款标志
    ,o.sign -- 0签收状态没同步  1签收状态已同步
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
from ${iol_schema}.bdms_bms_accept_details_bk o
    left join ${iol_schema}.bdms_bms_accept_details_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_accept_details_cl d
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
--truncate table ${iol_schema}.bdms_bms_accept_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_accept_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_accept_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_accept_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_accept_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_accept_details_cl;
alter table ${iol_schema}.bdms_bms_accept_details exchange partition p_20991231 with table ${iol_schema}.bdms_bms_accept_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_accept_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_accept_details_op purge;
drop table ${iol_schema}.bdms_bms_accept_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_accept_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_accept_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
