/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ptl_sec_valution
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
create table ${iol_schema}.fams_ptl_sec_valution_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ptl_sec_valution
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_sec_valution_op purge;
drop table ${iol_schema}.fams_ptl_sec_valution_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ptl_sec_valution_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_sec_valution where 0=1;

create table ${iol_schema}.fams_ptl_sec_valution_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ptl_sec_valution where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_sec_valution_cl(
            cdate -- 日期
            ,portfolio_id -- 组合代码
            ,finprod_id -- 金融产品代码
            ,inv_aim -- 投资目的
            ,ccy -- 币种
            ,share_amt -- 数量
            ,tdy_float_ingpl -- 公允价值变动
            ,dsc_cost_amt -- 摊销总成本，券面+利息调整
            ,dsc_clean_price -- 摊销成本净价
            ,tdy_intincexp -- 当日应计利息
            ,buy_cost_amt -- 买入总成本，暂时不用
            ,buy_clean_price -- 买入成本净价，暂时不用
            ,market_value -- 市值，暂时不用
            ,market_clean_price -- 市价净价，暂时不用
            ,tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
            ,tdy_intincexp_add -- 当日发生利息收入，暂时不用
            ,tdy_dscloss_add -- 当日发生价差收入，暂时不用
            ,tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
            ,tdy_fee_add -- 当日发生费用支出，暂时不用
            ,accu_net_value -- 累计单位净值，暂时不用
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,act_d_yield -- 实际日利率
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
            ,delay_pay_amt -- 待清算资金
            ,b_ccy -- 本位币
            ,tdy_float_ingpl_b -- 公允价值变动_本位币
            ,dsc_cost_amt_b -- 摊销总成本_本位币
            ,dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
            ,delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
            ,tdy_intincexp_b -- 当日应计利息_本位币
            ,in_tdy_intincexp -- 收入端应计利息_原币
            ,out_tdy_intincexp -- 支出端应计利息_原币
            ,end_days_1 -- 剩余期限，下一个付息日行权日-计算日
            ,end_days_2 -- 剩余存续期限,到期日-计算日
            ,int_rate -- 计提利率
            ,tdy_dscloss_add_b -- 当日价差收入_本币
            ,gen_type -- 生成方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_sec_valution_op(
            cdate -- 日期
            ,portfolio_id -- 组合代码
            ,finprod_id -- 金融产品代码
            ,inv_aim -- 投资目的
            ,ccy -- 币种
            ,share_amt -- 数量
            ,tdy_float_ingpl -- 公允价值变动
            ,dsc_cost_amt -- 摊销总成本，券面+利息调整
            ,dsc_clean_price -- 摊销成本净价
            ,tdy_intincexp -- 当日应计利息
            ,buy_cost_amt -- 买入总成本，暂时不用
            ,buy_clean_price -- 买入成本净价，暂时不用
            ,market_value -- 市值，暂时不用
            ,market_clean_price -- 市价净价，暂时不用
            ,tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
            ,tdy_intincexp_add -- 当日发生利息收入，暂时不用
            ,tdy_dscloss_add -- 当日发生价差收入，暂时不用
            ,tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
            ,tdy_fee_add -- 当日发生费用支出，暂时不用
            ,accu_net_value -- 累计单位净值，暂时不用
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,act_d_yield -- 实际日利率
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
            ,delay_pay_amt -- 待清算资金
            ,b_ccy -- 本位币
            ,tdy_float_ingpl_b -- 公允价值变动_本位币
            ,dsc_cost_amt_b -- 摊销总成本_本位币
            ,dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
            ,delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
            ,tdy_intincexp_b -- 当日应计利息_本位币
            ,in_tdy_intincexp -- 收入端应计利息_原币
            ,out_tdy_intincexp -- 支出端应计利息_原币
            ,end_days_1 -- 剩余期限，下一个付息日行权日-计算日
            ,end_days_2 -- 剩余存续期限,到期日-计算日
            ,int_rate -- 计提利率
            ,tdy_dscloss_add_b -- 当日价差收入_本币
            ,gen_type -- 生成方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cdate, o.cdate) as cdate -- 日期
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 组合代码
    ,nvl(n.finprod_id, o.finprod_id) as finprod_id -- 金融产品代码
    ,nvl(n.inv_aim, o.inv_aim) as inv_aim -- 投资目的
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.share_amt, o.share_amt) as share_amt -- 数量
    ,nvl(n.tdy_float_ingpl, o.tdy_float_ingpl) as tdy_float_ingpl -- 公允价值变动
    ,nvl(n.dsc_cost_amt, o.dsc_cost_amt) as dsc_cost_amt -- 摊销总成本，券面+利息调整
    ,nvl(n.dsc_clean_price, o.dsc_clean_price) as dsc_clean_price -- 摊销成本净价
    ,nvl(n.tdy_intincexp, o.tdy_intincexp) as tdy_intincexp -- 当日应计利息
    ,nvl(n.buy_cost_amt, o.buy_cost_amt) as buy_cost_amt -- 买入总成本，暂时不用
    ,nvl(n.buy_clean_price, o.buy_clean_price) as buy_clean_price -- 买入成本净价，暂时不用
    ,nvl(n.market_value, o.market_value) as market_value -- 市值，暂时不用
    ,nvl(n.market_clean_price, o.market_clean_price) as market_clean_price -- 市价净价，暂时不用
    ,nvl(n.tdy_dscincexp_add, o.tdy_dscincexp_add) as tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
    ,nvl(n.tdy_intincexp_add, o.tdy_intincexp_add) as tdy_intincexp_add -- 当日发生利息收入，暂时不用
    ,nvl(n.tdy_dscloss_add, o.tdy_dscloss_add) as tdy_dscloss_add -- 当日发生价差收入，暂时不用
    ,nvl(n.tdy_float_ingpl_add, o.tdy_float_ingpl_add) as tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
    ,nvl(n.tdy_fee_add, o.tdy_fee_add) as tdy_fee_add -- 当日发生费用支出，暂时不用
    ,nvl(n.accu_net_value, o.accu_net_value) as accu_net_value -- 累计单位净值，暂时不用
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.act_d_yield, o.act_d_yield) as act_d_yield -- 实际日利率
    ,nvl(n.sec_acct_id, o.sec_acct_id) as sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
    ,nvl(n.delay_pay_amt, o.delay_pay_amt) as delay_pay_amt -- 待清算资金
    ,nvl(n.b_ccy, o.b_ccy) as b_ccy -- 本位币
    ,nvl(n.tdy_float_ingpl_b, o.tdy_float_ingpl_b) as tdy_float_ingpl_b -- 公允价值变动_本位币
    ,nvl(n.dsc_cost_amt_b, o.dsc_cost_amt_b) as dsc_cost_amt_b -- 摊销总成本_本位币
    ,nvl(n.dsc_clean_price_b, o.dsc_clean_price_b) as dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
    ,nvl(n.delay_pay_amt_b, o.delay_pay_amt_b) as delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
    ,nvl(n.tdy_intincexp_b, o.tdy_intincexp_b) as tdy_intincexp_b -- 当日应计利息_本位币
    ,nvl(n.in_tdy_intincexp, o.in_tdy_intincexp) as in_tdy_intincexp -- 收入端应计利息_原币
    ,nvl(n.out_tdy_intincexp, o.out_tdy_intincexp) as out_tdy_intincexp -- 支出端应计利息_原币
    ,nvl(n.end_days_1, o.end_days_1) as end_days_1 -- 剩余期限，下一个付息日行权日-计算日
    ,nvl(n.end_days_2, o.end_days_2) as end_days_2 -- 剩余存续期限,到期日-计算日
    ,nvl(n.int_rate, o.int_rate) as int_rate -- 计提利率
    ,nvl(n.tdy_dscloss_add_b, o.tdy_dscloss_add_b) as tdy_dscloss_add_b -- 当日价差收入_本币
    ,nvl(n.gen_type, o.gen_type) as gen_type -- 生成方式
    ,case when
            n.cdate is null
            and n.portfolio_id is null
            and n.finprod_id is null
            and n.inv_aim is null
            and n.sec_acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cdate is null
            and n.portfolio_id is null
            and n.finprod_id is null
            and n.inv_aim is null
            and n.sec_acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cdate is null
            and n.portfolio_id is null
            and n.finprod_id is null
            and n.inv_aim is null
            and n.sec_acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ptl_sec_valution_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ptl_sec_valution where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cdate = n.cdate
            and o.portfolio_id = n.portfolio_id
            and o.finprod_id = n.finprod_id
            and o.inv_aim = n.inv_aim
            and o.sec_acct_id = n.sec_acct_id
