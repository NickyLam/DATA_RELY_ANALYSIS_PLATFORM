/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_trd_fin_product_deal_total
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
create table ${iol_schema}.fams_trd_fin_product_deal_total_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_trd_fin_product_deal_total
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_fin_product_deal_total_op purge;
drop table ${iol_schema}.fams_trd_fin_product_deal_total_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_trd_fin_product_deal_total_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_fin_product_deal_total where 0=1;

create table ${iol_schema}.fams_trd_fin_product_deal_total_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_trd_fin_product_deal_total where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_fin_product_deal_total_cl(
            totle_trade_id -- 汇总交易编号
            ,busi_type -- 业务类型
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,ccy -- 交易币种
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额
            ,prin_amt -- 交易本金
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、修改、撤销
            ,p_trade_id -- 原交易编号
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,is_clean -- 是否结清，收息付费时用
            ,cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
            ,sec_manage_acct_id -- 证券管理户代码
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,f_trade_id -- 关联系统交易编号
            ,portfolio_id -- 投资组合代码
            ,prod_id -- 理财产品代码
            ,p_totle_trade_id -- 上级汇总交易编号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,current_sub -- 本期认购
            ,last_amt -- 上期余额
            ,last_red -- 上期赎回
            ,last_amt_sub -- 上期滚入余额
            ,accounting_amt -- 到账资金
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,dqprin_amt -- 到期本金
            ,pay_date -- 交付日
            ,remain_prin -- 剩余名义本金
            ,tg_busi_type -- 投管业务类型
            ,is_overdue_deal -- 是否逾期交易
            ,clear_type -- 清算类型
            ,eff_time -- 有效时间
            ,delivery_type -- 首期结算方式
            ,m_delivery_type -- 到期结算方式
            ,rate -- 利率
            ,repo_term -- 期限(天)
            ,term_type -- 期限品种
            ,settle_speed -- 清算速度
            ,pay_unpaidint_amt -- 支付未支付利息
            ,ispay_unpaidint -- 是否转让还本未支付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_fin_product_deal_total_op(
            totle_trade_id -- 汇总交易编号
            ,busi_type -- 业务类型
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,ccy -- 交易币种
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额
            ,prin_amt -- 交易本金
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、修改、撤销
            ,p_trade_id -- 原交易编号
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,is_clean -- 是否结清，收息付费时用
            ,cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
            ,sec_manage_acct_id -- 证券管理户代码
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,f_trade_id -- 关联系统交易编号
            ,portfolio_id -- 投资组合代码
            ,prod_id -- 理财产品代码
            ,p_totle_trade_id -- 上级汇总交易编号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,current_sub -- 本期认购
            ,last_amt -- 上期余额
            ,last_red -- 上期赎回
            ,last_amt_sub -- 上期滚入余额
            ,accounting_amt -- 到账资金
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,dqprin_amt -- 到期本金
            ,pay_date -- 交付日
            ,remain_prin -- 剩余名义本金
            ,tg_busi_type -- 投管业务类型
            ,is_overdue_deal -- 是否逾期交易
            ,clear_type -- 清算类型
            ,eff_time -- 有效时间
            ,delivery_type -- 首期结算方式
            ,m_delivery_type -- 到期结算方式
            ,rate -- 利率
            ,repo_term -- 期限(天)
            ,term_type -- 期限品种
            ,settle_speed -- 清算速度
            ,pay_unpaidint_amt -- 支付未支付利息
            ,ispay_unpaidint -- 是否转让还本未支付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.totle_trade_id, o.totle_trade_id) as totle_trade_id -- 汇总交易编号
    ,nvl(n.busi_type, o.busi_type) as busi_type -- 业务类型
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.finprod_type, o.finprod_type) as finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.finprod_type2, o.finprod_type2) as finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日期
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 交割日期
    ,nvl(n.ccy, o.ccy) as ccy -- 交易币种
    ,nvl(n.unit_cprice, o.unit_cprice) as unit_cprice -- 单位净价
    ,nvl(n.unit_int, o.unit_int) as unit_int -- 单位利息
    ,nvl(n.unit_fprice, o.unit_fprice) as unit_fprice -- 单位全价
    ,nvl(n.par_value, o.par_value) as par_value -- 单位面值，债券100或者当前面值，其他资产1
    ,nvl(n.cprice_amt, o.cprice_amt) as cprice_amt -- 净价总额
    ,nvl(n.share_amt, o.share_amt) as share_amt -- 交易份额
    ,nvl(n.prin_amt, o.prin_amt) as prin_amt -- 交易本金
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息总额
    ,nvl(n.fprice_amt, o.fprice_amt) as fprice_amt -- 全价总额
    ,nvl(n.fee_amt_pay, o.fee_amt_pay) as fee_amt_pay -- 随交易支付费用
    ,nvl(n.trade_amt, o.trade_amt) as trade_amt -- 交易金额
    ,nvl(n.fee_amt_unpay, o.fee_amt_unpay) as fee_amt_unpay -- 未随交易支付费用
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 总交易费用
    ,nvl(n.ps, o.ps) as ps -- 交易方向
    ,nvl(n.yield, o.yield) as yield -- 到期收益率
    ,nvl(n.exer_yield, o.exer_yield) as exer_yield -- 行权收益率
    ,nvl(n.inv_aim, o.inv_aim) as inv_aim -- 投资目的
    ,nvl(n.trade_status, o.trade_status) as trade_status -- 交易状态，初始、修改、撤销
    ,nvl(n.p_trade_id, o.p_trade_id) as p_trade_id -- 原交易编号
    ,nvl(n.is_cancel, o.is_cancel) as is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
    ,nvl(n.is_clean, o.is_clean) as is_clean -- 是否结清，收息付费时用
    ,nvl(n.cash_id, o.cash_id) as cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
    ,nvl(n.sec_manage_acct_id, o.sec_manage_acct_id) as sec_manage_acct_id -- 证券管理户代码
    ,nvl(n.b_trade_id, o.b_trade_id) as b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
    ,nvl(n.chl_id, o.chl_id) as chl_id -- 渠道/通道代码
    ,nvl(n.counter_id, o.counter_id) as counter_id -- 交易对手
    ,nvl(n.is_out_trade, o.is_out_trade) as is_out_trade -- 是否外部交易，是、否
    ,nvl(n.trade_market, o.trade_market) as trade_market -- 交易场所，银行间、上交所、深交所、柜面等
    ,nvl(n.trade_plat, o.trade_plat) as trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
    ,nvl(n.trade_market_mode, o.trade_market_mode) as trade_market_mode -- 交易市场，一级市场、二级市场
    ,nvl(n.trader, o.trader) as trader -- 交易员
    ,nvl(n.counter_trader, o.counter_trader) as counter_trader -- 对手方交易员
    ,nvl(n.counter_contact, o.counter_contact) as counter_contact -- 对手方联系方式
    ,nvl(n.f_trade_id, o.f_trade_id) as f_trade_id -- 关联系统交易编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投资组合代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 理财产品代码
    ,nvl(n.p_totle_trade_id, o.p_totle_trade_id) as p_totle_trade_id -- 上级汇总交易编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.current_sub, o.current_sub) as current_sub -- 本期认购
    ,nvl(n.last_amt, o.last_amt) as last_amt -- 上期余额
    ,nvl(n.last_red, o.last_red) as last_red -- 上期赎回
    ,nvl(n.last_amt_sub, o.last_amt_sub) as last_amt_sub -- 上期滚入余额
    ,nvl(n.accounting_amt, o.accounting_amt) as accounting_amt -- 到账资金
    ,nvl(n.red_profit, o.red_profit) as red_profit -- 赎回收益
    ,nvl(n.red_cost, o.red_cost) as red_cost -- 赎回成本
    ,nvl(n.dqprin_amt, o.dqprin_amt) as dqprin_amt -- 到期本金
    ,nvl(n.pay_date, o.pay_date) as pay_date -- 交付日
    ,nvl(n.remain_prin, o.remain_prin) as remain_prin -- 剩余名义本金
    ,nvl(n.tg_busi_type, o.tg_busi_type) as tg_busi_type -- 投管业务类型
    ,nvl(n.is_overdue_deal, o.is_overdue_deal) as is_overdue_deal -- 是否逾期交易
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算类型
    ,nvl(n.eff_time, o.eff_time) as eff_time -- 有效时间
    ,nvl(n.delivery_type, o.delivery_type) as delivery_type -- 首期结算方式
    ,nvl(n.m_delivery_type, o.m_delivery_type) as m_delivery_type -- 到期结算方式
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.repo_term, o.repo_term) as repo_term -- 期限(天)
    ,nvl(n.term_type, o.term_type) as term_type -- 期限品种
    ,nvl(n.settle_speed, o.settle_speed) as settle_speed -- 清算速度
    ,nvl(n.pay_unpaidint_amt, o.pay_unpaidint_amt) as pay_unpaidint_amt -- 支付未支付利息
    ,nvl(n.ispay_unpaidint, o.ispay_unpaidint) as ispay_unpaidint -- 是否转让还本未支付利息
    ,case when
            n.totle_trade_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.totle_trade_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.totle_trade_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_trd_fin_product_deal_total_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_trd_fin_product_deal_total where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.totle_trade_id = n.totle_trade_id
