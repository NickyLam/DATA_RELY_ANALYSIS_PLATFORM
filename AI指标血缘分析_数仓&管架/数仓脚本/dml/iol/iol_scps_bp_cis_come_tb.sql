/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_cis_come_tb
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
create table ${iol_schema}.scps_bp_cis_come_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_cis_come_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_cis_come_tb_op purge;
drop table ${iol_schema}.scps_bp_cis_come_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_cis_come_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_cis_come_tb where 0=1;

create table ${iol_schema}.scps_bp_cis_come_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_cis_come_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_cis_come_tb_cl(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd）
            ,trans_time -- 交易时间
            ,trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
            ,scene_code -- 业务场景码
            ,charge_id -- 授权柜员号
            ,br_code -- 记账机构号
            ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
            ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
            ,business_type -- 1-正常业务、2-退票业务
            ,voucher_code -- 凭证代码,780-支票
            ,voucher_no -- 凭证号码
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,cust_no -- 客户号(本行付款人时才有)
            ,cust_name -- 客户名称
            ,curr_code -- 币种
            ,pay_name -- 付款人名称
            ,pay_acc_no -- 交易对手账号
            ,pay_bank_no -- 付款行名号
            ,pay_bank_name -- 付款行名称
            ,pay_addr -- 付款人地址
            ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
            ,payee_name -- 收款人名称
            ,payee_acc_no -- 收款人账号
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,payee_addr -- 收款人地址
            ,amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,purpose -- 用途（附言）
            ,memoce -- 摘要码
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,tally_send_seqno -- 记账报文流水号
            ,tally_host_seqno -- 记账核心交易流水
            ,tally_host_date -- 记账核心交易日期
            ,pay_send_seqno -- 支付报文流水号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_seqno -- 支付主机流水号
            ,pay_host_date -- 支付主机交易日期
            ,pay_business_no -- 支付业务序号
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,ticket_count -- 票据张数
            ,endorser_num -- 背书人数
            ,endorsers -- 背书清单，背书人之间使用分号;分隔
            ,pay_date -- 提示付款日期 格式yyyyMMdd
            ,pay_password -- 支付密码
            ,trade_date -- 交换日期
            ,micr -- 磁码交易码
            ,out_bk_no -- 提出行行号
            ,out_bk_name -- 提出行名称
            ,in_bk_no -- 提入行行号
            ,in_bk_name -- 提入行名称
            ,billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
            ,trade_round -- 交换场次
            ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
            ,suspend_acctacctpno -- 挂账受理号
            ,start_way -- 提入业务发起方式[1-导入 2-扫描]
            ,return_reason_desc -- 退票理由描述
            ,tran_br_code -- 交易机构编号
            ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
            ,trade_bank_code -- 交换行号
            ,is_special_submit -- 是否特殊提交 0、空-否  1-是
            ,inacct_flag -- 入账标识 0-否  1-是
            ,return_limited -- 包回执期限 单位为天(工作日)
            ,trans_id -- 业务场景种类编号
            ,vouch_group -- 业务场景凭证组合
            ,channel -- 渠道
            ,txcd -- 业务种类
            ,billin_order -- 提入顺序号
            ,task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
            ,doc_id -- 影像批次号
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,trans_no -- 服务码
            ,user_no -- 用户号
            ,organ_no -- 机构号
            ,acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
            ,acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
            ,acct_branch_code -- 账号开户机构
            ,overdraw_amount -- 透支金额
            ,return_ticket_type -- 退票类型 1-行内退票 2-我行退票
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,trade_type -- 业务类型
            ,entr_dt -- 委托日期
            ,pay_txn_ord_nbr -- 支付交易序号
            ,entr_side -- 委托方	
            ,spl_send_ind -- 补发标识	
            ,ret_reason -- 退票原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_cis_come_tb_op(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd）
            ,trans_time -- 交易时间
            ,trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
            ,scene_code -- 业务场景码
            ,charge_id -- 授权柜员号
            ,br_code -- 记账机构号
            ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
            ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
            ,business_type -- 1-正常业务、2-退票业务
            ,voucher_code -- 凭证代码,780-支票
            ,voucher_no -- 凭证号码
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,cust_no -- 客户号(本行付款人时才有)
            ,cust_name -- 客户名称
            ,curr_code -- 币种
            ,pay_name -- 付款人名称
            ,pay_acc_no -- 交易对手账号
            ,pay_bank_no -- 付款行名号
            ,pay_bank_name -- 付款行名称
            ,pay_addr -- 付款人地址
            ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
            ,payee_name -- 收款人名称
            ,payee_acc_no -- 收款人账号
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,payee_addr -- 收款人地址
            ,amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,purpose -- 用途（附言）
            ,memoce -- 摘要码
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,tally_send_seqno -- 记账报文流水号
            ,tally_host_seqno -- 记账核心交易流水
            ,tally_host_date -- 记账核心交易日期
            ,pay_send_seqno -- 支付报文流水号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_seqno -- 支付主机流水号
            ,pay_host_date -- 支付主机交易日期
            ,pay_business_no -- 支付业务序号
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,ticket_count -- 票据张数
            ,endorser_num -- 背书人数
            ,endorsers -- 背书清单，背书人之间使用分号;分隔
            ,pay_date -- 提示付款日期 格式yyyyMMdd
            ,pay_password -- 支付密码
            ,trade_date -- 交换日期
            ,micr -- 磁码交易码
            ,out_bk_no -- 提出行行号
            ,out_bk_name -- 提出行名称
            ,in_bk_no -- 提入行行号
            ,in_bk_name -- 提入行名称
            ,billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
            ,trade_round -- 交换场次
            ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
            ,suspend_acctacctpno -- 挂账受理号
            ,start_way -- 提入业务发起方式[1-导入 2-扫描]
            ,return_reason_desc -- 退票理由描述
            ,tran_br_code -- 交易机构编号
            ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
            ,trade_bank_code -- 交换行号
            ,is_special_submit -- 是否特殊提交 0、空-否  1-是
            ,inacct_flag -- 入账标识 0-否  1-是
            ,return_limited -- 包回执期限 单位为天(工作日)
            ,trans_id -- 业务场景种类编号
            ,vouch_group -- 业务场景凭证组合
            ,channel -- 渠道
            ,txcd -- 业务种类
            ,billin_order -- 提入顺序号
            ,task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
            ,doc_id -- 影像批次号
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,trans_no -- 服务码
            ,user_no -- 用户号
            ,organ_no -- 机构号
            ,acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
            ,acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
            ,acct_branch_code -- 账号开户机构
            ,overdraw_amount -- 透支金额
            ,return_ticket_type -- 退票类型 1-行内退票 2-我行退票
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,trade_type -- 业务类型
            ,entr_dt -- 委托日期
            ,pay_txn_ord_nbr -- 支付交易序号
            ,entr_side -- 委托方	
            ,spl_send_ind -- 补发标识	
            ,ret_reason -- 退票原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期（yyyyMMdd）
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.trans_state, o.trans_state) as trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
    ,nvl(n.scene_code, o.scene_code) as scene_code -- 业务场景码
    ,nvl(n.charge_id, o.charge_id) as charge_id -- 授权柜员号
    ,nvl(n.br_code, o.br_code) as br_code -- 记账机构号
    ,nvl(n.change_channel, o.change_channel) as change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,nvl(n.change_no, o.change_no) as change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
    ,nvl(n.business_type, o.business_type) as business_type -- 1-正常业务、2-退票业务
    ,nvl(n.voucher_code, o.voucher_code) as voucher_code -- 凭证代码,780-支票
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.bill_date, o.bill_date) as bill_date -- 出票日期 格式yyyyMMdd
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号(本行付款人时才有)
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.curr_code, o.curr_code) as curr_code -- 币种
    ,nvl(n.pay_name, o.pay_name) as pay_name -- 付款人名称
    ,nvl(n.pay_acc_no, o.pay_acc_no) as pay_acc_no -- 交易对手账号
    ,nvl(n.pay_bank_no, o.pay_bank_no) as pay_bank_no -- 付款行名号
    ,nvl(n.pay_bank_name, o.pay_bank_name) as pay_bank_name -- 付款行名称
    ,nvl(n.pay_addr, o.pay_addr) as pay_addr -- 付款人地址
    ,nvl(n.inac_flag, o.inac_flag) as inac_flag -- 内部账户标识 0非内部标识 1内部标识
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收款人名称
    ,nvl(n.payee_acc_no, o.payee_acc_no) as payee_acc_no -- 收款人账号
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收款行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收款行名称
    ,nvl(n.payee_addr, o.payee_addr) as payee_addr -- 收款人地址
    ,nvl(n.amount, o.amount) as amount -- 交易金额 例如100.00
    ,nvl(n.trans_amount_ch, o.trans_amount_ch) as trans_amount_ch -- 交易金额(大写)
    ,nvl(n.purpose, o.purpose) as purpose -- 用途（附言）
    ,nvl(n.memoce, o.memoce) as memoce -- 摘要码
    ,nvl(n.tally_state, o.tally_state) as tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,nvl(n.submit_state, o.submit_state) as submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,nvl(n.tally_send_seqno, o.tally_send_seqno) as tally_send_seqno -- 记账报文流水号
    ,nvl(n.tally_host_seqno, o.tally_host_seqno) as tally_host_seqno -- 记账核心交易流水
    ,nvl(n.tally_host_date, o.tally_host_date) as tally_host_date -- 记账核心交易日期
    ,nvl(n.pay_send_seqno, o.pay_send_seqno) as pay_send_seqno -- 支付报文流水号
    ,nvl(n.pay_send_date, o.pay_send_date) as pay_send_date -- 支付报文交易日期
    ,nvl(n.pay_host_seqno, o.pay_host_seqno) as pay_host_seqno -- 支付主机流水号
    ,nvl(n.pay_host_date, o.pay_host_date) as pay_host_date -- 支付主机交易日期
    ,nvl(n.pay_business_no, o.pay_business_no) as pay_business_no -- 支付业务序号
    ,nvl(n.drawee_info_send_result, o.drawee_info_send_result) as drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,nvl(n.drawee_info_send_time, o.drawee_info_send_time) as drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,nvl(n.drawee_info_send_flag, o.drawee_info_send_flag) as drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,nvl(n.ticket_count, o.ticket_count) as ticket_count -- 票据张数
    ,nvl(n.endorser_num, o.endorser_num) as endorser_num -- 背书人数
    ,nvl(n.endorsers, o.endorsers) as endorsers -- 背书清单，背书人之间使用分号;分隔
    ,nvl(n.pay_date, o.pay_date) as pay_date -- 提示付款日期 格式yyyyMMdd
    ,nvl(n.pay_password, o.pay_password) as pay_password -- 支付密码
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交换日期
    ,nvl(n.micr, o.micr) as micr -- 磁码交易码
    ,nvl(n.out_bk_no, o.out_bk_no) as out_bk_no -- 提出行行号
    ,nvl(n.out_bk_name, o.out_bk_name) as out_bk_name -- 提出行名称
    ,nvl(n.in_bk_no, o.in_bk_no) as in_bk_no -- 提入行行号
    ,nvl(n.in_bk_name, o.in_bk_name) as in_bk_name -- 提入行名称
    ,nvl(n.billnd, o.billnd) as billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
    ,nvl(n.trade_round, o.trade_round) as trade_round -- 交换场次
    ,nvl(n.acct_do_type, o.acct_do_type) as acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,nvl(n.suspend_acctacctpno, o.suspend_acctacctpno) as suspend_acctacctpno -- 挂账受理号
    ,nvl(n.start_way, o.start_way) as start_way -- 提入业务发起方式[1-导入 2-扫描]
    ,nvl(n.return_reason_desc, o.return_reason_desc) as return_reason_desc -- 退票理由描述
    ,nvl(n.tran_br_code, o.tran_br_code) as tran_br_code -- 交易机构编号
    ,nvl(n.if_sensitive_account, o.if_sensitive_account) as if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,nvl(n.trade_bank_code, o.trade_bank_code) as trade_bank_code -- 交换行号
    ,nvl(n.is_special_submit, o.is_special_submit) as is_special_submit -- 是否特殊提交 0、空-否  1-是
    ,nvl(n.inacct_flag, o.inacct_flag) as inacct_flag -- 入账标识 0-否  1-是
    ,nvl(n.return_limited, o.return_limited) as return_limited -- 包回执期限 单位为天(工作日)
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 业务场景种类编号
    ,nvl(n.vouch_group, o.vouch_group) as vouch_group -- 业务场景凭证组合
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.txcd, o.txcd) as txcd -- 业务种类
    ,nvl(n.billin_order, o.billin_order) as billin_order -- 提入顺序号
    ,nvl(n.task_create_status, o.task_create_status) as task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像批次号
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统号
    ,nvl(n.trans_no, o.trans_no) as trans_no -- 服务码
    ,nvl(n.user_no, o.user_no) as user_no -- 用户号
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 机构号
    ,nvl(n.acct_state, o.acct_state) as acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
    ,nvl(n.acct_balance_state, o.acct_balance_state) as acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
    ,nvl(n.acct_branch_code, o.acct_branch_code) as acct_branch_code -- 账号开户机构
    ,nvl(n.overdraw_amount, o.overdraw_amount) as overdraw_amount -- 透支金额
    ,nvl(n.return_ticket_type, o.return_ticket_type) as return_ticket_type -- 退票类型 1-行内退票 2-我行退票
    ,nvl(n.model_code, o.model_code) as model_code -- 影像模型
    ,nvl(n.busi_start_date, o.busi_start_date) as busi_start_date -- 影像上传时间
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 业务类型
    ,nvl(n.entr_dt, o.entr_dt) as entr_dt -- 委托日期
    ,nvl(n.pay_txn_ord_nbr, o.pay_txn_ord_nbr) as pay_txn_ord_nbr -- 支付交易序号
    ,nvl(n.entr_side, o.entr_side) as entr_side -- 委托方	
    ,nvl(n.spl_send_ind, o.spl_send_ind) as spl_send_ind -- 补发标识	
    ,nvl(n.ret_reason, o.ret_reason) as ret_reason -- 退票原因
    ,case when
            n.task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_cis_come_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_cis_come_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