where (
        o.cdate is null
        and o.portfolio_id is null
        and o.finprod_id is null
        and o.inv_aim is null
        and o.sec_acct_id is null
    )
    or (
        n.cdate is null
        and n.portfolio_id is null
        and n.finprod_id is null
        and n.inv_aim is null
        and n.sec_acct_id is null
    )
    or (
        o.ccy <> n.ccy
        or o.share_amt <> n.share_amt
        or o.tdy_float_ingpl <> n.tdy_float_ingpl
        or o.dsc_cost_amt <> n.dsc_cost_amt
        or o.dsc_clean_price <> n.dsc_clean_price
        or o.tdy_intincexp <> n.tdy_intincexp
        or o.buy_cost_amt <> n.buy_cost_amt
        or o.buy_clean_price <> n.buy_clean_price
        or o.market_value <> n.market_value
        or o.market_clean_price <> n.market_clean_price
        or o.tdy_dscincexp_add <> n.tdy_dscincexp_add
        or o.tdy_intincexp_add <> n.tdy_intincexp_add
        or o.tdy_dscloss_add <> n.tdy_dscloss_add
        or o.tdy_float_ingpl_add <> n.tdy_float_ingpl_add
        or o.tdy_fee_add <> n.tdy_fee_add
        or o.accu_net_value <> n.accu_net_value
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.act_d_yield <> n.act_d_yield
        or o.delay_pay_amt <> n.delay_pay_amt
        or o.b_ccy <> n.b_ccy
        or o.tdy_float_ingpl_b <> n.tdy_float_ingpl_b
        or o.dsc_cost_amt_b <> n.dsc_cost_amt_b
        or o.dsc_clean_price_b <> n.dsc_clean_price_b
        or o.delay_pay_amt_b <> n.delay_pay_amt_b
        or o.tdy_intincexp_b <> n.tdy_intincexp_b
        or o.in_tdy_intincexp <> n.in_tdy_intincexp
        or o.out_tdy_intincexp <> n.out_tdy_intincexp
        or o.end_days_1 <> n.end_days_1
        or o.end_days_2 <> n.end_days_2
        or o.int_rate <> n.int_rate
        or o.tdy_dscloss_add_b <> n.tdy_dscloss_add_b
        or o.gen_type <> n.gen_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ptl_sec_valution_cl(
            cdate -- 日期
            ,portfolio_id -- 组合代码
            ,finprod_id -- 金融产品代码
            ,inv_aim -- 投资目的
            ,ccy -- 币种
            ,share_amt -- 数量
            ,tdy_float_ingpl -- 公允价值变动
            ,dsc_cost_amt -- 摊销总成本，券面+利息调整
            ,dsc_clean_price -- 摊销成本净价
            ,tdy_intincexp -- 当日应计利息
            ,buy_cost_amt -- 买入总成本，暂时不用
            ,buy_clean_price -- 买入成本净价，暂时不用
            ,market_value -- 市值，暂时不用
            ,market_clean_price -- 市价净价，暂时不用
            ,tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
            ,tdy_intincexp_add -- 当日发生利息收入，暂时不用
            ,tdy_dscloss_add -- 当日发生价差收入，暂时不用
            ,tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
            ,tdy_fee_add -- 当日发生费用支出，暂时不用
            ,accu_net_value -- 累计单位净值，暂时不用
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,act_d_yield -- 实际日利率
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
            ,delay_pay_amt -- 待清算资金
            ,b_ccy -- 本位币
            ,tdy_float_ingpl_b -- 公允价值变动_本位币
            ,dsc_cost_amt_b -- 摊销总成本_本位币
            ,dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
            ,delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
            ,tdy_intincexp_b -- 当日应计利息_本位币
            ,in_tdy_intincexp -- 收入端应计利息_原币
            ,out_tdy_intincexp -- 支出端应计利息_原币
            ,end_days_1 -- 剩余期限，下一个付息日行权日-计算日
            ,end_days_2 -- 剩余存续期限,到期日-计算日
            ,int_rate -- 计提利率
            ,tdy_dscloss_add_b -- 当日价差收入_本币
            ,gen_type -- 生成方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ptl_sec_valution_op(
            cdate -- 日期
            ,portfolio_id -- 组合代码
            ,finprod_id -- 金融产品代码
            ,inv_aim -- 投资目的
            ,ccy -- 币种
            ,share_amt -- 数量
            ,tdy_float_ingpl -- 公允价值变动
            ,dsc_cost_amt -- 摊销总成本，券面+利息调整
            ,dsc_clean_price -- 摊销成本净价
            ,tdy_intincexp -- 当日应计利息
            ,buy_cost_amt -- 买入总成本，暂时不用
            ,buy_clean_price -- 买入成本净价，暂时不用
            ,market_value -- 市值，暂时不用
            ,market_clean_price -- 市价净价，暂时不用
            ,tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
            ,tdy_intincexp_add -- 当日发生利息收入，暂时不用
            ,tdy_dscloss_add -- 当日发生价差收入，暂时不用
            ,tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
            ,tdy_fee_add -- 当日发生费用支出，暂时不用
            ,accu_net_value -- 累计单位净值，暂时不用
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,act_d_yield -- 实际日利率
            ,sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
            ,delay_pay_amt -- 待清算资金
            ,b_ccy -- 本位币
            ,tdy_float_ingpl_b -- 公允价值变动_本位币
            ,dsc_cost_amt_b -- 摊销总成本_本位币
            ,dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
            ,delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
            ,tdy_intincexp_b -- 当日应计利息_本位币
            ,in_tdy_intincexp -- 收入端应计利息_原币
            ,out_tdy_intincexp -- 支出端应计利息_原币
            ,end_days_1 -- 剩余期限，下一个付息日行权日-计算日
            ,end_days_2 -- 剩余存续期限,到期日-计算日
            ,int_rate -- 计提利率
            ,tdy_dscloss_add_b -- 当日价差收入_本币
            ,gen_type -- 生成方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cdate -- 日期
    ,o.portfolio_id -- 组合代码
    ,o.finprod_id -- 金融产品代码
    ,o.inv_aim -- 投资目的
    ,o.ccy -- 币种
    ,o.share_amt -- 数量
    ,o.tdy_float_ingpl -- 公允价值变动
    ,o.dsc_cost_amt -- 摊销总成本，券面+利息调整
    ,o.dsc_clean_price -- 摊销成本净价
    ,o.tdy_intincexp -- 当日应计利息
    ,o.buy_cost_amt -- 买入总成本，暂时不用
    ,o.buy_clean_price -- 买入成本净价，暂时不用
    ,o.market_value -- 市值，暂时不用
    ,o.market_clean_price -- 市价净价，暂时不用
    ,o.tdy_dscincexp_add -- 当日发生摊销收入，暂时不用
    ,o.tdy_intincexp_add -- 当日发生利息收入，暂时不用
    ,o.tdy_dscloss_add -- 当日发生价差收入，暂时不用
    ,o.tdy_float_ingpl_add -- 当日发生浮动盈亏，暂时不用
    ,o.tdy_fee_add -- 当日发生费用支出，暂时不用
    ,o.accu_net_value -- 累计单位净值，暂时不用
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.act_d_yield -- 实际日利率
    ,o.sec_acct_id -- 证券管理账户/通道代码，无通道无证券管理账户的存999999，目前不管证券管理户维度
    ,o.delay_pay_amt -- 待清算资金
    ,o.b_ccy -- 本位币
    ,o.tdy_float_ingpl_b -- 公允价值变动_本位币
    ,o.dsc_cost_amt_b -- 摊销总成本_本位币
    ,o.dsc_clean_price_b -- 摊销成本净价_本位币，摊销总成本/数量
    ,o.delay_pay_amt_b -- 待清算资金_本位币， 还本/付息区间后未支付的本金/利息，T+1交易，资金清算金额
    ,o.tdy_intincexp_b -- 当日应计利息_本位币
    ,o.in_tdy_intincexp -- 收入端应计利息_原币
    ,o.out_tdy_intincexp -- 支出端应计利息_原币
    ,o.end_days_1 -- 剩余期限，下一个付息日行权日-计算日
    ,o.end_days_2 -- 剩余存续期限,到期日-计算日
    ,o.int_rate -- 计提利率
    ,o.tdy_dscloss_add_b -- 当日价差收入_本币
    ,o.gen_type -- 生成方式
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
from ${iol_schema}.fams_ptl_sec_valution_bk o
    left join ${iol_schema}.fams_ptl_sec_valution_op n
        on
            o.cdate = n.cdate
            and o.portfolio_id = n.portfolio_id
            and o.finprod_id = n.finprod_id
            and o.inv_aim = n.inv_aim
            and o.sec_acct_id = n.sec_acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ptl_sec_valution_cl d
        on
            o.cdate = d.cdate
            and o.portfolio_id = d.portfolio_id
            and o.finprod_id = d.finprod_id
            and o.inv_aim = d.inv_aim
            and o.sec_acct_id = d.sec_acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_ptl_sec_valution;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_ptl_sec_valution') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_ptl_sec_valution drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_ptl_sec_valution add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_ptl_sec_valution exchange partition p_${batch_date} with table ${iol_schema}.fams_ptl_sec_valution_cl;
alter table ${iol_schema}.fams_ptl_sec_valution exchange partition p_20991231 with table ${iol_schema}.fams_ptl_sec_valution_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ptl_sec_valution to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ptl_sec_valution_op purge;
drop table ${iol_schema}.fams_ptl_sec_valution_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ptl_sec_valution_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ptl_sec_valution',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