where (
        o.totle_trade_id is null
    )
    or (
        n.totle_trade_id is null
    )
    or (
        o.busi_type <> n.busi_type
        or o.finprod_id <> n.finprod_id
        or o.finprod_type <> n.finprod_type
        or o.finprod_type2 <> n.finprod_type2
        or o.branch <> n.branch
        or o.trade_date <> n.trade_date
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.settle_date <> n.settle_date
        or o.ccy <> n.ccy
        or o.unit_cprice <> n.unit_cprice
        or o.unit_int <> n.unit_int
        or o.unit_fprice <> n.unit_fprice
        or o.par_value <> n.par_value
        or o.cprice_amt <> n.cprice_amt
        or o.share_amt <> n.share_amt
        or o.prin_amt <> n.prin_amt
        or o.int_amt <> n.int_amt
        or o.fprice_amt <> n.fprice_amt
        or o.fee_amt_pay <> n.fee_amt_pay
        or o.trade_amt <> n.trade_amt
        or o.fee_amt_unpay <> n.fee_amt_unpay
        or o.fee_amt <> n.fee_amt
        or o.ps <> n.ps
        or o.yield <> n.yield
        or o.exer_yield <> n.exer_yield
        or o.inv_aim <> n.inv_aim
        or o.trade_status <> n.trade_status
        or o.p_trade_id <> n.p_trade_id
        or o.is_cancel <> n.is_cancel
        or o.is_clean <> n.is_clean
        or o.cash_id <> n.cash_id
        or o.sec_manage_acct_id <> n.sec_manage_acct_id
        or o.b_trade_id <> n.b_trade_id
        or o.chl_id <> n.chl_id
        or o.counter_id <> n.counter_id
        or o.is_out_trade <> n.is_out_trade
        or o.trade_market <> n.trade_market
        or o.trade_plat <> n.trade_plat
        or o.trade_market_mode <> n.trade_market_mode
        or o.trader <> n.trader
        or o.counter_trader <> n.counter_trader
        or o.counter_contact <> n.counter_contact
        or o.f_trade_id <> n.f_trade_id
        or o.portfolio_id <> n.portfolio_id
        or o.prod_id <> n.prod_id
        or o.p_totle_trade_id <> n.p_totle_trade_id
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.current_sub <> n.current_sub
        or o.last_amt <> n.last_amt
        or o.last_red <> n.last_red
        or o.last_amt_sub <> n.last_amt_sub
        or o.accounting_amt <> n.accounting_amt
        or o.red_profit <> n.red_profit
        or o.red_cost <> n.red_cost
        or o.dqprin_amt <> n.dqprin_amt
        or o.pay_date <> n.pay_date
        or o.remain_prin <> n.remain_prin
        or o.tg_busi_type <> n.tg_busi_type
        or o.is_overdue_deal <> n.is_overdue_deal
        or o.clear_type <> n.clear_type
        or o.eff_time <> n.eff_time
        or o.delivery_type <> n.delivery_type
        or o.m_delivery_type <> n.m_delivery_type
        or o.rate <> n.rate
        or o.repo_term <> n.repo_term
        or o.term_type <> n.term_type
        or o.settle_speed <> n.settle_speed
        or o.pay_unpaidint_amt <> n.pay_unpaidint_amt
        or o.ispay_unpaidint <> n.ispay_unpaidint
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_trd_fin_product_deal_total_cl(
            totle_trade_id -- 汇总交易编号
            ,busi_type -- 业务类型
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,ccy -- 交易币种
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额
            ,prin_amt -- 交易本金
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、修改、撤销
            ,p_trade_id -- 原交易编号
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,is_clean -- 是否结清，收息付费时用
            ,cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
            ,sec_manage_acct_id -- 证券管理户代码
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,f_trade_id -- 关联系统交易编号
            ,portfolio_id -- 投资组合代码
            ,prod_id -- 理财产品代码
            ,p_totle_trade_id -- 上级汇总交易编号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,current_sub -- 本期认购
            ,last_amt -- 上期余额
            ,last_red -- 上期赎回
            ,last_amt_sub -- 上期滚入余额
            ,accounting_amt -- 到账资金
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,dqprin_amt -- 到期本金
            ,pay_date -- 交付日
            ,remain_prin -- 剩余名义本金
            ,tg_busi_type -- 投管业务类型
            ,is_overdue_deal -- 是否逾期交易
            ,clear_type -- 清算类型
            ,eff_time -- 有效时间
            ,delivery_type -- 首期结算方式
            ,m_delivery_type -- 到期结算方式
            ,rate -- 利率
            ,repo_term -- 期限(天)
            ,term_type -- 期限品种
            ,settle_speed -- 清算速度
            ,pay_unpaidint_amt -- 支付未支付利息
            ,ispay_unpaidint -- 是否转让还本未支付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_trd_fin_product_deal_total_op(
            totle_trade_id -- 汇总交易编号
            ,busi_type -- 业务类型
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,ccy -- 交易币种
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额
            ,prin_amt -- 交易本金
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、修改、撤销
            ,p_trade_id -- 原交易编号
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,is_clean -- 是否结清，收息付费时用
            ,cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
            ,sec_manage_acct_id -- 证券管理户代码
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,f_trade_id -- 关联系统交易编号
            ,portfolio_id -- 投资组合代码
            ,prod_id -- 理财产品代码
            ,p_totle_trade_id -- 上级汇总交易编号
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,current_sub -- 本期认购
            ,last_amt -- 上期余额
            ,last_red -- 上期赎回
            ,last_amt_sub -- 上期滚入余额
            ,accounting_amt -- 到账资金
            ,red_profit -- 赎回收益
            ,red_cost -- 赎回成本
            ,dqprin_amt -- 到期本金
            ,pay_date -- 交付日
            ,remain_prin -- 剩余名义本金
            ,tg_busi_type -- 投管业务类型
            ,is_overdue_deal -- 是否逾期交易
            ,clear_type -- 清算类型
            ,eff_time -- 有效时间
            ,delivery_type -- 首期结算方式
            ,m_delivery_type -- 到期结算方式
            ,rate -- 利率
            ,repo_term -- 期限(天)
            ,term_type -- 期限品种
            ,settle_speed -- 清算速度
            ,pay_unpaidint_amt -- 支付未支付利息
            ,ispay_unpaidint -- 是否转让还本未支付利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.totle_trade_id -- 汇总交易编号
    ,o.busi_type -- 业务类型
    ,o.finprod_id -- 金融产品代码
    ,o.finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,o.branch -- 分支序号
    ,o.trade_date -- 交易日期
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.settle_date -- 交割日期
    ,o.ccy -- 交易币种
    ,o.unit_cprice -- 单位净价
    ,o.unit_int -- 单位利息
    ,o.unit_fprice -- 单位全价
    ,o.par_value -- 单位面值，债券100或者当前面值，其他资产1
    ,o.cprice_amt -- 净价总额
    ,o.share_amt -- 交易份额
    ,o.prin_amt -- 交易本金
    ,o.int_amt -- 利息总额
    ,o.fprice_amt -- 全价总额
    ,o.fee_amt_pay -- 随交易支付费用
    ,o.trade_amt -- 交易金额
    ,o.fee_amt_unpay -- 未随交易支付费用
    ,o.fee_amt -- 总交易费用
    ,o.ps -- 交易方向
    ,o.yield -- 到期收益率
    ,o.exer_yield -- 行权收益率
    ,o.inv_aim -- 投资目的
    ,o.trade_status -- 交易状态，初始、修改、撤销
    ,o.p_trade_id -- 原交易编号
    ,o.is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
    ,o.is_clean -- 是否结清，收息付费时用
    ,o.cash_id -- 现金流代码，金融产品代码+金融产品类型+现金流二级类型，还本、付息、付费等时存对应计划的现金流代码
    ,o.sec_manage_acct_id -- 证券管理户代码
    ,o.b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
    ,o.chl_id -- 渠道/通道代码
    ,o.counter_id -- 交易对手
    ,o.is_out_trade -- 是否外部交易，是、否
    ,o.trade_market -- 交易场所，银行间、上交所、深交所、柜面等
    ,o.trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
    ,o.trade_market_mode -- 交易市场，一级市场、二级市场
    ,o.trader -- 交易员
    ,o.counter_trader -- 对手方交易员
    ,o.counter_contact -- 对手方联系方式
    ,o.f_trade_id -- 关联系统交易编号
    ,o.portfolio_id -- 投资组合代码
    ,o.prod_id -- 理财产品代码
    ,o.p_totle_trade_id -- 上级汇总交易编号
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.current_sub -- 本期认购
    ,o.last_amt -- 上期余额
    ,o.last_red -- 上期赎回
    ,o.last_amt_sub -- 上期滚入余额
    ,o.accounting_amt -- 到账资金
    ,o.red_profit -- 赎回收益
    ,o.red_cost -- 赎回成本
    ,o.dqprin_amt -- 到期本金
    ,o.pay_date -- 交付日
    ,o.remain_prin -- 剩余名义本金
    ,o.tg_busi_type -- 投管业务类型
    ,o.is_overdue_deal -- 是否逾期交易
    ,o.clear_type -- 清算类型
    ,o.eff_time -- 有效时间
    ,o.delivery_type -- 首期结算方式
    ,o.m_delivery_type -- 到期结算方式
    ,o.rate -- 利率
    ,o.repo_term -- 期限(天)
    ,o.term_type -- 期限品种
    ,o.settle_speed -- 清算速度
    ,o.pay_unpaidint_amt -- 支付未支付利息
    ,o.ispay_unpaidint -- 是否转让还本未支付利息
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
from ${iol_schema}.fams_trd_fin_product_deal_total_bk o
    left join ${iol_schema}.fams_trd_fin_product_deal_total_op n
        on
            o.totle_trade_id = n.totle_trade_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_trd_fin_product_deal_total_cl d
        on
            o.totle_trade_id = d.totle_trade_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_trd_fin_product_deal_total;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_trd_fin_product_deal_total') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_trd_fin_product_deal_total drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_trd_fin_product_deal_total add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_trd_fin_product_deal_total exchange partition p_${batch_date} with table ${iol_schema}.fams_trd_fin_product_deal_total_cl;
alter table ${iol_schema}.fams_trd_fin_product_deal_total exchange partition p_20991231 with table ${iol_schema}.fams_trd_fin_product_deal_total_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_trd_fin_product_deal_total to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_trd_fin_product_deal_total_op purge;
drop table ${iol_schema}.fams_trd_fin_product_deal_total_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_trd_fin_product_deal_total_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_trd_fin_product_deal_total',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
