/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cpes_anoclick_match_contract
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
create table ${iol_schema}.bdms_cpes_anoclick_match_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cpes_anoclick_match_contract;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_anoclick_match_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_match_contract where 0=1;

create table ${iol_schema}.bdms_cpes_anoclick_match_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cpes_anoclick_match_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_match_contract_cl(
            id -- ID
            ,quote_contract_id -- 报价批次表ID
            ,deal_id -- 成交单表ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,dealed_no -- 成交单编号
            ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,sum_count -- 票据总张数
            ,sum_amount -- 票据总金额
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,brh_no -- 本方机构代码
            ,pro_no -- 本方非法人产品
            ,trader_id -- 本方交易员ID
            ,adver_brh_no -- 对方机构代码
            ,adver_pro_no -- 对方非法人产品
            ,adver_trader_id -- 对方交易员ID
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,buy_back_amt -- 回购金额
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,tenor_days -- 回购期限
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,latest_settle_time -- 最晚首期结算时间
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 首期结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,rate -- 回购利率
            ,pay_interest -- 应付利息
            ,yield_rate -- 回购收益率
            ,close_time -- 提票截止时间
            ,credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,credit_check_status -- 
            ,due_pay_interest -- 到期应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_match_contract_op(
            id -- ID
            ,quote_contract_id -- 报价批次表ID
            ,deal_id -- 成交单表ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,dealed_no -- 成交单编号
            ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,sum_count -- 票据总张数
            ,sum_amount -- 票据总金额
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,brh_no -- 本方机构代码
            ,pro_no -- 本方非法人产品
            ,trader_id -- 本方交易员ID
            ,adver_brh_no -- 对方机构代码
            ,adver_pro_no -- 对方非法人产品
            ,adver_trader_id -- 对方交易员ID
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,buy_back_amt -- 回购金额
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,tenor_days -- 回购期限
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,latest_settle_time -- 最晚首期结算时间
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 首期结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,rate -- 回购利率
            ,pay_interest -- 应付利息
            ,yield_rate -- 回购收益率
            ,close_time -- 提票截止时间
            ,credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,credit_check_status -- 
            ,due_pay_interest -- 到期应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.quote_contract_id, o.quote_contract_id) as quote_contract_id -- 报价批次表ID
    ,nvl(n.deal_id, o.deal_id) as deal_id -- 成交单表ID
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 批次号
    ,nvl(n.product_no, o.product_no) as product_no -- 产品号
    ,nvl(n.dealed_no, o.dealed_no) as dealed_no -- 成交单编号
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 成交日期
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 成交时间
    ,nvl(n.trade_status, o.trade_status) as trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,nvl(n.sum_count, o.sum_count) as sum_count -- 票据总张数
    ,nvl(n.sum_amount, o.sum_amount) as sum_amount -- 票据总金额
    ,nvl(n.quote_no, o.quote_no) as quote_no -- 报价单编号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
    ,nvl(n.trade_direct, o.trade_direct) as trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 本方机构代码
    ,nvl(n.pro_no, o.pro_no) as pro_no -- 本方非法人产品
    ,nvl(n.trader_id, o.trader_id) as trader_id -- 本方交易员ID
    ,nvl(n.adver_brh_no, o.adver_brh_no) as adver_brh_no -- 对方机构代码
    ,nvl(n.adver_pro_no, o.adver_pro_no) as adver_pro_no -- 对方非法人产品
    ,nvl(n.adver_trader_id, o.adver_trader_id) as adver_trader_id -- 对方交易员ID
    ,nvl(n.draft_type, o.draft_type) as draft_type -- 票据类型 AC01 银承 AC02 商承
    ,nvl(n.draft_attr, o.draft_attr) as draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,nvl(n.buy_back_amt, o.buy_back_amt) as buy_back_amt -- 回购金额
    ,nvl(n.tenor_code, o.tenor_code) as tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,nvl(n.tenor_days, o.tenor_days) as tenor_days -- 回购期限
    ,nvl(n.clear_speed, o.clear_speed) as clear_speed -- 清算速度 CS00 T+0 CS01 T+1
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
    ,nvl(n.latest_settle_time, o.latest_settle_time) as latest_settle_time -- 最晚首期结算时间
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 首期结算金额
    ,nvl(n.due_settle_amt, o.due_settle_amt) as due_settle_amt -- 到期结算金额
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 首期结算日
    ,nvl(n.due_settle_date, o.due_settle_date) as due_settle_date -- 到期结算日
    ,nvl(n.rate, o.rate) as rate -- 回购利率
    ,nvl(n.pay_interest, o.pay_interest) as pay_interest -- 应付利息
    ,nvl(n.yield_rate, o.yield_rate) as yield_rate -- 回购收益率
    ,nvl(n.close_time, o.close_time) as close_time -- 提票截止时间
    ,nvl(n.credit_type, o.credit_type) as credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,nvl(n.department_no, o.department_no) as department_no -- 所属部门
    ,nvl(n.manager_no, o.manager_no) as manager_no -- 客户经理
    ,nvl(n.busi_branch_no, o.busi_branch_no) as busi_branch_no -- 业务机构号
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- 总行机构号
    ,nvl(n.contract_status, o.contract_status) as contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,nvl(n.message_status, o.message_status) as message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,nvl(n.settle_status, o.settle_status) as settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,nvl(n.account_status, o.account_status) as account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后修改人
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.reserver1, o.reserver1) as reserver1 -- 预留域1
    ,nvl(n.reserver2, o.reserver2) as reserver2 -- 预留域2
    ,nvl(n.credit_check_status, o.credit_check_status) as credit_check_status -- 
    ,nvl(n.due_pay_interest, o.due_pay_interest) as due_pay_interest -- 到期应付利息
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
from (select * from ${iol_schema}.bdms_cpes_anoclick_match_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cpes_anoclick_match_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.quote_contract_id <> n.quote_contract_id
        or o.deal_id <> n.deal_id
        or o.contract_no <> n.contract_no
        or o.product_no <> n.product_no
        or o.dealed_no <> n.dealed_no
        or o.trade_type <> n.trade_type
        or o.trade_date <> n.trade_date
        or o.trade_time <> n.trade_time
        or o.trade_status <> n.trade_status
        or o.sum_count <> n.sum_count
        or o.sum_amount <> n.sum_amount
        or o.quote_no <> n.quote_no
        or o.busi_type <> n.busi_type
        or o.trade_direct <> n.trade_direct
        or o.brh_no <> n.brh_no
        or o.pro_no <> n.pro_no
        or o.trader_id <> n.trader_id
        or o.adver_brh_no <> n.adver_brh_no
        or o.adver_pro_no <> n.adver_pro_no
        or o.adver_trader_id <> n.adver_trader_id
        or o.draft_type <> n.draft_type
        or o.draft_attr <> n.draft_attr
        or o.buy_back_amt <> n.buy_back_amt
        or o.tenor_code <> n.tenor_code
        or o.tenor_days <> n.tenor_days
        or o.clear_speed <> n.clear_speed
        or o.clear_type <> n.clear_type
        or o.latest_settle_time <> n.latest_settle_time
        or o.settle_mode <> n.settle_mode
        or o.settle_amt <> n.settle_amt
        or o.due_settle_amt <> n.due_settle_amt
        or o.settle_date <> n.settle_date
        or o.due_settle_date <> n.due_settle_date
        or o.rate <> n.rate
        or o.pay_interest <> n.pay_interest
        or o.yield_rate <> n.yield_rate
        or o.close_time <> n.close_time
        or o.credit_type <> n.credit_type
        or o.department_no <> n.department_no
        or o.manager_no <> n.manager_no
        or o.busi_branch_no <> n.busi_branch_no
        or o.top_branch_no <> n.top_branch_no
        or o.contract_status <> n.contract_status
        or o.message_status <> n.message_status
        or o.settle_status <> n.settle_status
        or o.account_status <> n.account_status
        or o.created_by <> n.created_by
        or o.last_upd_opr <> n.last_upd_opr
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.reserver1 <> n.reserver1
        or o.reserver2 <> n.reserver2
        or o.credit_check_status <> n.credit_check_status
        or o.due_pay_interest <> n.due_pay_interest
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cpes_anoclick_match_contract_cl(
            id -- ID
            ,quote_contract_id -- 报价批次表ID
            ,deal_id -- 成交单表ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,dealed_no -- 成交单编号
            ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,sum_count -- 票据总张数
            ,sum_amount -- 票据总金额
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,brh_no -- 本方机构代码
            ,pro_no -- 本方非法人产品
            ,trader_id -- 本方交易员ID
            ,adver_brh_no -- 对方机构代码
            ,adver_pro_no -- 对方非法人产品
            ,adver_trader_id -- 对方交易员ID
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,buy_back_amt -- 回购金额
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,tenor_days -- 回购期限
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,latest_settle_time -- 最晚首期结算时间
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 首期结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,rate -- 回购利率
            ,pay_interest -- 应付利息
            ,yield_rate -- 回购收益率
            ,close_time -- 提票截止时间
            ,credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,credit_check_status -- 
            ,due_pay_interest -- 到期应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cpes_anoclick_match_contract_op(
            id -- ID
            ,quote_contract_id -- 报价批次表ID
            ,deal_id -- 成交单表ID
            ,contract_no -- 批次号
            ,product_no -- 产品号
            ,dealed_no -- 成交单编号
            ,trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
            ,trade_date -- 成交日期
            ,trade_time -- 成交时间
            ,trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
            ,sum_count -- 票据总张数
            ,sum_amount -- 票据总金额
            ,quote_no -- 报价单编号
            ,busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
            ,trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
            ,brh_no -- 本方机构代码
            ,pro_no -- 本方非法人产品
            ,trader_id -- 本方交易员ID
            ,adver_brh_no -- 对方机构代码
            ,adver_pro_no -- 对方非法人产品
            ,adver_trader_id -- 对方交易员ID
            ,draft_type -- 票据类型 AC01 银承 AC02 商承
            ,draft_attr -- 票据属性： ME01 纸票 ME02 电票
            ,buy_back_amt -- 回购金额
            ,tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
            ,tenor_days -- 回购期限
            ,clear_speed -- 清算速度 CS00 T+0 CS01 T+1
            ,clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
            ,latest_settle_time -- 最晚首期结算时间
            ,settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
            ,settle_amt -- 首期结算金额
            ,due_settle_amt -- 到期结算金额
            ,settle_date -- 首期结算日
            ,due_settle_date -- 到期结算日
            ,rate -- 回购利率
            ,pay_interest -- 应付利息
            ,yield_rate -- 回购收益率
            ,close_time -- 提票截止时间
            ,credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
            ,department_no -- 所属部门
            ,manager_no -- 客户经理
            ,busi_branch_no -- 业务机构号
            ,top_branch_no -- 总行机构号
            ,contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
            ,message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
            ,settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
            ,account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
            ,created_by -- 创建人
            ,last_upd_opr -- 最后修改人
            ,last_upd_time -- 最后修改时间
            ,misc -- 备注
            ,reserver1 -- 预留域1
            ,reserver2 -- 预留域2
            ,credit_check_status -- 
            ,due_pay_interest -- 到期应付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.quote_contract_id -- 报价批次表ID
    ,o.deal_id -- 成交单表ID
    ,o.contract_no -- 批次号
    ,o.product_no -- 产品号
    ,o.dealed_no -- 成交单编号
    ,o.trade_type -- 成交方式： TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
    ,o.trade_date -- 成交日期
    ,o.trade_time -- 成交时间
    ,o.trade_status -- 成交单状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,o.sum_count -- 票据总张数
    ,o.sum_amount -- 票据总金额
    ,o.quote_no -- 报价单编号
    ,o.busi_type -- 业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 RBT01 再贴现买断 RBT02 再贴现质押式回购
    ,o.trade_direct -- 交易方向： CRD01 逆回购 CRD02 正回购
    ,o.brh_no -- 本方机构代码
    ,o.pro_no -- 本方非法人产品
    ,o.trader_id -- 本方交易员ID
    ,o.adver_brh_no -- 对方机构代码
    ,o.adver_pro_no -- 对方非法人产品
    ,o.adver_trader_id -- 对方交易员ID
    ,o.draft_type -- 票据类型 AC01 银承 AC02 商承
    ,o.draft_attr -- 票据属性： ME01 纸票 ME02 电票
    ,o.buy_back_amt -- 回购金额
    ,o.tenor_code -- 期限品种 TM000 0D(0天) TM001 1D(1天) TM007 7D(7天) TM014 14D(14天) TM030 1M(1月) TM090 3M(3月) TM180 6M(6月) TM270 9M(9月) TM360 1Y(1年)
    ,o.tenor_days -- 回购期限
    ,o.clear_speed -- 清算速度 CS00 T+0 CS01 T+1
    ,o.clear_type -- 清算类型 CT01 全额清算 CT02 净额清算
    ,o.latest_settle_time -- 最晚首期结算时间
    ,o.settle_mode -- 结算方式 ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,o.settle_amt -- 首期结算金额
    ,o.due_settle_amt -- 到期结算金额
    ,o.settle_date -- 首期结算日
    ,o.due_settle_date -- 到期结算日
    ,o.rate -- 回购利率
    ,o.pay_interest -- 应付利息
    ,o.yield_rate -- 回购收益率
    ,o.close_time -- 提票截止时间
    ,o.credit_type -- 信用主体类型 201 政策性银行 202	国有商业银行 203	股份制商业银行 204	外资银行 205	城市商业银行 206	农商行和农合行 207	村镇银行 208	农村信用社 301	财务公司
    ,o.department_no -- 所属部门
    ,o.manager_no -- 客户经理
    ,o.busi_branch_no -- 业务机构号
    ,o.top_branch_no -- 总行机构号
    ,o.contract_status -- 审批状态 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,o.message_status -- 报文状态 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答发送成功 32 应答确认成功 33 应答确认失败
    ,o.settle_status -- 清算状态 MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,o.account_status -- 记账状态 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,o.created_by -- 创建人
    ,o.last_upd_opr -- 最后修改人
    ,o.last_upd_time -- 最后修改时间
    ,o.misc -- 备注
    ,o.reserver1 -- 预留域1
    ,o.reserver2 -- 预留域2
    ,o.credit_check_status -- 
    ,o.due_pay_interest -- 到期应付利息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cpes_anoclick_match_contract_bk o
    left join ${iol_schema}.bdms_cpes_anoclick_match_contract_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cpes_anoclick_match_contract_cl d
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
-- truncate table ${iol_schema}.bdms_cpes_anoclick_match_contract;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cpes_anoclick_match_contract exchange partition p_19000101 with table ${iol_schema}.bdms_cpes_anoclick_match_contract_cl;
alter table ${iol_schema}.bdms_cpes_anoclick_match_contract exchange partition p_20991231 with table ${iol_schema}.bdms_cpes_anoclick_match_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cpes_anoclick_match_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract_op purge;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cpes_anoclick_match_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cpes_anoclick_match_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
