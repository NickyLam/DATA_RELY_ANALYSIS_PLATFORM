/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_ces_quote_deal
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
create table ${iol_schema}.bdms_ces_quote_deal_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_ces_quote_deal
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_ces_quote_deal_op purge;
drop table ${iol_schema}.bdms_ces_quote_deal_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_ces_quote_deal_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_ces_quote_deal where 0=1;

create table ${iol_schema}.bdms_ces_quote_deal_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_ces_quote_deal where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_ces_quote_deal_cl(
            id -- ID
            ,buss_contract_id -- 业务表批次ID
            ,dealed_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,quote_no -- 报价单编号
            ,brh_no -- 机构代码
            ,product_no -- 非法人产品
            ,trader_id -- 交易员ID
            ,fundation_acct -- 资金账户
            ,adver_brh_no -- 对手机构代码
            ,adver_pro_no -- 对手非法人产品
            ,adver_trader_id -- 对手交易员ID
            ,adver_fund_acct -- 对手资金账户
            ,quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
            ,trace_reason -- 中止原因
            ,lock_flag -- 锁定标识： 0 否 1 是
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
            ,anoclick_deal_no -- 匿名点击成交单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,own_mem_no -- 所属会员代码
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,deal_tenor_days -- 持票期限
            ,deal_settle_amt -- 结算金额
            ,deal_sum_count -- 票据张数
            ,deal_sum_amount -- 票据总额
            ,deal_pay_interest -- 应付利息
            ,deal_yield_rate -- 收益率
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_ces_quote_deal_op(
            id -- ID
            ,buss_contract_id -- 业务表批次ID
            ,dealed_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,quote_no -- 报价单编号
            ,brh_no -- 机构代码
            ,product_no -- 非法人产品
            ,trader_id -- 交易员ID
            ,fundation_acct -- 资金账户
            ,adver_brh_no -- 对手机构代码
            ,adver_pro_no -- 对手非法人产品
            ,adver_trader_id -- 对手交易员ID
            ,adver_fund_acct -- 对手资金账户
            ,quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
            ,trace_reason -- 中止原因
            ,lock_flag -- 锁定标识： 0 否 1 是
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
            ,anoclick_deal_no -- 匿名点击成交单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,own_mem_no -- 所属会员代码
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,deal_tenor_days -- 持票期限
            ,deal_settle_amt -- 结算金额
            ,deal_sum_count -- 票据张数
            ,deal_sum_amount -- 票据总额
            ,deal_pay_interest -- 应付利息
            ,deal_yield_rate -- 收益率
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.buss_contract_id, o.buss_contract_id) as buss_contract_id -- 业务表批次ID
    ,nvl(n.dealed_no, o.dealed_no) as dealed_no -- 成交单编号
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型： AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 成交日期
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 成交时间
    ,nvl(n.trade_status, o.trade_status) as trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.product_no, o.product_no) as product_no -- 非法人产品
    ,nvl(n.trader_id, o.trader_id) as trader_id -- 交易员ID
    ,nvl(n.fundation_acct, o.fundation_acct) as fundation_acct -- 资金账户
    ,nvl(n.adver_brh_no, o.adver_brh_no) as adver_brh_no -- 对手机构代码
    ,nvl(n.adver_pro_no, o.adver_pro_no) as adver_pro_no -- 对手非法人产品
    ,nvl(n.adver_trader_id, o.adver_trader_id) as adver_trader_id -- 对手交易员ID
    ,nvl(n.adver_fund_acct, o.adver_fund_acct) as adver_fund_acct -- 对手资金账户
    ,nvl(n.quote_status, o.quote_status) as quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
    ,nvl(n.trace_reason, o.trace_reason) as trace_reason -- 中止原因
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 锁定标识： 0 否 1 是
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后操作员
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.due_settle_status, o.due_settle_status) as due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.nesting_lock_flag, o.nesting_lock_flag) as nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
    ,nvl(n.anoclick_deal_no, o.anoclick_deal_no) as anoclick_deal_no -- 匿名点击成交单编号
    ,nvl(n.click_type, o.click_type) as click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,nvl(n.own_mem_no, o.own_mem_no) as own_mem_no -- 所属会员代码
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.deal_tenor_days, o.deal_tenor_days) as deal_tenor_days -- 持票期限
    ,nvl(n.deal_settle_amt, o.deal_settle_amt) as deal_settle_amt -- 结算金额
    ,nvl(n.deal_sum_count, o.deal_sum_count) as deal_sum_count -- 票据张数
    ,nvl(n.deal_sum_amount, o.deal_sum_amount) as deal_sum_amount -- 票据总额
    ,nvl(n.deal_pay_interest, o.deal_pay_interest) as deal_pay_interest -- 应付利息
    ,nvl(n.deal_yield_rate, o.deal_yield_rate) as deal_yield_rate -- 收益率
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
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
from (select * from ${iol_schema}.bdms_ces_quote_deal_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_ces_quote_deal where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.buss_contract_id <> n.buss_contract_id
        or o.dealed_no <> n.dealed_no
        or o.trade_direct <> n.trade_direct
        or o.busi_type <> n.busi_type
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.trade_type <> n.trade_type
        or o.trade_date <> n.trade_date
        or o.trade_time <> n.trade_time
        or o.trade_status <> n.trade_status
        or o.settle_status <> n.settle_status
        or o.quote_no <> n.quote_no
        or o.brh_no <> n.brh_no
        or o.product_no <> n.product_no
        or o.trader_id <> n.trader_id
        or o.fundation_acct <> n.fundation_acct
        or o.adver_brh_no <> n.adver_brh_no
        or o.adver_pro_no <> n.adver_pro_no
        or o.adver_trader_id <> n.adver_trader_id
        or o.adver_fund_acct <> n.adver_fund_acct
        or o.quote_status <> n.quote_status
        or o.trace_reason <> n.trace_reason
        or o.lock_flag <> n.lock_flag
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.due_settle_status <> n.due_settle_status
        or o.nesting_lock_flag <> n.nesting_lock_flag
        or o.anoclick_deal_no <> n.anoclick_deal_no
        or o.click_type <> n.click_type
        or o.own_mem_no <> n.own_mem_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.deal_tenor_days <> n.deal_tenor_days
        or o.deal_settle_amt <> n.deal_settle_amt
        or o.deal_sum_count <> n.deal_sum_count
        or o.deal_sum_amount <> n.deal_sum_amount
        or o.deal_pay_interest <> n.deal_pay_interest
        or o.deal_yield_rate <> n.deal_yield_rate
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_ces_quote_deal_cl(
            id -- ID
            ,buss_contract_id -- 业务表批次ID
            ,dealed_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,quote_no -- 报价单编号
            ,brh_no -- 机构代码
            ,product_no -- 非法人产品
            ,trader_id -- 交易员ID
            ,fundation_acct -- 资金账户
            ,adver_brh_no -- 对手机构代码
            ,adver_pro_no -- 对手非法人产品
            ,adver_trader_id -- 对手交易员ID
            ,adver_fund_acct -- 对手资金账户
            ,quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
            ,trace_reason -- 中止原因
            ,lock_flag -- 锁定标识： 0 否 1 是
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
            ,anoclick_deal_no -- 匿名点击成交单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,own_mem_no -- 所属会员代码
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,deal_tenor_days -- 持票期限
            ,deal_settle_amt -- 结算金额
            ,deal_sum_count -- 票据张数
            ,deal_sum_amount -- 票据总额
            ,deal_pay_interest -- 应付利息
            ,deal_yield_rate -- 收益率
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_ces_quote_deal_op(
            id -- ID
            ,buss_contract_id -- 业务表批次ID
            ,dealed_no -- 成交单编号
            ,trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
            ,draft_type -- 票据类型： AC01 银承 AC02 商承
            ,draft_attr -- 票据介质： ME01 纸票 ME02 电票
            ,trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
            ,settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,quote_no -- 报价单编号
            ,brh_no -- 机构代码
            ,product_no -- 非法人产品
            ,trader_id -- 交易员ID
            ,fundation_acct -- 资金账户
            ,adver_brh_no -- 对手机构代码
            ,adver_pro_no -- 对手非法人产品
            ,adver_trader_id -- 对手交易员ID
            ,adver_fund_acct -- 对手资金账户
            ,quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
            ,trace_reason -- 中止原因
            ,lock_flag -- 锁定标识： 0 否 1 是
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,last_upd_opr -- 最后操作员
            ,last_upd_time -- 最后修改时间
            ,due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
            ,anoclick_deal_no -- 匿名点击成交单编号
            ,click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
            ,own_mem_no -- 所属会员代码
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,deal_tenor_days -- 持票期限
            ,deal_settle_amt -- 结算金额
            ,deal_sum_count -- 票据张数
            ,deal_sum_amount -- 票据总额
            ,deal_pay_interest -- 应付利息
            ,deal_yield_rate -- 收益率
            ,create_time -- 创建时间
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.buss_contract_id -- 业务表批次ID
    ,o.dealed_no -- 成交单编号
    ,o.trade_direct -- 交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
    ,o.busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,o.draft_type -- 票据类型： AC01 银承 AC02 商承
    ,o.draft_attr -- 票据介质： ME01 纸票 ME02 电票
    ,o.trade_type -- 成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,o.trade_date -- 成交日期
    ,o.trade_time -- 成交时间
    ,o.trade_status -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
    ,o.settle_status -- 清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.quote_no -- 报价单编号
    ,o.brh_no -- 机构代码
    ,o.product_no -- 非法人产品
    ,o.trader_id -- 交易员ID
    ,o.fundation_acct -- 资金账户
    ,o.adver_brh_no -- 对手机构代码
    ,o.adver_pro_no -- 对手非法人产品
    ,o.adver_trader_id -- 对手交易员ID
    ,o.adver_fund_acct -- 对手资金账户
    ,o.quote_status -- 报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
    ,o.trace_reason -- 中止原因
    ,o.lock_flag -- 锁定标识： 0 否 1 是
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.last_upd_opr -- 最后操作员
    ,o.last_upd_time -- 最后修改时间
    ,o.due_settle_status -- 到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.nesting_lock_flag -- 嵌套锁标识： 0 否 1 是
    ,o.anoclick_deal_no -- 匿名点击成交单编号
    ,o.click_type -- 点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
    ,o.own_mem_no -- 所属会员代码
    ,o.busi_branch_no -- 业务机构号
    ,o.top_branch_no -- 总行机构号
    ,o.deal_tenor_days -- 持票期限
    ,o.deal_settle_amt -- 结算金额
    ,o.deal_sum_count -- 票据张数
    ,o.deal_sum_amount -- 票据总额
    ,o.deal_pay_interest -- 应付利息
    ,o.deal_yield_rate -- 收益率
    ,o.create_time -- 创建时间
    ,o.create_by -- 创建人
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
from ${iol_schema}.bdms_ces_quote_deal_bk o
    left join ${iol_schema}.bdms_ces_quote_deal_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_ces_quote_deal_cl d
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
--truncate table ${iol_schema}.bdms_ces_quote_deal;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_ces_quote_deal') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_ces_quote_deal drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_ces_quote_deal add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_ces_quote_deal exchange partition p_${batch_date} with table ${iol_schema}.bdms_ces_quote_deal_cl;
alter table ${iol_schema}.bdms_ces_quote_deal exchange partition p_20991231 with table ${iol_schema}.bdms_ces_quote_deal_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_ces_quote_deal to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_ces_quote_deal_op purge;
drop table ${iol_schema}.bdms_ces_quote_deal_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_ces_quote_deal_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_ces_quote_deal',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