where (
        o.task_id is null
    )
    or (
        n.task_id is null
    )
    or (
        o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.trans_state <> n.trans_state
        or o.scene_code <> n.scene_code
        or o.charge_id <> n.charge_id
        or o.br_code <> n.br_code
        or o.change_channel <> n.change_channel
        or o.change_no <> n.change_no
        or o.business_type <> n.business_type
        or o.voucher_code <> n.voucher_code
        or o.voucher_no <> n.voucher_no
        or o.bill_date <> n.bill_date
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.curr_code <> n.curr_code
        or o.pay_name <> n.pay_name
        or o.pay_acc_no <> n.pay_acc_no
        or o.pay_bank_no <> n.pay_bank_no
        or o.pay_bank_name <> n.pay_bank_name
        or o.pay_addr <> n.pay_addr
        or o.inac_flag <> n.inac_flag
        or o.payee_name <> n.payee_name
        or o.payee_acc_no <> n.payee_acc_no
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_addr <> n.payee_addr
        or o.amount <> n.amount
        or o.trans_amount_ch <> n.trans_amount_ch
        or o.purpose <> n.purpose
        or o.memoce <> n.memoce
        or o.tally_state <> n.tally_state
        or o.submit_state <> n.submit_state
        or o.tally_send_seqno <> n.tally_send_seqno
        or o.tally_host_seqno <> n.tally_host_seqno
        or o.tally_host_date <> n.tally_host_date
        or o.pay_send_seqno <> n.pay_send_seqno
        or o.pay_send_date <> n.pay_send_date
        or o.pay_host_seqno <> n.pay_host_seqno
        or o.pay_host_date <> n.pay_host_date
        or o.pay_business_no <> n.pay_business_no
        or o.drawee_info_send_result <> n.drawee_info_send_result
        or o.drawee_info_send_time <> n.drawee_info_send_time
        or o.drawee_info_send_flag <> n.drawee_info_send_flag
        or o.ticket_count <> n.ticket_count
        or o.endorser_num <> n.endorser_num
        or o.endorsers <> n.endorsers
        or o.pay_date <> n.pay_date
        or o.pay_password <> n.pay_password
        or o.trade_date <> n.trade_date
        or o.micr <> n.micr
        or o.out_bk_no <> n.out_bk_no
        or o.out_bk_name <> n.out_bk_name
        or o.in_bk_no <> n.in_bk_no
        or o.in_bk_name <> n.in_bk_name
        or o.billnd <> n.billnd
        or o.trade_round <> n.trade_round
        or o.acct_do_type <> n.acct_do_type
        or o.suspend_acctacctpno <> n.suspend_acctacctpno
        or o.start_way <> n.start_way
        or o.return_reason_desc <> n.return_reason_desc
        or o.tran_br_code <> n.tran_br_code
        or o.if_sensitive_account <> n.if_sensitive_account
        or o.trade_bank_code <> n.trade_bank_code
        or o.is_special_submit <> n.is_special_submit
        or o.inacct_flag <> n.inacct_flag
        or o.return_limited <> n.return_limited
        or o.trans_id <> n.trans_id
        or o.vouch_group <> n.vouch_group
        or o.channel <> n.channel
        or o.txcd <> n.txcd
        or o.billin_order <> n.billin_order
        or o.task_create_status <> n.task_create_status
        or o.doc_id <> n.doc_id
        or o.glob_seq_num <> n.glob_seq_num
        or o.bank_no <> n.bank_no
        or o.system_no <> n.system_no
        or o.trans_no <> n.trans_no
        or o.user_no <> n.user_no
        or o.organ_no <> n.organ_no
        or o.acct_state <> n.acct_state
        or o.acct_balance_state <> n.acct_balance_state
        or o.acct_branch_code <> n.acct_branch_code
        or o.overdraw_amount <> n.overdraw_amount
        or o.return_ticket_type <> n.return_ticket_type
        or o.model_code <> n.model_code
        or o.busi_start_date <> n.busi_start_date
        or o.trade_type <> n.trade_type
        or o.entr_dt <> n.entr_dt
        or o.pay_txn_ord_nbr <> n.pay_txn_ord_nbr
        or o.entr_side <> n.entr_side
        or o.spl_send_ind <> n.spl_send_ind
        or o.ret_reason <> n.ret_reason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_cis_come_tb_cl(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd）
            ,trans_time -- 交易时间
            ,trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
            ,scene_code -- 业务场景码
            ,charge_id -- 授权柜员号
            ,br_code -- 记账机构号
            ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
            ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
            ,business_type -- 1-正常业务、2-退票业务
            ,voucher_code -- 凭证代码,780-支票
            ,voucher_no -- 凭证号码
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,cust_no -- 客户号(本行付款人时才有)
            ,cust_name -- 客户名称
            ,curr_code -- 币种
            ,pay_name -- 付款人名称
            ,pay_acc_no -- 交易对手账号
            ,pay_bank_no -- 付款行名号
            ,pay_bank_name -- 付款行名称
            ,pay_addr -- 付款人地址
            ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
            ,payee_name -- 收款人名称
            ,payee_acc_no -- 收款人账号
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,payee_addr -- 收款人地址
            ,amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,purpose -- 用途（附言）
            ,memoce -- 摘要码
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,tally_send_seqno -- 记账报文流水号
            ,tally_host_seqno -- 记账核心交易流水
            ,tally_host_date -- 记账核心交易日期
            ,pay_send_seqno -- 支付报文流水号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_seqno -- 支付主机流水号
            ,pay_host_date -- 支付主机交易日期
            ,pay_business_no -- 支付业务序号
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,ticket_count -- 票据张数
            ,endorser_num -- 背书人数
            ,endorsers -- 背书清单，背书人之间使用分号;分隔
            ,pay_date -- 提示付款日期 格式yyyyMMdd
            ,pay_password -- 支付密码
            ,trade_date -- 交换日期
            ,micr -- 磁码交易码
            ,out_bk_no -- 提出行行号
            ,out_bk_name -- 提出行名称
            ,in_bk_no -- 提入行行号
            ,in_bk_name -- 提入行名称
            ,billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
            ,trade_round -- 交换场次
            ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
            ,suspend_acctacctpno -- 挂账受理号
            ,start_way -- 提入业务发起方式[1-导入 2-扫描]
            ,return_reason_desc -- 退票理由描述
            ,tran_br_code -- 交易机构编号
            ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
            ,trade_bank_code -- 交换行号
            ,is_special_submit -- 是否特殊提交 0、空-否  1-是
            ,inacct_flag -- 入账标识 0-否  1-是
            ,return_limited -- 包回执期限 单位为天(工作日)
            ,trans_id -- 业务场景种类编号
            ,vouch_group -- 业务场景凭证组合
            ,channel -- 渠道
            ,txcd -- 业务种类
            ,billin_order -- 提入顺序号
            ,task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
            ,doc_id -- 影像批次号
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,trans_no -- 服务码
            ,user_no -- 用户号
            ,organ_no -- 机构号
            ,acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
            ,acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
            ,acct_branch_code -- 账号开户机构
            ,overdraw_amount -- 透支金额
            ,return_ticket_type -- 退票类型 1-行内退票 2-我行退票
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,trade_type -- 业务类型
            ,entr_dt -- 委托日期
            ,pay_txn_ord_nbr -- 支付交易序号
            ,entr_side -- 委托方	
            ,spl_send_ind -- 补发标识	
            ,ret_reason -- 退票原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_cis_come_tb_op(
            task_id -- 任务号
            ,trans_date -- 交易日期（yyyyMMdd）
            ,trans_time -- 交易时间
            ,trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
            ,scene_code -- 业务场景码
            ,charge_id -- 授权柜员号
            ,br_code -- 记账机构号
            ,change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
            ,change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
            ,business_type -- 1-正常业务、2-退票业务
            ,voucher_code -- 凭证代码,780-支票
            ,voucher_no -- 凭证号码
            ,bill_date -- 出票日期 格式yyyyMMdd
            ,cust_no -- 客户号(本行付款人时才有)
            ,cust_name -- 客户名称
            ,curr_code -- 币种
            ,pay_name -- 付款人名称
            ,pay_acc_no -- 交易对手账号
            ,pay_bank_no -- 付款行名号
            ,pay_bank_name -- 付款行名称
            ,pay_addr -- 付款人地址
            ,inac_flag -- 内部账户标识 0非内部标识 1内部标识
            ,payee_name -- 收款人名称
            ,payee_acc_no -- 收款人账号
            ,payee_bank_no -- 收款行行号
            ,payee_bank_name -- 收款行名称
            ,payee_addr -- 收款人地址
            ,amount -- 交易金额 例如100.00
            ,trans_amount_ch -- 交易金额(大写)
            ,purpose -- 用途（附言）
            ,memoce -- 摘要码
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,tally_send_seqno -- 记账报文流水号
            ,tally_host_seqno -- 记账核心交易流水
            ,tally_host_date -- 记账核心交易日期
            ,pay_send_seqno -- 支付报文流水号
            ,pay_send_date -- 支付报文交易日期
            ,pay_host_seqno -- 支付主机流水号
            ,pay_host_date -- 支付主机交易日期
            ,pay_business_no -- 支付业务序号
            ,drawee_info_send_result -- 收款人信息处理结果 处理结果描述
            ,drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
            ,drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
            ,ticket_count -- 票据张数
            ,endorser_num -- 背书人数
            ,endorsers -- 背书清单，背书人之间使用分号;分隔
            ,pay_date -- 提示付款日期 格式yyyyMMdd
            ,pay_password -- 支付密码
            ,trade_date -- 交换日期
            ,micr -- 磁码交易码
            ,out_bk_no -- 提出行行号
            ,out_bk_name -- 提出行名称
            ,in_bk_no -- 提入行行号
            ,in_bk_name -- 提入行名称
            ,billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
            ,trade_round -- 交换场次
            ,acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
            ,suspend_acctacctpno -- 挂账受理号
            ,start_way -- 提入业务发起方式[1-导入 2-扫描]
            ,return_reason_desc -- 退票理由描述
            ,tran_br_code -- 交易机构编号
            ,if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
            ,trade_bank_code -- 交换行号
            ,is_special_submit -- 是否特殊提交 0、空-否  1-是
            ,inacct_flag -- 入账标识 0-否  1-是
            ,return_limited -- 包回执期限 单位为天(工作日)
            ,trans_id -- 业务场景种类编号
            ,vouch_group -- 业务场景凭证组合
            ,channel -- 渠道
            ,txcd -- 业务种类
            ,billin_order -- 提入顺序号
            ,task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
            ,doc_id -- 影像批次号
            ,glob_seq_num -- 全局流水号
            ,bank_no -- 银行号
            ,system_no -- 系统号
            ,trans_no -- 服务码
            ,user_no -- 用户号
            ,organ_no -- 机构号
            ,acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
            ,acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
            ,acct_branch_code -- 账号开户机构
            ,overdraw_amount -- 透支金额
            ,return_ticket_type -- 退票类型 1-行内退票 2-我行退票
            ,model_code -- 影像模型
            ,busi_start_date -- 影像上传时间
            ,trade_type -- 业务类型
            ,entr_dt -- 委托日期
            ,pay_txn_ord_nbr -- 支付交易序号
            ,entr_side -- 委托方	
            ,spl_send_ind -- 补发标识	
            ,ret_reason -- 退票原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.trans_date -- 交易日期（yyyyMMdd）
    ,o.trans_time -- 交易时间
    ,o.trans_state -- E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
    ,o.scene_code -- 业务场景码
    ,o.charge_id -- 授权柜员号
    ,o.br_code -- 记账机构号
    ,o.change_channel -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,o.change_no -- 提入行场次属性:1-只参加一场 2-可参加两场
    ,o.business_type -- 1-正常业务、2-退票业务
    ,o.voucher_code -- 凭证代码,780-支票
    ,o.voucher_no -- 凭证号码
    ,o.bill_date -- 出票日期 格式yyyyMMdd
    ,o.cust_no -- 客户号(本行付款人时才有)
    ,o.cust_name -- 客户名称
    ,o.curr_code -- 币种
    ,o.pay_name -- 付款人名称
    ,o.pay_acc_no -- 交易对手账号
    ,o.pay_bank_no -- 付款行名号
    ,o.pay_bank_name -- 付款行名称
    ,o.pay_addr -- 付款人地址
    ,o.inac_flag -- 内部账户标识 0非内部标识 1内部标识
    ,o.payee_name -- 收款人名称
    ,o.payee_acc_no -- 收款人账号
    ,o.payee_bank_no -- 收款行行号
    ,o.payee_bank_name -- 收款行名称
    ,o.payee_addr -- 收款人地址
    ,o.amount -- 交易金额 例如100.00
    ,o.trans_amount_ch -- 交易金额(大写)
    ,o.purpose -- 用途（附言）
    ,o.memoce -- 摘要码
    ,o.tally_state -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,o.submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,o.tally_send_seqno -- 记账报文流水号
    ,o.tally_host_seqno -- 记账核心交易流水
    ,o.tally_host_date -- 记账核心交易日期
    ,o.pay_send_seqno -- 支付报文流水号
    ,o.pay_send_date -- 支付报文交易日期
    ,o.pay_host_seqno -- 支付主机流水号
    ,o.pay_host_date -- 支付主机交易日期
    ,o.pay_business_no -- 支付业务序号
    ,o.drawee_info_send_result -- 收款人信息处理结果 处理结果描述
    ,o.drawee_info_send_time -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,o.drawee_info_send_flag -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,o.ticket_count -- 票据张数
    ,o.endorser_num -- 背书人数
    ,o.endorsers -- 背书清单，背书人之间使用分号;分隔
    ,o.pay_date -- 提示付款日期 格式yyyyMMdd
    ,o.pay_password -- 支付密码
    ,o.trade_date -- 交换日期
    ,o.micr -- 磁码交易码
    ,o.out_bk_no -- 提出行行号
    ,o.out_bk_name -- 提出行名称
    ,o.in_bk_no -- 提入行行号
    ,o.in_bk_name -- 提入行名称
    ,o.billnd -- 票据标识 0-无纸质票据业务 1-纸质票据业务
    ,o.trade_round -- 交换场次
    ,o.acct_do_type -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,o.suspend_acctacctpno -- 挂账受理号
    ,o.start_way -- 提入业务发起方式[1-导入 2-扫描]
    ,o.return_reason_desc -- 退票理由描述
    ,o.tran_br_code -- 交易机构编号
    ,o.if_sensitive_account -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,o.trade_bank_code -- 交换行号
    ,o.is_special_submit -- 是否特殊提交 0、空-否  1-是
    ,o.inacct_flag -- 入账标识 0-否  1-是
    ,o.return_limited -- 包回执期限 单位为天(工作日)
    ,o.trans_id -- 业务场景种类编号
    ,o.vouch_group -- 业务场景凭证组合
    ,o.channel -- 渠道
    ,o.txcd -- 业务种类
    ,o.billin_order -- 提入顺序号
    ,o.task_create_status -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,o.doc_id -- 影像批次号
    ,o.glob_seq_num -- 全局流水号
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统号
    ,o.trans_no -- 服务码
    ,o.user_no -- 用户号
    ,o.organ_no -- 机构号
    ,o.acct_state -- 账号状态 0-关闭 1-正常 2-账户挂失
    ,o.acct_balance_state -- 账号余额信息 0-余额充足 1-余额不足
    ,o.acct_branch_code -- 账号开户机构
    ,o.overdraw_amount -- 透支金额
    ,o.return_ticket_type -- 退票类型 1-行内退票 2-我行退票
    ,o.model_code -- 影像模型
    ,o.busi_start_date -- 影像上传时间
    ,o.trade_type -- 业务类型
    ,o.entr_dt -- 委托日期
    ,o.pay_txn_ord_nbr -- 支付交易序号
    ,o.entr_side -- 委托方	
    ,o.spl_send_ind -- 补发标识	
    ,o.ret_reason -- 退票原因
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
from ${iol_schema}.scps_bp_cis_come_tb_bk o
    left join ${iol_schema}.scps_bp_cis_come_tb_op n
        on
            o.task_id = n.task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_cis_come_tb_cl d
        on
            o.task_id = d.task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_cis_come_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_cis_come_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_cis_come_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_cis_come_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_cis_come_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_cis_come_tb_cl;
alter table ${iol_schema}.scps_bp_cis_come_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_cis_come_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_cis_come_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_cis_come_tb_op purge;
drop table ${iol_schema}.scps_bp_cis_come_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_cis_come_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_cis_come_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
