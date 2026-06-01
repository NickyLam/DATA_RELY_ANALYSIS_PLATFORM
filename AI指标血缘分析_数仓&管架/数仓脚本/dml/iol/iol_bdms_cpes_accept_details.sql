/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_accept_details
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
create table ${iol_schema}.bdms_cpes_accept_details_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_accept_details
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_accept_details_op purge;
drop table ${iol_schema}.bdms_cpes_accept_details_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_accept_details_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_accept_details where 0=1;

create table ${iol_schema}.bdms_cpes_accept_details_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_accept_details where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_accept_details_cl(
            id -- ID
            ,draft_id -- 登记中心ID
            ,contract_id -- 承兑批次ID
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_number -- 票据号码/票据包编号
            ,draft_bp_range -- 票据包区间
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,acceptor_date -- 承兑签收日期
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,deposit_amount -- 保证金金额
            ,deduct_amount -- 扣款金额
            ,advance_amount -- 垫款金额
            ,charge -- 手续费
            ,bp_num -- 票据数量
            ,std_amt -- 标准金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 报文批次号
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payee_name -- 收票人名称
            ,payee_account -- 收票人账号
            ,payee_bank_no -- 收票人开户行行号
            ,payee_bank_name -- 收票人开户行名称
            ,payee_brh_no -- 收票人开户机构代码
            ,payee_soc_code -- 收票人社会信用代码
            ,payee_type -- 收票人类型
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_soc_code -- 承兑人社会信用代码
            ,acceptor_type -- 承兑人类型
            ,acceptor_brh_no -- 承兑人机构代码
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,req_remark -- 出票人备注
            ,rcv_remark -- 承兑人备注
            ,busi_branch_no -- 交易机构编号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,adjust_charge -- 调整后费用
            ,adjust_deposit_amount -- 调整后保证金
            ,valid_flag -- 有效标识
            ,apply_id -- 解析表ID
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,payment_ubank_no -- 付款行联行编号
            ,misc -- 信息域
            ,account_date -- 记账日期
            ,run_code -- 记账唯一标识
            ,record_logno -- 中间表对应的唯一标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_accept_details_op(
            id -- ID
            ,draft_id -- 登记中心ID
            ,contract_id -- 承兑批次ID
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_number -- 票据号码/票据包编号
            ,draft_bp_range -- 票据包区间
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,acceptor_date -- 承兑签收日期
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,deposit_amount -- 保证金金额
            ,deduct_amount -- 扣款金额
            ,advance_amount -- 垫款金额
            ,charge -- 手续费
            ,bp_num -- 票据数量
            ,std_amt -- 标准金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 报文批次号
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payee_name -- 收票人名称
            ,payee_account -- 收票人账号
            ,payee_bank_no -- 收票人开户行行号
            ,payee_bank_name -- 收票人开户行名称
            ,payee_brh_no -- 收票人开户机构代码
            ,payee_soc_code -- 收票人社会信用代码
            ,payee_type -- 收票人类型
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_soc_code -- 承兑人社会信用代码
            ,acceptor_type -- 承兑人类型
            ,acceptor_brh_no -- 承兑人机构代码
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,req_remark -- 出票人备注
            ,rcv_remark -- 承兑人备注
            ,busi_branch_no -- 交易机构编号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,adjust_charge -- 调整后费用
            ,adjust_deposit_amount -- 调整后保证金
            ,valid_flag -- 有效标识
            ,apply_id -- 解析表ID
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,payment_ubank_no -- 付款行联行编号
            ,misc -- 信息域
            ,account_date -- 记账日期
            ,run_code -- 记账唯一标识
            ,record_logno -- 中间表对应的唯一标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 登记中心ID
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 承兑批次ID
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码/票据包编号
    ,nvl(n.draft_bp_range, o.draft_bp_range) as draft_bp_range -- 票据包区间
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 票据金额
    ,nvl(n.remit_date, o.remit_date) as remit_date -- 出票日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.acceptor_date, o.acceptor_date) as acceptor_date -- 承兑签收日期
    ,nvl(n.end_smt_flag, o.end_smt_flag) as end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,nvl(n.deposit_amount, o.deposit_amount) as deposit_amount -- 保证金金额
    ,nvl(n.deduct_amount, o.deduct_amount) as deduct_amount -- 扣款金额
    ,nvl(n.advance_amount, o.advance_amount) as advance_amount -- 垫款金额
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.bp_num, o.bp_num) as bp_num -- 票据数量
    ,nvl(n.std_amt, o.std_amt) as std_amt -- 标准金额
    ,nvl(n.txl_ctrct_nb, o.txl_ctrct_nb) as txl_ctrct_nb -- 交易合同编号
    ,nvl(n.invc_nb, o.invc_nb) as invc_nb -- 发票号码
    ,nvl(n.btch_nb, o.btch_nb) as btch_nb -- 报文批次号
    ,nvl(n.remitter_name, o.remitter_name) as remitter_name -- 出票人名称
    ,nvl(n.remitter_account, o.remitter_account) as remitter_account -- 出票人账号
    ,nvl(n.remitter_bank_no, o.remitter_bank_no) as remitter_bank_no -- 出票人开户行行号
    ,nvl(n.remitter_bank_name, o.remitter_bank_name) as remitter_bank_name -- 出票人开户行名称
    ,nvl(n.remitter_cust_no, o.remitter_cust_no) as remitter_cust_no -- 出票人客户号
    ,nvl(n.remitter_soc_code, o.remitter_soc_code) as remitter_soc_code -- 出票人社会信用代码
    ,nvl(n.remitter_type, o.remitter_type) as remitter_type -- 出票人类型
    ,nvl(n.remitter_brh_no, o.remitter_brh_no) as remitter_brh_no -- 出票人开户机构代码
    ,nvl(n.payee_name, o.payee_name) as payee_name -- 收票人名称
    ,nvl(n.payee_account, o.payee_account) as payee_account -- 收票人账号
    ,nvl(n.payee_bank_no, o.payee_bank_no) as payee_bank_no -- 收票人开户行行号
    ,nvl(n.payee_bank_name, o.payee_bank_name) as payee_bank_name -- 收票人开户行名称
    ,nvl(n.payee_brh_no, o.payee_brh_no) as payee_brh_no -- 收票人开户机构代码
    ,nvl(n.payee_soc_code, o.payee_soc_code) as payee_soc_code -- 收票人社会信用代码
    ,nvl(n.payee_type, o.payee_type) as payee_type -- 收票人类型
    ,nvl(n.acceptor_name, o.acceptor_name) as acceptor_name -- 承兑人名称
    ,nvl(n.acceptor_account, o.acceptor_account) as acceptor_account -- 承兑人账号
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑人开户行号
    ,nvl(n.acceptor_bank_name, o.acceptor_bank_name) as acceptor_bank_name -- 承兑人开户行名称
    ,nvl(n.acceptor_soc_code, o.acceptor_soc_code) as acceptor_soc_code -- 承兑人社会信用代码
    ,nvl(n.acceptor_type, o.acceptor_type) as acceptor_type -- 承兑人类型
    ,nvl(n.acceptor_brh_no, o.acceptor_brh_no) as acceptor_brh_no -- 承兑人机构代码
    ,nvl(n.remitter_ratg_agcy, o.remitter_ratg_agcy) as remitter_ratg_agcy -- 出票人评级主体
    ,nvl(n.remitter_ratg_duedt, o.remitter_ratg_duedt) as remitter_ratg_duedt -- 出票人评级到期日
    ,nvl(n.remitter_credit_ratgs, o.remitter_credit_ratgs) as remitter_credit_ratgs -- 出票人信用等级
    ,nvl(n.acceptor_ratg_agcy, o.acceptor_ratg_agcy) as acceptor_ratg_agcy -- 承兑人信用主体
    ,nvl(n.acceptor_ratg_duedt, o.acceptor_ratg_duedt) as acceptor_ratg_duedt -- 承兑人评级到期日
    ,nvl(n.acceptor_credit_ratgs, o.acceptor_credit_ratgs) as acceptor_credit_ratgs -- 承兑人信用等级
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.deduct_status, o.deduct_status) as deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
    ,nvl(n.advance_status, o.advance_status) as advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,nvl(n.freece_flag, o.freece_flag) as freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,nvl(n.req_remark, o.req_remark) as req_remark -- 出票人备注
    ,nvl(n.rcv_remark, o.rcv_remark) as rcv_remark -- 承兑人备注
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 交易机构编号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总机构号
    ,nvl(n.create_operator, o.create_operator) as create_operator -- 创建操作员
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_operator, o.last_operator) as last_operator -- 最后修改操作员
    ,nvl(n.last_update_time, o.last_update_time) as last_update_time -- 最后修改时间
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.adjust_charge, o.adjust_charge) as adjust_charge -- 调整后费用
    ,nvl(n.adjust_deposit_amount, o.adjust_deposit_amount) as adjust_deposit_amount -- 调整后保证金
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 有效标识
    ,nvl(n.apply_id, o.apply_id) as apply_id -- 解析表ID
    ,nvl(n.accept_status, o.accept_status) as accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,nvl(n.payment_ubank_no, o.payment_ubank_no) as payment_ubank_no -- 付款行联行编号
    ,nvl(n.misc, o.misc) as misc -- 信息域
    ,nvl(n.account_date, o.account_date) as account_date -- 记账日期
    ,nvl(n.run_code, o.run_code) as run_code -- 记账唯一标识
    ,nvl(n.record_logno, o.record_logno) as record_logno -- 中间表对应的唯一标志
    ,nvl(n.sign, o.sign) as sign -- 0签收状态没同步  1签收状态已同步
    ,case when
            n.id is null
            and n.adjust_deposit_amount is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.adjust_deposit_amount is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.adjust_deposit_amount is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_cpes_accept_details_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_accept_details where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.adjust_deposit_amount = n.adjust_deposit_amount
