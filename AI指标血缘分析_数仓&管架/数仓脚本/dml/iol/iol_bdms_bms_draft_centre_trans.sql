/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_draft_centre_trans
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
create table ${iol_schema}.bdms_bms_draft_centre_trans_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_draft_centre_trans
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_draft_centre_trans_op purge;
drop table ${iol_schema}.bdms_bms_draft_centre_trans_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_draft_centre_trans_op nologging
for exchange with table
${iol_schema}.bdms_bms_draft_centre_trans;

create table ${iol_schema}.bdms_bms_draft_centre_trans_cl nologging
for exchange with table
${iol_schema}.bdms_bms_draft_centre_trans;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_draft_centre_trans_cl(
            id -- 
            ,draft_id -- 票据id
            ,contract_id -- 协议id
            ,details_id -- 清单id
            ,protocol_no -- 业务编号（协议号）
            ,product_no -- 产品代码
            ,trans_name -- 交易状态
            ,trans_no -- 交易编号
            ,draft_number -- 票据号码
            ,txn_date -- 交易日期
            ,req_name -- 请求方名称
            ,req_brch_code -- 请求方组织机构代码
            ,req_account -- 请求方帐号
            ,req_bank_id -- 请求方开户行行号
            ,rcv_name -- 接收方名称
            ,rcv_brch_code -- 接收方组织机构代码
            ,rcv_account -- 接收方帐号
            ,rcv_bank_id -- 接收方开户行行号
            ,rate -- 贴现利率
            ,draft_amount -- 金额
            ,interest -- 总利息
            ,buyer_interest -- 买方付息
            ,pay_amount -- 实付金额
            ,busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_name -- 付息人名称
            ,payer_account -- 付息人帐号
            ,payer_bank_name -- 付息人开户行
            ,payer_sale -- 付息比例
            ,agent_name -- 代理人名称
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_branch_no -- 实物保管机构号
            ,repurchase_date -- 赎回日
            ,cust_no -- 客户号
            ,charge -- 手续费
            ,expenses -- 工本费
            ,seq_no -- 历史序号
            ,last_operator_no -- 最后修改操作员id
            ,last_txn_date -- 最后修改时间
            ,acceptor_bank_no -- 承兑行行号
            ,tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
            ,sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
            ,status -- 票据状态
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,rpd_mk -- 是否回购式： 0 否 1 是
            ,rate_end_date -- 计息到期日
            ,is_lock -- 锁标志： 0 否 1 是
            ,last_trans_id -- 上一笔买入id
            ,end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
            ,repurchase_end_date -- 赎回截止日
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,storage_flag -- 
            ,buy_type -- 买入类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- 
            ,del_flag -- 
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_draft_centre_trans_op(
            id -- 
            ,draft_id -- 票据id
            ,contract_id -- 协议id
            ,details_id -- 清单id
            ,protocol_no -- 业务编号（协议号）
            ,product_no -- 产品代码
            ,trans_name -- 交易状态
            ,trans_no -- 交易编号
            ,draft_number -- 票据号码
            ,txn_date -- 交易日期
            ,req_name -- 请求方名称
            ,req_brch_code -- 请求方组织机构代码
            ,req_account -- 请求方帐号
            ,req_bank_id -- 请求方开户行行号
            ,rcv_name -- 接收方名称
            ,rcv_brch_code -- 接收方组织机构代码
            ,rcv_account -- 接收方帐号
            ,rcv_bank_id -- 接收方开户行行号
            ,rate -- 贴现利率
            ,draft_amount -- 金额
            ,interest -- 总利息
            ,buyer_interest -- 买方付息
            ,pay_amount -- 实付金额
            ,busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_name -- 付息人名称
            ,payer_account -- 付息人帐号
            ,payer_bank_name -- 付息人开户行
            ,payer_sale -- 付息比例
            ,agent_name -- 代理人名称
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_branch_no -- 实物保管机构号
            ,repurchase_date -- 赎回日
            ,cust_no -- 客户号
            ,charge -- 手续费
            ,expenses -- 工本费
            ,seq_no -- 历史序号
            ,last_operator_no -- 最后修改操作员id
            ,last_txn_date -- 最后修改时间
            ,acceptor_bank_no -- 承兑行行号
            ,tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
            ,sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
            ,status -- 票据状态
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,rpd_mk -- 是否回购式： 0 否 1 是
            ,rate_end_date -- 计息到期日
            ,is_lock -- 锁标志： 0 否 1 是
            ,last_trans_id -- 上一笔买入id
            ,end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
            ,repurchase_end_date -- 赎回截止日
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,storage_flag -- 
            ,buy_type -- 买入类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- 
            ,del_flag -- 
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.draft_id, o.draft_id) as draft_id -- 票据id
    ,nvl(n.contract_id, o.contract_id) as contract_id -- 协议id
    ,nvl(n.details_id, o.details_id) as details_id -- 清单id
    ,nvl(n.protocol_no, o.protocol_no) as protocol_no -- 业务编号（协议号）
    ,nvl(n.product_no, o.product_no) as product_no -- 产品代码
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 交易状态
    ,nvl(n.trans_no, o.trans_no) as trans_no -- 交易编号
    ,nvl(n.draft_number, o.draft_number) as draft_number -- 票据号码
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 交易日期
    ,nvl(n.req_name, o.req_name) as req_name -- 请求方名称
    ,nvl(n.req_brch_code, o.req_brch_code) as req_brch_code -- 请求方组织机构代码
    ,nvl(n.req_account, o.req_account) as req_account -- 请求方帐号
    ,nvl(n.req_bank_id, o.req_bank_id) as req_bank_id -- 请求方开户行行号
    ,nvl(n.rcv_name, o.rcv_name) as rcv_name -- 接收方名称
    ,nvl(n.rcv_brch_code, o.rcv_brch_code) as rcv_brch_code -- 接收方组织机构代码
    ,nvl(n.rcv_account, o.rcv_account) as rcv_account -- 接收方帐号
    ,nvl(n.rcv_bank_id, o.rcv_bank_id) as rcv_bank_id -- 接收方开户行行号
    ,nvl(n.rate, o.rate) as rate -- 贴现利率
    ,nvl(n.draft_amount, o.draft_amount) as draft_amount -- 金额
    ,nvl(n.interest, o.interest) as interest -- 总利息
    ,nvl(n.buyer_interest, o.buyer_interest) as buyer_interest -- 买方付息
    ,nvl(n.pay_amount, o.pay_amount) as pay_amount -- 实付金额
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付息人名称
    ,nvl(n.payer_account, o.payer_account) as payer_account -- 付息人帐号
    ,nvl(n.payer_bank_name, o.payer_bank_name) as payer_bank_name -- 付息人开户行
    ,nvl(n.payer_sale, o.payer_sale) as payer_sale -- 付息比例
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代理人名称
    ,nvl(n.trans_branch_no, o.trans_branch_no) as trans_branch_no -- 交易机构号
    ,nvl(n.acct_branch_no, o.acct_branch_no) as acct_branch_no -- 记账机构号
    ,nvl(n.store_branch_no, o.store_branch_no) as store_branch_no -- 实物保管机构号
    ,nvl(n.repurchase_date, o.repurchase_date) as repurchase_date -- 赎回日
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.charge, o.charge) as charge -- 手续费
    ,nvl(n.expenses, o.expenses) as expenses -- 工本费
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 历史序号
    ,nvl(n.last_operator_no, o.last_operator_no) as last_operator_no -- 最后修改操作员id
    ,nvl(n.last_txn_date, o.last_txn_date) as last_txn_date -- 最后修改时间
    ,nvl(n.acceptor_bank_no, o.acceptor_bank_no) as acceptor_bank_no -- 承兑行行号
    ,nvl(n.tmp_status, o.tmp_status) as tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
    ,nvl(n.sttlm_mk, o.sttlm_mk) as sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
    ,nvl(n.status, o.status) as status -- 票据状态
    ,nvl(n.inner_flag, o.inner_flag) as inner_flag -- 是否系统内： 0 否 1 是
    ,nvl(n.rpd_mk, o.rpd_mk) as rpd_mk -- 是否回购式： 0 否 1 是
    ,nvl(n.rate_end_date, o.rate_end_date) as rate_end_date -- 计息到期日
    ,nvl(n.is_lock, o.is_lock) as is_lock -- 锁标志： 0 否 1 是
    ,nvl(n.last_trans_id, o.last_trans_id) as last_trans_id -- 上一笔买入id
    ,nvl(n.end_smt_flag, o.end_smt_flag) as end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
    ,nvl(n.repurchase_end_date, o.repurchase_end_date) as repurchase_end_date -- 赎回截止日
    ,nvl(n.repurchase_rate, o.repurchase_rate) as repurchase_rate -- 赎回利率
    ,nvl(n.repurchase_begin_date, o.repurchase_begin_date) as repurchase_begin_date -- 赎回开放日
    ,nvl(n.storage_flag, o.storage_flag) as storage_flag -- 
    ,nvl(n.buy_type, o.buy_type) as buy_type -- 买入类型
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备注3
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 
    ,nvl(n.register_status, o.register_status) as register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
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
from (select * from ${iol_schema}.bdms_bms_draft_centre_trans_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_draft_centre_trans where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.draft_id <> n.draft_id
        or o.contract_id <> n.contract_id
        or o.details_id <> n.details_id
        or o.protocol_no <> n.protocol_no
        or o.product_no <> n.product_no
        or o.trans_name <> n.trans_name
        or o.trans_no <> n.trans_no
        or o.draft_number <> n.draft_number
        or o.txn_date <> n.txn_date
        or o.req_name <> n.req_name
        or o.req_brch_code <> n.req_brch_code
        or o.req_account <> n.req_account
        or o.req_bank_id <> n.req_bank_id
        or o.rcv_name <> n.rcv_name
        or o.rcv_brch_code <> n.rcv_brch_code
        or o.rcv_account <> n.rcv_account
        or o.rcv_bank_id <> n.rcv_bank_id
        or o.rate <> n.rate
        or o.draft_amount <> n.draft_amount
        or o.interest <> n.interest
        or o.buyer_interest <> n.buyer_interest
        or o.pay_amount <> n.pay_amount
        or o.busi_type <> n.busi_type
        or o.pay_type <> n.pay_type
        or o.payer_name <> n.payer_name
        or o.payer_account <> n.payer_account
        or o.payer_bank_name <> n.payer_bank_name
        or o.payer_sale <> n.payer_sale
        or o.agent_name <> n.agent_name
        or o.trans_branch_no <> n.trans_branch_no
        or o.acct_branch_no <> n.acct_branch_no
        or o.store_branch_no <> n.store_branch_no
        or o.repurchase_date <> n.repurchase_date
        or o.cust_no <> n.cust_no
        or o.charge <> n.charge
        or o.expenses <> n.expenses
        or o.seq_no <> n.seq_no
        or o.last_operator_no <> n.last_operator_no
        or o.last_txn_date <> n.last_txn_date
        or o.acceptor_bank_no <> n.acceptor_bank_no
        or o.tmp_status <> n.tmp_status
        or o.sttlm_mk <> n.sttlm_mk
        or o.status <> n.status
        or o.inner_flag <> n.inner_flag
        or o.rpd_mk <> n.rpd_mk
        or o.rate_end_date <> n.rate_end_date
        or o.is_lock <> n.is_lock
        or o.last_trans_id <> n.last_trans_id
        or o.end_smt_flag <> n.end_smt_flag
        or o.repurchase_end_date <> n.repurchase_end_date
        or o.repurchase_rate <> n.repurchase_rate
        or o.repurchase_begin_date <> n.repurchase_begin_date
        or o.storage_flag <> n.storage_flag
        or o.buy_type <> n.buy_type
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.busi_branch_no <> n.busi_branch_no
        or o.del_flag <> n.del_flag
        or o.register_status <> n.register_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_draft_centre_trans_cl(
            id -- 
            ,draft_id -- 票据id
            ,contract_id -- 协议id
            ,details_id -- 清单id
            ,protocol_no -- 业务编号（协议号）
            ,product_no -- 产品代码
            ,trans_name -- 交易状态
            ,trans_no -- 交易编号
            ,draft_number -- 票据号码
            ,txn_date -- 交易日期
            ,req_name -- 请求方名称
            ,req_brch_code -- 请求方组织机构代码
            ,req_account -- 请求方帐号
            ,req_bank_id -- 请求方开户行行号
            ,rcv_name -- 接收方名称
            ,rcv_brch_code -- 接收方组织机构代码
            ,rcv_account -- 接收方帐号
            ,rcv_bank_id -- 接收方开户行行号
            ,rate -- 贴现利率
            ,draft_amount -- 金额
            ,interest -- 总利息
            ,buyer_interest -- 买方付息
            ,pay_amount -- 实付金额
            ,busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_name -- 付息人名称
            ,payer_account -- 付息人帐号
            ,payer_bank_name -- 付息人开户行
            ,payer_sale -- 付息比例
            ,agent_name -- 代理人名称
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_branch_no -- 实物保管机构号
            ,repurchase_date -- 赎回日
            ,cust_no -- 客户号
            ,charge -- 手续费
            ,expenses -- 工本费
            ,seq_no -- 历史序号
            ,last_operator_no -- 最后修改操作员id
            ,last_txn_date -- 最后修改时间
            ,acceptor_bank_no -- 承兑行行号
            ,tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
            ,sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
            ,status -- 票据状态
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,rpd_mk -- 是否回购式： 0 否 1 是
            ,rate_end_date -- 计息到期日
            ,is_lock -- 锁标志： 0 否 1 是
            ,last_trans_id -- 上一笔买入id
            ,end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
            ,repurchase_end_date -- 赎回截止日
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,storage_flag -- 
            ,buy_type -- 买入类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- 
            ,del_flag -- 
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_draft_centre_trans_op(
            id -- 
            ,draft_id -- 票据id
            ,contract_id -- 协议id
            ,details_id -- 清单id
            ,protocol_no -- 业务编号（协议号）
            ,product_no -- 产品代码
            ,trans_name -- 交易状态
            ,trans_no -- 交易编号
            ,draft_number -- 票据号码
            ,txn_date -- 交易日期
            ,req_name -- 请求方名称
            ,req_brch_code -- 请求方组织机构代码
            ,req_account -- 请求方帐号
            ,req_bank_id -- 请求方开户行行号
            ,rcv_name -- 接收方名称
            ,rcv_brch_code -- 接收方组织机构代码
            ,rcv_account -- 接收方帐号
            ,rcv_bank_id -- 接收方开户行行号
            ,rate -- 贴现利率
            ,draft_amount -- 金额
            ,interest -- 总利息
            ,buyer_interest -- 买方付息
            ,pay_amount -- 实付金额
            ,busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
            ,pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
            ,payer_name -- 付息人名称
            ,payer_account -- 付息人帐号
            ,payer_bank_name -- 付息人开户行
            ,payer_sale -- 付息比例
            ,agent_name -- 代理人名称
            ,trans_branch_no -- 交易机构号
            ,acct_branch_no -- 记账机构号
            ,store_branch_no -- 实物保管机构号
            ,repurchase_date -- 赎回日
            ,cust_no -- 客户号
            ,charge -- 手续费
            ,expenses -- 工本费
            ,seq_no -- 历史序号
            ,last_operator_no -- 最后修改操作员id
            ,last_txn_date -- 最后修改时间
            ,acceptor_bank_no -- 承兑行行号
            ,tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
            ,sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
            ,status -- 票据状态
            ,inner_flag -- 是否系统内： 0 否 1 是
            ,rpd_mk -- 是否回购式： 0 否 1 是
            ,rate_end_date -- 计息到期日
            ,is_lock -- 锁标志： 0 否 1 是
            ,last_trans_id -- 上一笔买入id
            ,end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
            ,repurchase_end_date -- 赎回截止日
            ,repurchase_rate -- 赎回利率
            ,repurchase_begin_date -- 赎回开放日
            ,storage_flag -- 
            ,buy_type -- 买入类型
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,reserve3 -- 备注3
            ,busi_branch_no -- 
            ,del_flag -- 
            ,register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.draft_id -- 票据id
    ,o.contract_id -- 协议id
    ,o.details_id -- 清单id
    ,o.protocol_no -- 业务编号（协议号）
    ,o.product_no -- 产品代码
    ,o.trans_name -- 交易状态
    ,o.trans_no -- 交易编号
    ,o.draft_number -- 票据号码
    ,o.txn_date -- 交易日期
    ,o.req_name -- 请求方名称
    ,o.req_brch_code -- 请求方组织机构代码
    ,o.req_account -- 请求方帐号
    ,o.req_bank_id -- 请求方开户行行号
    ,o.rcv_name -- 接收方名称
    ,o.rcv_brch_code -- 接收方组织机构代码
    ,o.rcv_account -- 接收方帐号
    ,o.rcv_bank_id -- 接收方开户行行号
    ,o.rate -- 贴现利率
    ,o.draft_amount -- 金额
    ,o.interest -- 总利息
    ,o.buyer_interest -- 买方付息
    ,o.pay_amount -- 实付金额
    ,o.busi_type -- 业务种类： 010 承兑 011 未用退回 012 扣款 013 付款 014 保证金管理 015 垫款 016 贷款 017 挂失 018 解除挂失 020 直贴 021 回购式贴现 022 代理直贴 023 到期赎回 030 转(再)贴现买入 031 转(再)贴现卖出 032 系统内转帖买入 033 系统内转帖卖出 034 转帖现到期回购 035 转帖现到期返售 036 理财买入 037 理财卖出 040 发托 041 代客发托 042 托收回款记账 043 托收退票 050 质押 051 质押解除 100 实物管理 101 代保管 102 票据池
    ,o.pay_type -- 付息方式： 1 买方付息 2 卖方付息 3 协议付息
    ,o.payer_name -- 付息人名称
    ,o.payer_account -- 付息人帐号
    ,o.payer_bank_name -- 付息人开户行
    ,o.payer_sale -- 付息比例
    ,o.agent_name -- 代理人名称
    ,o.trans_branch_no -- 交易机构号
    ,o.acct_branch_no -- 记账机构号
    ,o.store_branch_no -- 实物保管机构号
    ,o.repurchase_date -- 赎回日
    ,o.cust_no -- 客户号
    ,o.charge -- 手续费
    ,o.expenses -- 工本费
    ,o.seq_no -- 历史序号
    ,o.last_operator_no -- 最后修改操作员id
    ,o.last_txn_date -- 最后修改时间
    ,o.acceptor_bank_no -- 承兑行行号
    ,o.tmp_status -- 处理中状态： 10 买入处理中 20 买入库存 30 卖出处理中 40 卖出
    ,o.sttlm_mk -- 线上清算标识： sm00 线上清算 sm01 线下清算
    ,o.status -- 票据状态
    ,o.inner_flag -- 是否系统内： 0 否 1 是
    ,o.rpd_mk -- 是否回购式： 0 否 1 是
    ,o.rate_end_date -- 计息到期日
    ,o.is_lock -- 锁标志： 0 否 1 是
    ,o.last_trans_id -- 上一笔买入id
    ,o.end_smt_flag -- 不得转让标记： em00 可再转让 em01 不得转让
    ,o.repurchase_end_date -- 赎回截止日
    ,o.repurchase_rate -- 赎回利率
    ,o.repurchase_begin_date -- 赎回开放日
    ,o.storage_flag -- 
    ,o.buy_type -- 买入类型
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
    ,o.reserve3 -- 备注3
    ,o.busi_branch_no -- 
    ,o.del_flag -- 
    ,o.register_status -- 登记状态： 00 初始 10 登记发送中 20 登记成功
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
from ${iol_schema}.bdms_bms_draft_centre_trans_bk o
    left join ${iol_schema}.bdms_bms_draft_centre_trans_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_draft_centre_trans_cl d
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
--truncate table ${iol_schema}.bdms_bms_draft_centre_trans;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_draft_centre_trans') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_draft_centre_trans drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_draft_centre_trans add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_draft_centre_trans exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_draft_centre_trans_cl;
alter table ${iol_schema}.bdms_bms_draft_centre_trans exchange partition p_20991231 with table ${iol_schema}.bdms_bms_draft_centre_trans_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_draft_centre_trans to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_draft_centre_trans_op purge;
drop table ${iol_schema}.bdms_bms_draft_centre_trans_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_draft_centre_trans_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_draft_centre_trans',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