where (
        o.id is null
        and o.adjust_deposit_amount is null
    )
    or (
        n.id is null
        and n.adjust_deposit_amount is null
    )
    or (
        o.draft_id <> n.draft_id
        or o.contract_id <> n.contract_id
        or o.draft_attr <> n.draft_attr
        or o.draft_number <> n.draft_number
        or o.draft_bp_range <> n.draft_bp_range
        or o.draft_amount <> n.draft_amount
        or o.remit_date <> n.remit_date
        or o.maturity_date <> n.maturity_date
        or o.acceptor_date <> n.acceptor_date
        or o.end_smt_flag <> n.end_smt_flag
        or o.deposit_amount <> n.deposit_amount
        or o.deduct_amount <> n.deduct_amount
        or o.advance_amount <> n.advance_amount
        or o.charge <> n.charge
        or o.bp_num <> n.bp_num
        or o.std_amt <> n.std_amt
        or o.txl_ctrct_nb <> n.txl_ctrct_nb
        or o.invc_nb <> n.invc_nb
        or o.btch_nb <> n.btch_nb
        or o.remitter_name <> n.remitter_name
        or o.remitter_account <> n.remitter_account
        or o.remitter_bank_no <> n.remitter_bank_no
        or o.remitter_bank_name <> n.remitter_bank_name
        or o.remitter_cust_no <> n.remitter_cust_no
        or o.remitter_soc_code <> n.remitter_soc_code
        or o.remitter_type <> n.remitter_type
        or o.remitter_brh_no <> n.remitter_brh_no
        or o.payee_name <> n.payee_name
        or o.payee_account <> n.payee_account
        or o.payee_bank_no <> n.payee_bank_no
        or o.payee_bank_name <> n.payee_bank_name
        or o.payee_brh_no <> n.payee_brh_no
        or o.payee_soc_code <> n.payee_soc_code
        or o.payee_type <> n.payee_type
        or o.acceptor_name <> n.acceptor_name
        or o.acceptor_account <> n.acceptor_account
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.acceptor_bank_name <> n.acceptor_bank_name
        or o.acceptor_soc_code <> n.acceptor_soc_code
        or o.acceptor_type <> n.acceptor_type
        or o.acceptor_brh_no <> n.acceptor_brh_no
        or o.remitter_ratg_agcy <> n.remitter_ratg_agcy
        or o.remitter_ratg_duedt <> n.remitter_ratg_duedt
        or o.remitter_credit_ratgs <> n.remitter_credit_ratgs
        or o.acceptor_ratg_agcy <> n.acceptor_ratg_agcy
        or o.acceptor_ratg_duedt <> n.acceptor_ratg_duedt
        or o.acceptor_credit_ratgs <> n.acceptor_credit_ratgs
        or o.message_status <> n.message_status
        or o.account_status <> n.account_status
        or o.deduct_status <> n.deduct_status
        or o.advance_status <> n.advance_status
        or o.freece_flag <> n.freece_flag
        or o.req_remark <> n.req_remark
        or o.rcv_remark <> n.rcv_remark
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.create_operator <> n.create_operator
        or o.create_time <> n.create_time
        or o.last_operator <> n.last_operator
        or o.last_update_time <> n.last_update_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.adjust_charge <> n.adjust_charge
        or o.valid_flag <> n.valid_flag
        or o.apply_id <> n.apply_id
        or o.accept_status <> n.accept_status
        or o.payment_ubank_no <> n.payment_ubank_no
        or o.misc <> n.misc
        or o.account_date <> n.account_date
        or o.run_code <> n.run_code
        or o.record_logno <> n.record_logno
        or o.sign <> n.sign
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_accept_details_cl(
            id -- ID
            ,draft_id -- 登记中心ID
            ,contract_id -- 承兑批次ID
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_number -- 票据号码/票据包编号
            ,draft_bp_range -- 票据包区间
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,acceptor_date -- 承兑签收日期
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,deposit_amount -- 保证金金额
            ,deduct_amount -- 扣款金额
            ,advance_amount -- 垫款金额
            ,charge -- 手续费
            ,bp_num -- 票据数量
            ,std_amt -- 标准金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 报文批次号
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payee_name -- 收票人名称
            ,payee_account -- 收票人账号
            ,payee_bank_no -- 收票人开户行行号
            ,payee_bank_name -- 收票人开户行名称
            ,payee_brh_no -- 收票人开户机构代码
            ,payee_soc_code -- 收票人社会信用代码
            ,payee_type -- 收票人类型
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_soc_code -- 承兑人社会信用代码
            ,acceptor_type -- 承兑人类型
            ,acceptor_brh_no -- 承兑人机构代码
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,req_remark -- 出票人备注
            ,rcv_remark -- 承兑人备注
            ,busi_branch_no -- 交易机构编号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,adjust_charge -- 调整后费用
            ,adjust_deposit_amount -- 调整后保证金
            ,valid_flag -- 有效标识
            ,apply_id -- 解析表ID
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,payment_ubank_no -- 付款行联行编号
            ,misc -- 信息域
            ,account_date -- 记账日期
            ,run_code -- 记账唯一标识
            ,record_logno -- 中间表对应的唯一标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_accept_details_op(
            id -- ID
            ,draft_id -- 登记中心ID
            ,contract_id -- 承兑批次ID
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,draft_number -- 票据号码/票据包编号
            ,draft_bp_range -- 票据包区间
            ,draft_amount -- 票据金额
            ,remit_date -- 出票日
            ,maturity_date -- 到期日
            ,acceptor_date -- 承兑签收日期
            ,end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
            ,deposit_amount -- 保证金金额
            ,deduct_amount -- 扣款金额
            ,advance_amount -- 垫款金额
            ,charge -- 手续费
            ,bp_num -- 票据数量
            ,std_amt -- 标准金额
            ,txl_ctrct_nb -- 交易合同编号
            ,invc_nb -- 发票号码
            ,btch_nb -- 报文批次号
            ,remitter_name -- 出票人名称
            ,remitter_account -- 出票人账号
            ,remitter_bank_no -- 出票人开户行行号
            ,remitter_bank_name -- 出票人开户行名称
            ,remitter_cust_no -- 出票人客户号
            ,remitter_soc_code -- 出票人社会信用代码
            ,remitter_type -- 出票人类型
            ,remitter_brh_no -- 出票人开户机构代码
            ,payee_name -- 收票人名称
            ,payee_account -- 收票人账号
            ,payee_bank_no -- 收票人开户行行号
            ,payee_bank_name -- 收票人开户行名称
            ,payee_brh_no -- 收票人开户机构代码
            ,payee_soc_code -- 收票人社会信用代码
            ,payee_type -- 收票人类型
            ,acceptor_name -- 承兑人名称
            ,acceptor_account -- 承兑人账号
            ,acceptor_bank_no -- 承兑人开户行号
            ,acceptor_bank_name -- 承兑人开户行名称
            ,acceptor_soc_code -- 承兑人社会信用代码
            ,acceptor_type -- 承兑人类型
            ,acceptor_brh_no -- 承兑人机构代码
            ,remitter_ratg_agcy -- 出票人评级主体
            ,remitter_ratg_duedt -- 出票人评级到期日
            ,remitter_credit_ratgs -- 出票人信用等级
            ,acceptor_ratg_agcy -- 承兑人信用主体
            ,acceptor_ratg_duedt -- 承兑人评级到期日
            ,acceptor_credit_ratgs -- 承兑人信用等级
            ,message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
            ,account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
            ,advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
            ,freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
            ,req_remark -- 出票人备注
            ,rcv_remark -- 承兑人备注
            ,busi_branch_no -- 交易机构编号
            ,top_branch_no -- 总机构号
            ,create_operator -- 创建操作员
            ,create_time -- 创建时间
            ,last_operator -- 最后修改操作员
            ,last_update_time -- 最后修改时间
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,adjust_charge -- 调整后费用
            ,adjust_deposit_amount -- 调整后保证金
            ,valid_flag -- 有效标识
            ,apply_id -- 解析表ID
            ,accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
            ,payment_ubank_no -- 付款行联行编号
            ,misc -- 信息域
            ,account_date -- 记账日期
            ,run_code -- 记账唯一标识
            ,record_logno -- 中间表对应的唯一标志
            ,sign -- 0签收状态没同步  1签收状态已同步
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.draft_id -- 登记中心ID
    ,o.contract_id -- 承兑批次ID
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.draft_number -- 票据号码/票据包编号
    ,o.draft_bp_range -- 票据包区间
    ,o.draft_amount -- 票据金额
    ,o.remit_date -- 出票日
    ,o.maturity_date -- 到期日
    ,o.acceptor_date -- 承兑签收日期
    ,o.end_smt_flag -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,o.deposit_amount -- 保证金金额
    ,o.deduct_amount -- 扣款金额
    ,o.advance_amount -- 垫款金额
    ,o.charge -- 手续费
    ,o.bp_num -- 票据数量
    ,o.std_amt -- 标准金额
    ,o.txl_ctrct_nb -- 交易合同编号
    ,o.invc_nb -- 发票号码
    ,o.btch_nb -- 报文批次号
    ,o.remitter_name -- 出票人名称
    ,o.remitter_account -- 出票人账号
    ,o.remitter_bank_no -- 出票人开户行行号
    ,o.remitter_bank_name -- 出票人开户行名称
    ,o.remitter_cust_no -- 出票人客户号
    ,o.remitter_soc_code -- 出票人社会信用代码
    ,o.remitter_type -- 出票人类型
    ,o.remitter_brh_no -- 出票人开户机构代码
    ,o.payee_name -- 收票人名称
    ,o.payee_account -- 收票人账号
    ,o.payee_bank_no -- 收票人开户行行号
    ,o.payee_bank_name -- 收票人开户行名称
    ,o.payee_brh_no -- 收票人开户机构代码
    ,o.payee_soc_code -- 收票人社会信用代码
    ,o.payee_type -- 收票人类型
    ,o.acceptor_name -- 承兑人名称
    ,o.acceptor_account -- 承兑人账号
    ,o.acceptor_bank_no -- 承兑人开户行号
    ,o.acceptor_bank_name -- 承兑人开户行名称
    ,o.acceptor_soc_code -- 承兑人社会信用代码
    ,o.acceptor_type -- 承兑人类型
    ,o.acceptor_brh_no -- 承兑人机构代码
    ,o.remitter_ratg_agcy -- 出票人评级主体
    ,o.remitter_ratg_duedt -- 出票人评级到期日
    ,o.remitter_credit_ratgs -- 出票人信用等级
    ,o.acceptor_ratg_agcy -- 承兑人信用主体
    ,o.acceptor_ratg_duedt -- 承兑人评级到期日
    ,o.acceptor_credit_ratgs -- 承兑人信用等级
    ,o.message_status -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,o.account_status -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.deduct_status -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
    ,o.advance_status -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,o.freece_flag -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,o.req_remark -- 出票人备注
    ,o.rcv_remark -- 承兑人备注
    ,o.busi_branch_no -- 交易机构编号
    ,o.top_branch_no -- 总机构号
    ,o.create_operator -- 创建操作员
    ,o.create_time -- 创建时间
    ,o.last_operator -- 最后修改操作员
    ,o.last_update_time -- 最后修改时间
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.adjust_charge -- 调整后费用
    ,o.adjust_deposit_amount -- 调整后保证金
    ,o.valid_flag -- 有效标识
    ,o.apply_id -- 解析表ID
    ,o.accept_status -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,o.payment_ubank_no -- 付款行联行编号
    ,o.misc -- 信息域
    ,o.account_date -- 记账日期
    ,o.run_code -- 记账唯一标识
    ,o.record_logno -- 中间表对应的唯一标志
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
from ${iol_schema}.bdms_cpes_accept_details_bk o
    left join ${iol_schema}.bdms_cpes_accept_details_op n
        on
            o.id = n.id
            and o.adjust_deposit_amount = n.adjust_deposit_amount
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_accept_details_cl d
        on
            o.id = d.id
            and o.adjust_deposit_amount = d.adjust_deposit_amount
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_cpes_accept_details;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_cpes_accept_details') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_cpes_accept_details drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_cpes_accept_details add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_cpes_accept_details exchange partition p_${batch_date} with table ${iol_schema}.bdms_cpes_accept_details_cl;
alter table ${iol_schema}.bdms_cpes_accept_details exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_accept_details_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_accept_details to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_accept_details_op purge;
drop table ${iol_schema}.bdms_cpes_accept_details_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_accept_details_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_accept_details',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
